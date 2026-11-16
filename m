Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827147;
	b=1rZZA/6nTMv6bc/iEg/47rxq6L9m3cqvSpo117UoWokC0vICWvGw0zodo3XJZWNRplT7
	 ZkCMx8G+eOS11vCbZEBNJ5IS0py+dSRHn8Sx4R0Qv7f8JJhm3GqoE6mflLsWmlvhCawM4
	 Dnz0x0AnhGmISJ2PLbpbwvgcZszy5vfiLZfTVS7FSWkuP+SXGAGM0fg6dlfPbCcRkRNXX
	 81WsBvB8YiMd0duWpB57ARnYbY3pvLEe5mExs5G/K/2Y1AnenC71x6cBdVTPTVtTJlvxf
	 EZmt9jteGxUgvfgSJmkZYb2cvDq22Ik/2e1onFArbhYDW8n1fWZ+nw5TnmAvMqsSh8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827147;
	h=DMARC-Filter:DKIM-Signature:To:From:X-Lms-Return-Path:
	 X-Original-From:Cc:Mime-Version:X-Mailer:Content-Transfer-Encoding:
	 Subject:Date:Message-Id:Content-Type;
	bh=C4ywSkJsWV8hlNQvfAA7CBUzypleCa5Ls4MfcbDg+g0=;
	b=xTrdqo9ACA9QboRwOJk3UpOieex4YZNScju7/3dod85d8HIe4yAR0rnfkojiw9MFGbNg
	 Luy2lw62g6IFlZOH2DpzeKDKqVH7bGhU8r445yQkzPy1dnqdUOA5k8Wj2fimF00ztifQf
	 XnYT4pqOThOWKguaw6jDDkyCL0WT/z9CxJK8S4AizReGO/wyzz3LUdtxIvIORESFrMXze
	 6LU1FPr+wY1lJt0ZPWZMAfF5ree3WZDkRKE67vIgtR/PSo7YWeOGo6VQzJQ5C2lvT5A1J
	 +upB9gZ4G+jGTbAHhX54kyP8J9TyYO+N5Thn19N29DfevaOTdLDvEY58F/fUlQg0BeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=BEnmhypO;
	arc=none smtp.remote-ip=209.127.230.112
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1EC606A32F
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A1EC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=BEnmhypO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794827140; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=C4ywSkJsWV8hlNQvfAA7CBUzypleCa5Ls4MfcbDg+g0=;
 b=BEnmhypOpsh8uhkP7ys8vGEhOgri2TNsfrE/klF/J3zgBfdFWBR1RoQu42PMcb9bnnpB8s
 9PDQ14h/LDSmfFvg2FA9yzjNQVvcuJfNYMRFDA5KtVQ4DOcu2wT5dHXL/XNuQiWcMgGB7M
 Krzsl60SL5rtx+9Hm6yJEqVYyZSOx02uOQpARx3gqFff+I4bu9SPJQ0vKOHgnrswnUm+93
 6faG3mCXqPosxFuz1kTtSzWCrNjUQrR8mwkBB9wYS6jaT/Hyz3KwTR7VkpLCLpYm27fXE4
 bWk5VHCMWckw0V7R8XLkXhbxMyDbP2ROXsQjO/gMR9uqEpP18R3qQGVKJKtHDA==
To: <joshua.hahnjy@gmail.com>, <akpm@linux-foundation.org>, 
	<david@kernel.org>, <gourry@gourry.net>, <hannes@cmpxchg.org>, 
	<ljs@kernel.org>, <mhocko@suse.com>, <muchun.song@linux.dev>, 
	<rakie.kim@sk.com>, <roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, 
	<weixugc@google.com>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26afae383+37f419+vger.kernel.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Subject: [PATCH v3] mm: add source selector to memory.reclaim
Date: Mon, 16 Nov 2026 19:04:59 +0800
Message-Id: <20261116110459.11048-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8

memory.reclaim can apply proactive reclaim to a memcg, but it cannot
target source nodes the way global node reclaim can. Proactive memcg
reclaim follows a fast-to-slow fallback order, which attempts demotion
before reclaiming from slower tiers.

As a result, a memcg controller cannot decide whether reclaim should
start from DRAM or from a slower tier. For a cgroup that is close to OOM
and needs charge reduction, or for a controller trying to shape a
workload's DRAM/CXL resident distribution, the default policy may spend
reclaim effort on the wrong source tier.

Add source=nodes:<nodelist> to memory.reclaim. The selector only chooses
the resident source nodes where the existing memcg reclaim path applies
pressure. It does not select demotion targets, force demotion, force
eviction, promote pages, or change completion accounting. Leaving source
unspecified preserves existing behavior.

With this, userspace can build the policy it needs on top of existing
kernel reclaim behavior:

1. start reclaim from lower-tier nodes to reduce the cgroup's memory
   usage more directly;
2. steer reclaim toward over-represented nodes to shape a workload's
   DRAM/CXL resident distribution; and
3. reclaim from lower-tier nodes first so later top-tier reclaim has
   room for demotion.

Example: nodes 0-2=DRAM, node3=CXL

  echo 1G > memory.reclaim # progress from nodes 0-3
  echo "1G source=nodes:3" > memory.reclaim # reclaim from CXL
  echo "1G source=nodes:0-2" > memory.reclaim # usually demote to CXL

