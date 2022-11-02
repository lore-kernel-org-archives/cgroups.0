From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v4 0/5] multiple cleanup patches for bfqd
Date: Wed,  2 Nov 2022 10:25:37 +0800
Message-ID: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

Changes in v4:
 - move first two patches from v3 into another thread.
 - add patch 1

Changes in v3:
 - resend v2 with new mail address

Changes in v2:
 - add missing blank line in patch 1.
 - remove patch 7,8, since they are wrong.
 - add reviewed-by tag

Yu Kuai (5):
  block, bfq: remove set but not used variable in
    __bfq_entity_update_weight_prio
  block, bfq: factor out code to update 'active_entities'
  block, bfq: cleanup bfq_activate_requeue_entity()
  block, bfq: remove dead code for updating 'rq_in_driver'
  block, bfq: don't declare 'bfqd' as type 'void *' in bfq_group

 block/bfq-cgroup.c  |  2 +-
 block/bfq-iosched.c | 16 ---------
 block/bfq-iosched.h |  2 +-
 block/bfq-wf2q.c    | 88 ++++++++++++++++++---------------------------
 4 files changed, 37 insertions(+), 71 deletions(-)

-- 
2.31.1

