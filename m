From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] mm: use SWP_SYNCHRONOUS_IO more intelligently
Date: Fri, 24 Jul 2020 09:33:10 +0200
Message-ID: <20200724073313.138789-12-hch@lst.de>
References: <20200724073313.138789-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=r6GVNDpJ00GIAfQlV8fGdOFlOngs4z7GOfztVZ4Wopg=; b=H9chBPz8VW3nrS8D/DH/sVlU/F
        qTE3kQJSkvGa29xlm3sAbuZDi82AskW2+7fjPxCRR3QbJ5YsVUt0Kj+m8PmTj83HPitCjtfgBFagh
        inT+4I3iJoCyCsHSTaIY4hPuGyKoQeZH4Fsyw/aa5PL9uBdYUAkMYnBp1k4e49Ul7v1pqEWn0UxsY
        XfablgUGRHFB9tB8aOnvgmsHzlderU2IxPDewd6CL5W8+uAmGEFj9vyCWe9GiPc0TNVvHCRXS+iuy
        Q2LFPaHq7JyKjuiOcqQ6wzIBvrK2CfwQ8vwUbz+CDh8leY7Wq2+X79x5o+SCC6EhkmwDHXTZLDR9y
        agi2Ht8Q==;
In-Reply-To: <20200724073313.138789-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

There is no point in trying to call bdev_read_page if SWP_SYNCHRONOUS_IO
is not set, as the device won't support it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index ccda7679008851..7eef3c84766abc 100644
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
2.27.0

