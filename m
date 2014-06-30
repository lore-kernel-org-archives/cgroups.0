From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/3] kernfs: introduce kernfs_pin_sb()
Date: Mon, 30 Jun 2014 10:19:06 -0400
Message-ID: <20140630141906.GB14807@htj.dyndns.org>
References: <53B0DE66.5080100@huawei.com>
 <53B0DE84.40206@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uD0BTCdPQmALMMahH+F7RfKMz79icNkRtyUYJQ9qVzQ=;
        b=C0xlOuKsBZd4BfhmqKCVTnCCinRfxRi8sfvnM6CS7HYh/KLWvp180ZS89t7KcFb0J6
         u4MTbNQkvxzGsCXJVNmVUE+FyTkjGsIyBvIEOlvMQ2dc6awTKDHnBraocXvdMyEnfNgT
         LNPlXu75xov46pLmHgoguRoCFU8mevHIIsMeXFgo0fzaacMGshq/vIU63ro663gS6W7J
         US4i/FDpwLXHZdqfxtrTFRZC8oWK9ylqiG8+6bRNOF+V3hHSuJPn3Q7mdkhm03QhDLQo
         IdbO2YwBOGBuK0fnJBQWrzwFhCXLtvrIrl6GQoljtkdRGnDkJZQfAzzU4a4GKFW4yP2J
         wAPg==
Content-Disposition: inline
In-Reply-To: <53B0DE84.40206-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Applied to cgroup/for-3.16-fixes with minor updates.  Thanks.
------ 8< ------
From 4e26445faad366d67d7723622bf6a60a6f0f5993 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Mon, 30 Jun 2014 11:50:28 +0800
Subject: [PATCH 2/3] kernfs: introduce kernfs_pin_sb()

kernfs_pin_sb() tries to get a refcnt of the superblock.

This will be used by cgroupfs.

v2:
- make kernfs_pin_sb() return the superblock.
- drop kernfs_drop_sb().

tj: Updated the comment a bit.

[ This is a prerequisite for a bugfix. ]
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.15
Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/kernfs/mount.c      | 30 ++++++++++++++++++++++++++++++
 include/linux/kernfs.h |  1 +
 2 files changed, 31 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index d171b98..f973ae9 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -211,6 +211,36 @@ void kernfs_kill_sb(struct super_block *sb)
 	kernfs_put(root_kn);
 }
 
+/**
+ * kernfs_pin_sb: try to pin the superblock associated with a kernfs_root
+ * @kernfs_root: the kernfs_root in question
+ * @ns: the namespace tag
+ *
+ * Pin the superblock so the superblock won't be destroyed in subsequent
+ * operations.  This can be used to block ->kill_sb() which may be useful
+ * for kernfs users which dynamically manage superblocks.
+ *
+ * Returns NULL if there's no superblock associated to this kernfs_root, or
+ * -EINVAL if the superblock is being freed.
+ */
+struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns)
+{
+	struct kernfs_super_info *info;
+	struct super_block *sb = NULL;
+
+	mutex_lock(&kernfs_mutex);
+	list_for_each_entry(info, &root->supers, node) {
+		if (info->ns == ns) {
+			sb = info->sb;
+			if (!atomic_inc_not_zero(&info->sb->s_active))
+				sb = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	mutex_unlock(&kernfs_mutex);
+	return sb;
+}
+
 void __init kernfs_init(void)
 {
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 17aa1cc..20f4935 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -304,6 +304,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 			       struct kernfs_root *root, unsigned long magic,
 			       bool *new_sb_created, const void *ns);
 void kernfs_kill_sb(struct super_block *sb);
+struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns);
 
 void kernfs_init(void);
 
-- 
1.9.3
