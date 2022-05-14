From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next 0/8] multiple cleanup patches for bfq
Date: Sat, 14 May 2022 17:05:14 +0800
Message-ID: <20220514090522.1669270-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

There are no functional changes in this patchset, just some places
that I think can be improved during code review.

Yu Kuai (8):
  block, bfq: cleanup bfq_weights_tree add/remove apis
  block, bfq: cleanup __bfq_weights_tree_remove()
  block, bfq: factor out code to update 'active_entities'
  block, bfq: don't declare 'bfqd' as type 'void *' in bfq_group
  block, bfq: cleanup bfq_activate_requeue_entity()
  block, bfq: remove dead code for updating 'rq_in_driver'
  block, bfq: cleanup bfq_bfqq_update_budg_for_activation()
  block, bfq: cleanup bfq_bfqq_handle_idle_busy_switch()

 block/bfq-cgroup.c  |   2 +-
 block/bfq-iosched.c | 179 ++++++++++++++++++--------------------------
 block/bfq-iosched.h |  11 +--
 block/bfq-wf2q.c    |  91 ++++++++++------------
 4 files changed, 119 insertions(+), 164 deletions(-)

-- 
2.31.1

