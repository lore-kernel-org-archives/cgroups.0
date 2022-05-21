From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v2 0/6] multiple cleanup patches for bfq
Date: Sat, 21 May 2022 15:35:17 +0800
Message-ID: <20220521073523.3118246-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Changes in v2:
 - add missing blank line in patch 1.
 - remove patch 7,8, since they are wrong.
 - add reviewed-by tag

There are no functional changes in this patchset, just some places
that I think can be improved during code review.

This patchset is rebased based on this patchset:
https://lore.kernel.org/all/20220428120837.3737765-1-yukuai3@huawei.com/

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

