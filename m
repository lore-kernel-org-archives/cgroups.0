Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793603169;
	b=Li3OqfT0yxgppcxEMNOs2WIh0I0Kp1ySeNNTwyWcrTb/IOLDsKx5nbtOsbcQmC0hElh1
	 SB0XB6z7CAEaZcaqYud1uSlDGv8AS6VqnRx3aDXpv1BEvogr9h9NTtebrI1Dfc9dQBvla
	 ZJqkM8MuuU3PG9GXYJ9Rm5jWYINXsMY3Tt1eZQAh8e4FtIour2ozPl3djm1m4+Gm9nN1g
	 cNTbEv64hxmhCEyDJw36Vhus3H3MmHqF6WhCKy7wNKOiXAssLzOm/J6mi+bd3B92DOhPV
	 5F7myxLAxyW0fus694WAA7PfR6yIPXwhONFEEVBxM5KQIcoet/o+v4oV0jjjpPTbhcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793603169;
	h=DMARC-Filter:DKIM-Signature:Cc:From:Message-Id:In-Reply-To:
	 X-Lms-Return-Path:Content-Transfer-Encoding:Content-Type:To:
	 References:Date:Mime-Version:X-Mailer:X-Original-From:Subject;
	bh=enLchkwkJtq/TfAQp+411aBERINT09YDWrENgNdLIdE=;
	b=SBHfgv+4D4PZ9FSOxNehNI88t0Nwi1zPu6zHRAlwMHVUeQgvNnsFDXph5E/7k+Y8/lPj
	 eEl4y/Dwc1vB4b30XJcc6HE4pr1aP0OIMDW5+ZfwGv26Th4kYHTWRfYz0eUIkqis2Wj8v
	 yqNr5Tt5DhnXWqTUR3Rm1XFk1Aa2yxSch8gfcWIgyLEqJUvo7e5AaijAmFZUo/ElneuTE
	 hZvlTu4+C7vRoLX0SPUOrYWkqxwDpvJHBxrbwM/9LH93u4AoYMFNnaNE3FcjjvIiNgvm2
	 8mFj2nP1vuJu8TXJhrBkcVRic+MTu0YNtLhn22AbrLSOYAYonVP3NOGET/LLUGiwytA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=mDscme0I;
	arc=none smtp.remote-ip=209.127.230.115
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2309C606A330
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 07:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2309C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=mDscme0I
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793603163; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=enLchkwkJtq/TfAQp+411aBERINT09YDWrENgNdLIdE=;
 b=mDscme0Ira6yOrKix6TTp5H8gH9sWt80A3Vx53zOxzeiCdCIDgCaUPmVrKM0eADVS2uDi9
 Pe5bH+B2Pohw4l47wIoMVBm1Jah3IrtZ7XtfQb1QlcmlhgGs+AJLxHhXzm6I5wPGCbmBpq
 1HpNVtoEXmznWPrmr6x3CwgmfUrZ/sl+hBmI4r2BmZ2sLoNHx4r4esXC2JqLHPY5sOyRc1
 GpVb6sOln7MVHM0s7Un/2gsqFfrd3Hq9jdrNrSURbDUEZ/hslCUbjuzK+zeG/VPdTGliYn
 8Ko4tFj5a/LVpRxADrS5rlt0WBMez3paifHF00p8lOqjgV8wujb8DDcbxlwy/g==
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261102070440.16262-2-lizhe.67@bytedance.com>
In-Reply-To: <20261102070440.16262-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ae83658+eaab51+vger.kernel.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <rakie.kim@sk.com>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
References: <20261102070440.16262-1-lizhe.67@bytedance.com>
Date: Mon,  2 Nov 2026 15:04:40 +0800
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
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: [RFC v2 1/1] mm: add source selector to memory.reclaim

memory.reclaim was added as a generic proactive reclaim
interface for memcgs, but memory tiering makes its practical
meaning less obvious. Reclaim may demote cold folios from a
faster tier to a slower tier before they are eventually evicted.
As a result, a write to memory.reclaim can either move folios
between tiers or evict them from the cgroup, depending on where
the reclaim walk finds eligible memory and whether demotion is
available.

That ambiguity is awkward for userspace controllers. A controller
that is trying to manage DRAM, CXL, or other tier occupancy cannot
direct reclaim pressure to the resident memory it wants to relieve.
It can only ask the kernel to reclaim from the memcg as a whole,
while the resulting progress is reported as one aggregate value.
This makes effective tier-ratio control largely infeasible:
userspace can observe that the distribution of memory across tiers
has drifted away from the controller's preferred balance, but it
cannot direct the next reclaim request to the corresponding source
nodes. It also makes controlled charge reduction unreliable: a
controller that wants to free memory from a terminal tier cannot ask
reclaim to start from that tier.

Add a typed source= selector to memory.reclaim. The first
supported form is source=nodes:<nodelist>. The selector declares
the source nodes to which userspace wants the kernel to apply the
normal memcg reclaim path. It constrains the source to which reclaim
pressure is applied; it is not a demotion-only goal, an eviction-only
goal, or a demotion target selector.

The selector only chooses where the existing reclaim policy is
applied. It does not change when the kernel decides to demote,
evict, activate, or keep a folio.

With this primitive, userspace can build higher-level policies by
choosing different sources across requests. For example, a
controller can issue one request against top-tier nodes for tier
balancing, another request against lower-tier nodes to make room for
later demotion, and another request against terminal-tier nodes when
it needs actual charge reduction. This composes tiering policies from
a simple source selector instead of adding policy-specific
memory.reclaim keys. This patch does not change the reclaim policy:
memory.reclaim continues to run the kernel's existing reclaim path,
now with an optional source constraint.

Leaving source unspecified preserves the existing memory.reclaim
behavior.

The source= key is intentionally typed so future selectors can be
added without reinterpreting source=nodes:<nodelist>.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  9 +++++
 mm/bpf_memcontrol.c                     |  3 +-
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 ++++--
 mm/vmscan.c                             | 49 +++++++++++++++++++++++--
 6 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2e..ee42da817c062 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1458,6 +1458,7 @@ The following nested keys are defined.
 
 	  ==========            ================================
 	  swappiness            Swappiness value to reclaim with
+	  source                Source to apply reclaim pressure to
 	  ==========            ================================
 
 	Specifying a swappiness value instructs the kernel to perform
@@ -1468,6 +1469,14 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	Specifying a source value constrains where proactive reclaim applies
+	pressure. Currently only source=nodes:<nodelist> is supported. For
+	example::
+
+	  echo "1G source=nodes:0-1" > memory.reclaim
+
+	This reclaims memory of the target cgroup resident on nodes 0-1.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c285600..7d98f55a044fa 100644
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
index 566cbd2dce485..b16efceb58458 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -83,7 +83,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness);
+					   int *swappiness,
+					   nodemask_t *source_nodes);
 
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b7f2868885071..74aa06fee76a0 100644
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
index a05d9a8baa1b6..f07dc44b9e4fc 100644
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
@@ -2771,7 +2771,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4996,7 +4997,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -5055,7 +5057,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..265807e437af4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7013,12 +7013,14 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   nodemask_t *source_nodes)
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
+					   nodemask_t *source_nodes)
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
+	nodemask_t *source_nodemask = NULL;
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
