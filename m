From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] cgroup1: fix leaked context root causing sporadic NULL deref in LTP
Date: Wed, 16 Jun 2021 08:51:57 -0400
Message-ID: <20210616125157.438837-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqh9XlF7nA9T5POQEJ+2jE24qs2nVP5D6ZdsXxaFmjA=;
 b=E8pk3fBBfKcMd92egK4dJFIeXlfYWLHdOn0R6eAWoM+oDUH8VqKc78S+QVLkuV7Qq6kQdMfUIuOWEPdc9MCOPujNV9L3SH2D6FAp9VVJ//7oTbEOktyPl80yi/5TJ5avhkWNbCcKHXNgXjnFF7SiyRHxtOHfQNLPwfKBYlH2YgI=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>, Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org, Richard Purdie <richard.purdie@linuxfoundation.org>

Richard reported sporadic (roughly one in 10 or so) null dereferences and
other strange behaviour for a set of automated LTP tests.  Things like:

   BUG: kernel NULL pointer dereference, address: 0000000000000008
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 0 P4D 0
   Oops: 0000 [#1] PREEMPT SMP PTI
   CPU: 0 PID: 1516 Comm: umount Not tainted 5.10.0-yocto-standard #1
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
   RIP: 0010:kernfs_sop_show_path+0x1b/0x60

...or these others:

   RIP: 0010:do_mkdirat+0x6a/0xf0
   RIP: 0010:d_alloc_parallel+0x98/0x510
   RIP: 0010:do_readlinkat+0x86/0x120

There were other less common instances of some kind of a general scribble
but the common theme was mount and cgroup and a dubious dentry triggering
the NULL dereference.  I was only able to reproduce it under qemu by
replicating Richard's setup as closely as possible - I never did get it
to happen on bare metal, even while keeping everything else the same.

In commit 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
we see this as a part of the overall change:

   --------------
           struct cgroup_subsys *ss;
   -       struct dentry *dentry;

   [...]

   -       dentry = cgroup_do_mount(&cgroup_fs_type, fc->sb_flags, root,
   -                                CGROUP_SUPER_MAGIC, ns);

   [...]

   -       if (percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
   -               struct super_block *sb = dentry->d_sb;
   -               dput(dentry);
   +       ret = cgroup_do_mount(fc, CGROUP_SUPER_MAGIC, ns);
   +       if (!ret && percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
   +               struct super_block *sb = fc->root->d_sb;
   +               dput(fc->root);
                   deactivate_locked_super(sb);
                   msleep(10);
                   return restart_syscall();
           }
   --------------

In changing from the local "*dentry" variable to using fc->root, we now
export/leave that dentry pointer in the file context after doing the dput()
in the unlikely "is_dying" case.   With LTP doing a crazy amount of back to
back mount/unmount [testcases/bin/cgroup_regression_5_1.sh] the unlikely
becomes slightly likely and then bad things happen.

A fix would be to not leave the stale reference in fc->root as follows:

   --------------
                  dput(fc->root);
  +               fc->root = NULL;
                  deactivate_locked_super(sb);
   --------------

...but then we are just open-coding a duplicate of fc_drop_locked() so we
simply use that instead.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org      # v5.1+
Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Fixes: 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/fs/internal.h b/fs/internal.h
index 6aeae7ef3380..728f8d70d7f1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -61,7 +61,6 @@ extern void __init chrdev_init(void);
  */
 extern const struct fs_context_operations legacy_fs_context_ops;
 extern int parse_monolithic_mount_data(struct fs_context *, void *);
-extern void fc_drop_locked(struct fs_context *);
 extern void vfs_clean_context(struct fs_context *fc);
 extern int finish_clean_context(struct fs_context *fc);
 
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 37e1e8f7f08d..5b44b0195a28 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -139,6 +139,7 @@ extern int vfs_parse_fs_string(struct fs_context *fc, const char *key,
 extern int generic_parse_monolithic(struct fs_context *fc, void *data);
 extern int vfs_get_tree(struct fs_context *fc);
 extern void put_fs_context(struct fs_context *fc);
+extern void fc_drop_locked(struct fs_context *fc);
 
 /*
  * sget() wrappers to be called from the ->get_tree() op.
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 1f274d7fc934..6e554743cf2b 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1223,9 +1223,7 @@ int cgroup1_get_tree(struct fs_context *fc)
 		ret = cgroup_do_get_tree(fc);
 
 	if (!ret && percpu_ref_is_dying(&ctx->root->cgrp.self.refcnt)) {
-		struct super_block *sb = fc->root->d_sb;
-		dput(fc->root);
-		deactivate_locked_super(sb);
+		fc_drop_locked(fc);
 		ret = 1;
 	}
 
-- 
2.31.1

