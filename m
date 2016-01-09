From: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: fix a typo.
Date: Sat,  9 Jan 2016 23:33:06 +0200
Message-ID: <1452375186-2673-1-git-send-email-rami.rosen@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch fixes a typo in a comment in cgroup.c.

Signed-off-by: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f1603c1..528d0d9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4000,7 +4000,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 		goto out_err;
 
 	/*
-	 * Migrate tasks one-by-one until @form is empty.  This fails iff
+	 * Migrate tasks one-by-one until @from is empty.  This fails iff
 	 * ->can_attach() fails.
 	 */
 	do {
-- 
2.4.0
