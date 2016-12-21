# Nimbix 2-node, dual K80 configuration OpenMPI
```
nimbix@JARVICENAE-0A0A1837:/data/torch_mpi$ cat /etc/JARVICE//nodes
JARVICENAE-0A0A1837
JARVICENAE-0A0A1939
```

```
nimbix@JARVICENAE-0A0A1837:/data/torch_mpi$ nvidia-smi
Thu Dec  8 21:14:09 2016
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 367.55                 Driver Version: 367.55                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla K80           On   | 0000:05:00.0     Off |                  Off |
| N/A   34C    P8    26W / 149W |      0MiB / 12205MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   1  Tesla K80           On   | 0000:06:00.0     Off |                  Off |
| N/A   31C    P8    29W / 149W |      0MiB / 12205MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   2  Tesla K80           On   | 0000:84:00.0     Off |                  Off |
| N/A   34C    P8    26W / 149W |      0MiB / 12205MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   3  Tesla K80           On   | 0000:85:00.0     Off |                  Off |
| N/A   29C    P8    29W / 149W |      0MiB / 12205MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID  Type  Process name                               Usage      |
|=============================================================================|
|  No running processes found                                                 |
```

```
nimbix@JARVICENAE-0A0A1837:/data/torch_mpi$ nvidia-smi topo -m
        GPU0    GPU1    GPU2    GPU3    mlx5_0  CPU Affinity
GPU0     X      PIX     SOC     SOC     SOC     0-7
GPU1    PIX      X      SOC     SOC     SOC     0-7
GPU2    SOC     SOC      X      PIX     PHB     8-15
GPU3    SOC     SOC     PIX      X      PHB     8-15
mlx5_0  SOC     SOC     PHB     PHB      X

Legend:

  X   = Self
  SOC  = Connection traversing PCIe as well as the SMP link between CPU sockets(e.g. QPI)
  PHB  = Connection traversing PCIe as well as a PCIe Host Bridge (typically the CPU)
  PXB  = Connection traversing multiple PCIe switches (without traversing the PCIe Host Bridge)
  PIX  = Connection traversing a single PCIe switch
  NV#  = Connection traversing a bonded set of # NVLinks
```

## Single machine Latency test CPU only

### Single thread
```
mpirun -np 2 /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

# OSU MPI-CUDA Latency Test v5.3.2
# Send Buffer on HOST (H) and Receive Buffer on HOST (H)
# Size          Latency (us)
0                       0.54
1                       0.84
2                       0.78
4                       0.75
8                       0.72
16                      0.69
32                      0.67
64                      0.66
128                     0.76
256                     0.82
512                     0.85
1024                    0.97
2048                    1.13
4096                    1.81
8192                    2.62
16384                   4.30
32768                   7.40
65536                  12.02
131072                 22.25
262144                 39.73
524288                 74.84
1048576               140.57
2097152               221.17
4194304               435.01
```

### Multi-thread
```
mpirun -np 2 /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency_mt

# OSU MPI Multi-threaded Latency Test v5.3.2
# Size          Latency (us)
0                       3.89
1                       3.05
2                       2.55
4                       2.41
8                       2.95
16                      2.80
32                      2.62
64                      2.47
128                     2.94
256                     3.02
512                     2.73
1024                    2.62
2048                    2.69
4096                    4.49
8192                    4.62
16384                   6.36
32768                   8.86
65536                  13.17
131072                 21.21
262144                 50.27
524288                 92.26
1048576               161.98
2097152               336.73
4194304               656.55
```


## Multi-machine Latency test CPU only

### Single thread
```
mpirun -np 2 -hostfile /etc/JARVICE/nodes -map-by node -bind-to none /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
# OSU MPI-CUDA Latency Test v5.3.2
# Send Buffer on HOST (H) and Receive Buffer on HOST (H)
# Size          Latency (us)
0                       1.76
1                       2.00
2                       1.87
4                       1.78
8                       1.79
16                      1.79
32                      1.80
64                      1.83
128                     2.31
256                     2.66
512                     2.79
1024                    3.09
2048                    3.70
4096                    5.02
8192                    7.13
16384                  10.71
32768                  15.23
65536                  20.24
131072                 30.22
262144                 50.50
524288                 91.35
1048576               173.82
2097152               356.72
4194304               711.80
```

### Multi-thread
```
mpirun -np 2 -hostfile /etc/JARVICE/nodes -map-by node -bind-to none /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency_mt
mpirun -np 2 -hostfile /etc/JARVICE/nodes -map-by node -bind-to none /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency_mt
# OSU MPI Multi-threaded Latency Test v5.3.2
# Size          Latency (us)
0                       4.74
1                       4.10
2                       3.62
4                       3.55
8                       3.99
16                      4.29
32                      3.81
64                      3.94
128                     4.11
256                     4.43
512                     4.78
1024                    5.11
2048                    6.02
4096                    7.27
8192                    9.95
16384                  16.85
32768                  20.76
65536                  25.28
131072                 36.62
262144                 54.98
524288                 94.13
1048576               177.22
2097152               337.86
4194304               663.45
```

## Single machine GPU GDR Latency test
Note that atm GDR support is not available on Nimbix so perf is throttled down
```
mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 -x LD_LIBRARY_PATH -mca btl_openib_if_include mlx5_0:1 -report-bindings -mca coll_fca_enable 0 -x CUDA_VISIBLE_DEVICES=0 /usr/local/osu-micro-benchmarks/mpi/pt2pt/osu_latency -d cuda D D
nimbix@JARVICENAE-0A0A1837:/data/torch_mpi$ mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 -x LD_LIBRARY_PATH -mca btl_openib_if_include mlx5_0:1 -report-bindings -mca coll_fca_enable 0 -x CUDA_VISIBLE_DEVICES=0 /usr/local/osu-micro-benchmarks/mpi/pt2pt/osu_latency -d cuda D D
[JARVICENAE-0A0A1837:25805] MCW rank 0 bound to socket 0[core 0[hwt 0]], socket 0[core 1[hwt 0]], socket 0[core 2[hwt 0]], socket 0[core 3[hwt 0]], socket 0[core 4[hwt 0]], socket 0[core 5[hwt 0]], socket 0[core 6[hwt 0]], socket 0[core 7[hwt 0]]: [B/B/B/B/B/B/B/B][./././././././.]
[JARVICENAE-0A0A1837:25805] MCW rank 1 bound to socket 0[core 0[hwt 0]], socket 0[core 1[hwt 0]], socket 0[core 2[hwt 0]], socket 0[core 3[hwt 0]], socket 0[core 4[hwt 0]], socket 0[core 5[hwt 0]], socket 0[core 6[hwt 0]], socket 0[core 7[hwt 0]]: [B/B/B/B/B/B/B/B][./././././././.]
--------------------------------------------------------------------------
You requested to run with CUDA GPU Direct RDMA support but this OFED
installation does not have that support.  Contact Mellanox to figure
out how to get an OFED stack with that support.

  Local host:              JARVICENAE-0A0A1837
--------------------------------------------------------------------------
# OSU MPI-CUDA Latency Test v5.3.2
# Send Buffer on DEVICE (D) and Receive Buffer on DEVICE (D)
# Size          Latency (us)
0                       0.60
1                      61.33
2                      54.99
4                      55.04
8                      54.98
[JARVICENAE-0A0A1837:25805] 1 more process has sent help message help-mpi-btl-openib.txt / driver_no_gdr_support
[JARVICENAE-0A0A1837:25805] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
16                     54.32
32                     54.83
64                     55.07
128                    54.61
256                    55.00
512                    54.20
1024                   54.97
2048                   54.59
4096                   54.94
8192                   54.97
16384                  54.86
32768                  55.04
65536                  55.19
131072                 55.88
262144                 56.41
524288                 61.17
1048576                67.63
2097152                79.88
4194304               103.12
```

