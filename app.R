#install.packages("shinydashboard")
#install.packages("highcharter")
library(shiny)
library(DBI)
library(RMySQL)
library(glue)
library(readr)
library(shinydashboard)
library(DT)
library(ggplot2)
library(dplyr)
library(highcharter)

# UI
ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = span("", style = "font-weight: bold;")),
  
  dashboardSidebar(
    
    tags$div(
      style = "text-align: center; padding: 10px; font-size: 20px; font-weight: bold; color: white;",
      "Customer & Sales"
    ),
    tags$div(
      style = "text-align: center; padding: 0px; font-size: 30px; font-weight: bold; color: white;",
      "Dashboard"
    ),
    tags$div(
      style = "text-align: center; padding: 10px;",
      imageOutput("logo", height = "100px") 
    ),
    
    tags$div(
      style = "background-color: white; border-radius: 10px; padding: 10px; margin: 10px;",
      
      sidebarMenu(
        menuItem("Customer Insights", tabName = "onlineshop", icon = icon("shopping-cart")),
        menuItem("Transaction Overview", tabName = "transaction", icon = icon("exchange-alt"))
      )
    ),
    tags$div(
      style = "text-align: center; padding: 10px;",
      imageOutput("graphic", height = "100px") 
    ),
    tags$div(
      style = "background-color: white; border-radius: 10px; padding: 10px; margin: 10px;",
      
      sidebarMenu(
        menuItem("Table", tabName = "table", icon = icon("table")),
        menuItem("Member", tabName = "member", icon = icon("users"))
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      # Tab Online Shop
      tabItem(
        tabName = "onlineshop",
        fluidRow(
          box(width = 12, selectInput("category", "Select Product Category:", 
                                      choices = NULL, selected = NULL))
        ),
        fluidRow(
          valueBoxOutput("total_price_box", width = 4),
          valueBoxOutput("total_qty_box", width = 4),
          valueBoxOutput("total_customer_box", width = 4)
        ),
        fluidRow(
          box(title = div(strong("Customer by Location"), style="text-align: center; font-size: 100%;"), 
              width = 4, highchartOutput("location_bar")),
          box(title = div(strong("Gender Distribution"), style="text-align: center; font-size: 100%;"), 
              width = 4, highchartOutput("gender_pie")),
          box(title = div(strong("Age Distribution"), style="text-align: center; font-size: 100%;"), 
              width = 4, highchartOutput("age_hist"))
        ),
        fluidRow(
          box(title = tags$b("Top 5 Customers by Category and Voucher Recommendation"), status = "primary", width = 12,
              DTOutput("top_customer_table"))
        )
      ),
      
      # Tab Transaction
      tabItem(
        tabName = "transaction",
        fluidRow(
          box(width = 6, selectInput("select_location", "Select Lokasi", choices = NULL)),
          box(width = 6, selectInput("select_product", "Select Produk", choices = NULL))
        ),
        fluidRow(
          box(width = 4, valueBoxOutput("total_revenue", width = NULL)),
          box(width = 4, valueBoxOutput("total_transactions", width = NULL)),
          box(width = 4, valueBoxOutput("avg_discount", width = NULL))
        ),
        fluidRow(
          box(title = tags$b("Total Sales by Location"), status = "primary", width = 6,
              DTOutput("location_price_table")),
          box(title = tags$b("Top Payment Methods"), status = "primary", width = 6,
              DTOutput("top_payment_table"))),
        fluidRow(
          box(title = tags$b("Top Products by Discount"), status = "primary", width = 6,
              DTOutput("top_discount_table")),
          box(title = tags$b("Top Products by Transaction"), status = "primary", width = 6,
              DTOutput("top_products_table"))
        )
      ),
      
      # Tab Table
      tabItem(
        tabName = "table",
        fluidRow(
          box(width = 12, collapsible = TRUE, collapsed = TRUE, 
              title = "Online Shop Data", status = "primary",
              DTOutput("tableOnlineShop"))
        ),
        fluidRow(
          box(width = 12, collapsible = TRUE, collapsed = TRUE, 
              title = "Transaction Data", status = "primary",
              DTOutput("tableTransaction"))
        ),
        fluidRow(
          box(width = 12, collapsible = TRUE, collapsed = TRUE, 
              title = "Customer Data", status = "primary",
              DTOutput("tableCustomer"))
        ),
        fluidRow(
          box(width = 12, collapsible = TRUE, collapsed = TRUE, 
              title = "Product Data", status = "primary",
              DTOutput("tableProduct"))
        ),
        fluidRow(
          box(width = 12, collapsible = TRUE, collapsed = TRUE, 
              title = "Voucher Data", status = "primary",
              DTOutput("tableVoucher"))
        )
      ),
      
      # Tab Member
      tabItem(
        tabName = "member",
        fluidRow(
          box(width = 12, div(strong("Team Members"), style="text-align: center; font-size: 200%;"))
        ),
        fluidRow(
          box(width = 4, 
              div(strong("DB-Manager"),style="text-align: center; font-size: 150%;"),
              div(imageOutput("Panji"), style="text-align: center; margin-bottom:-180px;"),
              div(strong("Panji Lokajaya Arifa"),style="text-align: center;"),
              div(strong("M0501241036"),style="text-align: center;")),
          
          box(width = 4, 
              div(strong("DB-Designer"),style="text-align: center; font-size: 150%;"),
              div(imageOutput("Syafiq"), style="text-align: center; margin-bottom:-180px;"),
              div(strong("Muhammad Syafiq"),style="text-align: center;"),
              div(strong("M0501241005"),style="text-align: center;")),
          
          box(width = 4, 
              div(strong("Back-End"),style="text-align: center; font-size: 150%;"),
              div(imageOutput("Unique"), style="text-align: center; margin-bottom:-180px;"),
              div(strong("Unique Desyrre A. Resiloy"),style="text-align: center;"),
              div(strong("M0501241025"),style="text-align: center;"))
        ),
        fluidRow(
          box(width = 6, 
              div(strong("Front-End"),style="text-align: center; font-size: 150%;"),
              div(imageOutput("Zahra"), style="text-align: center; margin-bottom:-180px;"),
              div(strong("Putri Nisrina Az-Zahra"),style="text-align: center;"),
              div(strong("M0501241050"),style="text-align: center;")),
          
          box(width = 6, 
              div(strong("Technical-Writer"),style="text-align: center; font-size: 150%;"),
              div(imageOutput("Riza"), style="text-align: center; margin-bottom:-180px;"),
              div(strong("Riza Rahmah Angelia"),style="text-align: center;"),
              div(strong("M0501241008"),style="text-align: center;"))
        )
      )
    ),
    
    # Footer
    fluidRow(
      tags$div(
        HTML("by <b>Kelompok 4</b> | 2025 "),
        style = "text-align:center; padding:10px; font-size:14px; color:gray;"
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Konfigurasi database Clever Cloud
  db_config <- list(
    host = "btlxevouzglcbl1tixko-mysql.services.clever-cloud.com",
    port = 3306,
    user = "uf6r5artq92yro23",
    password = "lEDiwks9mEx8UB0XdrT7",
    dbname = "btlxevouzglcbl1tixko"
  )
  
  con_db <- dbConnect(
    MySQL(),
    host = db_config$host,
    port = db_config$port,
    user = db_config$user,
    password = db_config$password,
    dbname = db_config$dbname
  )
  
  # Tab Onlineshop  
  
  customer_data <- reactive({
    dbGetQuery(con_db, "SELECT * FROM OnlineShop")
  })
  
  observe({
    updateSelectInput(session, "category", 
                      choices = c("All", unique(customer_data()$Product_Category)),
                      selected = "All")
  })
  
  # Update server logic to filter by selected category
  data_filtered <- reactive({
    req(customer_data())  # Pastikan data tersedia
    if (input$category == "All") {
      customer_data()
    } else {
      customer_data() %>% filter(Product_Category == input$category)
    }
  })
  
  output$total_price_box <- renderValueBox({
    total_price <- data_filtered() %>%
      summarise(Total_Price = sum(Total_Price, na.rm = TRUE)) %>%
      pull(Total_Price)
    
    valueBox(
      paste("$",format(total_price, big.mark = ",")),
      "Total Revenue",
      color = "navy",
      icon = icon("dollar-sign")
    )
  })
  
  output$total_qty_box <- renderValueBox({
    total_qty <- data_filtered() %>%
      summarise(Total_qty = sum(Quantity, na.rm = TRUE)) %>%
      pull(Total_qty)
    
    valueBox(
      paste(format(total_qty, big.mark = ",")),
      "Total Quantity Sold",
      color = "light-blue",
      icon = icon("store")
    )
  })
  
  output$total_customer_box <- renderValueBox({
    total_customers <- data_filtered() %>%
      summarise(Total_customers = n_distinct(CustomerID, na.rm = TRUE)) %>%
      pull(Total_customers)
    
    valueBox(
      paste(format(total_customers, big.mark = ",")),
      "Total Customers",
      color = "teal",
      icon = icon("users")
    )
  })
  
  output$gender_pie <- renderHighchart({
    data <- data_filtered()
    
    gender_count <- data %>%
      filter(!is.na(Gender)) %>%
      group_by(Gender) %>%
      summarise(n = n()) %>%
      ungroup()
    
    highchart() %>%
      hc_chart(type = "pie") %>%
      hc_colors(c("#FFB1B1", "#1679AB")) %>% 
      hc_add_series(
        name = "Count",
        data = lapply(1:nrow(gender_count), function(i) {
          list(name = gender_count$Gender[i], y = gender_count$n[i])
        })
      ) %>%
      hc_plotOptions(pie = list(
        allowPointSelect = TRUE,
        cursor = "pointer",
        dataLabels = list(enabled = TRUE, format = "<b>{point.name}</b>: ({point.percentage:.1f}%)")
      ))
  })
  
  output$location_bar <- renderHighchart({
    data <- data_filtered()
    
    location_count <- data %>%
      filter(!is.na(Location)) %>%
      group_by(Location) %>%
      summarise(n = n()) %>%
      ungroup() %>%
      arrange(desc(n))
    
    highchart() %>%
      hc_chart(type = "column") %>%
      hc_colors(c("#2973B2", "#48A6A7", "#9ACBD0", "#A3D1C6")) %>% 
      hc_xAxis(categories = location_count$Location) %>%
      hc_yAxis(title = list(text = "Number of Customers")) %>%
      hc_add_series(
        name = "Count",
        data = location_count$n, 
        colorByPoint = TRUE) %>%
      hc_plotOptions(column = list(
        pointPadding = 0.2,
        borderWidth = 0
      ))
  })
  
  output$age_hist <- renderHighchart({
    data <- data_filtered() %>% filter(!is.na(Age))
    
    # Buat kategori generasi berdasarkan umur
    data$Generation <- cut(
      data$Age,
      breaks = c(-Inf, 27, 43, 59, Inf),  # Sesuaikan dengan rentang umur 2024
      labels = c("Gen Z", "Millennial", "Gen X", "Baby Boomers")
    )
    
    # Hitung jumlah individu dalam setiap generasi
    gen_data <- as.data.frame(table(data$Generation))
    names(gen_data) <- c("Generation", "Count")
    
    highchart() %>%
      hc_chart(type = "column") %>%
      hc_xAxis(categories = gen_data$Generation, title = list(text = "Generation")) %>%
      hc_yAxis(title = list(text = "Count")) %>%
      hc_colors(c("#2973B2", "#48A6A7", "#9ACBD0")) %>%
      hc_add_series(
        name = "Count",
        data = as.numeric(gen_data$Count),
        colorByPoint = TRUE
      ) %>%
      hc_plotOptions(column = list(
        pointPadding = 0.2,
        borderWidth = 0
      ))
  })
  
  # TABLES
  
  # Tab OnlineShop 
  
  output$tableOnlineShop <- renderDT({
    datatable(dbGetQuery(con_db, "SELECT * FROM OnlineShop"),
              options = list(scrollX = TRUE, 
                             scrollY = "400px",
                             pageLength = 20, 
                             autoWidth = TRUE, 
                             class = 'cell-border stripe'))
  })
  
  # Tab Transaction  
  
  output$tableTransaction <- renderDT({
    datatable(dbGetQuery(con_db, "SELECT * FROM Transaction"),
              options = list(scrollX = TRUE, 
                             scrollY = "400px",
                             pageLength = 20, 
                             autoWidth = TRUE, 
                             class = 'cell-border stripe'))
  })
  
  # Tab Customer
  
  output$tableCustomer <- renderDT({
    datatable(dbGetQuery(con_db, "SELECT * FROM Customer"),
              options = list(scrollX = TRUE, 
                             scrollY = "400px",
                             pageLength = 20, 
                             autoWidth = TRUE, 
                             class = 'cell-border stripe'))
  })
  
  # Tab Product
  
  output$tableProduct <- renderDT({
    datatable(dbGetQuery(con_db, "SELECT * FROM Product"),
              options = list(scrollX = TRUE, 
                             scrollY = "400px",
                             pageLength = 20, 
                             autoWidth = TRUE, 
                             class = 'cell-border stripe'))
  })
  
  # Tab Voucher
  
  output$tableVoucher <- renderDT({
    datatable(dbGetQuery(con_db, "SELECT * FROM Voucher"),
              options = list(scrollX = TRUE, 
                             scrollY = "400px",
                             pageLength = 20, 
                             autoWidth = TRUE, 
                             class = 'cell-border stripe'))
  })
  
  
  # Populate filter choices
  observe({
    location_choices <- dbGetQuery(con_db, "SELECT DISTINCT Locations FROM Customer")$Locations
    updateSelectInput(session, "select_location", 
                      choices = c("All", location_choices))
    
    product_choices <- dbGetQuery(con_db, "SELECT DISTINCT product_Name FROM Product")$product_Name
    updateSelectInput(session, "select_product", 
                      choices = c("All", product_choices))
  })
  
  # Total transactions
  output$total_transactions <- renderValueBox({
    query <- paste0("SELECT COUNT(TransactionID) AS total FROM Transaction WHERE 1=1",
                    if (input$select_location != "All") paste0(" AND CustomerID IN (SELECT CustomerID FROM Customer WHERE Locations = ", dbQuoteString(con_db, input$select_location), ")"),
                    if (input$select_product != "All") paste0(" AND ProductID IN (SELECT ProductID FROM Product WHERE product_Name = ", dbQuoteString(con_db, input$select_product), ")"))
    total_trans <- dbGetQuery(con_db, query)$total
    valueBox(value = total_trans, subtitle = "Total Transactions", icon = icon("shopping-cart"), color = "aqua")
  })
  
  # Total revenue
  output$total_revenue <- renderValueBox({
    query <- paste0("SELECT SUM(total_price) AS total FROM Transaction WHERE 1=1",
                    if (input$select_location != "All") paste0(" AND CustomerID IN (SELECT CustomerID FROM Customer WHERE Locations = ", dbQuoteString(con_db, input$select_location), ")"),
                    if (input$select_product != "All") paste0(" AND ProductID IN (SELECT ProductID FROM Product WHERE product_Name = ", dbQuoteString(con_db, input$select_product), ")"))
    total_rev <- dbGetQuery(con_db, query)$total
    valueBox(value = paste0("$", formatC(total_rev, format = "f", big.mark = ",", digits = 2)), 
             subtitle = "Total Revenue", icon = icon("dollar-sign"), color = "blue")
  })
  
  # Average discount
  output$avg_discount <- renderValueBox({
    query <- paste0("SELECT AVG(v.Discount) AS avg_discount 
              FROM Transaction t 
              LEFT JOIN Voucher v ON t.VoucherID = v.VoucherID WHERE 1=1",
                    if (input$select_location != "All") paste0(" AND CustomerID IN (SELECT CustomerID FROM Customer WHERE Locations = ", dbQuoteString(con_db, input$select_location), ")"),
                    if (input$select_product != "All") paste0(" AND ProductID IN (SELECT ProductID FROM Product WHERE product_Name = ", dbQuoteString(con_db, input$select_product), ")"))
    avg_disc <- dbGetQuery(con_db, query)$avg_discount
    valueBox(value = paste0(round(avg_disc, 2), "%"), 
             subtitle = "Average Discount", icon = icon("percent"), color = "light-blue")
  })
  
  # Query untuk Top 5 Produk Terlaris
  output$top_products_table <- renderDT({
    query <- "SELECT p.product_Name, COUNT(t.TransactionID) AS total_transactions
              FROM Transaction t
              JOIN Product p ON t.ProductID = p.ProductID
              GROUP BY p.product_Name
              ORDER BY total_transactions DESC;"
    
    datatable(dbGetQuery(con_db, query), options = list(pageLength = 5, scrollX = TRUE))
  })
  
  # Query untuk Urutan Lokasi Berdasarkan Total Harga
  output$location_price_table <- renderDT({
    query <- "SELECT Location, SUM(Total_Price) AS total_harga
              FROM OnlineShop
              GROUP BY Location
              ORDER BY total_harga DESC;"
    
    datatable(dbGetQuery(con_db, query), options = list(pageLength = 5, lengthChange = FALSE, searching = FALSE))
  })
  
  # Query untuk Top Metode Pembayaran Berdasarkan Jumlah Transaksi
  output$top_payment_table <- renderDT({
    query <- "SELECT Method_name, COUNT(*) AS TransactionID
              FROM OnlineShop
              GROUP BY Method_name
              ORDER BY TransactionID DESC;"
    
    datatable(dbGetQuery(con_db, query), options = list(pageLength = 5, lengthChange = FALSE, searching = FALSE))
  })
  
  # Query untuk Top Produk Berdasarkan Diskon Terbesar
  output$top_discount_table <- renderDT({
    query <- "SELECT p.product_Name, MAX(v.Discount) AS Max_Discount 
              FROM Transaction t 
              JOIN Product p ON t.ProductID = p.ProductID 
              JOIN Voucher v ON t.VoucherID = v.VoucherID 
              GROUP BY p.product_Name 
              ORDER BY Max_Discount DESC;"
    
    datatable(dbGetQuery(con_db, query), options = list(pageLength = 5, scrollX = TRUE))
  })
  
  output$top_customer_table <- renderDT({
    data <- data_filtered() %>%
      group_by(CustomerID, Age, Gender, Location, VoucherID, Voucher_name) %>%
      summarise(Total_Price = round(sum(Total_Price, na.rm = TRUE), 1), .groups = "drop") %>%
      arrange(desc(Total_Price)) %>%
      rename(
        `Total Expenses` = Total_Price,
        `Voucher Recommendation` = VoucherID,
        `Total Discount` = Voucher_name
      ) %>%
      select(CustomerID, Age, Gender, Location, `Total Expenses`, `Voucher Recommendation`, `Total Discount`) %>%
      head(5)  # Ambil hanya 5 baris teratas
    
    datatable(data, options = list(pageLength = 5, lengthChange = FALSE, searching = FALSE))
  })
  
  
  
  # Tab Member
  
  output$Panji <- renderImage({
    list(src = "www/Panji.jpg", contentType = "image/jpg", 
         width = "200px", height = "200px")}, deleteFile = FALSE)
  
  output$Syafiq <- renderImage({
    list(src = "www/Syafiq.jpg", contentType = "image/jpg", 
         width = "200px", height = "200px")}, deleteFile = FALSE)
  
  output$Unique <- renderImage({
    list(src = "www/Unique.jpg", contentType = "image/jpg", 
         width = "200px", height = "200px")}, deleteFile = FALSE)
  
  output$Zahra <- renderImage({
    list(src = "www/Zahra.jpg", contentType = "image/jpg", 
         width = "200px", height = "200px")}, deleteFile = FALSE)
  
  output$Riza <- renderImage({
    list(src = "www/Riza.jpg", contentType = "image/jpg", 
         width = "200px", height = "200px")}, deleteFile = FALSE)
  
  output$logo <- renderImage({
    list(src = "www/logo.png", width = 150, height = 150)}, deleteFile = FALSE)
  
  output$graphic <- renderImage({
    list(src = "www/graphic.png", width = 150, height = 150)}, deleteFile = FALSE)
  
  # Tutup koneksi saat aplikasi berhenti
  onStop(function() {
    dbDisconnect(con_db)
  })
}


# Run App
shinyApp(ui, server)