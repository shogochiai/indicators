# Parabolic Stop-and-Reversal
# http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:parabolic_sar
# 
# ------------------------------
# 
# [Rising SAR]
#
# Prior SAR: The SAR value for the previous period. 
#
# Extreme Point (EP): The highest high of the current uptrend. 
#
# Acceleration Factor (AF):
#   Starting at .02, AF increases by .02 each
#   time the extreme point makes a new high. AF can reach a maximum 
#   of .20, no matter how long the uptrend extends. 
#
# Current SAR = Prior SAR + Prior AF(Prior EP - Prior SAR)
#             = 48.13 + .14(49.20 - 48.13)
#             = 48.28
#
# The Acceleration Factor is multiplied by the difference between the 
# Extreme Point and the prior period's SAR. This is then added to the 
# prior period's SAR. Note however that SAR can never be above the
# prior two periods' lows. Should SAR be above one of those lows, use
# the lowest of the two for SAR. 
#
# ------------------------------
#
# [Falling SAR]
#
# Prior SAR: The SAR value for the previous period. 
#
# Extreme Point (EP): The lowest low of the current downtrend. 
#
# Acceleration Factor (AF):
#   Starting at .02, AF increases by .02 each 
#   time the extreme point makes a new low. AF can reach a maximum
#   of .20, no matter how long the downtrend extends. 
# 
# Current SAR = Prior SAR - Prior AF(Prior SAR - Prior EP)
#             = 43.84 - .16(43.84 - 42.07)
#             = 43.56
#
# The Acceleration Factor is multiplied by the difference between the 
# Prior period's SAR and the Extreme Point. This is then subtracted 
# from the prior period's SAR. Note however that SAR can never be
# below the prior two periods' highs. Should SAR be below one of
# those highs, use the highest of the two for SAR. 
#
# ------------------------------

module Indicators
  class Psar
    # Input: Price array of that period
    # Returns: []
    def self.calculate data, parameters
      iaf, maxaf = parameters[0], parameters[1]
puts data
      length = data[:date].length
      tail_index = length - 1
      dates = data[:date]
      high = data[:high]
      low = data[:low]
      close = data[:close]
      psar = close[0..tail_index]
      
      # "bull" swing its horn to above, then uptrend symbol, "bear" swing its nail to below, then downtrend symbol.
      psarbull = psarbear = Array.new length
      
      bull = true
      af = iaf
      ep = low[0]
      hp = high[0]
      lp = low[0]
      for i in (2..tail_index)
        reverse = false

        # in bull trend, check psar is always lower than low
        if bull
          # monotonically increase
          psar[i] = psar[i - 1] + af * (hp - psar[i - 1])

          # "if reverse" flow
          if low[i] < psar[i]
            bull = !bull
            reverse = true
            psar[i] = lp
            lp = low[i]
            af = iaf
          end

          # normal flow
          if not reverse

            # update pramas
            if high[i] > hp
              hp = high[i]
              af = [af + iaf, maxaf].min
            end

            # double check?
            if low[i - 1] < psar[i]
              psar[i] = low[i - 1]
            end
            if low[i - 2] < psar[i]
              psar[i] = low[i - 2]
            end
          end
          psarbull[i] = psar[i]

        # in bear trend, check psar is always higher than high
        else
          # monotonically decrease
          psar[i] = psar[i - 1] - af * (psar[i - 1] - lp)
          if high[i] > psar[i]
            bull = !bull
            reverse = true
            psar[i] = hp
            hp = high[i]
            af = iaf
          end
          if not reverse
            if low[i] < lp
              lp = low[i]
              af = [af + iaf, maxaf].min
            end
            if high[i - 1] > psar[i]
              psar[i] = high[i - 1]
            end
            if high[i - 2] > psar[i]
              psar[i] = high[i - 2]
            end
          end
          psarbear[i] = psar[i]
        end
        puts "i: #{i}, bull: #{bull}, reverse: #{reverse}, psar[i - 1]: #{psar[i - 1]}, psar[i]: #{psar[i]}, af: #{af}, hp: #{hp}, lp: #{lp}, ep: #{ep}"
      end
      return {"dates":dates, "high":high, "low":low, "close":close, "psar":psar, "psarbear":psarbear, "psarbull":psarbull}
    end

  end
end

