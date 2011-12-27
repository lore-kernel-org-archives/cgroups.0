From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH v2] cgroup: fix to allow mounting a hierarchy by name
Date: Tue, 27 Dec 2011 14:25:55 +0800
Message-ID: <4EF964F3.8090705@cn.fujitsu.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EF9291D.7030208-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If we mount a hierarchy with a specified name, the name is unique,
and we can use it to mount the hierarchy without specifying its
set of subsystem names. This feature is documented is
Documentation/cgroups/cgroups.txt section 2.3

Here's an example:

	# mount -t cgroup -o cpuset,name=myhier xxx /cgroup1
	# mount -t cgroup -o name=myhier xxx /cgroup2

But it was broken by commit 32a8cf235e2f192eb002755076994525cdbaa35a
(cgroup: make the mount options parsing more accurate)

This fixes the regression.

Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---

v2: fix code comment s/or/and

---

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1042b3c..8e412fd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1193,10 +1193,10 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 
 	/*
 	 * If the 'all' option was specified select all the subsystems,
-	 * otherwise 'all, 'none' and a subsystem name options were not
-	 * specified, let's default to 'all'
+	 * otherwise if 'none', 'name=' and a subsystem name options
+	 * were not specified, let's default to 'all'
 	 */
-	if (all_ss || (!all_ss && !one_ss && !opts->none)) {
+	if (all_ss || (!one_ss && !opts->none && !opts->name)) {
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 			if (ss == NULL)
-- 
1.7.3.1
