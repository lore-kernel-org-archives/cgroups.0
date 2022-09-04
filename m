From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2 cgroup/for-6.1] cgroup: Improve cftype add/rm error
 handling
Date: Sun, 4 Sep 2022 11:09:53 -1000
Message-ID: <YxUUISLVLEIRBwEY@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date;
        bh=RrHh9O6PhzAN31NW2y2ora7UtS8+X9Q/3gVI7YIt4sI=;
        b=Es/XHRaQSNag8OoZiPCnqwQgmvL8hUgaGZoHJIoW5bYrllYQf7FBUBrF+wy9JBPDMY
         Z9aCYBRqT/GJ1Prc/KY65W+T+F0dkO7pTVmzJE+wVwfpzr7Gl7MJeEWffwL/bX4PLDWS
         G+oaZ6izK24lKQEcLKDZwqhiiarpnc9gomBCVJPFia3q7q8Hb/sU9MEmM72Qa6kriNqH
         IhHC96/q/5HQDZIVTPY4D1NgQjDNUlRSxoseQOUAIDUQ7rldP34ws/nQMLvfojE0tMXr
         OeOaoliBcxA3VFafiJGY77Bwx+4IBgHMCLkY0I8wX9Yy1vARGzXlcYT00uL6atMMKZIt
         jUcQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Let's track whether a cftype is currently added or not using a new flag
__CFTYPE_ADDED so that duplicate operations can be failed safely and
consistently allow using empty cftypes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hello,

If no one objects, imma apply these two cgroup file handling cleanup patches
to cgroup/for-6.1 in a few days.

Thanks.

 include/linux/cgroup-defs.h |    1 +
 kernel/cgroup/cgroup.c      |   27 ++++++++++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -131,6 +131,7 @@ enum {
 	/* internal flags, do not use outside cgroup core proper */
 	__CFTYPE_ONLY_ON_DFL	= (1 << 16),	/* only on default hierarchy */
 	__CFTYPE_NOT_ON_DFL	= (1 << 17),	/* not on default hierarchy */
+	__CFTYPE_ADDED		= (1 << 18),
 };
 
 /*
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4166,19 +4166,26 @@ static void cgroup_exit_cftypes(struct c
 		cft->ss = NULL;
 
 		/* revert flags set by cgroup core while adding @cfts */
-		cft->flags &= ~(__CFTYPE_ONLY_ON_DFL | __CFTYPE_NOT_ON_DFL);
+		cft->flags &= ~(__CFTYPE_ONLY_ON_DFL | __CFTYPE_NOT_ON_DFL |
+				__CFTYPE_ADDED);
 	}
 }
 
 static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype *cft;
+	int ret = 0;
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
 		struct kernfs_ops *kf_ops;
 
 		WARN_ON(cft->ss || cft->kf_ops);
 
+		if (cft->flags & __CFTYPE_ADDED) {
+			ret = -EBUSY;
+			break;
+		}
+
 		if ((cft->flags & CFTYPE_PRESSURE) && !cgroup_psi_enabled())
 			continue;
 
@@ -4194,26 +4201,26 @@ static int cgroup_init_cftypes(struct cg
 		if (cft->max_write_len && cft->max_write_len != PAGE_SIZE) {
 			kf_ops = kmemdup(kf_ops, sizeof(*kf_ops), GFP_KERNEL);
 			if (!kf_ops) {
-				cgroup_exit_cftypes(cfts);
-				return -ENOMEM;
+				ret = -ENOMEM;
+				break;
 			}
 			kf_ops->atomic_write_len = cft->max_write_len;
 		}
 
 		cft->kf_ops = kf_ops;
 		cft->ss = ss;
+		cft->flags |= __CFTYPE_ADDED;
 	}
 
-	return 0;
+	if (ret)
+		cgroup_exit_cftypes(cfts);
+	return ret;
 }
 
 static int cgroup_rm_cftypes_locked(struct cftype *cfts)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (!cfts || !cfts[0].ss)
-		return -ENOENT;
-
 	list_del(&cfts->node);
 	cgroup_apply_cftypes(cfts, false);
 	cgroup_exit_cftypes(cfts);
@@ -4235,6 +4242,12 @@ int cgroup_rm_cftypes(struct cftype *cft
 {
 	int ret;
 
+	if (!cfts || cfts[0].name[0] == '\0')
+		return 0;
+
+	if (!(cfts[0].flags & __CFTYPE_ADDED))
+		return -ENOENT;
+
 	mutex_lock(&cgroup_mutex);
 	ret = cgroup_rm_cftypes_locked(cfts);
 	mutex_unlock(&cgroup_mutex);
