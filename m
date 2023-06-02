From: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] cgroup: Replace the css_set call with cgroup_get
Date: Fri, 2 Jun 2023 15:43:46 +0800
Message-ID: <20230602074346.333276-1-cuigaosheng1@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

We will release the refcnt of cgroup via cgroup_put, for example
in the cgroup_lock_and_drain_offline function, so replace css_get
with the cgroup_get function for better readability.

Signed-off-by: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 8b8ca2e01019..7d4272778c76 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -619,7 +619,7 @@ EXPORT_SYMBOL_GPL(cgroup_get_e_css);
 static void cgroup_get_live(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
-	css_get(&cgrp->self);
+	cgroup_get(cgrp);
 }
 
 /**
-- 
2.25.1

