From: <yanfei.xu-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: [PATCH] cpuset: Move node_isset() outside of the rcu_read region
Date: Wed, 16 Sep 2020 19:23:42 +0800
Message-ID: <20200916112342.25790-1-yanfei.xu@windriver.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Yanfei Xu <yanfei.xu-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

It's no need to keep node_isset still in rcu_read region, just move
it outside of the rcu_read region.

Signed-off-by: Yanfei Xu <yanfei.xu-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 642415b8c3c9..51d51ed97deb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3443,9 +3443,9 @@ bool __cpuset_node_allowed(int node, gfp_t gfp_mask)
 
 	rcu_read_lock();
 	cs = nearest_hardwall_ancestor(task_cs(current));
-	allowed = node_isset(node, cs->mems_allowed);
 	rcu_read_unlock();
 
+	allowed = node_isset(node, cs->mems_allowed);
 	spin_unlock_irqrestore(&callback_lock, flags);
 	return allowed;
 }
-- 
2.18.2

