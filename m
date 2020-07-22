From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] mm: use SWP_SYNCHRONOUS_IO more intelligently
Date: Wed, 22 Jul 2020 08:25:49 +0200
Message-ID: <20200722062552.212200-12-hch@lst.de>
References: <20200722062552.212200-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Jdh+Se3a2Jmdkbd57oVwwUzzlSWemowvtj1/EcjXiHo=; b=rjXQWvaS8qHBtniDPxFQ3W77Lf
        53UqC85nCDqwBMS670ZU8cqxhPbGs900+d1eIdmxbZ04GiYESYTfGlNCJgRQPBJuB86FTUwLpkHn3
        wPFSDOUzY5zhrDQMil0gRtDB48U4m1FpG+6tlFelSCd34zlztC8m/YowLfNo1I6/mXYie3MDWq7Wh
        QyvLFIXsIK4EB5pGBoHLx+hnJia9LMlhD6KbRcJ4zSik1o4g3eiVehQ9Bns6aNJzBx4RZvdKoLxB1
        JfOOksSykmuh1FyXqu4n88wDVc3dB5EDt/60gUX099FVBcr9ZkMC7D3y/p66Zj7Tco563xJ/Ht9As
        6JeW5qow==;
In-Reply-To: <20200722062552.212200-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
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
index ccda7679008851..442061348dfb26 100644
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
+		if (ret) {
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

