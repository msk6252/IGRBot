# URLにアクセスするためのライブラリの読み込み                                                                                                                 
require 'open-uri'                                                                                                                                            
# Nokogiriライブラリの読み込み                                                                                                                                
require 'nokogiri'                                                                                                                                            

# スクレイピング先のURL（青山駅の例）                                                                                                                                       
url = 'http://www.igr.jp/wp/timetable/takizawa'                                                                                                                 

charset = nil                                                                                                                                                 
html = open(url) do |f|                                                                                                                                       
    charset = f.charset # 文字種別を取得                                                                                                                      
    f.read # htmlを読み込んで変数htmlに渡す                                                                                                                   
end                                                                                                                                                           

# htmlをパース(解析)してオブジェクトを生成                                                                                                                    
docs = Nokogiri::HTML.parse(html, nil, charset)                                                                                                               

TIMES_TARGET_NUMBER = 5                                                                                                                                       

#対象ページの時刻表欄抽出                                                                                                                                     
lines = docs.xpath("//div[@class='post']/p[#{TIMES_TARGET_NUMBER}]").text                                                                                     
times = lines.to_s.strip.split(/[\r\n]+/)                                                                                                                     

time_and_sts = times.map do |time|                                                                                                                            
    time.split(/[\s]/) if time =~ /^[0-9]+:[0-9]+/                                                                                                            
end.compact                                                                                                                                                   

now_time = Time.now                                                                                                                                           

next_trains = time_and_sts.map do |time|                                                                                                                      
    time_str = time[0].split(/[:]/)                                                                                                                           
    if now_time.hour <= time_str[0].to_i                                                                                                                     
        time if now_time.hour < time_str[0].to_i || now_time.min <= time_str[1].to_i                                                                          
    end                                                                                                                                                       
end.compact                                                                                                                                                   
puts next_trains
