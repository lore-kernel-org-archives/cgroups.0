From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] memcg, kmem: Use is_root_cache instead of hard code
Date: Wed, 23 Oct 2013 19:31:13 +0800
Message-ID: <1382527875-10112-2-git-send-email-h.huangqiang@huawei.com>
References: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382527875-10112-1-git-send-email-h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b73988a..15ad0e3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -57,6 +57,7 @@
 #include <net/sock.h>
 #include <net/ip.h>
 #include <net/tcp_memcontrol.h>
+#include "slab.h"
 
 #include <asm/uaccess.h>
 
@@ -3064,7 +3065,7 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 {
 	struct memcg_cache_params *cur_params = s->memcg_params;
 
-	VM_BUG_ON(s->memcg_params && !s->memcg_params->is_root_cache);
+	VM_BUG_ON(!is_root_cache(s));
 
 	if (num_groups > memcg_limited_groups_array_size) {
 		int i;
-- 
1.8.3

