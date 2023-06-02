From: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] rdmacg: fix kernel-doc warnings in rdmacg
Date: Fri, 2 Jun 2023 15:44:56 +0800
Message-ID: <20230602074456.333840-1-cuigaosheng1@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Fix all kernel-doc warnings in rdmacg:

kernel/cgroup/rdma.c:209: warning: Function parameter or member 'cg'
not described in 'rdmacg_uncharge_hierarchy'
kernel/cgroup/rdma.c:230: warning: Function parameter or member 'cg'
not described in 'rdmacg_uncharge'

Signed-off-by: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index 3135406608c7..ef5878fb2005 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -197,6 +197,7 @@ uncharge_cg_locked(struct rdma_cgroup *cg,
 
 /**
  * rdmacg_uncharge_hierarchy - hierarchically uncharge rdma resource count
+ * @cg: pointer to cg to uncharge and all parents in hierarchy
  * @device: pointer to rdmacg device
  * @stop_cg: while traversing hirerchy, when meet with stop_cg cgroup
  *           stop uncharging
@@ -221,6 +222,7 @@ static void rdmacg_uncharge_hierarchy(struct rdma_cgroup *cg,
 
 /**
  * rdmacg_uncharge - hierarchically uncharge rdma resource count
+ * @cg: pointer to cg to uncharge and all parents in hierarchy
  * @device: pointer to rdmacg device
  * @index: index of the resource to uncharge in cgroup in given resource pool
  */
-- 
2.25.1

