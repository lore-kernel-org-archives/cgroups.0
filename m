From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/15] blk-cgroup: cleanup blkcg_maybe_throttle_current
Date: Wed, 20 Apr 2022 06:27:22 +0200
Message-ID: <20220420042723.1010598-15-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xmlR5HUFOAI8yqQFKY2MjEXGwXGx785pMDVfAqM57ow=; b=LMiuO+Sz6pZtEd/3zHUKL+74hk
        RpDt274l1HCMYrW1VFhdZfv9C/v4MJmcABLxfjJSnH1xD1FymXQDAiM1XRKJ0bfzpPnyq6JA7vTsJ
        U6ighNPhZ6WMln3DZRgZGB8IrKD8jsHv7+Zcz+q/n0qQb8Qln1SRuvSUhu8rnPRAO4NkoUS+IYw5E
        UpWlcjxj53dat92wmf8kUZLE+5nDicqZ1JW7ngiAfEgWoQyG34+GlzY5iwkasD8PrBCyhI7EY/6c5
        UV72fx2cclo9+GXOvxhux5g04dBiY3tCpN9Axb2GlbCQepBEpSDQCvzIUQQJTy26JU9m0aKkIi0li
        OvH2sV+w==;
In-Reply-To: <20220420042723.1010598-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org, linux-mm@kvack.org

Use blkcg_css instead of opencoding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5684a8ce1f755..a91f8ae18b49b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1808,7 +1808,6 @@ static void blkcg_maybe_throttle_blkg(struct blkcg_gq *blkg, bool use_memdelay)
 void blkcg_maybe_throttle_current(void)
 {
 	struct request_queue *q = current->throttle_queue;
-	struct cgroup_subsys_state *css;
 	struct blkcg *blkcg;
 	struct blkcg_gq *blkg;
 	bool use_memdelay = current->use_memdelay;
@@ -1820,12 +1819,7 @@ void blkcg_maybe_throttle_current(void)
 	current->use_memdelay = false;
 
 	rcu_read_lock();
-	css = kthread_blkcg();
-	if (css)
-		blkcg = css_to_blkcg(css);
-	else
-		blkcg = css_to_blkcg(task_css(current, io_cgrp_id));
-
+	blkcg = css_to_blkcg(blkcg_css());
 	if (!blkcg)
 		goto out;
 	blkg = blkg_lookup(blkcg, q);
-- 
2.30.2

