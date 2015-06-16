From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/4] kernfs: make kernfs_get_inode() public
Date: Tue, 16 Jun 2015 15:10:14 -0400
Message-ID: <1434481817-32001-2-git-send-email-tj@kernel.org>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6RBc3zzE/VrINnLTvVgpsxFaMbAIviach6pHoFme6Zw=;
        b=MHTMrWg9whGPb7iqSrZGSGJkJxHGVl6Ck9noi1/yl4ldyBo6dX1sL6JBYtE5e3h5HT
         IW5mVsEB+R73tfK4aTCxbgXJQ2L7bdg4U/03oe6w/BVjGvTN3rFEScxHemunplOnp1Yn
         aMvxqLD8nrjlSOju2wYYO6CRqHRNm0qUyRmaSmlOKHSUoHnWwfpuW5i13cksLz+w7mWy
         Q0IhbUm+UMpCQfTI1ylKjNHPAzrMffVMszG+TK/83CciGi6jRASf4oUCrnWHT1ffMfO5
         ooMvaoIa5I4bN+6MV0RX7r1jFwxn/lP3yEGygr3soUPyJKve0ovc/OrTp3eDH4ES5afg
         B3qg==
In-Reply-To: <1434481817-32001-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Move kernfs_get_inode() prototype from fs/kernfs/kernfs-internal.h to
include/linux/kernfs.h.  It obtains the matching inode for a
kernfs_node.

It will be used by cgroup for inode based permission checks for now
but is generally useful.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
Hello, Greg.

Given that cgroup will be the first and only, for now, user, I think
it'd be the eaiest to route this with the related cgroup patches
through the cgroup tree.  What do you think?

Thanks.

 fs/kernfs/kernfs-internal.h | 1 -
 include/linux/kernfs.h      | 5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index af9fa74..6762bfb 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -76,7 +76,6 @@ extern struct kmem_cache *kernfs_node_cache;
 /*
  * inode.c
  */
-struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn);
 void kernfs_evict_inode(struct inode *inode);
 int kernfs_iop_permission(struct inode *inode, int mask);
 int kernfs_iop_setattr(struct dentry *dentry, struct iattr *iattr);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 71ecdab..e6b2f7d 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -277,6 +277,7 @@ void kernfs_put(struct kernfs_node *kn);
 
 struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry);
 struct kernfs_root *kernfs_root_from_sb(struct super_block *sb);
+struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn);
 
 struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
 				       unsigned int flags, void *priv);
@@ -352,6 +353,10 @@ static inline struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry)
 static inline struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
 { return NULL; }
 
+static inline struct inode *
+kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
+{ return NULL; }
+
 static inline struct kernfs_root *
 kernfs_create_root(struct kernfs_syscall_ops *scops, unsigned int flags,
 		   void *priv)
-- 
2.4.3
