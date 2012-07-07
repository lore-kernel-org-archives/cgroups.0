From: 'Tejun Heo' <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] cgroup: fix cgroup hierarchy umount race
Date: Sat, 7 Jul 2012 16:46:59 -0700
Message-ID: <20120707234659.GD16783@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED@mx.google.com>
 <20120707234634.GC16783@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ABNddMwk2ZkH5Nx3K7weS2r6QnGHfcWwrWn5/+57SGE=;
        b=CfFnARakww77pUKB56ZqgNTvSFGtPRywwSrYFFxaHCY9rPzfFwC18jS5jAUB8q9WWy
         WAuGdUU3emoQRJ63L3hT4VHQYncWrhG/lbNyqUAENr6Vu5ae5s0LQAL63cv5Pi+HTs8d
         7Qx2CPqlQeVsC18U5Nlv2caoDqcq2XPJws0z/npvleIQbCo9WmZI1l6UeMmw3g4OwoHo
         1oN0iGNIr4YJNg7R7tHCtzfrnSIB7Y1T4gj8WVc7dGvVkcdjHUHMnt3lxFwx943Is0m8
         1FXAX/Ip3kFmKPh1cZyUv79i3Co6emW+rGRTf55on9VtAvp+7ftogicOn3ilTsPgwbt5
         E9Ew==
Content-Disposition: inline
In-Reply-To: <20120707234634.GC16783-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shyju PV <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: 'Li Zefan' <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Sanil kumar' <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Masanari Iida' <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Cgroups' <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nagamani.mantha-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From 5db9a4d99b0157a513944e9a44d29c9cec2e91dc Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Sat, 7 Jul 2012 16:08:18 -0700

48ddbe1946 "cgroup: make css->refcnt clearing on cgroup removal
optional" allowed a css to linger after the associated cgroup is
removed.  As a css holds a reference on the cgroup's dentry, it means
that cgroup dentries may linger for a while.

Destroying a superblock which has dentries with positive refcnts is a
critical bug and triggers BUG() in vfs code.  As each cgroup dentry
holds an s_active reference, any lingering cgroup has both its dentry
and the superblock pinned and thus preventing premature release of
superblock.

Unfortunately, after 48ddbe1946, there's a small window while
releasing a cgroup which is directly under the root of the hierarchy.
When a cgroup directory is released, vfs layer first deletes the
corresponding dentry and then invokes dput() on the parent, which may
recurse further, so when a cgroup directly below root cgroup is
released, the cgroup is first destroyed - which releases the s_active
it was holding - and then the dentry for the root cgroup is dput().

This creates a window where the root dentry's refcnt isn't zero but
superblock's s_active is.  If umount happens before or during this
window, vfs will see the root dentry with non-zero refcnt and trigger
BUG().

Before 48ddbe1946, this problem didn't exist because the last dentry
reference was guaranteed to be put synchronously from rmdir(2)
invocation which holds s_active around the whole process.

Fix it by holding an extra superblock->s_active reference across
dput() from css release, which is the dput() path added by 48ddbe1946
and the only one which doesn't hold an extra s_active ref across the
final cgroup dput().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
LKML-Reference: <4FEEA5CB.8070809-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reported-by: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Tested-by: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5f134a0..b303dfc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3883,8 +3883,12 @@ static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
+	struct dentry *dentry = css->cgroup->dentry;
+	struct super_block *sb = dentry->d_sb;
 
-	dput(css->cgroup->dentry);
+	atomic_inc(&sb->s_active);
+	dput(dentry);
+	deactivate_super(sb);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
-- 
1.7.7.3