## Multi-machine GPU GDR Latency test
```
mpirun -np 2 -hostfile /etc/JARVICE/nodes -map-by node -bind-to none -mca btl_openib_want_cuda_gdr 1 -x LD_LIBRARY_PATH -mca btl_openib_if_include mlx5_0:1 -report-bindings -mca coll_fca_enable 0 -x CUDA_VISIBLE_DEVICES=0 /usr/local/osu-micro-benchmarks/mpi/pt2pt/osu_latency -d cuda D D
[JARVICENAE-0A0A1837:25796] MCW rank 0 is not bound (or bound to all available processors)
--------------------------------------------------------------------------
You requested to run with CUDA GPU Direct RDMA support but this OFED
installation does not have that support.  Contact Mellanox to figure
out how to get an OFED stack with that support.

  Local host:              JARVICENAE-0A0A1837
--------------------------------------------------------------------------

DEADLOCKS
```



## Single machine CPU collectives test, 2 processes
```
mpirun -n 2 --bind-to none  --mca mpi_cuda_support 0 --mca btl self,vader,openib ./scripts/wrap_openmpi.sh luajit ./test/collectives.lua -nocheck
sockets core_per_socket core_per_process = 2 8 8
sockets core_per_socket core_per_process = 2 8 8
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 0
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=0-7 luajit ./test/collectives.lua -nocheck
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 1
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=8-15 luajit ./test/collectives.lua -nocheck
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (59 contiguous values) -> 10 us (0.023445 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (75 contiguous values) -> 3 us (0.079841 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (107 contiguous values) -> 4 us (0.087398 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (171 contiguous values) -> 3 us (0.176439 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (299 contiguous values) -> 4 us (0.279309 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (555 contiguous values) -> 58 us (0.038015 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1067 contiguous values) -> 61 us (0.068904 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2091 contiguous values) -> 66 us (0.126037 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4139 contiguous values) -> 70 us (0.234772 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8235 contiguous values) -> 80 us (0.409704 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16427 contiguous values) -> 101 us (0.645976 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (32811 contiguous values) -> 198 us (0.659918 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (65579 contiguous values) -> 300 us (0.874144 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (131115 contiguous values) -> 492 us (1.065448 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (262187 contiguous values) -> 837 us (1.252119 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (524331 contiguous values) -> 1463 us (1.432953 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1048619 contiguous values) -> 2632 us (1.593269 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2097195 contiguous values) -> 5459 us (1.536526 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4194347 contiguous values) -> 12205 us (1.374531 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8388651 contiguous values) -> 25353 us (1.323471 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16777259 contiguous values) -> 51012 us (1.315535 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
allreduce (2 processes) torch.FloatTensor (59 contiguous values) -> 4 us (0.048761 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
allreduce (2 processes) torch.FloatTensor (75 contiguous values) -> 4 us (0.068759 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
allreduce (2 processes) torch.FloatTensor (107 contiguous values) -> 4 us (0.105350 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
allreduce (2 processes) torch.FloatTensor (171 contiguous values) -> 4 us (0.162085 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
allreduce (2 processes) torch.FloatTensor (299 contiguous values) -> 4 us (0.243042 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
allreduce (2 processes) torch.FloatTensor (555 contiguous values) -> 5 us (0.436743 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
allreduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 7 us (0.554219 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
allreduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 12 us (0.678815 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
allreduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 16 us (1.020589 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
allreduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 21 us (1.555160 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
allreduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 34 us (1.897806 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
allreduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 59 us (2.211640 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
allreduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 113 us (2.310346 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
allreduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 216 us (2.422680 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
allreduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 417 us (2.509452 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
allreduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 810 us (2.587496 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
allreduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1640 us (2.556982 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
allreduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 3281 us (2.556588 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
allreduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 6499 us (2.581462 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
allreduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 15180 us (2.210448 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
allreduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 30233 us (2.219675 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
broadcast (2 processes) torch.FloatTensor (59 contiguous values) -> 3 us (0.073760 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
broadcast (2 processes) torch.FloatTensor (75 contiguous values) -> 2 us (0.112750 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
broadcast (2 processes) torch.FloatTensor (107 contiguous values) -> 2 us (0.165911 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
broadcast (2 processes) torch.FloatTensor (171 contiguous values) -> 5 us (0.119637 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
broadcast (2 processes) torch.FloatTensor (299 contiguous values) -> 3 us (0.376041 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
broadcast (2 processes) torch.FloatTensor (555 contiguous values) -> 4 us (0.528454 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
broadcast (2 processes) torch.FloatTensor (1067 contiguous values) -> 8 us (0.501999 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
broadcast (2 processes) torch.FloatTensor (2091 contiguous values) -> 7 us (1.106661 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
broadcast (2 processes) torch.FloatTensor (4139 contiguous values) -> 11 us (1.414851 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
broadcast (2 processes) torch.FloatTensor (8235 contiguous values) -> 18 us (1.748423 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
broadcast (2 processes) torch.FloatTensor (16427 contiguous values) -> 34 us (1.895717 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
broadcast (2 processes) torch.FloatTensor (32811 contiguous values) -> 63 us (2.082617 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
broadcast (2 processes) torch.FloatTensor (65579 contiguous values) -> 112 us (2.329719 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
broadcast (2 processes) torch.FloatTensor (131115 contiguous values) -> 106 us (4.905108 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
broadcast (2 processes) torch.FloatTensor (262187 contiguous values) -> 212 us (4.942769 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
broadcast (2 processes) torch.FloatTensor (524331 contiguous values) -> 414 us (5.059886 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
broadcast (2 processes) torch.FloatTensor (1048619 contiguous values) -> 829 us (5.058457 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
broadcast (2 processes) torch.FloatTensor (2097195 contiguous values) -> 1666 us (5.033114 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
broadcast (2 processes) torch.FloatTensor (4194347 contiguous values) -> 3375 us (4.969813 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
broadcast (2 processes) torch.FloatTensor (8388651 contiguous values) -> 8137 us (4.123687 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
broadcast (2 processes) torch.FloatTensor (16777259 contiguous values) -> 16383 us (4.096181 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
reduce (2 processes) torch.FloatTensor (59 contiguous values) -> 3 us (0.062729 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
reduce (2 processes) torch.FloatTensor (75 contiguous values) -> 2 us (0.101312 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
reduce (2 processes) torch.FloatTensor (107 contiguous values) -> 2 us (0.145711 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
reduce (2 processes) torch.FloatTensor (171 contiguous values) -> 3 us (0.208496 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
reduce (2 processes) torch.FloatTensor (299 contiguous values) -> 3 us (0.353765 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
reduce (2 processes) torch.FloatTensor (555 contiguous values) -> 3 us (0.562960 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
reduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 5 us (0.781716 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
reduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 7 us (1.145694 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
reduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 10 us (1.582518 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
reduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 17 us (1.837728 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
reduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 31 us (2.118365 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
reduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 53 us (2.451359 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
reduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 102 us (2.553100 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
reduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 202 us (2.590434 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
reduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 396 us (2.642633 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
reduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 799 us (2.623957 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
reduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1578 us (2.658061 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
reduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 3151 us (2.662057 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
reduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 6338 us (2.646935 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
reduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 13623 us (2.463081 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
reduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 27239 us (2.463671 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
```

