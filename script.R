suppressMessages(library(dplyr))
suppressMessages(library(UpSetR))
suppressMessages(library("ggplot2"))

args <- commandArgs(trailingOnly = TRUE)

var1 <- args[1]
var2 <- args[2]


df1 = read.table(var1, header = TRUE)
#df1 = read.table("Proteomics_milk.tsv", header = TRUE)
df2 = read.table(var2, header = FALSE)
#df2 = read.table("test_data.tsv", header = FALSE)


df2 = df2 %>%
  mutate(sample = 1)

result_df = df1 %>%
  left_join(df2 %>% select(V1, sample), by = c("genes" = "V1"))

result_df = result_df %>% replace(is.na(.), 0)
data  = result_df %>% select(-genes)

# Split the sets into two groups
exosomes_set = c("human", "bovine", "goat", "donkey", "sample")
milk_set = c("human_milk", "bovine_milk", "goat_milk", "sample")

# Create two data frames for each panel
exosomes_data <- data[, exosomes_set]
milk_data <- data[, milk_set]


cat("Creating an UpSetPlot for exosome proteins")
# Create the UpSet plot
jpeg("UpSetPlot_exosomes.jpg", width = 16, height = 10, units = 'in', res = 600)
upset(exosomes_data, sets = exosomes_set, order.by = "freq",
#		set_order = c("a", "b", "c"),
		mainbar.y.label = "Intersection Size", 
		sets.x.label = "Set Size",
#     nsets = 6,
#		c(intersection size title, intersection size tick labels, set size title, set size tick labels, set names, numbers above bars)
      text.scale = c(2, 1.5, 2, 1.5, 2, 2),
      point.size = 4.0, 
      line.size = 1.7,
#     sets.bar.color = "lightblue", 
#		main.bar.color = "lightgray",
		empty.intersections = "on",
		keep.order = TRUE,
#		group.by = "sets"
      ) 
none = dev.off()
cat(" - Done \n")

cat("Creating an UpSetPlot for milk proteins")
# Create the UpSet plot
jpeg("UpSetPlot_milk.jpg", width = 16, height = 10, units = 'in', res = 600)
upset(milk_data, sets = milk_set, order.by = "freq",
		mainbar.y.label = "Intersection Size", 
		sets.x.label = "Set Size",
#     nsets = 6,
#		c(intersection size title, intersection size tick labels, set size title, set size tick labels, set names, numbers above bars)
      text.scale = c(2, 1.5, 2, 1.5, 2, 2),
      point.size = 4.0, 
      line.size = 1.7,
#     sets.bar.color = "lightblue", 
#		main.bar.color = "lightgray",
		empty.intersections = "on",
		keep.order = TRUE,
#		group.by = "sets"
      )
none = dev.off()
cat(" - Done \n")


