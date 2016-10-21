data_in <- maml.mapInputPort(1)

extract_weight_in_kg <- function(txt){
  pat <- "Vital signs:[^\\n<]+weight ?([0-9\\.]+) ?(kg|kilo|kilogram|lb|pound)"
  matches <- regexec(pat, txt, ignore.case=TRUE)
  
  get_matches <- function(match, src)
    substring(src, first=match, last=match + attr(match, "match.length"))
  
  M_list <- mapply(get_matches, matches, txt, SIMPLIFY=FALSE) # I'll simplify it myself, thank you
  M <- do.call("cbind", lapply(M_list, function(v) v[1:3]))
  
  val <- as.numeric(M[2,])
  unit <- ifelse(substr(M[3,],1,1) == 'k', 1, 1/2.20462)
  
  val * unit
}

weight <- extract_weight_in_kg(data_in$hx)
data_out <- data.frame(encounter_id=data_in$encounter_id, weight=weight)

maml.mapOutputPort("data_out");