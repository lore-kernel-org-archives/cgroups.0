From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cgroup: remove cgroup_mutex from cgroupstats_build
Date: Sun, 24 Oct 2021 23:19:15 -0700
Message-ID: <20211025061916.3853623-2-shakeelb@google.com>
References: <20211025061916.3853623-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZWcH7rWC3ZsHErnrMwwxWzyNMoxVakai+vPjAaFHzVQ=;
        b=hOMf4il33vbkfJyrzLVbrglaaETehyTreBSt+7K7c6eZFmlWBxyFhb8QmG53tAMHjo
         9A8hK5RqzXNl6UGb+aHrz3o1OoeY2Qi/m87JHrptd2Cscjtjhi5OKqHdS3euGZ+DDudF
         vDpFkGp7HmYoSHhDu/i8JDYjJ/9Lj7E5M5UyH79Xjg+64TS9RKsRfayisnySku0cQpbz
         UtDKoXNGhPG1DtxPSW40RGRHQEKG2ZqIpmm1+0BsfREZ2y4LufrJHNbKls/e8a1bWs3t
         JqdKSFi/RIalkhdeKVCE8qoaIHmviBIT1IK5Avzg832qRyK/hHnWPb2D5A/j1A1wC+am
         eBCw==
In-Reply-To: <20211025061916.3853623-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The function cgroupstats_build extracts cgroup from the kernfs_node's
priv pointer which is a RCU pointer. So, there is no need to grab
cgroup_mutex. Just get the reference on the cgroup before using and
remove the cgroup_mutex altogether.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index f6cc5f8484dc..fd14a60379c1 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -698,8 +698,6 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	    kernfs_type(kn) != KERNFS_DIR)
 		return -EINVAL;
 
-	mutex_lock(&cgroup_mutex);
-
 	/*
 	 * We aren't being called from kernfs and there's no guarantee on
 	 * @kn->priv's validity.  For this and css_tryget_online_from_dir(),
@@ -707,9 +705,8 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	 */
 	rcu_read_lock();
 	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
-	if (!cgrp || cgroup_is_dead(cgrp)) {
+	if (!cgrp || !cgroup_tryget(cgrp)) {
 		rcu_read_unlock();
-		mutex_unlock(&cgroup_mutex);
 		return -ENOENT;
 	}
 	rcu_read_unlock();
@@ -737,7 +734,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	}
 	css_task_iter_end(&it);
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_put(cgrp);
 	return 0;
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

