NUM_STATES <- 60 * 24 * 4

reported_postures <- c(
  horizontal = 0,
  upright = 2,
  walking = 3,
  running = 4,
  unknown = 5
)

simulated_postures <- c("sleeping", "resting", "sitting", "eating", "standing", "walking", "running")

posture_mapping <- c(
  sleeping = 'horizontal',
  resting = 'horizontal',
  sitting = 'upright',
  eating = 'upright',
  standing = 'upright',
  walking = 'walking',
  running = 'running'
)

# I won't model "unknown"; postures near transitions could have some probability of being reported "unknown".

active_night <- matrix(c(
  0.95, 0.05, 0.00, 0.00, 0.00, 0.00, 0.00, # sleeping
  0.45, 0.45, 0.10, 0.00, 0.00, 0.00, 0.00, # resting
  0.00, 0.30, 0.50, 0.05, 0.15, 0.00, 0.00, # sitting
  0.00, 0.00, 0.45, 0.20, 0.35, 0.00, 0.00, # eating
  0.00, 0.00, 0.45, 0.00, 0.10, 0.45, 0.00, # standing
  0.00, 0.00, 0.00, 0.00, 0.75, 0.20, 0.05, # walking
  0.00, 0.00, 0.00, 0.00, 0.00, 0.05, 0.95  # running
), nrow=length(simulated_postures), byrow=T)

active_day <- matrix(c(
  0.25, 0.75, 0.00, 0.00, 0.00, 0.00, 0.00, # sleeping
  0.05, 0.45, 0.50, 0.00, 0.00, 0.00, 0.00, # resting
  0.00, 0.10, 0.55, 0.05, 0.30, 0.00, 0.00, # sitting
  0.00, 0.00, 0.45, 0.20, 0.35, 0.00, 0.00, # eating
  0.00, 0.00, 0.25, 0.05, 0.55, 0.15, 0.00, # standing
  0.00, 0.00, 0.00, 0.00, 0.25, 0.50, 0.25, # walking
  0.00, 0.00, 0.00, 0.00, 0.00, 0.05, 0.95  # running
), nrow=length(simulated_postures), byrow=T)

active_meal <- matrix(c(
  0.25, 0.75, 0.00, 0.00, 0.00, 0.00, 0.00, # sleeping
  0.05, 0.15, 0.80, 0.00, 0.00, 0.00, 0.00, # resting
  0.00, 0.00, 0.25, 0.75, 0.00, 0.00, 0.00, # sitting
  0.00, 0.00, 0.10, 0.80, 0.10, 0.00, 0.00, # eating
  0.00, 0.00, 0.25, 0.05, 0.55, 0.15, 0.00, # standing
  0.00, 0.00, 0.00, 0.00, 0.35, 0.50, 0.15, # walking
  0.00, 0.00, 0.00, 0.00, 0.00, 0.10, 0.90  # running
), nrow=length(simulated_postures), byrow=T)

sedentary_night <- matrix(c(
  0.95, 0.05, 0.00, 0.00, 0.00, 0.00, 0.00, # sleeping
  0.25, 0.45, 0.30, 0.00, 0.00, 0.00, 0.00, # resting
  0.00, 0.20, 0.70, 0.05, 0.05, 0.00, 0.00, # sitting
  0.00, 0.00, 0.45, 0.20, 0.35, 0.00, 0.00, # eating
  0.00, 0.00, 0.65, 0.00, 0.10, 0.25, 0.00, # standing
  0.00, 0.00, 0.00, 0.00, 0.75, 0.20, 0.05, # walking
  0.00, 0.00, 0.00, 0.00, 0.00, 0.95, 0.05  # running
), nrow=length(simulated_postures), byrow=T)

sedentary_day <- matrix(c(
  0.25, 0.75, 0.00, 0.00, 0.00, 0.00, 0.00, # sleeping
  0.25, 0.45, 0.30, 0.00, 0.00, 0.00, 0.00, # resting
  0.00, 0.20, 0.60, 0.05, 0.15, 0.00, 0.00, # sitting
  0.00, 0.00, 0.45, 0.20, 0.35, 0.00, 0.00, # eating
  0.00, 0.00, 0.35, 0.10, 0.40, 0.15, 0.00, # standing
  0.00, 0.00, 0.00, 0.00, 0.55, 0.40, 0.05, # walking
  0.00, 0.00, 0.00, 0.00, 0.00, 0.80, 0.20  # running
), nrow=length(simulated_postures), byrow=T)

