From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/14] block: really clone the block cgroup in bio_clone_blkg_association
Date: Sat, 27 Jun 2020 09:31:48 +0200
Message-ID: <20200627073159.2447325-4-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=te67Kz6q7FtaNJUJ111t8gsYne197tgP/jW4K8xX9vA=; b=NllTbXB2YDFcVqcI043iyFsHwr
        tt77jKmSatOzYm5rqro2913myOlHulKnX4dt+8MOfTpepgR6TO2fYBzD4y3xZLLq57sFsuQKwjUn/
        lLsBuzEeKDXVHq14z0Y+4mUXx0ae20B6us+olRYV4IeSBgdmadhqE/mKZGOP0xLqG7DAOykeARTW8
        Vjwxz8hyIJzVL46ScOCngCuMa5pAPZ9e4ExDnntp/DtIrhC5V8t0SDq3ssA0P/EEZesARi7JZ4vl/
        YcKpLXYo8gmWNoJberB6ct7R0JEf97ic7E/wfDM/BF56/51DV1p8WH5aKgRth6mdXE0o4D8tMK60/
        N0hDQYQg==;
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

bio_clone_blkg_association is supposed to clone the associatation, but
actually ends up doing a search with a tryget.  As we know we have a
reference on the source cgroup just get an unconditional additional
reference to it and call it a day.  That also removes the need for
a RCU critical section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8aef4460b32e0e..e1d01acce8070c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1737,12 +1737,12 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
  */
 void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
-	rcu_read_lock();
-
-	if (src->bi_blkg)
-		__bio_associate_blkg(dst, src->bi_blkg);
-
-	rcu_read_unlock();
+	if (src->bi_blkg) {
+		if (dst->bi_blkg)
+			blkg_put(dst->bi_blkg);
+		blkg_get(src->bi_blkg);
+		dst->bi_blkg = src->bi_blkg;
+	}
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 #endif /* CONFIG_BLK_CGROUP */
-- 
2.26.2

