From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v3 1/5] fs: kernfs: add poll file operation
Date: Thu, 24 Jan 2019 13:15:14 -0800
Message-ID: <20190124211518.244221-2-surenb@google.com>
References: <20190124211518.244221-1-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ucF1EwcLVxCtpPOBrQuqUFcO6ME+3ZXcCq84fU7zCQU=;
        b=gygzfM8DMwdV2iIuQLyTUNZoqz3zBV3YtlUapmjclo6FC0Cojxkyvg4NivMng9lbsQ
         UWdyeeLEfhPEp8uDGJi7V+xJ1r8fLv7cSF3AgCBMzvurwt/n6qyU4ar7Cg9qTtZeIxbU
         J6YSkeKSSK0UPNMIulk/GIHII8GRmfVYhpB65NdU5mVAAkC5EC5Z9ITK8S75A88PP/rM
         YCmvpjQontE64hJ0camuKp/QHj5ID+XU4FRhNKvHB2zo3jpM7bZb6q/XuMvwwy6vaDwK
         BPTQ0nG+MGuEYAZ0eOa1zCAzJnqN3qOecuomYBNuInO5ONQIFkVFx7A78idtIZ3d2iHh
         EAXA==
In-Reply-To: <20190124211518.244221-1-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>

From: Johannes Weiner <hannes@cmpxchg.org>

Kernfs has a standardized poll/notification mechanism for waking all
pollers on all fds when a filesystem node changes. To allow polling
for custom events, add a .poll callback that can override the default.

This is in preparation for pollable cgroup pressure files which have
per-fd trigger configurations.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/kernfs/file.c       | 31 ++++++++++++++++++++-----------
 include/linux/kernfs.h |  6 ++++++
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index f8d5021a652e..ae948aaa4c53 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -832,26 +832,35 @@ void kernfs_drain_open_files(struct kernfs_node *kn)
  * to see if it supports poll (Neither 'poll' nor 'select' return
  * an appropriate error code).  When in doubt, set a suitable timeout value.
  */
+__poll_t kernfs_generic_poll(struct kernfs_open_file *of, poll_table *wait)
+{
+	struct kernfs_node *kn = kernfs_dentry_node(of->file->f_path.dentry);
+	struct kernfs_open_node *on = kn->attr.open;
+
+	poll_wait(of->file, &on->poll, wait);
+
+	if (of->event != atomic_read(&on->event))
+		return DEFAULT_POLLMASK|EPOLLERR|EPOLLPRI;
+
+	return DEFAULT_POLLMASK;
+}
+
 static __poll_t kernfs_fop_poll(struct file *filp, poll_table *wait)
 {
 	struct kernfs_open_file *of = kernfs_of(filp);
 	struct kernfs_node *kn = kernfs_dentry_node(filp->f_path.dentry);
-	struct kernfs_open_node *on = kn->attr.open;
+	__poll_t ret;
 
 	if (!kernfs_get_active(kn))
-		goto trigger;
+		return DEFAULT_POLLMASK|EPOLLERR|EPOLLPRI;
 
-	poll_wait(filp, &on->poll, wait);
+	if (kn->attr.ops->poll)
+		ret = kn->attr.ops->poll(of, wait);
+	else
+		ret = kernfs_generic_poll(of, wait);
 
 	kernfs_put_active(kn);
-
-	if (of->event != atomic_read(&on->event))
-		goto trigger;
-
-	return DEFAULT_POLLMASK;
-
- trigger:
-	return DEFAULT_POLLMASK|EPOLLERR|EPOLLPRI;
+	return ret;
 }
 
 static void kernfs_notify_workfn(struct work_struct *work)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 5b36b1287a5a..0cac1207bb00 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -25,6 +25,7 @@ struct seq_file;
 struct vm_area_struct;
 struct super_block;
 struct file_system_type;
+struct poll_table_struct;
 
 struct kernfs_open_node;
 struct kernfs_iattrs;
@@ -261,6 +262,9 @@ struct kernfs_ops {
 	ssize_t (*write)(struct kernfs_open_file *of, char *buf, size_t bytes,
 			 loff_t off);
 
+	__poll_t (*poll)(struct kernfs_open_file *of,
+			 struct poll_table_struct *pt);
+
 	int (*mmap)(struct kernfs_open_file *of, struct vm_area_struct *vma);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -350,6 +354,8 @@ int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		     const char *new_name, const void *new_ns);
 int kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr);
+__poll_t kernfs_generic_poll(struct kernfs_open_file *of,
+			     struct poll_table_struct *pt);
 void kernfs_notify(struct kernfs_node *kn);
 
 const void *kernfs_super_ns(struct super_block *sb);
-- 
2.20.1.321.g9e740568ce-goog