## Multi-machine CPU collectives test, 2 processes, 1 per machine
```
mpirun -n 2 -hostfile /etc/JARVICE/nodes --map-by node --bind-to none  --mca mpi_cuda_support 0 --mca btl self,vader,openib ./scripts/wrap_openmpi.sh luajit ./test/collectives.lua -nocheck
sockets core_per_socket core_per_process = 2 8 16
sockets core_per_socket core_per_process = 2 8 16
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ hostname
+ cat /etc/JARVICE/nodes
+ MPI_MY_NODE=JARVICENAE-0A0A196C
+ + MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
hostname
+ test 0
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=0-15 luajit ./test/collectives.lua -nocheck
+ MPI_NODES=JARVICENAE-0A0A196C
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 0
+ MPI_MY_NODE=JARVICENAE-0A0A196C MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=0-15 luajit ./test/collectives.lua -nocheck
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (59 contiguous values) -> 23 us (0.010236 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (75 contiguous values) -> 10 us (0.028468 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (107 contiguous values) -> 9 us (0.045150 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (171 contiguous values) -> 9 us (0.068536 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (299 contiguous values) -> 10 us (0.119154 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (555 contiguous values) -> 57 us (0.038934 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1067 contiguous values) -> 57 us (0.074508 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2091 contiguous values) -> 59 us (0.139821 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4139 contiguous values) -> 66 us (0.247844 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8235 contiguous values) -> 77 us (0.426790 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16427 contiguous values) -> 92 us (0.708810 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (32811 contiguous values) -> 172 us (0.761801 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (65579 contiguous values) -> 248 us (1.054408 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (131115 contiguous values) -> 398 us (1.316219 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (262187 contiguous values) -> 651 us (1.610291 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (524331 contiguous values) -> 1088 us (1.927199 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1758 us (2.385744 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2097195 contiguous values) -> 3342 us (2.509704 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4194347 contiguous values) -> 8936 us (1.877450 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8388651 contiguous values) -> 18086 us (1.855256 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16777259 contiguous values) -> 36401 us (1.843558 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
allreduce (2 processes) torch.FloatTensor (59 contiguous values) -> 5 us (0.041141 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
allreduce (2 processes) torch.FloatTensor (75 contiguous values) -> 5 us (0.057932 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
allreduce (2 processes) torch.FloatTensor (107 contiguous values) -> 5 us (0.085321 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
allreduce (2 processes) torch.FloatTensor (171 contiguous values) -> 5 us (0.133562 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
allreduce (2 processes) torch.FloatTensor (299 contiguous values) -> 5 us (0.214376 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
allreduce (2 processes) torch.FloatTensor (555 contiguous values) -> 6 us (0.349001 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
allreduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 7 us (0.540172 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
allreduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 10 us (0.775789 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
allreduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 16 us (1.014624 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
allreduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 29 us (1.111329 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
allreduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 40 us (1.618507 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
allreduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 69 us (1.893236 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
allreduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 101 us (2.595134 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
allreduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 162 us (3.222314 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
allreduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 282 us (3.708410 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
allreduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 526 us (3.982009 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
allreduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1113 us (3.766847 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
allreduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 2179 us (3.848166 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
allreduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 4335 us (3.869805 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
allreduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 8682 us (3.864689 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
allreduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 18043 us (3.719312 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
broadcast (2 processes) torch.FloatTensor (59 contiguous values) -> 4 us (0.049394 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
broadcast (2 processes) torch.FloatTensor (75 contiguous values) -> 2 us (0.133861 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
broadcast (2 processes) torch.FloatTensor (107 contiguous values) -> 1 us (0.252130 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
broadcast (2 processes) torch.FloatTensor (171 contiguous values) -> 7 us (0.087467 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
broadcast (2 processes) torch.FloatTensor (299 contiguous values) -> 1 us (0.702575 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
broadcast (2 processes) torch.FloatTensor (555 contiguous values) -> 5 us (0.409470 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
broadcast (2 processes) torch.FloatTensor (1067 contiguous values) -> 37 us (0.113876 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
broadcast (2 processes) torch.FloatTensor (2091 contiguous values) -> 3 us (2.766653 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
broadcast (2 processes) torch.FloatTensor (4139 contiguous values) -> 9743 us (0.001699 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
broadcast (2 processes) torch.FloatTensor (8235 contiguous values) -> 25 us (1.287848 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
broadcast (2 processes) torch.FloatTensor (16427 contiguous values) -> 39 us (1.644387 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
broadcast (2 processes) torch.FloatTensor (32811 contiguous values) -> 65 us (1.992173 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
broadcast (2 processes) torch.FloatTensor (65579 contiguous values) -> 115 us (2.269551 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
broadcast (2 processes) torch.FloatTensor (131115 contiguous values) -> 126 us (4.135480 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
broadcast (2 processes) torch.FloatTensor (262187 contiguous values) -> 253 us (4.141342 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
broadcast (2 processes) torch.FloatTensor (524331 contiguous values) -> 500 us (4.188441 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
broadcast (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1010 us (4.152052 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
broadcast (2 processes) torch.FloatTensor (2097195 contiguous values) -> 1989 us (4.216945 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
broadcast (2 processes) torch.FloatTensor (4194347 contiguous values) -> 4081 us (4.110774 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
broadcast (2 processes) torch.FloatTensor (8388651 contiguous values) -> 8212 us (4.085877 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
broadcast (2 processes) torch.FloatTensor (16777259 contiguous values) -> 16540 us (4.057294 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
reduce (2 processes) torch.FloatTensor (59 contiguous values) -> 3 us (0.060877 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
reduce (2 processes) torch.FloatTensor (75 contiguous values) -> 2 us (0.106998 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
reduce (2 processes) torch.FloatTensor (107 contiguous values) -> 3 us (0.133768 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
reduce (2 processes) torch.FloatTensor (171 contiguous values) -> 3 us (0.185810 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
reduce (2 processes) torch.FloatTensor (299 contiguous values) -> 12 us (0.096136 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
reduce (2 processes) torch.FloatTensor (555 contiguous values) -> 3 us (0.725183 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
reduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 3 us (1.226116 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
reduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 8 us (0.977191 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
reduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 15 us (1.089098 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
reduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 22 us (1.490403 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
reduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 40 us (1.608118 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
reduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 61 us (2.131980 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
reduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 117 us (2.227914 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
reduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 241 us (2.167193 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
reduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 463 us (2.261089 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
reduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 907 us (2.311921 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
reduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1830 us (2.291113 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
reduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 3625 us (2.314145 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
reduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 7389 us (2.270554 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
reduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 15800 us (2.123628 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
reduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 32186 us (2.085017 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
```

