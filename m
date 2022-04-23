From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH memcg v2] net: set proper memcg for net_init hooks allocations
Date: Sat, 23 Apr 2022 18:38:59 +0300
Message-ID: <3e457e4e-a908-0de7-ba3e-6d5ab434107e@openvz.org>
References: <202204231806.8O86U791-lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=a+z70vimB+5HjACd5bJnkNciNJmYhICT7m82HtTW0ak=;
        b=DGOxBYWGDBUZ85wK2PSmDgFBf3glfu6gBp9RcuZpjhtgF6HOjUY5Q2ABqF6SbbucDY
         ALM7X7aHf99HafMPHM99WC7enJTKMJTEBI283/ereOCVLfHFuQ8XI1lmfyBXO4h9RU39
         n7ABaPpwvD4EdliIxzOrw9UewqCBHWH67THLRGJkCkFdWcimUmA0Utg7st7+XwHgRZEN
         Tu0dkwEzwiUufuFq4DrEvruNVCpmplVfy26ZaeqNDdT2ToVxmbZ4I9RCx2oG79NVen3C
         Wb/krsbyfcOO9f8SOZQBZytlQePpf4MEK1030tBTm6Gbcd4qrT0i/toFpmtC8xaMzfOw
         2oNg==
Content-Language: en-US
In-Reply-To: <202204231806.8O86U791-lkp@intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeelb@google.com>
Cc: kernel@openvz.org, Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

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
v2: introduced get/put_net_memcg(),
    new functions are moved under CONFIG_MEMCG_KMEM
    to fix compilation issues reported by Intel's kernel test robot

v1: introduced get_mem_cgroup_from_kmem(), which takes the refcount
    for the found memcg, suggested by Shakeel
---
 include/linux/memcontrol.h | 35 +++++++++++++++++++++++++++++++++++
 net/core/net_namespace.c   |  7 +++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0abbd685703b..5230d3c5585a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1714,6 +1714,33 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
 
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
+static inline void put_net_memcg(struct mem_cgroup *memcg)
+{
+	css_put(&memcg->css);
+}
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1766,6 +1793,14 @@ static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
        return NULL;
 }
 
+static inline struct mem_cgroup *get_net_memcg(void *p)
+{
+	return NULL;
+}
+
+static inline void put_net_memcg(struct mem_cgroup *memcg)
+{
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a5b5bb99c644..bf88360b8377 100644
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
+			put_net_memcg(memcg);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
-- 
2.31.1

