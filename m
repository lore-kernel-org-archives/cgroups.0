From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/13] aoe: set an optimal I/O size
Date: Thu, 24 Sep 2020 08:51:31 +0200
Message-ID: <20200924065140.726436-5-hch@lst.de>
References: <20200924065140.726436-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=g9xVnmRLNXPehcB4PdT7j+hjYku/j4udzyGtMh1GMwg=; b=L6rYs9SgfbS93bAxFavESPGoy0
        /v4w1xHKzUlgbK7M4J4CfEklqmTuP2Z/b95hBWtxRTKXZM2PVUt7f4/gSSAFoLGN2git2oF5dLDwh
        TSLtJUhfBUrAXO9zkv+5p3NWTXtFLm3D8EMaWzzFlgrsHn61ZVCByA0wmc8fkLa3okgAXVOozzmiS
        4rdy3q4Io0SIE7nJ6FE9igOCKmRGmE5Lv5ZKxomzwPp1dYsWWeKuiPxEpUh/iDHCQAft+lM3+BSxP
        MCvW3VsvvRaDMI9viLfFCmAnA8bzSX6j3m2/KNgIrWab8PfiT3CagUBPdUVzdoZvWuLIrBAc0ghF8
        EWnVjA0w==;
In-Reply-To: <20200924065140.726436-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Jan Kara <jack@suse.cz>

aoe forces a larger readahead size, but any reason to do larger I/O
is not limited to readahead.  Also set the optimal I/O size, and
remove the local constants in favor of just using SZ_2G.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 drivers/block/aoe/aoeblk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 5ca7216e9e01f3..d8cfc233e64b93 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -347,7 +347,6 @@ aoeblk_gdalloc(void *vp)
 	mempool_t *mp;
 	struct request_queue *q;
 	struct blk_mq_tag_set *set;
-	enum { KB = 1024, MB = KB * KB, READ_AHEAD = 2 * MB, };
 	ulong flags;
 	int late = 0;
 	int err;
@@ -407,7 +406,8 @@ aoeblk_gdalloc(void *vp)
 	WARN_ON(d->gd);
 	WARN_ON(d->flags & DEVFL_UP);
 	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
-	q->backing_dev_info->ra_pages = READ_AHEAD / PAGE_SIZE;
+	q->backing_dev_info->ra_pages = SZ_2M / PAGE_SIZE;
+	blk_queue_io_opt(q, SZ_2M);
 	d->bufpool = mp;
 	d->blkq = gd->queue = q;
 	q->queuedata = d;
-- 
2.28.0

