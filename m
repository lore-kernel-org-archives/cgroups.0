From: Weiping Zhang <zhangweiping@didiglobal.com>
Subject: [PATCH v5 0/4] Add support Weighted Round Robin for blkcg and nvme
Date: Tue, 4 Feb 2020 11:30:45 +0800
Message-ID: <cover.1580786525.git.zhangweiping@didiglobal.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, tj@kernel.org, hch@lst.de, bvanassche@acm.org, kbusch@kernel.org, minwoo.im.dev@gmail.com, tglx@linutronix.de, ming.lei@redhat.com, edmund.nadolski@intel.com
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org

Hi,

This series try to add Weighted Round Robin for block cgroup and nvme
driver. When multiple containers share a single nvme device, we want
to protect IO critical container from not be interfernced by other
containers. We add blkio.wrr interface to user to control their IO
priority. The blkio.wrr accept five level priorities, which contains
"urgent", "high", "medium", "low" and "none", the "none" is used for
disable WRR for this cgroup.

The first patch add an WRR infrastucture for block cgroup.

We add extra four hareware contexts at blk-mq layer,
HCTX_TYPE_WRR_URGETN/HIGH/MEDIUM/LOW to allow device driver maps
different hardsware queues to dirrenct hardware context.

The second patch add a nvme_ctrl_ops named get_ams to get the expect
Arbitration Mechanism Selected, now this series only support nvme-pci.
This operations will check both CAP.AMS and nvme-pci wrr queue count,
to decide enable WRR or RR.

The third patch rename write_queues module parameter to read_queues,
that can simplify the calculation the number of defaut,read,poll,wrr
queue.

The last patch add support nvme-pci Weighted Round Robin with Urgent
Priority Class, we add four module paranmeters as follow:
	wrr_urgent_queues
	wrr_high_queues
	wrr_medium_queues
	wrr_low_queues
nvme-pci will set CC.AMS=001b, if CAP.AMS[17]=1 and wrr_xxx_queues
larger than 0. nvme driver will split hardware queues base on the
read/pool/wrr_xxx_queues, then set proper value for Queue Priority
(QPRIO) in DWORD11. This patch also extends IRQ_AFFINITY_MAX_SETS to 6,
since nvme may use 6 irq sets, if read, default,wrr related queues are
all not equal to 0.

fio test:

CPU:	Intel(R) Xeon(R) Platinum 8160 CPU @ 2.10GHz
NVME:	Intel SSDPE2KX020T8 P4510 2TB

[root@tmp-201812-d1802-818396173 low]# nvme show-regs /dev/nvme0n1
cap     : 2078030fff
version : 10200
intms   : 0
intmc   : 0
cc      : 460801
csts    : 1
nssr    : 0
aqa     : 1f001f
asq     : 5f7cc08000
acq     : 5f5ac23000
cmbloc  : 0
cmbsz   : 0

Run fio-1, fio-2, fio-3 in parallel, 

For RR(round robin) these three fio nearly get same iops or bps,
if we set blkio.wrr for different priority, the WRR "high" will
get more iops/bps than "medium" and "low".

RR:
fio-1: echo "259:0 none" > /sys/fs/cgroup/blkio/high/blkio.wrr
fio-2: echo "259:0 none" > /sys/fs/cgroup/blkio/medium/blkio.wrr
fio-3: echo "259:0 none" > /sys/fs/cgroup/blkio/low/blkio.wrr

WRR:
fio-1: echo "259:0 high" > /sys/fs/cgroup/blkio/high/blkio.wrr
fio-2: echo "259:0 medium" > /sys/fs/cgroup/blkio/medium/blkio.wrr
fio-3: echo "259:0 low" > /sys/fs/cgroup/blkio/low/blkio.wrr

    Test script:
    https://github.com/dublio/nvme-wrr/blob/master/test_wrr.sh

    Test result:
    randread             (RR)IOPS        (RR)latency     (WRR)IOPS       (WRR)latency
    --------------------------------------------------------------------------------
    randread_high        217474          3528.49         404451          1897.17
    randread_medium      217473          3528.56         202349          3793.54
    randread_low         217978          3520.98         67419           11386.43

    randwrite            (RR)IOPS        (RR)latency     (WRR)IOPS       (WRR)latency
    --------------------------------------------------------------------------------
    randwrite_high       144946          5295.34         277401          2766.66
    randwrite_medium     144861          5296.85         138710          5532.28
    randwrite_low        145105          5289.36         46316           16569.54

    read                 (RR)BW          (RR)latency     (WRR)BW         (WRR)latency
    --------------------------------------------------------------------------------
    read_high            956191          410823.48       1790273         219427.11
    read_medium          920096          426887.25       897644          437760.17
    read_low             928076          423248.05       302899          1297195.34

    write                (RR)BW          (RR)latency     (WRR)BW         (WRR)latency
    --------------------------------------------------------------------------------
    write_high           737211          532359.31       1194013         328970.70
    write_medium         759052          516902.66       600626          653876.69
    write_low            782348          501309.47       203754          1928779.39

Changes since V4:
 * calculate the number of irq sets by the queue count of each HCTX type, and 
   drops patch: genirq/affinity: allow driver's discontigous affinity set
 * extends IRQ_AFFINITY_MAX_SETS to 6 instead of 7.

Changes since V3:
 * only show blkio.wrr in non-root cgroups.
 * give bs/iops and latency in test result.

Changes since V2:
 * drop null_blk related patch, which adds a new NULL_Q_IRQ_WRR to
	simulte nvme wrr policy
 * add urgent tagset map for nvme driver
 * fix some problem in V2, suggested by Minwoo

Changes since V1:
 * reorder HCTX_TYPE_POLL to the last one to adopt nvme driver easily.
 * add support WRR(Weighted Round Robin) for nvme driver

Weiping Zhang (4):
  block: add weighted round robin for blkcgroup
  nvme: add get_ams for nvme_ctrl_ops
  nvme-pci: rename module parameter write_queues to read_queues
  nvme: add support weighted round robin queue

 block/blk-cgroup.c         |  91 ++++++++++++++++
 block/blk-mq-debugfs.c     |   4 +
 block/blk-mq-sched.c       |   5 +-
 block/blk-mq-tag.c         |   4 +-
 block/blk-mq-tag.h         |   2 +-
 block/blk-mq.c             |  12 ++-
 block/blk-mq.h             |  20 +++-
 block/blk.h                |   2 +-
 drivers/nvme/host/core.c   |   9 +-
 drivers/nvme/host/nvme.h   |   2 +
 drivers/nvme/host/pci.c    | 260 ++++++++++++++++++++++++++++++++++++---------
 include/linux/blk-cgroup.h |   2 +
 include/linux/blk-mq.h     |  18 ++++
 include/linux/interrupt.h  |   2 +-
 include/linux/nvme.h       |   3 +
 15 files changed, 375 insertions(+), 61 deletions(-)

-- 
2.14.1

