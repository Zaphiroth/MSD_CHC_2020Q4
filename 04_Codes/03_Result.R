# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  MSD CHC 2020Q4
# Purpose:      Result
# programmer:   Zhe Liu
# Date:         2021-02-24
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


##---- MSD CHC 2020Q4 ----
msd.2020q4 <- history.msd %>% 
  filter(Channel == 'CHC', Date == '2020Q3') %>% 
  mutate(Pack_ID = stri_pad_left(Pack_ID, 7, 0)) %>% 
  pivot_wider(names_from = Measurement, 
              values_from = Value) %>% 
  left_join(growth.msd, by = c('City' = 'city_en', 'Pack_ID' = 'packid')) %>% 
  mutate(growth_value = if_else(is.na(growth_value), 1, growth_value), 
         growth_volume = if_else(is.na(growth_volume), 1, growth_volume), 
         growth_dosage = if_else(is.na(growth_dosage), 1, growth_dosage)) %>% 
  mutate(Date = '2020Q4', 
         Sales = Sales * growth_value, 
         Units = Units * growth_volume, 
         DosageUnits = DosageUnits * growth_dosage, 
         PDot = PDot * growth_dosage) %>% 
  pivot_longer(cols = c(Sales, Units, DosageUnits, PDot), 
               names_to = 'Measurement', 
               values_to = 'Value') %>% 
  select(-starts_with('growth_'))


##---- MSD delivery ----
delivery.msd <- bind_rows(history.msd, msd.2020q4) %>% 
  arrange(Channel, Date, Province, City, MKT, Pack_ID)

write.xlsx(delivery.msd, '03_Outputs/MSD_CHC_OAD_Dashboard_2020Q4.xlsx')
