From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 0/4] A few cleanup patches for blk-cgroup
Date: Mon, 10 Oct 2022 10:38:55 +0800
Message-ID: <20221010023859.11896-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

This series contains a few cleanup patches to correct comment, remove
unnecessary exit and add NULL check.

Kemeng Shi (4):
  blk-cgroup: Remove unnecessary blk_ioprio_exit in blkcg_init_queue
  blk-cgroup: correct comment for blk_alloc_queue and blk_exit_queue
  blk-cgroup: Add NULL check of pd_alloc_fn in blkcg_activate_policy
  blk-cgroup: Fix typo in comment

 block/blk-cgroup.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

-- 
2.30.0

