From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/13] bcache: inherit the optimal I/O size
Date: Mon, 21 Sep 2020 10:07:24 +0200
Message-ID: <20200921080734.452759-4-hch@lst.de>
References: <20200921080734.452759-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1Wl4CR3g3QHDQhZ33f8Oe6qI9aP7fMZeE5hKlObwJ0M=; b=EQwu/cR2LodCQaFHG05hYNpozm
        U++iiQM/OeP2AkVo1WTUpU+dI2Dxy9PU9SMGZkQIchixHl5Jx7a0QZk5QjsM3mKR+reWMYdC5dYVn
        1/RyKrVkK9YLy3fmeQEtMZdYZZY5sO+JS6B15u1VfcYsZYeIJhvelBd9tWQF1KMWdpSxOaOX7AQ3C
        wizDdm3VvY8FkkLVnDPzz1aL3YJazDYKgNWRltE/h20ULbz8zDeUg/9HS2R2SkDzVSLHKIMcr5zcW
        Ycx/mTaN0ejniWyn1jkIqStX3tT5JOPuH+P5WFBTHwcT/t8jMI83iRyfSIeaANZdLu8MwdwI6fNNq
        LsuftJjQ==;
In-Reply-To: <20200921080734.452759-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

Inherit the optimal I/O size setting just like the readahead window,
as any reason to do larger I/O does not apply to just readahead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1bbdc410ee3c51..48113005ed86ad 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1430,6 +1430,8 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 	dc->disk.disk->queue->backing_dev_info->ra_pages =
 		max(dc->disk.disk->queue->backing_dev_info->ra_pages,
 		    q->backing_dev_info->ra_pages);
+	blk_queue_io_opt(dc->disk.disk->queue,
+		max(queue_io_opt(dc->disk.disk->queue), queue_io_opt(q)));
 
 	atomic_set(&dc->io_errors, 0);
 	dc->io_disable = false;
-- 
2.28.0

