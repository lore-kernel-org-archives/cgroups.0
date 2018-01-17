From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 87/99] btrfs: Convert reada_extents to XArray
Date: Wed, 17 Jan 2018 12:21:51 -0800
Message-ID: <20180117202203.19756-88-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=UT4reEabBwlrAlD/B4VqBTYh03oxqYSFRm+m3GdzRt0=; b=G7iW+sEWrShg9Ka5i7Zrfmt8A
	wXz2g7Kq/U3+fK+aQ4514AiTjj2AwJ57v3dcl/HcdwjtFLZsjYvTdvSvYvQjeM5QTywBVWuhp2qu8
	pd7EVv2fF3FWaJ27gdLLGLOpcGm4iklUzzOUGfBVZx0XW9Pa2+ssbYuTIFF/2IsBFNzhSEPrX1Qtf
	+BXIqxQ3hiZvHHZSLqeMBzWKfuLlfrdQ14kkNvGJBfc707UV77zMDWXDs5sFMXR8w7qhlZhAqjKdN
	aILE67S/MdP2OWPyDUjwpDKpnq5XeEYcl9PkPAE50oOMkUCio/a4zfEKoP6xafZJJzzrE2AtUyPxv
	if8Xdg/qQ==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/btrfs/reada.c   | 32 +++++++++++++++++---------------
 fs/btrfs/volumes.c |  2 +-
 fs/btrfs/volumes.h |  2 +-
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index ef8e84ff2012..8100f1565250 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -438,13 +438,14 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 			continue;
 		}
 		prev_dev = dev;
-		ret = radix_tree_insert(&dev->reada_extents, index, re);
+		ret = xa_insert(&dev->reada_extents, index, re,
+					GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 		if (ret) {
 			while (--nzones >= 0) {
 				dev = re->zones[nzones]->device;
 				BUG_ON(dev == NULL);
 				/* ignore whether the entry was inserted */
-				radix_tree_delete(&dev->reada_extents, index);
+				xa_erase(&dev->reada_extents, index);
 			}
 			radix_tree_delete(&fs_info->reada_tree, index);
 			spin_unlock(&fs_info->reada_lock);
@@ -504,7 +505,7 @@ static void reada_extent_put(struct btrfs_fs_info *fs_info,
 	for (i = 0; i < re->nzones; ++i) {
 		struct reada_zone *zone = re->zones[i];
 
-		radix_tree_delete(&zone->device->reada_extents, index);
+		xa_erase(&zone->device->reada_extents, index);
 	}
 
 	spin_unlock(&fs_info->reada_lock);
@@ -644,6 +645,7 @@ static int reada_start_machine_dev(struct btrfs_device *dev)
 	int mirror_num = 0;
 	struct extent_buffer *eb = NULL;
 	u64 logical;
+	unsigned long index;
 	int ret;
 	int i;
 
@@ -660,19 +662,19 @@ static int reada_start_machine_dev(struct btrfs_device *dev)
 	 * a contiguous block of extents, we could also coagulate them or use
 	 * plugging to speed things up
 	 */
-	ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
-				     dev->reada_next >> PAGE_SHIFT, 1);
-	if (ret == 0 || re->logical > dev->reada_curr_zone->end) {
+	index = dev->reada_next >> PAGE_SHIFT;
+	re = xa_find(&dev->reada_extents, &index, ULONG_MAX, XA_PRESENT);
+	if (!re || re->logical > dev->reada_curr_zone->end) {
 		ret = reada_pick_zone(dev);
 		if (!ret) {
 			spin_unlock(&fs_info->reada_lock);
 			return 0;
 		}
-		re = NULL;
-		ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
-					dev->reada_next >> PAGE_SHIFT, 1);
+		index = dev->reada_next >> PAGE_SHIFT;
+		re = xa_find(&dev->reada_extents, &index, ULONG_MAX,
+								XA_PRESENT);
 	}
-	if (ret == 0) {
+	if (!re) {
 		spin_unlock(&fs_info->reada_lock);
 		return 0;
 	}
@@ -828,11 +830,11 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 		cnt = 0;
 		index = 0;
 		while (all) {
-			struct reada_extent *re = NULL;
+			struct reada_extent *re;
 
-			ret = radix_tree_gang_lookup(&device->reada_extents,
-						     (void **)&re, index, 1);
-			if (ret == 0)
+			re = xa_find(&device->reada_extents, &index, ULONG_MAX,
+								XA_PRESENT);
+			if (!re)
 				break;
 			pr_debug("  re: logical %llu size %u empty %d scheduled %d",
 				re->logical, fs_info->nodesize,
@@ -848,7 +850,7 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 				}
 			}
 			pr_cont("\n");
-			index = (re->logical >> PAGE_SHIFT) + 1;
+			index++;
 			if (++cnt > 15)
 				break;
 		}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8e683799b436..304c2ef4c557 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -248,7 +248,7 @@ static struct btrfs_device *__alloc_device(void)
 	atomic_set(&dev->dev_stats_ccnt, 0);
 	btrfs_device_data_ordered_init(dev);
 	xa_init(&dev->reada_zones);
-	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
+	xa_init(&dev->reada_extents);
 
 	return dev;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index aeabe03d3e44..0e0c04e2613c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -140,7 +140,7 @@ struct btrfs_device {
 	u64 reada_next;
 	struct reada_zone *reada_curr_zone;
 	struct xarray reada_zones;
-	struct radix_tree_root reada_extents;
+	struct xarray reada_extents;
 
 	/* disk I/O failure stats. For detailed description refer to
 	 * enum btrfs_dev_stat_values in ioctl.h */
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
