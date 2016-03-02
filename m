From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [cgroup/for-4.6 1/2] cgroup: re-hash init_css_set after subsystems
 are initialized
Date: Wed, 2 Mar 2016 13:07:12 -0500
Message-ID: <20160302180712.GA11029@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CXGM6vVonHGa0tTZmGeYru6e+t2n1QrEwoDVcEHU9CQ=;
        b=ZtAHRwTX/ajxJQBQbQyX1MOIPnMfPp3jTaPr8UL5DuuCJqScfS3sz4noixVsKJXm70
         TclNeu/KdUO0DGW1nhx+MSULTT2IQW9Me41QRyykuA+55wkpYqY4DTa16PbRt6OR7WsK
         K76bIEqUZ+WMeQ2tSz+twd0bFz6FMXC7FWkthggeiVF+RLTd4QBVgQLRqVaMG9xFsDhI
         sc0iXNoE0DneaViupOfh3Mrtqg/A16wrM5L/jZIWYW42Mx37qHAb98sLoNZApTA+Cg+O
         D35pjA8QHtKjPkY5v3irkmivuLYcO8qRDmy7C/H+kEI9m/MDFhb+pWLf1PXJ7YRNs142
         iBcA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

css_sets are hashed by their subsys[] contents and in cgroup_init()
init_css_set is hashed early, before subsystem inits, when all entries
in its subsys[] are NULL, so that cgroup_dfl_root initialization can
find and link to it.  As subsystems are initialized,
init_css_set.subsys[] is filled up but the hashing is never updated
making init_css_set hashed in the wrong place.  While incorrect, this
doesn't cause a critical failure as css_set management code would
create an identical css_set dynamically.

Fix it by rehashing init_css_set after subsystems are initialized.
While at it, drop unnecessary @key local variable.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5263,7 +5263,6 @@ static u16 cgroup_disable_mask __initdat
 int __init cgroup_init(void)
 {
 	struct cgroup_subsys *ss;
-	unsigned long key;
 	int ssid;
 
 	BUILD_BUG_ON(CGROUP_SUBSYS_COUNT > 16);
@@ -5273,9 +5272,12 @@ int __init cgroup_init(void)
 
 	mutex_lock(&cgroup_mutex);
 
-	/* Add init_css_set to the hash table */
-	key = css_set_hash(init_css_set.subsys);
-	hash_add(css_set_table, &init_css_set.hlist, key);
+	/*
+	 * Add init_css_set to the hash table so that dfl_root can link to
+	 * it during init.
+	 */
+	hash_add(css_set_table, &init_css_set.hlist,
+		 css_set_hash(init_css_set.subsys));
 
 	BUG_ON(cgroup_setup_root(&cgrp_dfl_root, 0));
 
@@ -5328,6 +5330,11 @@ int __init cgroup_init(void)
 			ss->bind(init_css_set.subsys[ssid]);
 	}
 
+	/* init_css_set.subsys[] has been updated, re-hash */
+	hash_del(&init_css_set.hlist);
+	hash_add(css_set_table, &init_css_set.hlist,
+		 css_set_hash(init_css_set.subsys));
+
 	WARN_ON(sysfs_create_mount_point(fs_kobj, "cgroup"));
 	WARN_ON(register_filesystem(&cgroup_fs_type));
 	WARN_ON(register_filesystem(&cgroup2_fs_type));
