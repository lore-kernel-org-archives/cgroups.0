From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v3 0/6] multiple cleanup patches for bfq
Date: Sat, 28 May 2022 17:59:52 +0800
Message-ID: <20220528095958.270455-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Resend just in case v2 end up in spam (for Paolo).

Changes in v2:
 - add missing blank line in patch 1.
 - remove patch 7,8, since they are wrong.
 - add reviewed-by tag

There are no functional changes in this patchset, just some places
that I think can be improved during code review.

Previous version:
v1: https://lore.kernel.org/all/20220514090522.1669270-1-yukuai3@huawei.com/

Yu Kuai (6):
  block, bfq: cleanup bfq_weights_tree add/remove apis
  block, bfq: cleanup __bfq_weights_tree_remove()
  block, bfq: factor out code to update 'active_entities'
  block, bfq: don't declare 'bfqd' as type 'void *' in bfq_group
  block, bfq: cleanup bfq_activate_requeue_entity()
  block, bfq: remove dead code for updating 'rq_in_driver'

 block/bfq-cgroup.c  |  2 +-
 block/bfq-iosched.c | 38 +++----------------
 block/bfq-iosched.h | 11 ++----
 block/bfq-wf2q.c    | 91 ++++++++++++++++++++-------------------------
 4 files changed, 51 insertions(+), 91 deletions(-)

-- 
2.31.1