sedentary_meal <- matrix(c(
  0.25, 0.75, 0.00, 0.00, 0.00, 0.00, 0.00, # sleeping
  0.05, 0.45, 0.50, 0.00, 0.00, 0.00, 0.00, # resting
  0.00, 0.15, 0.20, 0.60, 0.05, 0.00, 0.00, # sitting
  0.00, 0.00, 0.10, 0.80, 0.10, 0.00, 0.00, # eating
  0.00, 0.00, 0.35, 0.10, 0.40, 0.15, 0.00, # standing
  0.00, 0.00, 0.00, 0.00, 0.55, 0.40, 0.05, # walking
  0.00, 0.00, 0.00, 0.00, 0.00, 0.80, 0.20  # running
), nrow=length(simulated_postures), byrow=T)

POSTURE_TRANSITION_MATRICES <- list(
  active = list(
    day = active_day,
    night=active_night,
    meal=active_meal
  ),
  sedentary = list(
    day = sedentary_day,
    night=sedentary_night,
    meal= sedentary_meal
  )
)

# lapply(POSTURE_TRANSITION_MATRICES, sapply, rowSums)

next_state <- function(current_state, transition_matrix)
  which.max(transition_matrix[current_state,] * runif(nrow(transition_matrix)))

# A patient's transition matrix will be a mixture of active and sedentary, based on activity score
compute_transition_matrices <- function(activity){
  dayparts <- c("day", "night", "meal")
  names(dayparts) <- dayparts
  lapply(dayparts, function(dp){
    activity * POSTURE_TRANSITION_MATRICES[["active"]][[dp]] + 
      (1 - activity)*POSTURE_TRANSITION_MATRICES[["sedentary"]][[dp]]
  })
}

# Run simulation of states

# Each set of states starts at midnight with the patient asleep. 
# These dates are not used, so we can pretend they happen on any day we want when assigning hospital discharge dates.

DAY_TIMES <- SIM_START_TIME + 60*(1:(24*60))
hour <- as.POSIXlt(DAY_TIMES)[['hour']]
DAY_PART <- ifelse(hour %in% c(0:6, 22:23), "night",
                   ifelse(hour %in% c(7, 12, 18), "meal", "day"))

sim_state <- function(activity_level, num_states=(4*24*60), seed=123){
  set.seed(seed)
  patient_state <- numeric(num_states)
  patient_state[1] <- 1
  circadian_adjustment <- round(rnorm(1, mean=0, sd=45))
  pt_tmats <- compute_transition_matrices(activity_level)
  for (st in 2:num_states){
    shifted_state_idx <- 1 + (st + (circadian_adjustment - 1)) %% length(DAY_TIMES)
    circadian_day_part <- DAY_PART[shifted_state_idx]
    transmat <- pt_tmats[[circadian_day_part]]
    patient_state[st] <- next_state(patient_state[st-1], transmat)
  }
  patient_state
}

# sim_state(0.5)

calculate_activity_states <- function(activity_levels){
  PATIENT_STATE <- t(apply(activity_levels, 1, 
                           function(v) sim_state(v[['sal1']], seed=v[['encounter_id']])))
  rownames(PATIENT_STATE) <- activity_levels$encounter_id
  PATIENT_STATE
}

summarize_activity_states <- function(activity_levels){
  state_counts <- t(apply(activity_levels, 1, function(v){
    state_vec <- sim_state(v[['sal1']], seed=v[['encounter_id']])
    sapply(1:7, function(p) sum(state_vec == p))
  }))
  rownames(state_counts) <- activity_levels$encounter_id
  state_counts
}

# activity_state_summaries <- summarize_activity_states(secret_activity_levels)
# saveRDS(activity_state_summaries, file="activity_state_summaries.Rds")
# 
# activity_state_summaries <- readRDS("activity_state_summaries.Rds")
# minutes_walking <- activity_state_summaries[,6]

