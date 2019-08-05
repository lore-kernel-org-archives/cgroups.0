From: Fam Zheng <zhengfeiran@bytedance.com>
Subject: [PATCH v2 0/3] Implement BFQ per-device weight interface
Date: Mon,  5 Aug 2019 14:38:04 +0800
Message-ID: <20190805063807.9494-1-zhengfeiran@bytedance.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=c8VHeq19ya4NgPAfDdaqw+9aj+OFOs4WuaGxyy8ErMY=;
        b=OIeSnNO7cj0zewIOCmHFYjKvW+fx4JZINu923BjB0Hq/ubX+bwiftL7/216vqNXYB1
         Lvks5py6y2q6fGu/M7MagQ8j0/yj5L9KGlvU+Mibf3MLnOSONPXVuTIdfPrUM7z974aj
         /eVzeZ2pbGEtDq1N5I9ns4JjUvVzAwJ2GuM0Dp56b/MMHk55rwpC8sB9F58psHo3HV3f
         yiHG0YyHEFKQXZ6Lwpmr6OB9/t3xUkgMGy95WPvIGYYGwp00ReDgvYx+1hfgOoTkb4Hg
         HooskmgqWCHsPqVKWhVei8eC/pOEyaijR9Pk8/gclfLyAZkvoIiS+vIgNoO0O5tg/PcS
         4VqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, fam@euphon.net, paolo.valente@linaro.org, duanxiongchun@bytedance.com, linux-block@vger.kernel.org, tj@kernel.org, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com

(Revision starting from v2 since v1 was used off-list)

Hi Paolo and others,

This adds to BFQ the missing per-device weight interfaces:
blkio.bfq.weight_device on legacy and io.bfq.weight on unified. The
implementation pretty closely resembles what we had in CFQ and the parsing code
is basically reused.

Tests
=====

Using two cgroups and three block devices, having weights setup as:

Cgroup          test1           test2
============================================
default         100             500
sda             500             100
sdb             default         default
sdc             200             200

cgroup v1 runs
--------------

    sda.test1.out:   READ: bw=913MiB/s
    sda.test2.out:   READ: bw=183MiB/s

    sdb.test1.out:   READ: bw=213MiB/s
    sdb.test2.out:   READ: bw=1054MiB/s

    sdc.test1.out:   READ: bw=650MiB/s
    sdc.test2.out:   READ: bw=650MiB/s

cgroup v2 runs
--------------

    sda.test1.out:   READ: bw=915MiB/s
    sda.test2.out:   READ: bw=184MiB/s

    sdb.test1.out:   READ: bw=216MiB/s
    sdb.test2.out:   READ: bw=1069MiB/s

    sdc.test1.out:   READ: bw=621MiB/s
    sdc.test2.out:   READ: bw=622MiB/s

Fam Zheng (3):
  bfq: Fix the missing barrier in __bfq_entity_update_weight_prio
  bfq: Extract bfq_group_set_weight from bfq_io_set_weight_legacy
  bfq: Add per-device weight

 block/bfq-cgroup.c  | 151 +++++++++++++++++++++++++++++++++++++++-------------
 block/bfq-iosched.h |   3 ++
 block/bfq-wf2q.c    |   2 +
 3 files changed, 119 insertions(+), 37 deletions(-)

-- 
2.11.0

