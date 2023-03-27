From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] block: async_bio_lock does not need to be bh-safe
Date: Mon, 27 Mar 2023 09:49:52 +0900
Message-ID: <20230327004954.728797-7-hch@lst.de>
References: <20230327004954.728797-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3WakPQXoeSMBHEPH563KK9+L13liempcHofus5A/Ot8=; b=d67K7+N6/KWpQYNy6k3CFhe2Uz
        x7YOO4e3q6Uj2LARNCWckeWWq8m4w0y7ONVL6BflMm8kKUVCJNvxP4c/0xH9bi7Dq+MmDn/O13Jp7
        xFaSm4piEIC2y4EopR0t3JPPNuVFw6d5kFHYPAGTvm/2WPZflNZ8long+I3pwekDv0asO9hcJYU2r
        YqbBVNXFjLa5kB8Bmn58f0wr2Ukt8TLUPcYb1NdKy18+W7pwgSAnPI0H3UvOLaw9AArKowBGCqifx
        ybk2dr85sWlDmBm6B+HUrdJ0AHopWItK+6Uex9r+lAdn6LuHZ4SJcKE1UjOwm9Mna5h0V6KC1scm9
        6/iWzv+Q==;
In-Reply-To: <20230327004954.728797-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

async_bio_lock is only taken from bio submission and workqueue context,
both are never in bottom halves.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9f5f3263c1781e..c524ecab440b8f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -198,10 +198,10 @@ static void blkg_async_bio_workfn(struct work_struct *work)
 	bool need_plug = false;
 
 	/* as long as there are pending bios, @blkg can't go away */
-	spin_lock_bh(&blkg->async_bio_lock);
+	spin_lock(&blkg->async_bio_lock);
 	bio_list_merge(&bios, &blkg->async_bios);
 	bio_list_init(&blkg->async_bios);
-	spin_unlock_bh(&blkg->async_bio_lock);
+	spin_unlock(&blkg->async_bio_lock);
 
 	/* start plug only when bio_list contains at least 2 bios */
 	if (bios.head && bios.head->bi_next) {
@@ -1699,9 +1699,9 @@ void blkcg_punt_bio_submit(struct bio *bio)
 	struct blkcg_gq *blkg = bio->bi_blkg;
 
 	if (blkg->parent) {
-		spin_lock_bh(&blkg->async_bio_lock);
+		spin_lock(&blkg->async_bio_lock);
 		bio_list_add(&blkg->async_bios, bio);
-		spin_unlock_bh(&blkg->async_bio_lock);
+		spin_unlock(&blkg->async_bio_lock);
 		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
 	} else {
 		/* never bounce for the root cgroup */
-- 
2.39.2

