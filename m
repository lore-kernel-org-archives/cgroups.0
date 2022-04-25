From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH memcg v3] net: set proper memcg for net_init hooks allocations
Date: Mon, 25 Apr 2022 13:56:02 +0300
Message-ID: <c2f0139a-62e2-5985-34e9-d42faac81960@openvz.org>
References: <20220424144627.GB13403@xsang-OptiPlex-9020>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=T8bwaMzGPgoQcIyr+n6koMGrG7fm/Z4/AiIVbk5FTRE=;
        b=PHxpIopHnjSfjS/SVHNS9Ad2fDgAC87mv4w+6ga4qbdW0Q2DTzaYmHRN3FR9hnZOCy
         6xHdBZqPo+eR6dnxjdmLPyDBqPd9zII1ImpopMWmMb93yF0N8tm+cUmIT5jrtOL4N/4v
         XixhnibyCcGYMbLesUH9fox8gdn0Zo0vLs70tveEs+TVVtOicDv7XzpKK+lCL7Svz8Lj
         GZMLt9aTLZIYCm/IcFYiEyN9C17/I/NuJ8YIv2YRMMdH1cS5JDNQB8rXKBscDJ3JiUNc
         UpHURClLwRUW/qmDhx/2kWlIj9Ntv/iBjic6ui24tNOoA8UmKZVBg0Y/Y35+pkBgxAMI
         0zRQ==
Content-Language: en-US
In-Reply-To: <20220424144627.GB13403@xsang-OptiPlex-9020>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

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

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
v3: put_net_memcg() replaced by an alreay existing mem_cgroup_put()
    It checks memcg before accessing it, this is required for
    __register_pernet_operations() called before memcg initialization.
    Additionally fixed leading whitespaces in non-memcg_kmem version
    of mem_cgroup_from_obj().

v2: introduced get/put_net_memcg(),
    new functions are moved under CONFIG_MEMCG_KMEM
    to fix compilation issues reported by Intel's kernel test robot

v1: introduced get_mem_cgroup_from_kmem(), which takes the refcount
    for the found memcg, suggested by Shakeel
---
 include/linux/memcontrol.h | 29 ++++++++++++++++++++++++++++-
 net/core/net_namespace.c   |  7 +++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0abbd685703b..cfb68a3f7015 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1714,6 +1714,29 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
 
 struct mem_cgroup *mem_cgroup_from_obj(void *p);
 
+static inline struct mem_cgroup *get_mem_cgroup_from_kmem(void *p)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	do {
+		memcg = mem_cgroup_from_obj(p);
+	} while (memcg && !css_tryget(&memcg->css));
+	rcu_read_unlock();
+	return memcg;
+}
+
+static inline struct mem_cgroup *get_net_memcg(void *p)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = get_mem_cgroup_from_kmem(p);
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	return memcg;
+}
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1763,9 +1786,13 @@ static inline void memcg_put_cache_ids(void)
 
 static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
 {
-       return NULL;
+	return NULL;
 }
 
+static inline struct mem_cgroup *get_net_memcg(void *p)
+{
+	return NULL;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a5b5bb99c644..3093b4d5b2b9 100644
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
+			struct mem_cgroup *old, *memcg;
+
+			memcg = get_net_memcg(net);
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
+			mem_cgroup_put(memcg);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
-- 
2.31.1