Force TCP (Nimbix's Ethernet is 10Gb/s), feel the pain of not using IB.
```
nimbix@JARVICENAE-0A0A1844:/data/torchmpi$ mpirun -n 2 -hostfile /etc/JARVICE/nodes --map-by node --bind-to none  --mca mpi_cuda_support 0 --mca btl self,vader,tcp ./scripts/wrap_openmpi.sh luajit ./test/collectives.lua -nocheck
sockets core_per_socket core_per_process = 2 8 16
sockets core_per_socket core_per_process = 2 8 16
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 0
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=0-15 luajit ./test/collectives.lua -nocheck
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A196C
+ hostname
+ MPI_NODES=JARVICENAE-0A0A196C
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 0
+ MPI_MY_NODE=JARVICENAE-0A0A196C MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=0-15 luajit ./test/collectives.lua -nocheck
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (59 contiguous values) -> 51 us (0.004622 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (75 contiguous values) -> 51 us (0.005864 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (107 contiguous values) -> 47 us (0.009041 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (171 contiguous values) -> 47 us (0.014504 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (299 contiguous values) -> 64 us (0.018658 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (555 contiguous values) -> 107 us (0.020744 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1067 contiguous values) -> 100 us (0.042612 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2091 contiguous values) -> 117 us (0.070954 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4139 contiguous values) -> 143 us (0.115743 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8235 contiguous values) -> 181 us (0.181785 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16427 contiguous values) -> 289 us (0.226782 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (32811 contiguous values) -> 659 us (0.199011 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (65579 contiguous values) -> 1355 us (0.193514 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (131115 contiguous values) -> 2658 us (0.197248 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (262187 contiguous values) -> 5554 us (0.188797 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (524331 contiguous values) -> 10110 us (0.207432 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1048619 contiguous values) -> 20007 us (0.209642 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2097195 contiguous values) -> 36612 us (0.229124 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4194347 contiguous values) -> 70506 us (0.237955 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8388651 contiguous values) -> 147117 us (0.228080 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16777259 contiguous values) -> 290544 us (0.230977 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
allreduce (2 processes) torch.FloatTensor (59 contiguous values) -> 58 us (0.004036 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
allreduce (2 processes) torch.FloatTensor (75 contiguous values) -> 51 us (0.005769 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
allreduce (2 processes) torch.FloatTensor (107 contiguous values) -> 51 us (0.008343 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
allreduce (2 processes) torch.FloatTensor (171 contiguous values) -> 51 us (0.013339 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
allreduce (2 processes) torch.FloatTensor (299 contiguous values) -> 63 us (0.018816 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
allreduce (2 processes) torch.FloatTensor (555 contiguous values) -> 110 us (0.020127 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
allreduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 123 us (0.034431 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
allreduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 118 us (0.070509 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
allreduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 228 us (0.072340 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
allreduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 258 us (0.127673 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
allreduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 318 us (0.206293 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
allreduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 735 us (0.178554 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
allreduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 1316 us (0.199243 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
allreduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 2535 us (0.206839 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
allreduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 5281 us (0.198573 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
allreduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 10709 us (0.195841 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
allreduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 20378 us (0.205832 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
allreduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 41014 us (0.204533 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
allreduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 82081 us (0.204399 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
allreduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 160930 us (0.208504 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
allreduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 322875 us (0.207848 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
broadcast (2 processes) torch.FloatTensor (59 contiguous values) -> 10 us (0.022693 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
broadcast (2 processes) torch.FloatTensor (75 contiguous values) -> 10 us (0.027925 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
broadcast (2 processes) torch.FloatTensor (107 contiguous values) -> 12 us (0.034682 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
broadcast (2 processes) torch.FloatTensor (171 contiguous values) -> 6 us (0.109584 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
broadcast (2 processes) torch.FloatTensor (299 contiguous values) -> 10 us (0.117756 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
broadcast (2 processes) torch.FloatTensor (555 contiguous values) -> 17 us (0.126307 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
broadcast (2 processes) torch.FloatTensor (1067 contiguous values) -> 27 us (0.156452 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
broadcast (2 processes) torch.FloatTensor (2091 contiguous values) -> 37 us (0.220248 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
broadcast (2 processes) torch.FloatTensor (4139 contiguous values) -> 57 us (0.288017 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
broadcast (2 processes) torch.FloatTensor (8235 contiguous values) -> 86 us (0.381427 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
broadcast (2 processes) torch.FloatTensor (16427 contiguous values) -> 153 us (0.426955 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
broadcast (2 processes) torch.FloatTensor (32811 contiguous values) -> 548 us (0.239242 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
broadcast (2 processes) torch.FloatTensor (65579 contiguous values) -> 769 us (0.341077 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
broadcast (2 processes) torch.FloatTensor (131115 contiguous values) -> 1502 us (0.349109 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
broadcast (2 processes) torch.FloatTensor (262187 contiguous values) -> 3001 us (0.349375 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
broadcast (2 processes) torch.FloatTensor (524331 contiguous values) -> 5977 us (0.350867 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
broadcast (2 processes) torch.FloatTensor (1048619 contiguous values) -> 11954 us (0.350858 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
broadcast (2 processes) torch.FloatTensor (2097195 contiguous values) -> 23962 us (0.350087 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
broadcast (2 processes) torch.FloatTensor (4194347 contiguous values) -> 47797 us (0.351012 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
broadcast (2 processes) torch.FloatTensor (8388651 contiguous values) -> 96101 us (0.349159 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
broadcast (2 processes) torch.FloatTensor (16777259 contiguous values) -> 191167 us (0.351048 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
reduce (2 processes) torch.FloatTensor (59 contiguous values) -> 9 us (0.024734 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
reduce (2 processes) torch.FloatTensor (75 contiguous values) -> 9 us (0.032480 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
reduce (2 processes) torch.FloatTensor (107 contiguous values) -> 8 us (0.050826 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
reduce (2 processes) torch.FloatTensor (171 contiguous values) -> 8 us (0.076997 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
reduce (2 processes) torch.FloatTensor (299 contiguous values) -> 8 us (0.134128 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
reduce (2 processes) torch.FloatTensor (555 contiguous values) -> 11 us (0.195781 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
reduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 14 us (0.303618 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
reduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 24 us (0.345900 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
reduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 39 us (0.423627 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
reduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 77 us (0.422535 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
reduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 167 us (0.391532 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
reduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 584 us (0.224540 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
reduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 1164 us (0.225222 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
reduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 2323 us (0.225720 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
reduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 4637 us (0.226124 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
reduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 9255 us (0.226610 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
reduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 18520 us (0.226471 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
reduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 36950 us (0.227025 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
reduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 73660 us (0.227767 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
reduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 149401 us (0.224594 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: true GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
reduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 280028 us (0.239651 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
```


## Single machine NCCL collectives test, 1 GPU per process
2 processes:
```
mpirun -n 2 --bind-to none ./scripts/wrap_openmpi.sh luajit ./test/collectives_nccl.lua -nocheck
sockets core_per_socket core_per_process = 2 8 8
sockets core_per_socket core_per_process = 2 8 8
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 0
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=0-7 luajit ./test/collectives_nccl.lua -nocheck
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 1
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=8-15 luajit ./test/collectives_nccl.lua -nocheck
allreduce (2 processes) torch.CudaTensor (59 contiguous values) -> 50 us (0.004653 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12626100224 / 12798197760
allreduce (2 processes) torch.CudaTensor (75 contiguous values) -> 47 us (0.006374 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12626100224 / 12798197760
allreduce (2 processes) torch.CudaTensor (107 contiguous values) -> 46 us (0.009209 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12626100224 / 12798197760
allreduce (2 processes) torch.CudaTensor (171 contiguous values) -> 45 us (0.015046 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12626100224 / 12798197760
allreduce (2 processes) torch.CudaTensor (299 contiguous values) -> 47 us (0.025137 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12625051648 / 12798197760
allreduce (2 processes) torch.CudaTensor (555 contiguous values) -> 46 us (0.047992 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12625051648 / 12625051648 / 12798197760
allreduce (2 processes) torch.CudaTensor (1067 contiguous values) -> 48 us (0.088358 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12625051648 / 12624003072 / 12798197760
allreduce (2 processes) torch.CudaTensor (2091 contiguous values) -> 50 us (0.164700 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12624003072 / 12624003072 / 12798197760
allreduce (2 processes) torch.CudaTensor (4139 contiguous values) -> 51 us (0.319739 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12624003072 / 12622954496 / 12798197760
allreduce (2 processes) torch.CudaTensor (8235 contiguous values) -> 56 us (0.579337 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12622954496 / 12622954496 / 12798197760
allreduce (2 processes) torch.CudaTensor (16427 contiguous values) -> 63 us (1.042279 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12622954496 / 12621905920 / 12798197760
allreduce (2 processes) torch.CudaTensor (32811 contiguous values) -> 75 us (1.732913 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12621905920 / 12621905920 / 12798197760
allreduce (2 processes) torch.CudaTensor (65579 contiguous values) -> 99 us (2.647591 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12621905920 / 12620857344 / 12798197760
allreduce (2 processes) torch.CudaTensor (131115 contiguous values) -> 141 us (3.708018 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12620857344 / 12620857344 / 12798197760
allreduce (2 processes) torch.CudaTensor (262187 contiguous values) -> 221 us (4.739030 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12620857344 / 12619677696 / 12798197760
allreduce (2 processes) torch.CudaTensor (524331 contiguous values) -> 405 us (5.168395 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12619677696 / 12617449472 / 12798197760
allreduce (2 processes) torch.CudaTensor (1048619 contiguous values) -> 764 us (5.484415 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12617449472 / 12613124096 / 12798197760
allreduce (2 processes) torch.CudaTensor (2097195 contiguous values) -> 1475 us (5.684220 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12613124096 / 12604604416 / 12798197760
allreduce (2 processes) torch.CudaTensor (4194347 contiguous values) -> 2648 us (6.333623 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12604604416 / 12587696128 / 12798197760
allreduce (2 processes) torch.CudaTensor (8388651 contiguous values) -> 4642 us (7.228420 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12587696128 / 12554010624 / 12798197760
allreduce (2 processes) torch.CudaTensor (16777259 contiguous values) -> 8104 us (8.280163 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12554010624 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (59 contiguous values) -> 33 us (0.007148 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (75 contiguous values) -> 32 us (0.009203 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (107 contiguous values) -> 32 us (0.012993 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (171 contiguous values) -> 32 us (0.020941 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (299 contiguous values) -> 32 us (0.036734 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (555 contiguous values) -> 33 us (0.066548 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (1067 contiguous values) -> 34 us (0.123491 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (2091 contiguous values) -> 35 us (0.237067 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (4139 contiguous values) -> 34 us (0.477651 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (8235 contiguous values) -> 36 us (0.901007 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (16427 contiguous values) -> 40 us (1.634634 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (32811 contiguous values) -> 48 us (2.718406 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (2 processes) torch.CudaTensor (65579 contiguous values) -> 65 us (3.992427 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12485722112 / 12798197760
broadcast (2 processes) torch.CudaTensor (131115 contiguous values) -> 84 us (6.206604 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12485722112 / 12485722112 / 12798197760
broadcast (2 processes) torch.CudaTensor (262187 contiguous values) -> 127 us (8.215240 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12485722112 / 12484542464 / 12798197760
broadcast (2 processes) torch.CudaTensor (524331 contiguous values) -> 207 us (10.091099 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12484542464 / 12482314240 / 12798197760
broadcast (2 processes) torch.CudaTensor (1048619 contiguous values) -> 368 us (11.392452 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12482314240 / 12477988864 / 12798197760
broadcast (2 processes) torch.CudaTensor (2097195 contiguous values) -> 689 us (12.170309 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12477988864 / 12469469184 / 12798197760
broadcast (2 processes) torch.CudaTensor (4194347 contiguous values) -> 1332 us (12.594494 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12469469184 / 12452560896 / 12798197760
broadcast (2 processes) torch.CudaTensor (8388651 contiguous values) -> 2617 us (12.820420 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12452560896 / 12418875392 / 12798197760
broadcast (2 processes) torch.CudaTensor (16777259 contiguous values) -> 5182 us (12.949806 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12418875392 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (59 contiguous values) -> 31 us (0.007525 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (75 contiguous values) -> 30 us (0.009747 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (107 contiguous values) -> 30 us (0.014060 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (171 contiguous values) -> 30 us (0.022250 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (299 contiguous values) -> 30 us (0.039142 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (555 contiguous values) -> 30 us (0.072597 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (1067 contiguous values) -> 31 us (0.134132 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (2091 contiguous values) -> 32 us (0.257684 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (4139 contiguous values) -> 33 us (0.492489 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (8235 contiguous values) -> 35 us (0.923779 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (16427 contiguous values) -> 40 us (1.605682 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (32811 contiguous values) -> 51 us (2.552524 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (2 processes) torch.CudaTensor (65579 contiguous values) -> 72 us (3.629216 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12350586880 / 12798197760
reduce (2 processes) torch.CudaTensor (131115 contiguous values) -> 110 us (4.734299 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12350586880 / 12350586880 / 12798197760
reduce (2 processes) torch.CudaTensor (262187 contiguous values) -> 169 us (6.186560 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12350586880 / 12349407232 / 12798197760
reduce (2 processes) torch.CudaTensor (524331 contiguous values) -> 252 us (8.302328 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12349407232 / 12347179008 / 12798197760
reduce (2 processes) torch.CudaTensor (1048619 contiguous values) -> 433 us (9.673555 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12347179008 / 12342853632 / 12798197760
reduce (2 processes) torch.CudaTensor (2097195 contiguous values) -> 794 us (10.557534 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12342853632 / 12334333952 / 12798197760
reduce (2 processes) torch.CudaTensor (4194347 contiguous values) -> 1518 us (11.049371 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12334333952 / 12587696128 / 12798197760
reduce (2 processes) torch.CudaTensor (8388651 contiguous values) -> 2963 us (11.323610 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12587696128 / 12554010624 / 12798197760
reduce (2 processes) torch.CudaTensor (16777259 contiguous values) -> 5856 us (11.459290 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12554010624 / 12486770688 / 12798197760
```

4 processes
```
mpirun -n 4 --bind-to none ./scripts/wrap_openmpi.sh luajit ./test/collectives_nccl.lua -nocheck
sockets core_per_socket core_per_process = 2 8 4
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 0
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=0-3 luajit ./test/collectives_nccl.lua -nocheck
sockets core_per_socket core_per_process = 2 8 4
sockets core_per_socket core_per_process = 2 8 4
sockets core_per_socket core_per_process = 2 8 4
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ cat /etc/JARVICE/nodes
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ test 1
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=4-7 luajit ./test/collectives_nccl.lua -nocheck
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ MPI_MY_NODE=JARVICENAE-0A0A1844
+ hostname
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ MPI_NODES=JARVICENAE-0A0A1844
+ test -e /etc/JARVICE/nodes
+ + cat /etc/JARVICE/nodes
cat /etc/JARVICE/nodes
+ MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
+ test
+ + MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C
test 2
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=8-11 luajit ./test/collectives_nccl.lua -nocheck
+ test
+ test 3
+ MPI_MY_NODE=JARVICENAE-0A0A1844 MPI_NODES=JARVICENAE-0A0A1844
JARVICENAE-0A0A196C numactl --physcpubind=12-15 luajit ./test/collectives_nccl.lua -nocheck
allreduce (4 processes) torch.CudaTensor (59 contiguous values) -> 84 us (0.004205 GB/s assuming good implementation, i.e. 0.000354 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12626100224 / 12798197760
allreduce (4 processes) torch.CudaTensor (75 contiguous values) -> 77 us (0.005820 GB/s assuming good implementation, i.e. 0.000450 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12626100224 / 12798197760
allreduce (4 processes) torch.CudaTensor (107 contiguous values) -> 77 us (0.008276 GB/s assuming good implementation, i.e. 0.000642 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12626100224 / 12798197760
allreduce (4 processes) torch.CudaTensor (171 contiguous values) -> 76 us (0.013335 GB/s assuming good implementation, i.e. 0.001026 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12626100224 / 12798197760
allreduce (4 processes) torch.CudaTensor (299 contiguous values) -> 76 us (0.023482 GB/s assuming good implementation, i.e. 0.001794 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12626100224 / 12625051648 / 12798197760
allreduce (4 processes) torch.CudaTensor (555 contiguous values) -> 78 us (0.042365 GB/s assuming good implementation, i.e. 0.003330 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12625051648 / 12625051648 / 12798197760
allreduce (4 processes) torch.CudaTensor (1067 contiguous values) -> 83 us (0.076232 GB/s assuming good implementation, i.e. 0.006402 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12625051648 / 12624003072 / 12798197760
allreduce (4 processes) torch.CudaTensor (2091 contiguous values) -> 91 us (0.136936 GB/s assuming good implementation, i.e. 0.012546 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12624003072 / 12624003072 / 12798197760
allreduce (4 processes) torch.CudaTensor (4139 contiguous values) -> 91 us (0.270282 GB/s assuming good implementation, i.e. 0.024834 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12624003072 / 12622954496 / 12798197760
allreduce (4 processes) torch.CudaTensor (8235 contiguous values) -> 101 us (0.485364 GB/s assuming good implementation, i.e. 0.049410 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12622954496 / 12622954496 / 12798197760
allreduce (4 processes) torch.CudaTensor (16427 contiguous values) -> 103 us (0.953587 GB/s assuming good implementation, i.e. 0.098562 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12622954496 / 12621905920 / 12798197760
allreduce (4 processes) torch.CudaTensor (32811 contiguous values) -> 135 us (1.453520 GB/s assuming good implementation, i.e. 0.196866 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12621905920 / 12621905920 / 12798197760
allreduce (4 processes) torch.CudaTensor (65579 contiguous values) -> 176 us (2.228817 GB/s assuming good implementation, i.e. 0.393474 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12621905920 / 12620857344 / 12798197760
allreduce (4 processes) torch.CudaTensor (131115 contiguous values) -> 244 us (3.214434 GB/s assuming good implementation, i.e. 0.786690 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12620857344 / 12620857344 / 12798197760
allreduce (4 processes) torch.CudaTensor (262187 contiguous values) -> 380 us (4.138900 GB/s assuming good implementation, i.e. 1.573122 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12620857344 / 12619677696 / 12798197760
allreduce (4 processes) torch.CudaTensor (524331 contiguous values) -> 742 us (4.238966 GB/s assuming good implementation, i.e. 3.145986 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12619677696 / 12617449472 / 12798197760
allreduce (4 processes) torch.CudaTensor (1048619 contiguous values) -> 1311 us (4.796757 GB/s assuming good implementation, i.e. 6.291714 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12617449472 / 12613124096 / 12798197760
allreduce (4 processes) torch.CudaTensor (2097195 contiguous values) -> 2494 us (5.044612 GB/s assuming good implementation, i.e. 12.583170 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12613124096 / 12604604416 / 12798197760
allreduce (4 processes) torch.CudaTensor (4194347 contiguous values) -> 4917 us (5.117655 GB/s assuming good implementation, i.e. 25.166082 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12604604416 / 12587696128 / 12798197760
allreduce (4 processes) torch.CudaTensor (8388651 contiguous values) -> 9759 us (5.157412 GB/s assuming good implementation, i.e. 50.331906 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12587696128 / 12554010624 / 12798197760
allreduce (4 processes) torch.CudaTensor (16777259 contiguous values) -> 19441 us (5.177734 GB/s assuming good implementation, i.e. 100.663554 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12554010624 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (59 contiguous values) -> 38 us (0.012330 GB/s assuming good implementation, i.e. 0.000472 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (75 contiguous values) -> 37 us (0.015840 GB/s assuming good implementation, i.e. 0.000600 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (107 contiguous values) -> 37 us (0.022790 GB/s assuming good implementation, i.e. 0.000856 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (171 contiguous values) -> 37 us (0.036192 GB/s assuming good implementation, i.e. 0.001368 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (299 contiguous values) -> 37 us (0.064403 GB/s assuming good implementation, i.e. 0.002392 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (555 contiguous values) -> 38 us (0.114012 GB/s assuming good implementation, i.e. 0.004440 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (1067 contiguous values) -> 41 us (0.207889 GB/s assuming good implementation, i.e. 0.008536 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (2091 contiguous values) -> 43 us (0.383317 GB/s assuming good implementation, i.e. 0.016728 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (4139 contiguous values) -> 56 us (0.587089 GB/s assuming good implementation, i.e. 0.033112 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (8235 contiguous values) -> 47 us (1.377197 GB/s assuming good implementation, i.e. 0.065880 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (16427 contiguous values) -> 61 us (2.148755 GB/s assuming good implementation, i.e. 0.131416 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (32811 contiguous values) -> 91 us (2.880722 GB/s assuming good implementation, i.e. 0.262488 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12486770688 / 12798197760
broadcast (4 processes) torch.CudaTensor (65579 contiguous values) -> 148 us (3.528989 GB/s assuming good implementation, i.e. 0.524632 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12486770688 / 12485722112 / 12798197760
broadcast (4 processes) torch.CudaTensor (131115 contiguous values) -> 194 us (5.406771 GB/s assuming good implementation, i.e. 1.048920 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12485722112 / 12485722112 / 12798197760
broadcast (4 processes) torch.CudaTensor (262187 contiguous values) -> 291 us (7.193524 GB/s assuming good implementation, i.e. 2.097496 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12485722112 / 12484542464 / 12798197760
broadcast (4 processes) torch.CudaTensor (524331 contiguous values) -> 603 us (6.956038 GB/s assuming good implementation, i.e. 4.194648 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12484542464 / 12482314240 / 12798197760
broadcast (4 processes) torch.CudaTensor (1048619 contiguous values) -> 1090 us (7.695430 GB/s assuming good implementation, i.e. 8.388952 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12482314240 / 12477988864 / 12798197760
broadcast (4 processes) torch.CudaTensor (2097195 contiguous values) -> 2066 us (8.120786 GB/s assuming good implementation, i.e. 16.777560 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12477988864 / 12469469184 / 12798197760
broadcast (4 processes) torch.CudaTensor (4194347 contiguous values) -> 4018 us (8.350368 GB/s assuming good implementation, i.e. 33.554776 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12469469184 / 12452560896 / 12798197760
broadcast (4 processes) torch.CudaTensor (8388651 contiguous values) -> 7913 us (8.480428 GB/s assuming good implementation, i.e. 67.109208 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12452560896 / 12418875392 / 12798197760
broadcast (4 processes) torch.CudaTensor (16777259 contiguous values) -> 15708 us (8.544024 GB/s assuming good implementation, i.e. 134.218072 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12418875392 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (59 contiguous values) -> 35 us (0.013140 GB/s assuming good implementation, i.e. 0.000472 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (75 contiguous values) -> 35 us (0.016913 GB/s assuming good implementation, i.e. 0.000600 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (107 contiguous values) -> 34 us (0.024642 GB/s assuming good implementation, i.e. 0.000856 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (171 contiguous values) -> 35 us (0.038044 GB/s assuming good implementation, i.e. 0.001368 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (299 contiguous values) -> 35 us (0.067190 GB/s assuming good implementation, i.e. 0.002392 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (555 contiguous values) -> 34 us (0.128167 GB/s assuming good implementation, i.e. 0.004440 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (1067 contiguous values) -> 37 us (0.224749 GB/s assuming good implementation, i.e. 0.008536 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (2091 contiguous values) -> 40 us (0.413644 GB/s assuming good implementation, i.e. 0.016728 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (4139 contiguous values) -> 44 us (0.750226 GB/s assuming good implementation, i.e. 0.033112 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (8235 contiguous values) -> 45 us (1.446100 GB/s assuming good implementation, i.e. 0.065880 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (16427 contiguous values) -> 62 us (2.111387 GB/s assuming good implementation, i.e. 0.131416 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (32811 contiguous values) -> 91 us (2.857395 GB/s assuming good implementation, i.e. 0.262488 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12351635456 / 12798197760
reduce (4 processes) torch.CudaTensor (65579 contiguous values) -> 147 us (3.550972 GB/s assuming good implementation, i.e. 0.524632 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12351635456 / 12350586880 / 12798197760
reduce (4 processes) torch.CudaTensor (131115 contiguous values) -> 256 us (4.085479 GB/s assuming good implementation, i.e. 1.048920 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12350586880 / 12350586880 / 12798197760
reduce (4 processes) torch.CudaTensor (262187 contiguous values) -> 350 us (5.982927 GB/s assuming good implementation, i.e. 2.097496 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12350586880 / 12349407232 / 12798197760
reduce (4 processes) torch.CudaTensor (524331 contiguous values) -> 607 us (6.904770 GB/s assuming good implementation, i.e. 4.194648 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12349407232 / 12347179008 / 12798197760
reduce (4 processes) torch.CudaTensor (1048619 contiguous values) -> 991 us (8.458657 GB/s assuming good implementation, i.e. 8.388952 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12347179008 / 12342853632 / 12798197760
reduce (4 processes) torch.CudaTensor (2097195 contiguous values) -> 1758 us (9.541824 GB/s assuming good implementation, i.e. 16.777560 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12342853632 / 12334333952 / 12798197760
reduce (4 processes) torch.CudaTensor (4194347 contiguous values) -> 3310 us (10.136669 GB/s assuming good implementation, i.e. 33.554776 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12334333952 / 12587696128 / 12798197760
reduce (4 processes) torch.CudaTensor (8388651 contiguous values) -> 6371 us (10.531956 GB/s assuming good implementation, i.e. 67.109208 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12587696128 / 12554010624 / 12798197760
reduce (4 processes) torch.CudaTensor (16777259 contiguous values) -> 12521 us (10.718858 GB/s assuming good implementation, i.e. 134.218072 MB through the slowest wire, assuming p2p wires) GPU memory pre / post / total alloc: 12554010624 / 12486770688 / 12798197760
```

## Multi-machine hierarchical MPI + NCCL collectives test, 1 GPU per process
8 processes, 4 process per machine
```
NCCL seems to deadlock when mixed with non-flat MPI communicators
```


# Nimbix 2-node, dual K80 configuration IntelMPI

## Single machine CPU collectives test, 2 processes
```
nimbix@JARVICENAE-0A0A1844:/data/torchmpi$ mpirun -n 2 -genv I_MPI_SHM_BYPASS 1 -genv NUM_RDMA_BUFFER 8 -genv I_MPI_USE_RENDEZVOUS_RDMA_WRITE 1 -genv I_MPI_OFA_ADAPTER_NAME mlx5_0 -genv I_MPI_OFA_NUM_PORTS 2 -genv I_MPI_FABRICS="ofa" -genv I_MPI_DEVICE="rdma:mlx5_0"  luajit ./test/collectives.lua -nocheck -inPlace
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (59 contiguous values) -> 10 us (0.022527 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (75 contiguous values) -> 6 us (0.044907 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (107 contiguous values) -> 4 us (0.097352 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (171 contiguous values) -> 4 us (0.139538 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (299 contiguous values) -> 4 us (0.246143 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (555 contiguous values) -> 5 us (0.396228 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1067 contiguous values) -> 6 us (0.640705 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2091 contiguous values) -> 8 us (0.972316 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4139 contiguous values) -> 12 us (1.333351 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8235 contiguous values) -> 19 us (1.713723 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16427 contiguous values) -> 33 us (1.933759 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (32811 contiguous values) -> 61 us (2.120973 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (65579 contiguous values) -> 118 us (2.222334 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (131115 contiguous values) -> 265 us (1.977156 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (262187 contiguous values) -> 511 us (2.049523 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (524331 contiguous values) -> 1013 us (2.068447 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1048619 contiguous values) -> 2045 us (2.050690 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2097195 contiguous values) -> 3633 us (2.308554 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4194347 contiguous values) -> 8680 us (1.932834 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8388651 contiguous values) -> 20688 us (1.621914 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16777259 contiguous values) -> 41400 us (1.620971 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
allreduce (2 processes) torch.FloatTensor (59 contiguous values) -> 7 us (0.031069 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
allreduce (2 processes) torch.FloatTensor (75 contiguous values) -> 6 us (0.049656 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
allreduce (2 processes) torch.FloatTensor (107 contiguous values) -> 5 us (0.071806 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
allreduce (2 processes) torch.FloatTensor (171 contiguous values) -> 6 us (0.112860 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
allreduce (2 processes) torch.FloatTensor (299 contiguous values) -> 6 us (0.192199 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
allreduce (2 processes) torch.FloatTensor (555 contiguous values) -> 8 us (0.252340 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
allreduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 7 us (0.544443 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
allreduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 9 us (0.874842 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
allreduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 13 us (1.213577 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
allreduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 23 us (1.423453 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
allreduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 44 us (1.473951 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
allreduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 75 us (1.742899 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
allreduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 134 us (1.943669 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
allreduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 281 us (1.865487 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
allreduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 537 us (1.949359 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
allreduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 1061 us (1.975773 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
allreduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 2137 us (1.962233 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
allreduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 4312 us (1.945413 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
allreduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 11835 us (1.417547 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
allreduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 24300 us (1.380824 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
allreduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 48754 us (1.376469 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
broadcast (2 processes) torch.FloatTensor (59 contiguous values) -> 3 us (0.069806 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
broadcast (2 processes) torch.FloatTensor (75 contiguous values) -> 2 us (0.129454 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
broadcast (2 processes) torch.FloatTensor (107 contiguous values) -> 2 us (0.205867 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
broadcast (2 processes) torch.FloatTensor (171 contiguous values) -> 2 us (0.320190 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
broadcast (2 processes) torch.FloatTensor (299 contiguous values) -> 2 us (0.463622 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
broadcast (2 processes) torch.FloatTensor (555 contiguous values) -> 2 us (1.077703 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
broadcast (2 processes) torch.FloatTensor (1067 contiguous values) -> 3 us (1.394181 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
broadcast (2 processes) torch.FloatTensor (2091 contiguous values) -> 3 us (2.534766 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
broadcast (2 processes) torch.FloatTensor (4139 contiguous values) -> 3 us (4.497467 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
broadcast (2 processes) torch.FloatTensor (8235 contiguous values) -> 25 us (1.306111 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
broadcast (2 processes) torch.FloatTensor (16427 contiguous values) -> 37 us (1.755186 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
broadcast (2 processes) torch.FloatTensor (32811 contiguous values) -> 59 us (2.198392 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
broadcast (2 processes) torch.FloatTensor (65579 contiguous values) -> 44 us (5.866032 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
broadcast (2 processes) torch.FloatTensor (131115 contiguous values) -> 94 us (5.528942 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
broadcast (2 processes) torch.FloatTensor (262187 contiguous values) -> 176 us (5.948622 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
broadcast (2 processes) torch.FloatTensor (524331 contiguous values) -> 350 us (5.977315 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
broadcast (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1407 us (2.979072 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
broadcast (2 processes) torch.FloatTensor (2097195 contiguous values) -> 2881 us (2.911555 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
broadcast (2 processes) torch.FloatTensor (4194347 contiguous values) -> 5744 us (2.920702 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
broadcast (2 processes) torch.FloatTensor (8388651 contiguous values) -> 11383 us (2.947730 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
broadcast (2 processes) torch.FloatTensor (16777259 contiguous values) -> 22674 us (2.959704 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
reduce (2 processes) torch.FloatTensor (59 contiguous values) -> 5 us (0.047002 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
reduce (2 processes) torch.FloatTensor (75 contiguous values) -> 4 us (0.069442 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
reduce (2 processes) torch.FloatTensor (107 contiguous values) -> 3 us (0.116267 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
reduce (2 processes) torch.FloatTensor (171 contiguous values) -> 4 us (0.158328 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
reduce (2 processes) torch.FloatTensor (299 contiguous values) -> 4 us (0.265698 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
reduce (2 processes) torch.FloatTensor (555 contiguous values) -> 4 us (0.547083 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
reduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 4 us (1.017119 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
reduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 4 us (1.917003 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
reduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 5 us (2.786553 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
reduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 9 us (3.653103 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
reduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 15 us (4.278164 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
reduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 30 us (4.316791 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
reduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 60 us (4.367737 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
reduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 116 us (4.491108 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
reduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 228 us (4.586445 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
reduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 456 us (4.590137 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
reduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 912 us (4.597890 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
reduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 1863 us (4.501341 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
reduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 5673 us (2.957098 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
reduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 12368 us (2.712921 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
reduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 24842 us (2.701367 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
```

## Multi-machine CPU collectives test, 2 processes, 1 per machine
```
nimbix@JARVICENAE-0A0A1844:/data/torchmpi$ mpirun -n 2 -ppn 1 -hostfile /etc/JARVICE/nodes -genv I_MPI_SHM_BYPASS 1 -genv NUM_RDMA_BUFFER 8 -genv I_MPI_USE_RENDEZVOUS_RDMA_WRITE 1 -genv I_MPI_OFA_ADAPTER_NAME mlx5_0 -genv I_MPI_OFA_NUM_PORTS 2 -genv I_MPI_FABRICS="ofa" -genv I_MPI_DEVICE="rdma:mlx5_0"  luajit ./test/collectives.lua -nocheck -inPlace
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (59 contiguous values) -> 18 us (0.012684 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (75 contiguous values) -> 9 us (0.032050 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (107 contiguous values) -> 7 us (0.055270 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (171 contiguous values) -> 7 us (0.094997 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (299 contiguous values) -> 7 us (0.158146 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (555 contiguous values) -> 8 us (0.276137 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1067 contiguous values) -> 9 us (0.455040 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2091 contiguous values) -> 12 us (0.667196 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4139 contiguous values) -> 16 us (1.026018 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8235 contiguous values) -> 25 us (1.306111 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16427 contiguous values) -> 46 us (1.419737 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (32811 contiguous values) -> 81 us (1.604422 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (65579 contiguous values) -> 140 us (1.866763 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (131115 contiguous values) -> 154 us (3.392364 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (262187 contiguous values) -> 269 us (3.889479 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (524331 contiguous values) -> 521 us (4.019710 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1017 us (4.122648 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (2097195 contiguous values) -> 1926 us (4.355367 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (4194347 contiguous values) -> 5817 us (2.884141 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (8388651 contiguous values) -> 15041 us (2.230793 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
sendreceivenext (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
sendreceivenext (2 processes) torch.FloatTensor (16777259 contiguous values) -> 30235 us (2.219563 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
allreduce (2 processes) torch.FloatTensor (59 contiguous values) -> 7 us (0.032138 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
allreduce (2 processes) torch.FloatTensor (75 contiguous values) -> 6 us (0.048063 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
allreduce (2 processes) torch.FloatTensor (107 contiguous values) -> 7 us (0.058627 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
allreduce (2 processes) torch.FloatTensor (171 contiguous values) -> 6 us (0.112860 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
allreduce (2 processes) torch.FloatTensor (299 contiguous values) -> 6 us (0.198590 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
allreduce (2 processes) torch.FloatTensor (555 contiguous values) -> 6 us (0.334460 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
allreduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 8 us (0.515590 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
allreduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 9 us (0.853556 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
allreduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 12 us (1.295539 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
allreduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 22 us (1.478283 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
allreduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 43 us (1.527374 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
allreduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 70 us (1.864255 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
allreduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 132 us (1.984834 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
allreduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 184 us (2.838014 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
allreduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 342 us (3.063294 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
allreduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 647 us (3.238099 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
allreduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 1262 us (3.323153 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
allreduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 2665 us (3.147073 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
allreduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 7763 us (2.160966 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
allreduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 17661 us (1.899845 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
allreduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
allreduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 35117 us (1.910977 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
broadcast (2 processes) torch.FloatTensor (59 contiguous values) -> 3 us (0.061789 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
broadcast (2 processes) torch.FloatTensor (75 contiguous values) -> 2 us (0.128136 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
broadcast (2 processes) torch.FloatTensor (107 contiguous values) -> 2 us (0.207773 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
broadcast (2 processes) torch.FloatTensor (171 contiguous values) -> 2 us (0.307822 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
broadcast (2 processes) torch.FloatTensor (299 contiguous values) -> 2 us (0.529155 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
broadcast (2 processes) torch.FloatTensor (555 contiguous values) -> 2 us (1.027743 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
broadcast (2 processes) torch.FloatTensor (1067 contiguous values) -> 3 us (1.135869 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
broadcast (2 processes) torch.FloatTensor (2091 contiguous values) -> 3 us (2.488025 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
broadcast (2 processes) torch.FloatTensor (4139 contiguous values) -> 4 us (4.018570 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
broadcast (2 processes) torch.FloatTensor (8235 contiguous values) -> 6 us (4.774028 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
broadcast (2 processes) torch.FloatTensor (16427 contiguous values) -> 11 us (5.531901 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
broadcast (2 processes) torch.FloatTensor (32811 contiguous values) -> 19 us (6.614723 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
broadcast (2 processes) torch.FloatTensor (65579 contiguous values) -> 43 us (6.055218 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
broadcast (2 processes) torch.FloatTensor (131115 contiguous values) -> 96 us (5.451930 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
broadcast (2 processes) torch.FloatTensor (262187 contiguous values) -> 177 us (5.905179 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
broadcast (2 processes) torch.FloatTensor (524331 contiguous values) -> 339 us (6.179187 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
broadcast (2 processes) torch.FloatTensor (1048619 contiguous values) -> 665 us (6.303126 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
broadcast (2 processes) torch.FloatTensor (2097195 contiguous values) -> 1322 us (6.342742 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
broadcast (2 processes) torch.FloatTensor (4194347 contiguous values) -> 2617 us (6.409355 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
broadcast (2 processes) torch.FloatTensor (8388651 contiguous values) -> 5214 us (6.434888 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
broadcast (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
broadcast (2 processes) torch.FloatTensor (16777259 contiguous values) -> 10410 us (6.446322 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (59 contiguous values)
reduce (2 processes) torch.FloatTensor (59 contiguous values) -> 4 us (0.057019 GB/s assuming good implementation, i.e. 0.000236 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (75 contiguous values)
reduce (2 processes) torch.FloatTensor (75 contiguous values) -> 4 us (0.074279 GB/s assuming good implementation, i.e. 0.000300 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (107 contiguous values)
reduce (2 processes) torch.FloatTensor (107 contiguous values) -> 3 us (0.125888 GB/s assuming good implementation, i.e. 0.000428 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (171 contiguous values)
reduce (2 processes) torch.FloatTensor (171 contiguous values) -> 3 us (0.197583 GB/s assuming good implementation, i.e. 0.000684 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (299 contiguous values)
reduce (2 processes) torch.FloatTensor (299 contiguous values) -> 3 us (0.308511 GB/s assuming good implementation, i.e. 0.001196 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (555 contiguous values)
reduce (2 processes) torch.FloatTensor (555 contiguous values) -> 3 us (0.593080 GB/s assuming good implementation, i.e. 0.002220 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1067 contiguous values)
reduce (2 processes) torch.FloatTensor (1067 contiguous values) -> 3 us (1.077093 GB/s assuming good implementation, i.e. 0.004268 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2091 contiguous values)
reduce (2 processes) torch.FloatTensor (2091 contiguous values) -> 3 us (2.100668 GB/s assuming good implementation, i.e. 0.008364 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4139 contiguous values)
reduce (2 processes) torch.FloatTensor (4139 contiguous values) -> 5 us (2.834322 GB/s assuming good implementation, i.e. 0.016556 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8235 contiguous values)
reduce (2 processes) torch.FloatTensor (8235 contiguous values) -> 9 us (3.382967 GB/s assuming good implementation, i.e. 0.032940 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16427 contiguous values)
reduce (2 processes) torch.FloatTensor (16427 contiguous values) -> 15 us (4.351110 GB/s assuming good implementation, i.e. 0.065708 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (32811 contiguous values)
reduce (2 processes) torch.FloatTensor (32811 contiguous values) -> 29 us (4.522488 GB/s assuming good implementation, i.e. 0.131244 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (65579 contiguous values)
reduce (2 processes) torch.FloatTensor (65579 contiguous values) -> 55 us (4.684235 GB/s assuming good implementation, i.e. 0.262316 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (131115 contiguous values)
reduce (2 processes) torch.FloatTensor (131115 contiguous values) -> 109 us (4.798326 GB/s assuming good implementation, i.e. 0.524460 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (262187 contiguous values)
reduce (2 processes) torch.FloatTensor (262187 contiguous values) -> 214 us (4.897533 GB/s assuming good implementation, i.e. 1.048748 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (524331 contiguous values)
reduce (2 processes) torch.FloatTensor (524331 contiguous values) -> 425 us (4.932553 GB/s assuming good implementation, i.e. 2.097324 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (1048619 contiguous values)
reduce (2 processes) torch.FloatTensor (1048619 contiguous values) -> 868 us (4.827222 GB/s assuming good implementation, i.e. 4.194476 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (2097195 contiguous values)
reduce (2 processes) torch.FloatTensor (2097195 contiguous values) -> 1708 us (4.910841 GB/s assuming good implementation, i.e. 8.388780 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (4194347 contiguous values)
reduce (2 processes) torch.FloatTensor (4194347 contiguous values) -> 5622 us (2.983782 GB/s assuming good implementation, i.e. 16.777388 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (8388651 contiguous values)
reduce (2 processes) torch.FloatTensor (8388651 contiguous values) -> 12523 us (2.679370 GB/s assuming good implementation, i.e. 33.554604 MB through the slowest wire, assuming p2p wires)
reduce (2 processes) (inPlace: false GPU: false Async: false ) torch.FloatTensor (16777259 contiguous values)
reduce (2 processes) torch.FloatTensor (16777259 contiguous values) -> 24860 us (2.699392 GB/s assuming good implementation, i.e. 67.109036 MB through the slowest wire, assuming p2p wires)
```
