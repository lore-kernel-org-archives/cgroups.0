From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH memcg RFC] net: set proper memcg for net_init hooks
 allocations
Date: Sun, 17 Apr 2022 09:39:37 +0300
Message-ID: <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
References: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=bT5KP076LNXAkBuT6bxsWqWs6Rnf/a89eLMuVK8//BE=;
        b=ncW0cuAMb8hBdKsyH8A3kwzpFlf5AjHuKNEWWaWOGkn5vtR0OwYflZ/UOyblXqRhoX
         kbsctJzKaEA9bWHOVkTV9KuCRQcRcOgvcUf41KIzu3vHK2W9CC4bp4s9AHaibfLLOQjS
         bT1e05vF0QYw5pL8iOoteYlboX9TqJwxMFp/G4XDGLWUN1+Kmy6fQdP8Kl/4NuFsySkn
         HzOuRVfYzz0kv3CUSF1d0XcVL91nMfwKTE/4x0Inr2clsZHHMcHM8uhguc3zAzvEA9cl
         WWfK9ozD2CGno/6VT0O3Ng+LCRT/WPIh/FlwpOJ46w4aohgfKTn2GFxLEpSzV5i7vrat
         rK0w==
Content-Language: en-US
In-Reply-To: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

__register_pernet_operations() executes init hook of registered
pernet_operation structure in all existing net namespaces.

Typically, these hooks are called by a process associated with
the specified net namespace, and all __GFP_ACCOUNTING marked
allocation are accounted for corresponding container/memcg.

However __register_pernet_operations() calls the hooks in the same
context, and as a result all marked allocations are accounted
to one memcg for all processed net namespaces.

This patch adjusts active memcg for each net namespace and helps
to account memory allocated inside ops_init() into the proper memcg.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
Dear Vlastimil, Roman,
I'm not sure that memcg is used correctly here, 
is it perhaps some additional locking required?
---
 net/core/net_namespace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a5b5bb99c644..171c6e0b2337 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -26,6 +26,7 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
+#include <linux/sched/mm.h>
 /*
  *	Our network namespace constructor/destructor lists
  */
@@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
 		 * setup_net() and cleanup_net() are not possible.
 		 */
 		for_each_net(net) {
+			struct mem_cgroup *old, *memcg = NULL;
+#ifdef CONFIG_MEMCG
+			memcg = (net == &init_net) ? root_mem_cgroup : mem_cgroup_from_obj(net);
+#endif
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
-- 
2.31.1

