From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v6 91/99] btrfs: Convert name_cache to XArray
Date: Wed, 17 Jan 2018 12:21:55 -0800
Message-ID: <20180117202203.19756-92-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IPMtOo9O6zePGjdzwMm0QriyABbJsEyfkDbEY7J63AE=; b=U2iKR1zx1AWPgk9mfBSBnzI60
        r4EyiRwmoL5DVss7Y1C7f4N4t+fdWXizui/c3eQoSIziPE9ptTRQBUN8Jc0sgfgwjPsN3+aMx7zoz
        VwGou8JjMjhnSb+tABYq1IcUUey1KHbdkSfwu2+qtsY2ZJu25aGEfnbmo/JmfCS46tHyIvrkZUIrC
        tdbJjEuihYBGUp6krlpRCvTX2aQH/zFHu0xZlqwT4Noy+xJF1ikjwwzon623v+iZNmFRbh6p5EEO9
        QGEiAlSJofqSz+13Na6CveQWj3dzXBYO19Q0qWBSwwe8bsMIbEZ++5Gff9tXbKRh7MNfuzfZo00e1
    
In-Reply-To: <20180117202203.19756-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

This is a very straightforward conversion.  The handling of collisions
in the namecache could be better handled with an hlist, but that's a
patch for another day.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/btrfs/send.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 20d3300bd268..3891a8e958fa 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -23,7 +23,7 @@
 #include <linux/mount.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl_xattr.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
 #include <linux/compat.h>
@@ -118,7 +118,7 @@ struct send_ctx {
 	struct list_head new_refs;
 	struct list_head deleted_refs;
 
-	struct radix_tree_root name_cache;
+	struct xarray name_cache;
 	struct list_head name_cache_list;
 	int name_cache_size;
 
@@ -2021,8 +2021,7 @@ static int name_cache_insert(struct send_ctx *sctx,
 	int ret = 0;
 	struct list_head *nce_head;
 
-	nce_head = radix_tree_lookup(&sctx->name_cache,
-			(unsigned long)nce->ino);
+	nce_head = xa_load(&sctx->name_cache, (unsigned long)nce->ino);
 	if (!nce_head) {
 		nce_head = kmalloc(sizeof(*nce_head), GFP_KERNEL);
 		if (!nce_head) {
@@ -2031,7 +2030,8 @@ static int name_cache_insert(struct send_ctx *sctx,
 		}
 		INIT_LIST_HEAD(nce_head);
 
-		ret = radix_tree_insert(&sctx->name_cache, nce->ino, nce_head);
+		ret = xa_insert(&sctx->name_cache, nce->ino, nce_head,
+								GFP_KERNEL);
 		if (ret < 0) {
 			kfree(nce_head);
 			kfree(nce);
@@ -2050,8 +2050,7 @@ static void name_cache_delete(struct send_ctx *sctx,
 {
 	struct list_head *nce_head;
 
-	nce_head = radix_tree_lookup(&sctx->name_cache,
-			(unsigned long)nce->ino);
+	nce_head = xa_load(&sctx->name_cache, (unsigned long)nce->ino);
 	if (!nce_head) {
 		btrfs_err(sctx->send_root->fs_info,
 	      "name_cache_delete lookup failed ino %llu cache size %d, leaking memory",
@@ -2066,7 +2065,7 @@ static void name_cache_delete(struct send_ctx *sctx,
 	 * We may not get to the final release of nce_head if the lookup fails
 	 */
 	if (nce_head && list_empty(nce_head)) {
-		radix_tree_delete(&sctx->name_cache, (unsigned long)nce->ino);
+		xa_erase(&sctx->name_cache, (unsigned long)nce->ino);
 		kfree(nce_head);
 	}
 }
@@ -2077,7 +2076,7 @@ static struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
 	struct list_head *nce_head;
 	struct name_cache_entry *cur;
 
-	nce_head = radix_tree_lookup(&sctx->name_cache, (unsigned long)ino);
+	nce_head = xa_load(&sctx->name_cache, (unsigned long)ino);
 	if (!nce_head)
 		return NULL;
 
@@ -6526,7 +6525,7 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 
 	INIT_LIST_HEAD(&sctx->new_refs);
 	INIT_LIST_HEAD(&sctx->deleted_refs);
-	INIT_RADIX_TREE(&sctx->name_cache, GFP_KERNEL);
+	xa_init(&sctx->name_cache);
 	INIT_LIST_HEAD(&sctx->name_cache_list);
 
 	sctx->flags = arg->flags;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
