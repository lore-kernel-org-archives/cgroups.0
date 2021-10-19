From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v3 -next 0/2] blk-cgroup: synchoronize blkg creation against policy deactivation
Date: Tue, 19 Oct 2021 10:41:30 +0800
Message-ID: <20211019024132.432458-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, avanzini.arianna@gmail.com, fchecconi@gmail.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Changes in V3:
 - grab q_usage_counter in blkg_conf_prep() instead of introducing a
 new mutex.

Changes in V2:
 - rename the patch title
 - instead of checking policy in blkg_create(), using a new solution.

Yu Kuai (2):
  blk-cgroup: don't call blk_mq_freeze_queue() in
    blkcg_deactivate_policy()
  blk-cgroup: synchoronize blkg creation against policy deactivation

 block/blk-cgroup.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

-- 
2.31.1

