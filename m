From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/13] bcache: inherit the optimal I/O size
Date: Thu, 24 Sep 2020 08:51:30 +0200
Message-ID: <20200924065140.726436-4-hch@lst.de>
References: <20200924065140.726436-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=+Llj/AmvV7mHR7T7gL/si/p73lK9Sq9nBxztkJ6FS3s=; b=tKir5D9mG/xQIv7GXHsh7cGgvx
        3y0D7EY/xxMVq0o00qzUZIykqJjNgrs/YlOajox62YL/Iqe1EYGLVGzG+9JBHp7et96FOLh238Hhx
        YlzCTDKvfJ8izWf1tp3jcCDTQrNbzpfQEdmv1OoIS7ecJ3BdKSSx7cr8eRSMRiNDo76JU+baIa100
        VFyFZ5UD7PdSLuwNzmfEXvOo1vGPKe0kwug7pVm0C48ljG+J0OOJy8PeZb/9gNVjhHzmwWcIBwwFF
        KlXPK6ixxl+tjcQ8r9oQC9V0kW8YWIzdUUgP4ynwziLtlB6+XId42Md/7Eg6wR86R1BKV04tFB9rK
        MW5QkZkQ==;
In-Reply-To: <20200924065140.726436-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Jan Kara <jack@suse.cz>

Inherit the optimal I/O size setting just like the readahead window,
as any reason to do larger I/O does not apply to just readahead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Coly Li <colyli@suse.de>
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

