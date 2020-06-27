From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/14] block: remove bio_disassociate_blkg
Date: Sat, 27 Jun 2020 09:31:47 +0200
Message-ID: <20200627073159.2447325-3-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TqBMh8wKMnVF/qZj/bM6cnnHs8Yim2J3gFC2ELItu+s=; b=C+ZyH4XC/PkkkGo8OrL4qvcn92
        TnizwBndOG4NHHJpYFLRpu8LYRZqZAN2x6fPq3HSY0c0038FlIUnkfpTHi3Qt2VhrxPFglng/X4Cc
        aZdSwTUR1u/eINbQC2X9UvbpnjV1m7wgCSeWJCDjROxe87fuIzT0EQqaXmxcSmrm4yq1F+bzu8VUN
        1HvaMG5Z4RE93Payt3MIpxhHccumVWuOutqXqy60zCifApzwCB2YgfFIETkyIrT0uDpmMHAqwsDmS
        jmmV+CbyN7d3VFXs3yi5MBQmvswTJ9K17V+dHSM5wowN9H+wv4o0R17ejZHH5EoXtFjTRlYlOK53+
        nUeLzM7Q==;
In-Reply-To: <20200627073159.2447325-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

bio_disassociate_blkg has two callers, of which one immediately assigns
a new value to >bi_blkg.  Just open code the function in the two callers.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/bio.c         | 27 ++++++++-------------------
 include/linux/bio.h |  2 --
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index fb5533416fa670..8aef4460b32e0e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -234,8 +234,12 @@ struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 
 void bio_uninit(struct bio *bio)
 {
-	bio_disassociate_blkg(bio);
-
+#ifdef CONFIG_BLK_CGROUP
+	if (bio->bi_blkg) {
+		blkg_put(bio->bi_blkg);
+		bio->bi_blkg = NULL;
+	}
+#endif
 	if (bio_integrity(bio))
 		bio_integrity_free(bio);
 
@@ -1625,21 +1629,6 @@ EXPORT_SYMBOL(bioset_init_from_src);
 
 #ifdef CONFIG_BLK_CGROUP
 
-/**
- * bio_disassociate_blkg - puts back the blkg reference if associated
- * @bio: target bio
- *
- * Helper to disassociate the blkg from @bio if a blkg is associated.
- */
-void bio_disassociate_blkg(struct bio *bio)
-{
-	if (bio->bi_blkg) {
-		blkg_put(bio->bi_blkg);
-		bio->bi_blkg = NULL;
-	}
-}
-EXPORT_SYMBOL_GPL(bio_disassociate_blkg);
-
 /**
  * __bio_associate_blkg - associate a bio with the a blkg
  * @bio: target bio
@@ -1656,8 +1645,8 @@ EXPORT_SYMBOL_GPL(bio_disassociate_blkg);
  */
 static void __bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 {
-	bio_disassociate_blkg(bio);
-
+	if (bio->bi_blkg)
+		blkg_put(bio->bi_blkg);
 	bio->bi_blkg = blkg_tryget_closest(blkg);
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0282f8aa85935c..4cd229e175c058 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -497,13 +497,11 @@ static inline void bio_associate_blkg_from_page(struct bio *bio,
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
-void bio_disassociate_blkg(struct bio *bio);
 void bio_associate_blkg(struct bio *bio);
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css);
 void bio_clone_blkg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
-static inline void bio_disassociate_blkg(struct bio *bio) { }
 static inline void bio_associate_blkg(struct bio *bio) { }
 static inline void bio_associate_blkg_from_css(struct bio *bio,
 					       struct cgroup_subsys_state *css)
-- 
2.26.2

