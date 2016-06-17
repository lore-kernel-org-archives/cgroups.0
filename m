From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 1/3] cgroup: fix idr leak for the first cgroup root
Date: Fri, 17 Jun 2016 12:23:59 -0400
Message-ID: <20160617162359.GB19084@cmpxchg.org>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
 <20160616200617.GD3262@mtj.duckdns.org>
 <20160617162310.GA19084@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160617162310.GA19084-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The valid cgroup hierarchy ID range includes 0, so we can't filter for
positive numbers when freeing it, or it'll leak the first ID. No big
deal, just disruptive when reading the code.

The ID is freed during error handling and when the reference count
hits zero, so the double-free test is not necessary; remove it.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/cgroup.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 86cb5c6e8932..36fc0ff506c3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1158,18 +1158,12 @@ static void cgroup_exit_root_id(struct cgroup_root *root)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (root->hierarchy_id) {
-		idr_remove(&cgroup_hierarchy_idr, root->hierarchy_id);
-		root->hierarchy_id = 0;
-	}
+	idr_remove(&cgroup_hierarchy_idr, root->hierarchy_id);
 }
 
 static void cgroup_free_root(struct cgroup_root *root)
 {
 	if (root) {
-		/* hierarchy ID should already have been released */
-		WARN_ON_ONCE(root->hierarchy_id);
-
 		idr_destroy(&root->cgroup_idr);
 		kfree(root);
 	}
-- 
2.8.3
