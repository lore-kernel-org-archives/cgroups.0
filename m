From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 0/4] block, bfq: minor cleanup and fix
Date: Tue, 21 Dec 2021 11:21:31 +0800
Message-ID: <20211221032135.878550-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz, fchecconi@gmail.com, avanzini.arianna@gmail.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Yu Kuai (4):
  block, bfq: cleanup bfq_bfqq_to_bfqg()
  block, bfq: avoid moving bfqq to it's parent bfqg
  block, bfq: don't move oom_bfqq
  block, bfq: update pos_root for idle bfq_queue in bfq_bfqq_move()

 block/bfq-cgroup.c  | 25 ++++++++++++++++++++-----
 block/bfq-iosched.c |  4 ++--
 block/bfq-iosched.h |  1 -
 block/bfq-wf2q.c    | 15 ---------------
 4 files changed, 22 insertions(+), 23 deletions(-)

-- 
2.31.1

