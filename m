Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD2B26158B
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 03:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788577541; cv=none; b=pfYCVYmmG2CFX00K4ffgWtLZrTYGreCO9fucyAZg+OBKPz4apSQb1kOLEQXaqKqwHPDxe2CfYMGwywLreFZ/Du7bSRkTAkriUgopJ/+cuy89n4cUldxUkhHzSASDWcXrIsVSrX5Op2nhScUV7z2/G2R00+Da0L9TroCdkpkmR7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788577541; c=relaxed/simple;
	bh=1J3PUA095spFjhU5SX/VP0Vy7DB3E7cHPPmCEK6BDk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2k9Z0j/yIjpGswpNSokVenVW0ZS6HZga609YlbJ/lGJnE7aJ58Uta6qWVLNICLVdMSxK/hfG0QZ+ucZDMk5ac9GLis3VTh9If0fk+DReXhETMt/vDY/cXT2aPcD3QNil+H1f90jyYM65r9dHMO56hyNWA9RN1Myqa9GzckIiP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M+GhIc21; arc=none smtp.client-ip=95.215.58.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M+GhIc21"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1J3PUA095spFjhU5SX/VP0Vy7DB3E7cHPPmCEK6BDk8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577536; v=1; x=1789182336;
 b=M+GhIc215tZSbUe72sTTT6oxkN2KRhTDUPngcGvnFRG7FrHdA3alBMY+lGRpA0BTiDKedvBQ
 uZ1h3wULe9ab2O1Db4v6y2z9aQ2WfuHHjGmnbAakjk0AFoqTcfq/pUqe0kaSRixLTFCqLf1UNAz
 xMq2sA2WNOa2/U1BjJm98lk8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6cd579c380cbde10;
	Sat, 05 Sep 2026 03:05:36 +0000
X-Mizu-Trace-ID: 6cd579c380cbde10
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] memcg: split mem_cgroup_private_id into two fields
Date: Fri,  4 Sep 2026 20:05:18 -0700
Message-ID: <20260905030522.1887837-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The two members of struct mem_cgroup_private_id have different access
patterns. The id is read on every eviction and refault through
mem_cgroup_private_id(), and is only written when the memcg is created
and destroyed. The ref is written on every swap charge and uncharge.

Split them into private_id and private_id_ref so a later patch can put
them into different cache line groups. A struct member cannot be split
across two groups.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 10 +++-------
 mm/memcontrol.c            | 18 +++++++++---------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ac575fcc5f1e..46fc99786ebd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -66,11 +66,6 @@ struct mem_cgroup_reclaim_cookie {
 
 #define MEM_CGROUP_ID_SHIFT	16
 
-struct mem_cgroup_private_id {
-	int id;
-	refcount_t ref;
-};
-
 struct memcg_vmstats_percpu;
 struct memcg1_events_percpu;
 struct memcg_vmstats;
@@ -189,7 +184,8 @@ struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	struct mem_cgroup_private_id id;
+	int private_id;
+	refcount_t private_id_ref;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -811,7 +807,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 	if (mem_cgroup_disabled())
 		return 0;
 
-	return memcg->id.id;
+	return memcg->private_id;
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9a65d7148c22..c42297ae3b0e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3797,7 +3797,7 @@ static void memcg_online_kmem(struct mem_cgroup *memcg)
 
 	static_branch_enable(&memcg_kmem_online_key);
 
-	memcg->kmemcg_id = memcg->id.id;
+	memcg->kmemcg_id = memcg->private_id;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
@@ -4056,15 +4056,15 @@ static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
 
 static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
-	if (memcg->id.id > 0) {
-		xa_erase(&mem_cgroup_private_ids, memcg->id.id);
-		memcg->id.id = 0;
+	if (memcg->private_id > 0) {
+		xa_erase(&mem_cgroup_private_ids, memcg->private_id);
+		memcg->private_id = 0;
 	}
 }
 
 static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
-	if (refcount_sub_and_test(n, &memcg->id.ref)) {
+	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
 		mem_cgroup_private_id_remove(memcg);
 
 		/* Memcg ID pins CSS */
@@ -4074,7 +4074,7 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
-	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
+	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -4198,7 +4198,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id.id, NULL,
+	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
 		goto fail;
@@ -4345,7 +4345,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	lru_gen_online_memcg(memcg);
 
 	/* Online state pins memcg ID, memcg ID pins CSS */
-	refcount_set(&memcg->id.ref, 1);
+	refcount_set(&memcg->private_id_ref, 1);
 	css_get(css);
 
 	/*
@@ -4358,7 +4358,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, GFP_KERNEL);
 
 	return 0;
 free_objcg:
-- 
2.53.0-Meta

