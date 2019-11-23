:: https://trac.ffmpeg.org/wiki

(for %%i in (%1) do @echo file '%%i') > mylist.txt
ffmpeg -f concat -i mylist.txt -c copy output.mp4

:: http://www.kompx.com/ru/vyrezat-fragment-iz-video-ffmpeg.htm
ffmpeg -ss <начало> -t <продолжительность> -i in1.avi -vcodec copy -acodec copy out1.avi
ffmpeg -ss 01:19:00 -t 00:05:00 -i in1.avi -vcodec copy -acodec copy out1.avi

:: https://andreyv.ru/kak-obedinit-zvuk-i-video.html
ffmpeg.exe -i видео.mp4 -i аудио.wav -c:v copy -c:a copy -shortest результат.mkv c:v copy -c:a copy

:: 19 команд ffmpeg для любых нужд
:: https://habr.com/ru/post/171213/
ffmpeg -r 12 -y -i "image_%010d.png" output.mpg

ffmpeg -i son.wav -i video_origine.avi video_finale.mpg
