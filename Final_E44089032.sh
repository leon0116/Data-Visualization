
PS=TWtopoRot
RANGE=118/125/20/26
ID=E44089032
#CPT=relief
#CPT=globe
#i=1

rm *.ps
rm *.mp4
rm *.png

#creat CPT file from GRD file
gmt grd2cpt etopo.grd -Crelief -Z -V > topo.cpt

## 3D topo
gmt makecpt -Crelief -T-6000/4000/50 -Z > topo3d.cpt

## Creat illumination (shade)  file
gmt grdgradient etopo.grd  -A60 -M -Nt0.75 -Gbathy_gradient.grd

gmt grdcut etopo.grd -Getopo_tw.grd -R$RANGE

#create TW  grd file for illumination
gmt grdgradient etopo_tw.grd -A60 -Getopo_tw.in.grd -Nt0.75 -M

for i in $(seq -f "%03g" 32 180)
do

## 3D Taiwan Map
    gmt grdview etopo_tw.grd -Ietopo_tw.in.grd -JM3i -JZ1.3i -Ctopo3d.cpt -E$i/30 -R118/125/20/26/-8000/4000 -X1i -Y1i -N-8000/220/220/220 -Qi100 -V -K > $PS'.'$i'.ps'

#To plot 3-D basemap at Z=-6000m
    gmt psbasemap -R -JM -JZ -BZ+t"E44089032_$i" -Bxa2 -Bya2  -Bza2000+l"Topo (m)" -E$i/30 -Z-8000 --MAP_FRAME_TYPE=plain -K -O -V >> $PS'.'$i'.ps'
    gmt pscoast -R -JM -JZ -p$i/30 -Na -Z0 -Di -W.5 -V -K -O >> $P'.'S$i'.ps'
    echo 120.215 23 0 NCKU | gmt psxyz -R -J -JZ -Sc0.05i -Gred -E$i/30 -V -K -O >> $PS'.'$i'.ps'
    echo 120.215 23 NCKURE | gmt pstext -R -J -JZ -F+f8,2+a5+jTL -E$i/30 -Z0 -D-1.4/-0.2 -V -K -O >> $PS'.'$i'.ps'
    echo "120.215 23 $ID" | gmt pstext -R -J -JZ -F+f8,2+a5+jTL -E$i/30 -Z0 -D-1.6/-0.5 -V -K -O >> $PS'.'$i'.ps'
    gmt psscale -R -J -Ctopo3d.cpt -DJTR+o0/1c -p -Ba1000+l"Elevation (m)" -V -K -O >> $PS'.'$i'.ps'

    gmt psxy -R -J -JZ -T -O >> $PS'.'$i'.ps'
    gmt psconvert -A -Tg $PS'.'$i'.ps'
    rm $PS'.'$i'.ps'
    echo $PS'.'$i'.'png done
    #start $PS'.'$i'.png'
done
#convert to viedo
ffmpeg -r 10 -start_number 32 -i $PS'.%03d.png' 'Final_'$ID'.mp4'


