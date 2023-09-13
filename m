From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 14/19] jffs2: convert to ->shutdown_sb and ->free_sb
Date: Wed, 13 Sep 2023 08:10:08 -0300
Message-ID: <20230913111013.77623-15-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=AwVUXcoXpUXwAjgKY+YMHBurOxH8fp8xakqCS5N8QOI=; b=tQeAokJJ8m0XmksMRtptFl8ZrW
        6Nom6PA+knKc6r3zg4W2KMC61HNnxlaQel6fkB1HrrRawRzpj0M2vmMWymFHxZopL1KDQnSJ22U5A
        Ow8kmT5tnVA86aSdIOqZfLkdy4Um0mUCoNALuvG5AqbRguzFlaFgGhQhRRopr604QlKgqzQKzCW5i
        6ZPKeGOFyLSHYmNqpfo99oZf3xJs34VDYnSiA3E8zNPES+89u4ecfTrDYhf1lDxZiXSmDagrKT8Ad
        fyPmeFZghP6slRpc1RhK91m65VkoFrK8jVEe0jyJ6QJqD4oF6dovad5lpUbyEsuC1cydeEOELenjv
        u4xvPPqg==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert jffs2 from ->kill_sb to ->shutdown_sb and ->free_sb.  Drop
the otherwise unused kill_mtd_super helpers, as there is no benefit in
it over just calling put_mtd_device on sb->s_mtd.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/mtd/mtdsuper.c    | 12 ------------
 fs/jffs2/super.c          | 22 ++++++++++++++--------
 include/linux/mtd/super.h |  2 --
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index b7e3763c47f0cd..66da2e6f90f5f5 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -165,15 +165,3 @@ int get_tree_mtd(struct fs_context *fc,
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(get_tree_mtd);
-
-/*
- * destroy an MTD-based superblock
- */
-void kill_mtd_super(struct super_block *sb)
-{
-	generic_shutdown_super(sb);
-	put_mtd_device(sb->s_mtd);
-	sb->s_mtd = NULL;
-}
-
-EXPORT_SYMBOL_GPL(kill_mtd_super);
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 7ea37f49f1e18e..14577368202e90 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -340,21 +340,27 @@ static void jffs2_put_super (struct super_block *sb)
 	jffs2_dbg(1, "%s(): returning\n", __func__);
 }
 
-static void jffs2_kill_sb(struct super_block *sb)
+static void jffs2_shutdown_sb(struct super_block *sb)
 {
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
+
 	if (c && !sb_rdonly(sb))
 		jffs2_stop_garbage_collect_thread(c);
-	kill_mtd_super(sb);
-	kfree(c);
+}
+
+static void jffs2_free_sb(struct super_block *sb)
+{
+	put_mtd_device(sb->s_mtd);
+	kfree(JFFS2_SB_INFO(sb));
 }
 
 static struct file_system_type jffs2_fs_type = {
-	.owner =	THIS_MODULE,
-	.name =		"jffs2",
-	.init_fs_context = jffs2_init_fs_context,
-	.parameters =	jffs2_fs_parameters,
-	.kill_sb =	jffs2_kill_sb,
+	.owner			= THIS_MODULE,
+	.name			= "jffs2",
+	.init_fs_context	= jffs2_init_fs_context,
+	.parameters		= jffs2_fs_parameters,
+	.shutdown_sb		= jffs2_shutdown_sb,
+	.free_sb		= jffs2_free_sb,
 };
 MODULE_ALIAS_FS("jffs2");
 
diff --git a/include/linux/mtd/super.h b/include/linux/mtd/super.h
index 3608a6c36faceb..f6d5c1a17eec23 100644
--- a/include/linux/mtd/super.h
+++ b/include/linux/mtd/super.h
@@ -17,8 +17,6 @@
 extern int get_tree_mtd(struct fs_context *fc,
 		     int (*fill_super)(struct super_block *sb,
 				       struct fs_context *fc));
-extern void kill_mtd_super(struct super_block *sb);
-
 
 #endif /* __KERNEL__ */
 
-- 
2.39.2

