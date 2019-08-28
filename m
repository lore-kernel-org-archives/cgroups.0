From: Fam Zheng <zhengfeiran@bytedance.com>
Subject: [PATCH v3 0/3] Implement BFQ per-device weight interface
Date: Wed, 28 Aug 2019 11:54:50 +0800
Message-ID: <20190828035453.18129-1-zhengfeiran@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y9181Itz3jIauqOELXX6WInlwQHr+dm37ugRC+ucshM=;
        b=TjQXccpZVKZ1sffAXO/DsPyDsK+AdFu9vdXcGvo9YuHGjpeHZlNiTOqwGfSPmYezm8
         l9Ajufq1E8hHy8CbTnQ2anykStPYMn7aF2ga3wEwW/IN1412J6cvxPr1DCxzzre7bLtx
         yS+d1Zh8I5PLqcOSKW5u/cce0sblzCDq2saTXTtJySLWpDmPv4on2rEXv33NS+3gHECZ
         /SIke6FZhTib1ascyJl3ItKGFoiCXn+zjg79QsgbWTNJQuWIrANzjeE+aU6JHsMPNJ9y
         IyyyJ8KkIDEJn10TuxcBtjTkEygENGwIvTRAXT18w5KFl4l7fKuf377AwEnhJljA6BBF
         crrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, paolo.valente@linaro.org, fam@euphon.net, duanxiongchun@bytedance.com, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com, tj@kernel.org, linux-block@vger.kernel.org

v3: Pick up rev-by and ack-by from Paolo and Tejun.
    Add commit message to patch 3.

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

 block/bfq-cgroup.c  | 151 +++++++++++++++++++++++++++++++++-----------
 block/bfq-iosched.h |   3 +
 block/bfq-wf2q.c    |   2 +
 3 files changed, 119 insertions(+), 37 deletions(-)

-- 
2.22.1