The typed source= form also leaves room for future source selectors
without changing the ABI introduced here.

Tested in a CXL setup with nodes 0-2 as DRAM and node 3 as CXL. A
userspace controller steered eight cgroups toward a 50:50 DRAM:CXL
resident ratio while a background workload created reclaim and demotion
pressure. With source=nodes, all eight cgroups ended with 45%-55% of
their memory on DRAM. Under the same pressure, the plain memory.reclaim
baseline left the worst cgroup far away from the target range.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
v2: https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedance.com/#t
v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedance.com/

Changes since v2:
- Dropped the separate cover letter and shortened/refocused the commit
  message, as suggested by Joshua Hahn and Gregory Price.
- Added an eight-cgroup CXL test summary under background
  reclaim/demotion pressure, as suggested by Joshua Hahn.

---
 Documentation/admin-guide/cgroup-v2.rst | 11 ++++++
 mm/bpf_memcontrol.c                     |  3 +-
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 ++++--
 mm/vmscan.c                             | 49 +++++++++++++++++++++++--
 6 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..992f9bdc46a1 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1458,6 +1458,7 @@ The following nested keys are defined.
 
 	  ==========            ================================
 	  swappiness            Swappiness value to reclaim with
+	  source                Source to apply reclaim pressure to
 	  ==========            ================================
 
 	Specifying a swappiness value instructs the kernel to perform
@@ -1468,6 +1469,16 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	Specifying a source value constrains where proactive reclaim applies
+	pressure. Currently only source=nodes:<nodelist> is supported. For
+	example::
+
+	  echo "1G source=nodes:0-1" > memory.reclaim
+
+	This applies proactive reclaim pressure to memory of the target cgroup
+	resident on nodes 0-1. It does not constrain demotion targets and does
+	not change memory.reclaim completion accounting.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..7d98f55a044f 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -201,7 +201,8 @@ __bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
 	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
 						    MEMCG_RECLAIM_MAY_SWAP |
 						    MEMCG_RECLAIM_PROACTIVE,
-						    swappiness == -1 ? NULL : &swappiness);
+						    swappiness == -1 ? NULL : &swappiness,
+						    NULL);
 
 	return nr_reclaimed * PAGE_SIZE;
 }
diff --git a/mm/internal.h b/mm/internal.h
index e3f92883bf23..ff24a58d47e8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -83,7 +83,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness);
+					   int *swappiness,
+					   const nodemask_t *source_nodes);
 
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b7f286888507..74aa06fee76a 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1464,7 +1464,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
+				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
+				NULL, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -1500,7 +1501,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			break;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP, NULL))
+						  MEMCG_RECLAIM_MAY_SWAP,
+						  NULL, NULL))
 			nr_retries--;
 	}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..116c6853c9ba 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2444,7 +2444,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL);
+							NULL, NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2774,7 +2774,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -5001,7 +5002,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -5060,7 +5062,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..15e2e5710468 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7013,12 +7013,14 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *source_nodes)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
+		.nodemask = source_nodes,
 		.proactive_swappiness = swappiness,
 		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
@@ -7054,7 +7056,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *source_nodes)
 {
 	return 0;
 }
@@ -8098,20 +8101,51 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
+	MEMORY_RECLAIM_SOURCE,
 	MEMORY_RECLAIM_NULL,
 };
 static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
 	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
+	{ MEMORY_RECLAIM_SOURCE, "source=%s"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
+#define MEMORY_RECLAIM_SOURCE_NODES	"nodes:"
+#define MEMORY_RECLAIM_SOURCE_NODES_LEN	(sizeof(MEMORY_RECLAIM_SOURCE_NODES) - 1)
+
+static int parse_memory_reclaim_source(const char *source,
+				       nodemask_t *source_nodes)
+{
+	const char *nodes;
+
+	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
+		    MEMORY_RECLAIM_SOURCE_NODES_LEN))
+		return -EINVAL;
+
+	nodes = source + MEMORY_RECLAIM_SOURCE_NODES_LEN;
+	if (!*nodes)
+		return -EINVAL;
+
+	nodes_clear(*source_nodes);
+	if (nodelist_parse(nodes, *source_nodes))
+		return -EINVAL;
+
+	nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
+	if (nodes_empty(*source_nodes))
+		return -EINVAL;
+
+	return 0;
+}
+
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat)
 {
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
 	int swappiness = -1;
+	nodemask_t source_nodes;
+	const nodemask_t *source_nodemask = NULL;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
 	gfp_t gfp_mask = GFP_KERNEL;
@@ -8142,6 +8176,14 @@ int user_proactive_reclaim(char *buf,
 		case MEMORY_RECLAIM_SWAPPINESS_MAX:
 			swappiness = SWAPPINESS_ANON_ONLY;
 			break;
+		case MEMORY_RECLAIM_SOURCE:
+			if (!memcg || source_nodemask)
+				return -EINVAL;
+			if (parse_memory_reclaim_source(args[0].from,
+							&source_nodes))
+				return -EINVAL;
+			source_nodemask = &source_nodes;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -8181,7 +8223,8 @@ int user_proactive_reclaim(char *buf,
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						 batch_size, gfp_mask,
 						 reclaim_options,
-						 swappiness == -1 ? NULL : &swappiness);
+						 swappiness == -1 ? NULL : &swappiness,
+						 source_nodemask);
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-- 
2.20.1
