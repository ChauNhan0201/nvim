--flua/user/java.lua
-- Cấu hình cho Java và Lombok

local M = {}

-- Cấu hình Java LSP thông qua nvim-jdtls
M.setup = function()
  local status_ok, jdtls = pcall(require, "jdtls")
  if not status_ok then
    vim.notify("jdtls không được tìm thấy", vim.log.levels.ERROR)
    return
  end
  
  -- Đường dẫn đến workspace
  local home = os.getenv("HOME")
  local workspace_path = home .. "/.local/share/jdtls-workspace/"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = workspace_path .. project_name
  
  -- Tìm đường dẫn đến server JDTLS đã được cài đặt qua Mason
  local mason_path = vim.fn.stdpath("data") .. "/mason"
  local jdtls_path = mason_path .. "/packages/jdtls"
  
  -- Tìm đường dẫn đến Lombok
  local lombok_path = jdtls_path .. "/lombok.jar"
  -- Nếu không tìm thấy trong thư mục mặc định, thử tìm trong thư mục extensions
  if vim.fn.filereadable(lombok_path) == 0 then
    lombok_path = jdtls_path .. "/plugins/lombok.jar"
  end
  
  -- Kiểm tra xem lombok.jar có tồn tại không
  if vim.fn.filereadable(lombok_path) == 0 then
    vim.notify("Không tìm thấy lombok.jar. Cần cài đặt Lombok", vim.log.levels.WARN)
    -- Tạo thư mục để tải lombok nếu cần
    local lombok_dir = jdtls_path .. "/plugins"
    if vim.fn.isdirectory(lombok_dir) == 0 then
      vim.fn.mkdir(lombok_dir, "p")
    end
    lombok_path = lombok_dir .. "/lombok.jar"
    -- Bạn có thể tự tải lombok.jar vào thư mục này
  end
  
  -- Xác định OS để chọn đúng config
  local os_config
  if vim.fn.has("mac") == 1 then
    os_config = "config_mac"
  elseif vim.fn.has("unix") == 1 then
    os_config = "config_linux"
  elseif vim.fn.has("win32") == 1 then
    os_config = "config_win"
  else
    os_config = "config_linux"
  end
  
  -- Tìm equinox launcher jar
  local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  
  -- Cấu hình JDTLS
  local config = {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      
      -- Lombok support
      "-javaagent:" .. lombok_path,
      
      "-jar", launcher_jar,
      "-configuration", jdtls_path .. "/" .. os_config,
      "-data", workspace_dir,
    },
    
    -- Cấu hình root_dir dựa vào project
    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),
    
    -- Cấu hình cụ thể cho Java
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*"
          },
          filteredTypes = {
            "com.sun.*",
            "io.micrometer.shaded.*",
            "java.awt.*",
            "jdk.*", "sun.*",
          },
          importOrder = {
            "java",
            "javax",
            "com",
            "org"
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
          },
          hashCodeEquals = {
            useJava7Objects = true,
          },
          useBlocks = true,
        },
        configuration = {
          -- Nếu bạn dùng SDKMAN để quản lý Java versions
          runtimes = {
 --           {
 --             name = "JavaSE-11",
 --             path = home .. "/.sdkman/candidates/java/11.0.12-open",
 --           },
            {
              name = "JavaSE-21",
              path = home .. "/.sdkman/candidates/java/21.0.8-amzn",
            },
          },
          updateBuildConfiguration = "interactive",
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        inlayHints = {
          parameterNames = {
            enabled = "all",
          },
        },
        format = {
          enabled = true,
        },
        -- Hỗ trợ Lombok
        lombok = {
          enabled = true,
        },
      },
    },
    
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    
    on_attach = function(client, bufnr)
      -- Thêm các phím tắt cụ thể cho Java
      local opts = { noremap = true, silent = true, buffer = bufnr }
      
      -- Chức năng đặc thù của JDTLS
      vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
      vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
      vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
      vim.keymap.set("n", "<leader>jm", jdtls.extract_method, opts)
      
      -- Test với JUnit
      vim.keymap.set("n", "<leader>jt", jdtls.test_nearest_method, opts)
      vim.keymap.set("n", "<leader>jT", jdtls.test_class, opts)
      
      -- Thiết lập để hoạt động tốt với DAP (Debug Adapter Protocol)
      jdtls.setup_dap({ hotcodereplace = 'auto' })
      
      -- Kích hoạt chức năng code_lens
      if client.server_capabilities.codeLensProvider then
        local group = vim.api.nvim_create_augroup("jdtls_codelens", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          group = group,
          callback = function()
            vim.lsp.codelens.refresh()
          end,
          buffer = bufnr,
        })
      end
      
      -- Kích hoạt jdtls extensions
      jdtls.setup.add_commands()
      
      -- Thiết lập format on save
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end
      
      -- Hỗ trợ debugger với nvim-dap (nếu có cài đặt)
      local has_dap, dap = pcall(require, "dap")
      if has_dap then
        -- Chỉ thêm Java configuration nếu chưa có
        if not dap.configurations.java then
          dap.configurations.java = {
            {
              type = "java",
              request = "attach",
              name = "Debug (Attach) - Remote",
              hostName = "127.0.0.1",
              port = 5005,
            },
            {
              type = "java",
              request = "launch",
              name = "Debug (Launch) - Current File",
              mainClass = "${file}",
            },
          }
        end
      end
      
      -- Thông báo khi JDTLS đã sẵn sàng
      vim.notify("JDTLS đã khởi động cho " .. project_name, vim.log.levels.INFO)
    end,
    
    -- Các cài đặt khác cho JDTLS
    init_options = {
      bundles = {},  -- Thêm bundles Java nếu cần
      extendedClientCapabilities = {
        progressReportProvider = true,
        classFileContentsSupport = true,
        generateToStringPromptSupport = true,
        hashCodeEqualsPromptSupport = true,
        advancedExtractRefactoringSupport = true,
        advancedOrganizeImportsSupport = true,
        generateConstructorsPromptSupport = true,
        generateDelegateMethodsPromptSupport = true,
      },
    },
  }
  
  -- Khởi động JDTLS
  jdtls.start_or_attach(config)
end

return M
