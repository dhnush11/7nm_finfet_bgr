v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 210 -90 290 -90 {lab=#net1}
N -30 -120 170 -120 {lab=VDD}
N 170 -120 330 -120 {lab=VDD}
N 330 -120 520 -120 {lab=VDD}
N 10 -90 40 -90 {lab=#net1}
N 40 -90 40 -30 {lab=#net1}
N -120 -60 -30 -60 {lab=#net2}
N -120 -60 -120 -30 {lab=#net2}
N 170 -60 170 80 {lab=#net3}
N 210 110 290 110 {lab=#net4}
N 330 -60 330 80 {lab=#net1}
N 290 -90 290 -60 {lab=#net1}
N 290 -60 330 -60 {lab=#net1}
N -120 30 -120 80 {lab=#net5}
N -180 110 -160 110 {lab=#net5}
N -180 50 -180 110 {lab=#net5}
N -180 50 -120 50 {lab=#net5}
N -80 0 -0 0 {lab=#net1}
N -40 -50 -40 -0 {lab=#net1}
N -40 -50 40 -50 {lab=#net1}
N 40 -50 210 -50 {lab=#net1}
N 210 -90 210 -50 {lab=#net1}
N 40 30 250 30 {lab=#net4}
N 250 30 250 110 {lab=#net4}
N -120 140 -120 180 {lab=#net6}
N -180 210 -160 210 {lab=#net6}
N -180 160 -180 210 {lab=#net6}
N -180 160 -120 160 {lab=#net6}
N 170 140 170 180 {lab=#net7}
N 100 210 130 210 {lab=#net7}
N 100 160 100 210 {lab=#net7}
N 100 160 170 160 {lab=#net7}
N 330 140 330 170 {lab=#net8}
N 520 -60 520 -20 {lab=vref}
N 330 230 330 310 {lab=#net9}
N 370 340 430 340 {lab=#net9}
N 700 340 750 340 {lab=#net9}
N 330 310 470 310 {lab=#net9}
N 470 310 660 310 {lab=#net9}
N 660 310 790 310 {lab=#net9}
N 400 310 400 340 {lab=#net9}
N 730 310 730 340 {lab=#net9}
N 330 370 330 390 {lab=0}
N 280 390 330 390 {lab=0}
N 280 340 280 390 {lab=0}
N 280 340 330 340 {lab=0}
N 470 370 470 390 {lab=0}
N 470 390 520 390 {lab=0}
N 520 340 520 390 {lab=0}
N 470 340 520 340 {lab=0}
N 660 370 660 390 {lab=0}
N 610 340 660 340 {lab=0}
N 610 340 610 390 {lab=0}
N 610 390 660 390 {lab=0}
N 790 340 840 340 {lab=0}
N 790 370 790 390 {lab=0}
N 840 340 840 390 {lab=0}
N 790 390 840 390 {lab=0}
N 520 40 520 80 {lab=vctat}
N 460 110 480 110 {lab=vctat}
N 460 60 460 110 {lab=vctat}
N 460 60 520 60 {lab=vctat}
N -120 240 -120 270 {lab=0}
N 170 240 170 270 {lab=0}
N 520 140 520 170 {lab=0}
N 310 390 310 420 {lab=0}
N 490 390 490 420 {lab=0}
N 630 390 630 420 {lab=0}
N 810 390 810 420 {lab=0}
N 100 -160 100 -120 {lab=VDD}
N 700 210 700 230 {lab=0}
N 680 120 700 120 {lab=VDD}
N 700 120 700 150 {lab=VDD}
N 520 -40 600 -40 {lab=vref}
N 520 60 590 60 {lab=vctat}
N 480 -90 480 -60 {lab=#net1}
N 330 -60 480 -60 {lab=#net1}
N -120 210 -70 210 {lab=0}
N -70 210 -70 250 {lab=0}
N -120 250 -70 250 {lab=0}
N 170 210 220 210 {lab=0}
N 220 210 220 250 {lab=0}
N 170 250 220 250 {lab=0}
N -120 110 -70 110 {lab=0}
N -70 110 -70 210 {lab=0}
N 330 110 400 110 {lab=0}
N 400 110 400 140 {lab=0}
N 60 110 170 110 {lab=0}
N 60 110 60 130 {lab=0}
N -180 -0 -120 0 {lab=VDD}
N -180 -120 -180 0 {lab=VDD}
N -180 -120 -30 -120 {lab=VDD}
N -180 -90 -30 -90 {lab=VDD}
N 520 -120 550 -120 {lab=VDD}
N 550 -120 550 -90 {lab=VDD}
N 520 -90 550 -90 {lab=VDD}
N 330 -90 370 -90 {lab=VDD}
N 370 -120 370 -90 {lab=VDD}
N 130 -90 170 -90 {lab=VDD}
N 130 -120 130 -90 {lab=VDD}
N 520 110 570 110 {lab=0}
N 570 110 570 150 {lab=0}
N 520 150 570 150 {lab=0}
N 40 0 70 0 {lab=VDD}
N 70 -120 70 0 {lab=VDD}
C {asap_7nm_pfet.sym} 190 -90 0 1 {name=pfet1 model=asap_7nm_pfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_nfet.sym} 190 110 0 1 {name=nfet1 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_pfet.sym} 310 -90 0 0 {name=pfet2 model=asap_7nm_pfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_pfet.sym} 500 -90 0 0 {name=pfet3 model=asap_7nm_pfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_pfet.sym} -10 -90 0 1 {name=pfet4 model=asap_7nm_pfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_pfet.sym} 20 0 0 0 {name=pfet5 model=asap_7nm_pfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_pfet.sym} -100 0 0 1 {name=pfet6 model=asap_7nm_pfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_nfet.sym} 310 110 0 0 {name=nfet2 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_nfet.sym} -140 110 0 0 {name=nfet3 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_nfet.sym} -140 210 0 0 {name=nfet4 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_nfet.sym} 150 210 0 0 {name=nfet5 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {res_ac.sym} 330 200 0 0 {name=R2
value=33k
ac=1k
m=1}
C {res_ac.sym} 520 10 0 0 {name=R1
value=50k
ac=1k
m=1}
C {asap_7nm_nfet.sym} 450 340 0 0 {name=nfet6 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_nfet.sym} 350 340 0 1 {name=nfet7 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_nfet.sym} 770 340 0 0 {name=nfet8 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14
}
C {asap_7nm_nfet.sym} 680 340 0 1 {name=nfet10 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {asap_7nm_nfet.sym} 500 110 0 0 {name=nfet11 model=asap_7nm_nfet spiceprefix=X l=7e-009 nfin=14}
C {gnd.sym} -120 270 0 0 {name=l1 lab=0}
C {gnd.sym} 170 270 0 0 {name=l2 lab=0}
C {gnd.sym} 310 420 0 0 {name=l3 lab=0}
C {gnd.sym} 520 170 0 0 {name=l4 lab=0}
C {gnd.sym} 490 420 0 0 {name=l5 lab=0}
C {gnd.sym} 630 420 0 0 {name=l6 lab=0}
C {gnd.sym} 810 420 0 0 {name=l7 lab=0}
C {vdd.sym} 100 -160 0 0 {name=l8 lab=VDD}
C {vsource.sym} 700 180 0 0 {name=v2 value=1.75 savecurrent=false}
C {gnd.sym} 700 230 0 0 {name=l9 lab=0}
C {simulator_commands_shown.sym} 680 -100 0 0 {name=COMMANDS
simulator=ngspice
only_toplevel=false 
value="
.dc temp -45 150 5
.control
run
plot v(vref) v(vctat)
plot v(vref)-v(vctat)
plot v(vctat)
plot v(vref)
let temp_coeff = deriv(v(vref))/1.24
plot temp_coeff
plot net9/30k vref/33.33k vctat/33.33k
plot abs(v2#branch)
show all
.endc
"}
C {lab_pin.sym} 680 120 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 600 -40 0 1 {name=p2 sig_type=std_logic lab=vref}
C {lab_pin.sym} 590 60 0 1 {name=p3 sig_type=std_logic lab=vctat}
C {gnd.sym} 60 130 0 0 {name=l10 lab=0}
C {gnd.sym} 400 140 0 0 {name=l11 lab=0}
