.bad_coords <- data.table(
  lat = c(30.917, 31.083, 31.250, 31.417, 31.750, 31.917),
  lon = c(35.417, 35.417, 35.417, 35.417, 35.583, 35.583)
)

.cru_month_names <- c(
  "jan",
  "feb",
  "mar",
  "apr",
  "may",
  "jun",
  "jul",
  "aug",
  "sep",
  "oct",
  "nov",
  "dec"
)

CRU_FILES <- c(
  pre = "grid_10min_pre.dat.gz",
  rd0 = "grid_10min_rd0.dat.gz",
  tmp = "grid_10min_tmp.dat.gz",
  dtr = "grid_10min_dtr.dat.gz",
  reh = "grid_10min_reh.dat.gz",
  sunp = "grid_10min_sunp.dat.gz",
  frs = "grid_10min_frs.dat.gz",
  wnd = "grid_10min_wnd.dat.gz",
  elv = "grid_10min_elv.dat.gz"
)
