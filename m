From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/14] cgroup: use CSS_ONLINE instead of CGRP_DEAD
Date: Fri,  9 May 2014 17:31:28 -0400
Message-ID: <1399671091-23867-12-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IuIXuhzc0/TTqD2+3ZncwUTgy2AQY8znlYFSH9uGcec=;
        b=InBxyMQ/RaHBoKmoQCg/MBssnTMrJ9Ivnw4xfuYdtvmwuxFCT02SOUv8vzu4PxUgc1
         +Bpif7ZYWtmheecaJmRxB9zhiAlCpVM796NwoB9ejWGFsgUtY+X+zQehgs1a3DseN5bK
         Zhv0vqBxrht2P13nGJUe6J8jIur4KoiNX5J3JgKd4d/pXP9/SZWT3DUhMuem9mBeSHdX
         8UOcSutNeNApBH8ZPT4bFg6nnFU1WulwXZwiGxwmTAVoONmW4KZyw/pkDAR0YDCpV7ii
         KvgWUwmumxpb/KKljrBJsh0F31qREM3Ez479OqwNHLc6Ly0JGqRd/0s1UgQzyqb4Lezu
         diOQ==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>

Use CSS_ONLINE on the self css to indicate whether a cgroup has been
killed instead of CGRP_DEAD.  This will allow re-using css online test
for cgroup liveliness test.  This doesn't introduce any functional
change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 2 --
 kernel/cgroup.c        | 7 ++++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 58867ed..2cf2063 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -138,8 +138,6 @@ static inline void css_put(struct cgroup_subsys_state *css)
 
 /* bits in struct cgroup flags field */
 enum {
-	/* Control Group is dead */
-	CGRP_DEAD,
 	/*
 	 * Control Group has previously had a child cgroup or a task,
 	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set)
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e0953f7..a0cfe36 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -278,7 +278,7 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 /* convenient tests for these bits */
 static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 {
-	return test_bit(CGRP_DEAD, &cgrp->flags);
+	return !(cgrp->self.flags & CSS_ONLINE);
 }
 
 struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
@@ -1518,6 +1518,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
 	cgrp->self.cgroup = cgrp;
+	cgrp->self.flags |= CSS_ONLINE;
 
 	for_each_subsys(ss, ssid)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
@@ -4540,13 +4541,13 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * Mark @cgrp dead.  This prevents further task migration and child
 	 * creation by disabling cgroup_lock_live_group().
 	 */
-	set_bit(CGRP_DEAD, &cgrp->flags);
+	cgrp->self.flags &= ~CSS_ONLINE;
 
 	/* initiate massacre of all css's */
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
 
-	/* CGRP_DEAD is set, remove from ->release_list for the last time */
+	/* CSS_ONLINE is clear, remove from ->release_list for the last time */
 	raw_spin_lock(&release_list_lock);
 	if (!list_empty(&cgrp->release_list))
 		list_del_init(&cgrp->release_list);
-- 
1.9.0
