From: 'Tejun Heo' <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] Revert "cgroup: superblock can't be released with
 active dentries"
Date: Sat, 7 Jul 2012 16:46:34 -0700
Message-ID: <20120707234634.GC16783@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED@mx.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TzhXnhhBlsUVW/K5QRhRwAMivkgZIM0Xklu17hI7lhA=;
        b=N1uxE2xVBJqMqq6ixI4M7C17PJghrD2pF9QMmlsoLA5KLwFSohvoIwAUOwrnIi402y
         hylACc+418MTC054IhzH5TRFbJb+5boB5/kBYxwvSw7qncuk58qTVfH8hHqjy77Awsb2
         USF0qdQzsPSJPaFmTfTuwltZcNNwEz3MV/l1QCn7Zj8ehboxMLAH5rE8q9LRQk621MgQ
         mSNJRfS7nSMZHnpVV1EAw/JaY9iY3g9heEEIruwknkuFmxz6CoDbx9wAjk3fu7EwX3JL
         ZAah2nCTssrKqOEHcPJv2A2nTBKaaXFv6XMzXr1uFudOMIpWzjeiqKFsDxqdxQN1oo2b
         Dy/g==
Content-Disposition: inline
In-Reply-To: <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shyju PV <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: 'Li Zefan' <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Sanil kumar' <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Masanari Iida' <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Cgroups' <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nagamani.mantha-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From 7db5b3ca0ecdb2e8fad52a4770e4e320e61c77a6 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Sat, 7 Jul 2012 15:55:47 -0700

This reverts commit fa980ca87d15bb8a1317853f257a505990f3ffde.  The
commit was an attempt to fix a race condition where a cgroup hierarchy
may be unmounted with positive dentry reference on root cgroup.  While
the commit made the race condition slightly more difficult to trigger,
the race was still there and could be reliably triggered using a
different test case.

Revert the incorrect fix.  The next commit will describe the race and
fix it correctly.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
LKML-Reference: <4FEEA5CB.8070809-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reported-by: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Sorry about the delay.  Was on vacation.  Will soon push these two
patches to Linus.

(Shyju, didn't realize I was replying to private reply, resending)

Thanks.

 kernel/cgroup.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2097684..5f134a0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -901,13 +901,10 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		mutex_unlock(&cgroup_mutex);
 
 		/*
-		 * We want to drop the active superblock reference from the
-		 * cgroup creation after all the dentry refs are gone -
-		 * kill_sb gets mighty unhappy otherwise.  Mark
-		 * dentry->d_fsdata with cgroup_diput() to tell
-		 * cgroup_d_release() to call deactivate_super().
+		 * Drop the active superblock reference that we took when we
+		 * created the cgroup
 		 */
-		dentry->d_fsdata = cgroup_diput;
+		deactivate_super(cgrp->root->sb);
 
 		/*
 		 * if we're getting rid of the cgroup, refcount should ensure
@@ -933,13 +930,6 @@ static int cgroup_delete(const struct dentry *d)
 	return 1;
 }
 
-static void cgroup_d_release(struct dentry *dentry)
-{
-	/* did cgroup_diput() tell me to deactivate super? */
-	if (dentry->d_fsdata == cgroup_diput)
-		deactivate_super(dentry->d_sb);
-}
-
 static void remove_dir(struct dentry *d)
 {
 	struct dentry *parent = dget(d->d_parent);
@@ -1547,7 +1537,6 @@ static int cgroup_get_rootdir(struct super_block *sb)
 	static const struct dentry_operations cgroup_dops = {
 		.d_iput = cgroup_diput,
 		.d_delete = cgroup_delete,
-		.d_release = cgroup_d_release,
 	};
 
 	struct inode *inode =
-- 
1.7.7.3
