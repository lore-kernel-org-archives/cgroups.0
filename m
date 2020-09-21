From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/13] mm: use SWP_SYNCHRONOUS_IO more intelligently
Date: Mon, 21 Sep 2020 10:07:31 +0200
Message-ID: <20200921080734.452759-11-hch@lst.de>
References: <20200921080734.452759-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=I7MiMBMaLkYFUGes/ZWFe9+6oC03kpbTj/tDtF5mSAI=; b=rTzSzbsce3QgyMY8zv6MyEkHGY
        tbu55NiUpRPj7zKuLcSHaDR272lrt2BoJNqPBwqJ/YPIU7ISABrYkM/UwmAVOJtnJOzR4jO94X+Rr
        oDd6Q6oZsQz8+QzGD/KySwZd8yNarsrpwX7WXnHSzs/6DeyG+S/FfkOZex0czj4dp72lWTyKGq4m7
        KVELv/mCJOyjfX5baxc0ps7djKVZoJ4qzFG9v3b34iaCGHz2Vcs0iQ8qSkTSHbIA7lSyCtfivoACK
        U0DFDLgQOD2YDza3HGsuEzAANqxYywc/6eztDNgLEwqpAOimEa3Wum76r7ogMOTUB6Whyy+S30Yli
        Rfp7uhug==;
In-Reply-To: <20200921080734.452759-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Jan Kara <jack@suse.cz>, Johannes Thumshirn <johannes.thumshirn@wdc.com>

There is no point in trying to call bdev_read_page if SWP_SYNCHRONOUS_IO
is not set, as the device won't support it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 mm/page_io.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index e485a6e8a6cddb..b199b87e0aa92b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -403,15 +403,17 @@ int swap_readpage(struct page *page, bool synchronous)
 		goto out;
 	}
 
-	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
-	if (!ret) {
-		if (trylock_page(page)) {
-			swap_slot_free_notify(page);
-			unlock_page(page);
-		}
+	if (sis->flags & SWP_SYNCHRONOUS_IO) {
+		ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
+		if (!ret) {
+			if (trylock_page(page)) {
+				swap_slot_free_notify(page);
+				unlock_page(page);
+			}
 
-		count_vm_event(PSWPIN);
-		goto out;
+			count_vm_event(PSWPIN);
+			goto out;
+		}
 	}
 
 	ret = 0;
-- 
2.28.0

