library(ROCR)

sign_preds <- read.delim("out/kinase-pssm-signed.tsv", as.is=TRUE)
rownames(sign_preds) <- paste(sign_preds$node1, sign_preds$node2, sep="_")
val_set <- read.table("data/sign-validation-set-omnipath.tsv")
names(val_set) <- c("node1",  "node2", "label")
rownames(val_set) <- paste(val_set$node1, val_set$node2, sep="_")

test_data <- merge(sign_preds, val_set)
test_data <- subset(test_data, !is.na(pssm.score))
test_data_act <- subset(test_data, label=="activates")
test_data_inhib <- subset(test_data, label=="inhibits")

test_data_rand <- NULL
test_labels_rand <- NULL
n <- 80
reps <- 1000
for (i in 1:reps){
    rand_data <- c(sample(test_data_act$pssm.score, n),
                   sample(test_data_inhib$pssm.score, n))
    rand_labels <- c(rep(TRUE, n), rep(FALSE, n))
    if (is.null(test_data_rand)){
        test_data_rand <- rand_data
        test_labels_rand <- rand_labels
    }else{
        test_data_rand <- cbind(test_data_rand, rand_data)
        test_labels_rand <- cbind(test_labels_rand, rand_labels)
    }
}

## pred <- prediction(test_data$pssm.score, test_data$label=="activates")
pred <- prediction(test_data_rand, test_labels_rand)
perf_roc <- performance(pred, "tpr", x.measure="fpr")
perf_roc2 <- performance(pred, "tnr", x.measure="fnr")
perf_mcc <- performance(pred, "mat")
perf_tprtnr <- performance(pred, "tpr", x.measure="tnr")

max_mcc_is <- lapply(perf_mcc@y.values, which.max)
max_mcc_cutoffs <- lapply(1:length(max_mcc_is),
                           function(i){
                               perf_mcc@x.values[[i]][max_mcc_is[[i]]]
                           })
max_mcc_cutoff <- mean(unlist(max_mcc_cutoffs))

max_mcc <- mean(unlist(lapply(perf_mcc@y.values, max, na.rm=TRUE)))


pdf("img/pssm-sign-val.pdf")
plot(perf_roc, spread.estimate="boxplot", avg="vertical")
plot(perf_roc2, spread.estimate="boxplot", avg="vertical")
plot(perf_mcc, spread.estimate="stderror", avg="vertical")
abline(v=0.0, col="blue", lty=2)
dev.off()

