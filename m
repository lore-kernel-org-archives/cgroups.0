From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-4.4-fixes] cgroup_pids: don't account for the root cgroup
Date: Mon, 30 Nov 2015 17:45:43 -0500
Message-ID: <20151130224543.GC9039@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=wbrZjxGkr6Q73pg2s9nfExKXU8l2r0ZW/aOzMWO911A=;
        b=A2YtFxYbxe9iz5/8xH4Ug9KZl7S5tgeWliWI5IScJklix/Bn9faX/CPZR94ScwQjVg
         mpkwDKRyDXGwEQD4IIC6QwnTudm69OUApAbuiNePBeP31nK4dLgVn/Ro/17p2D5GQdI6
         5dbkai6B9qY4VFKUTgXIyjWPVhJgW6L4YLPPm3Uu8KRbTSicMmwWv3T6CgO1PuglwIcU
         KkMiqEJ+EEv5bHgcUlRkwp3IOIxqMzj/QfzuSvAlJIWhnfpWxrRGz7wbbiTLY6h3fgCq
         WD1XQm/yYT57KDlMbQTpczLwoHMmEcpZQgIt6FhnSsqTIqF2oovtXmNZDQZtzY+49ATe
         lz2w==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

From 7bbb8d4e913853a1346d95745ca8092f0cc8ce00 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 30 Nov 2015 17:24:34 -0500

Because accounting resources for the root cgroup sometimes incurs
measureable overhead for workloads which don't care about cgroup and
often ends up calculating a number which is available elsewhere in a
slightly different form, cgroup is not in the business of providing
system-wide statistics.  The pids controller which was introduced
recently was exposing "pids.current" at the root.  This patch disable
accounting for root cgroup and removes the file from the root
directory.

While this is a userland visible behavior change, pids has been
available only in one version and was badly broken there, so I don't
think this will be noticeable.  If it turns out to be a problem, we
can reinstate it for v1 hierarchies.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup_pids.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index 8e27fc5..b50d5a1 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -106,7 +106,7 @@ static void pids_uncharge(struct pids_cgroup *pids, int num)
 {
 	struct pids_cgroup *p;
 
-	for (p = pids; p; p = parent_pids(p))
+	for (p = pids; parent_pids(p); p = parent_pids(p))
 		pids_cancel(p, num);
 }
 
@@ -123,7 +123,7 @@ static void pids_charge(struct pids_cgroup *pids, int num)
 {
 	struct pids_cgroup *p;
 
-	for (p = pids; p; p = parent_pids(p))
+	for (p = pids; parent_pids(p); p = parent_pids(p))
 		atomic64_add(num, &p->counter);
 }
 
@@ -140,7 +140,7 @@ static int pids_try_charge(struct pids_cgroup *pids, int num)
 {
 	struct pids_cgroup *p, *q;
 
-	for (p = pids; p; p = parent_pids(p)) {
+	for (p = pids; parent_pids(p); p = parent_pids(p)) {
 		int64_t new = atomic64_add_return(num, &p->counter);
 
 		/*
@@ -298,6 +298,7 @@ static struct cftype pids_files[] = {
 	{
 		.name = "current",
 		.read_s64 = pids_current_read,
+		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 	{ }	/* terminate */
 };
-- 
2.5.0
