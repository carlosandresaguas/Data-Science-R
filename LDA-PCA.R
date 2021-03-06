require(MASS)

# Load data
data(iris)

head(iris, 3)

r <- lda(formula = Species ~ ., 
         data = iris, 
         prior = c(1,1,1)/3)

r 
r$svd
prop = r$svd^2/sum(r$svd^2)
prop


require(ggplot2)
require(scales)
require(gridExtra)

pca <- prcomp(iris[,-5],
              center = TRUE,
              scale. = TRUE) 

prop.pca = pca$sdev^2/sum(pca$sdev^2)

lda <- lda(Species ~ ., 
           iris, 
           prior = c(1,1,1)/3)

prop.lda = r$svd^2/sum(r$svd^2)

plda <- predict(object = lda,
                newdata = iris)

dataset = data.frame(species = iris[,"Species"],
                     pca = pca$x, lda = plda$x)

p1 <- ggplot(dataset) + geom_point(aes(lda.LD1, lda.LD2, colour = species, shape = species), size = 2.5) + 
  labs(x = paste("LD1 (", percent(prop.lda[1]), ")", sep=""),
       y = paste("LD2 (", percent(prop.lda[2]), ")", sep=""))

p2 <- ggplot(dataset) + geom_point(aes(pca.PC1, pca.PC2, colour = species, shape = species), size = 2.5) +
  labs(x = paste("PC1 (", percent(prop.pca[1]), ")", sep=""),
       y = paste("PC2 (", percent(prop.pca[2]), ")", sep=""))

grid.arrange(p1, p2)
