From: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup_pids: fix a typo.
Date: Sun, 13 Dec 2015 22:13:08 +0200
Message-ID: <1450037588-13260-1-git-send-email-rami.rosen@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch fixes a typo in pids_charge() method.

Signed-off-by: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup_pids.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index cdd8df4..c14987e 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -134,7 +134,7 @@ static void pids_charge(struct pids_cgroup *pids, int num)
  *
  * This function follows the set limit. It will fail if the charge would cause
  * the new value to exceed the hierarchical limit. Returns 0 if the charge
- * succeded, otherwise -EAGAIN.
+ * succeeded, otherwise -EAGAIN.
  */
 static int pids_try_charge(struct pids_cgroup *pids, int num)
 {
-- 
2.5.0
