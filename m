From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/15] block: don't call blk_throtl_stat_add for non-READ/WRITE commands
Date: Tue, 24 Jan 2023 07:57:02 +0100
Message-ID: <20230124065716.152286-3-hch@lst.de>
References: <20230124065716.152286-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VWwPZdmK4rNkY5M0ChzWfV9yf3Jd1QwvNFbGSddgKhc=; b=aNFhekhXQgfzMBXDzIPdnTI0qW
        n/brvcYPf/mP8qDPVRqjo277TARKkGvkM+eYjpuPBZvug/Zerxkkr8OXcDodFbOu6NNcSnGqZL03m
        LKEtCMAdMFNaCzp4moe7EpY+tigQcbnhWMJoXs2YLKXNuINy+qWOJu9M8ig9wgCImYRk3j/xPtA3C
        CLNjB1mqV6tHOBtxP+0C1zKSu4c/8/uGP89hjEmZeOgbFhBeuyzS+DLdjMEmimbpcnSybBbC9AVhA
        dzDftU8h8W0cqyW5GsLjIRgdmTqHgUBSvz+Giup3xLIjYXmk51JK3bdvYPl7G+dZKiFZl/6tcXelz
        S6t8yXJw==;
In-Reply-To: <20230124065716.152286-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

blk_throtl_stat_add is called from blk_stat_add explicitly, unlike the
other stats that go through q->stats->callbacks.  To prepare for cgroup
data moving to the gendisk, ensure blk_throtl_stat_add is only called
for the plain READ and WRITE commands that it actually handles internally,
as blk_stat_add can also be called for passthrough commands on queues that
do not have a gendisk associated with them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
---
 block/blk-stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index 2ea01b5c1aca04..c6ca16abf911e2 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -58,7 +58,8 @@ void blk_stat_add(struct request *rq, u64 now)
 
 	value = (now >= rq->io_start_time_ns) ? now - rq->io_start_time_ns : 0;
 
-	blk_throtl_stat_add(rq, value);
+	if (req_op(rq) == REQ_OP_READ || req_op(rq) == REQ_OP_WRITE)
+		blk_throtl_stat_add(rq, value);
 
 	rcu_read_lock();
 	cpu = get_cpu();
-- 
2.39.0

