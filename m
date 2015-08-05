From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.3 1/3] cgroup: replace error handling in
 cgroup_init() with WARN_ON()s
Date: Wed, 5 Aug 2015 13:20:12 -0400
Message-ID: <20150805172012.GO17598@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=DcSqpUh1r0DEg9CQ4tc6+Y85QIE4lZhbOjnxwHbgX+o=;
        b=if6Q7mYHhSSuSF9fCRmeDfPRZBXGVtsXhdsu4obAnl3wjiuq9IAOh+j7APaStdonE5
         WN+lRItX+u+9KdCYmpc+XUKxPFs2hQXHp5d5ZBtodq3Li2F9tfTc/uPHQ3irZ0Q5esRa
         MGqjfQJQYr0o2pvVVmNRilanoQ72Y9sEuyViSE+VLla0lcKUGkROSsP3NDFA6xqJjX7o
         0nXo8GmTilWicaTUc+GW/INYK9imGJ3ob0HZGMF2apbK3k0Hq/Q1AyKBQ7jdotr2JkL6
         ajHBcbBdOxNeBzz93DdxSq/YinRIHtBoup1n/a5FyX3vSqlomYXrnvrqlfn3zvcxUhv7
         eLDA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The init sequence shouldn't fail short of bugs and even when it does
it's better to continue with the rest of initialization and we were
silently ignoring /proc/cgroups creation failure.

Drop the explicit error handling and wrap sysfs_create_mount_point(),
register_filesystem() and proc_create() with WARN_ON()s.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/cgroup.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5014,7 +5014,7 @@ int __init cgroup_init(void)
 {
 	struct cgroup_subsys *ss;
 	unsigned long key;
-	int ssid, err;
+	int ssid;
 
 	BUG_ON(percpu_init_rwsem(&cgroup_threadgroup_rwsem));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
@@ -5072,17 +5072,10 @@ int __init cgroup_init(void)
 			ss->bind(init_css_set.subsys[ssid]);
 	}
 
-	err = sysfs_create_mount_point(fs_kobj, "cgroup");
-	if (err)
-		return err;
-
-	err = register_filesystem(&cgroup_fs_type);
-	if (err < 0) {
-		sysfs_remove_mount_point(fs_kobj, "cgroup");
-		return err;
-	}
+	WARN_ON(sysfs_create_mount_point(fs_kobj, "cgroup"));
+	WARN_ON(register_filesystem(&cgroup_fs_type));
+	WARN_ON(!proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations));
 
-	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
 	return 0;
 }
 
