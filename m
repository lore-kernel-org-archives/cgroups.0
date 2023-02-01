From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/19] block: don't call blk_throtl_stat_add for non-READ/WRITE commands
Date: Wed,  1 Feb 2023 14:41:05 +0100
Message-ID: <20230201134123.2656505-2-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VWwPZdmK4rNkY5M0ChzWfV9yf3Jd1QwvNFbGSddgKhc=; b=10zii5TNG0st7Zv65RkwkFDyLA
        PvTSbbH2UzbvL/0RbqzGV/vc1PTIXLHGhBAASJcB6M4XYwk+FMDQ2FCivm8QHuXC1GFVnNASyM94Q
        h4Lbv6U+nAVwDmft8Lna+PZ2RHm9e2H38/fYVtEExy/r4dGfNzbQo6CN6rwzPX/r5ZJdi0lL3HGXS
        k9kVdJHVwFi8CpuHNDtZKmqgwPP7KAFopIpTfoH9QIyWPkXNXQTAFmE5SH9fSNYVoqFi1sbV9gjQb
        wF45qa8Mw8+NMLqpEGyOZg3QefwA86EfC4ZKvUtD9wuvuVqdZwaV00j8iWIJGlI4vI7WEbsDTaZk/
        LtDVNjXw==;
In-Reply-To: <20230201134123.2656505-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

blk_throtl_stat_add is called from blk_stat_add explicitly, unlike the
other stats that go through q->stats->callbacks.  To prepare for cgroup
data moving to the gendisk, ensure blk_throtl_stat_add is only called
for the plain READ and WRITE commands that it actually handles internally,
as blk_stat_add can also be called for passthrough commands on queues that
do not have a gendisk associated with them.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>
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

