From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix obsolete function name above css_free_rwork_fn()
Date: Tue, 1 Aug 2023 20:40:34 +0800
Message-ID: <20230801124034.2245419-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Since commit 8f36aaec9c92 ("cgroup: Use rcu_work instead of explicit rcu
and work item"), css_free_work_fn has been renamed to css_free_rwork_fn.
Update corresponding comment.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c7aafb59ecf2..d620d7ec47e8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5301,7 +5301,7 @@ static struct cftype cgroup_psi_files[] = {
  *    RCU callback.
  *
  * 4. After the grace period, the css can be freed.  Implemented in
- *    css_free_work_fn().
+ *    css_free_rwork_fn().
  *
  * It is actually hairier because both step 2 and 4 require process context
  * and thus involve punting to css->destroy_work adding two additional
-- 
2.33.0

