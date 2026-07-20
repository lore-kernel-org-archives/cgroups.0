Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10043AE6F5
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576087; cv=none; b=ADLJrHr5GD1s7noCFo7vQnlJbUJGCHGSTpVUqyrXQyo9Q30lCSaq67zT6DnCfWzvm5dopJPhv/KDfEc1Q5GkAdase8e1tGd3Ncy5Per4MOh3bhrgwNe1r12tcDxZh8951xpDG8Ewxf6LyfH/j/k4lbeIiO/gOoj2ZY9AlmstCgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576087; c=relaxed/simple;
	bh=BXKkjPaqRDLvf1Rsfxqjf9a9bmU7Z6cyMAMgQYWOA+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnullAwhx82+csUGbEyN4mKXr0hM9Ash3hCBPaDKjQD6d6IBQRyQmOvyUIywrY7+3I1f/fY+szc/PMDXagKjB+uJS30tRpqwFqxZlsHjFvHsL2LbGchR/RGW8hPOVdPIXpblCyN5dhxCORMolXeU6aXMItOXlBWM1Sf0d39jGBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=jrpOzZ2y; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="jrpOzZ2y"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92f0b5ed131so662350885a.3
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576084; x=1785180884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/c51hvMQmc3XHuoW6uDjvccdoKFQfSnHZbbwUxq30Zg=;
        b=jrpOzZ2ynYu9F7excnopUTd9s9hiCLHLOri8XDMd4svOLXUXM1ntthtLTdTWmCQmZg
         LTrr89ncyv582qROyKmVuX0qLZ+ZcDkWkVF6jjIGJeYsuxLJHubKrV7rXY63ooxkQSnc
         cBQRcXrJjstf55LXZAlMcyIhxOpE6YYKifL1xeH+e1dK14Ov109KSJupIbp/QdcMnQqZ
         0N2lTnXTJ+TMFmhE7aNSRLphdhOe+0NtTjA64JFAzT33MIFovAAydDxADk/LoO+47lA/
         jc7i0NOtVyGjUOoIbi1voxag75F+JjahEdrzGjCFGayzefrc62C/WgnaDUbwVpwNMGbi
         3bLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576084; x=1785180884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/c51hvMQmc3XHuoW6uDjvccdoKFQfSnHZbbwUxq30Zg=;
        b=JEuYIm2hGm5pANVIr9DXzqST0XUn5ZxZBTB0M3HXGfmdr29fJ2TsFX+MVkbVG+Yst9
         T7alTpPorfhxBK0IO7ofLGupr4f+wZVZDaIa/Xy3g1wFmzUMfA2L6OCcNp35b8J+dn55
         PrDa9IWK8ILohHhWSAx2S19/5BPyBi0MU6Mhm9P2DpSwmIiIArcRqmB83kvyVvYe70n9
         fqDOp1/1lI2mmseP4B1rNHAIGOpf0Ew2Ja7FAwnAxE5h5C/DWSfuFcsj5sM0wk+SBsRy
         wTfqiuGF21hxLnKANvWn4HTha7864Na+zMdANxnmRqYCqmnREXUgrdBBc5HygmeLL02h
         N0cQ==
X-Forwarded-Encrypted: i=1; AHgh+RofRiX8O36M6TCljcTgkKkjGIqUt1VB4ceyKKEGW360ficu4W4QBmje5C1S5W0496GC1yfYUQvw@vger.kernel.org
X-Gm-Message-State: AOJu0YwIh2Wd3z2bDbdkusymjudl6nqvNOanw3ZYFLNwBHERosr6YEeJ
	blZ35v7SU5TPNezfnu5R0he1Vr7pVSWZYTxsM9vAyXnF+DwA4ddViWlTfJMNKksb4Es=
X-Gm-Gg: AfdE7cnylFtTm1lSm2zW/PXb7ZrWjKkGHbt8twonwIKMFgZCT82yEhMVQIkEPRnVuR3
	8l0/gGA6urUoB1JJkIPv/AEocH7vP4QAPeWAuP0DIg67FJkyeTFRuUSQaFCmDpjfQqdvhS+FSky
	QKs5YutUSInb1knxPdY4xIWmWbk/kNE6nFAgG2P7PyXDYoo+AWfiKd7y2sZ7gg8JXljw7YbUo8U
	N0zQ0LFEkV5DQLlYKiQ1T7xo7hEOz72ILXd7334KTH8d72xxCD45zF8YNSpaYjV5jTLz4Qgm5KR
	GsW0TALykY+eXmrw3tjnlIawiE4oOAcfG2wGfA1y2rccZNbZ/h8PrL3iyBfe600mSMrUS3rbSL0
	V51KtGHxZuvQQxb1Kv1/CJN+IYwBDH/22Pwg7l3SGCqRLwSj3Y5pNDr4M23qWZeqcI5TecziOqt
	jKqKFXEfpms0GK46McRdfThSHYJJ4MzJWmogR33enkr2+RAFZLjwUs0kolrU6CPpNX/9kIZopvq
	w==
X-Received: by 2002:a05:620a:1a19:b0:92e:c118:18bb with SMTP id af79cd13be357-930b43dfc05mr1508161685a.90.1784576083785;
        Mon, 20 Jul 2026 12:34:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:43 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 02/36] mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
Date: Mon, 20 Jul 2026 15:33:56 -0400
Message-ID: <20260720193431.3841992-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract per-node fallback-list construction into build_node_zonelist().

This lets use build zonelists from candidate nodemasks instead of just
the default N_MEMORY node state list.

No functional change: build_zonelists() builds the same FALLBACK list over
N_MEMORY with node_load updates as before.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index acf096f525f49..4c1ef84c02a3d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5813,12 +5813,12 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
  * DMA zone, if any--but risks exhausting DMA zone.
  */
 static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
-		unsigned nr_nodes)
+		unsigned int nr_nodes, int zlidx)
 {
 	struct zoneref *zonerefs;
 	int i;
 
-	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
+	zonerefs = pgdat->node_zonelists[zlidx]._zonerefs;
 
 	for (i = 0; i < nr_nodes; i++) {
 		int nr_zones;
@@ -5847,26 +5847,28 @@ static void build_thisnode_zonelists(pg_data_t *pgdat)
 	zonerefs->zone_idx = 0;
 }
 
-static void build_zonelists(pg_data_t *pgdat)
+/*
+ * Build one node-ordered fallback list from a candidate nodemask.
+ * update_load round-robins node_load across equidistant nodes.
+ */
+static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
+				int zlidx, bool update_load,
+				int *node_order, int *nr)
 {
-	static int node_order[MAX_NUMNODES];
-	int node, nr_nodes = 0;
 	nodemask_t used_mask = NODE_MASK_NONE;
-	int local_node, prev_node;
-
-	/* NUMA-aware ordering of nodes */
-	local_node = pgdat->node_id;
-	prev_node = local_node;
+	int local_node = pgdat->node_id;
+	int prev_node = local_node;
+	int node, nr_nodes = 0;
 
-	memset(node_order, 0, sizeof(node_order));
 	while ((node = find_next_best_node_in(local_node, &used_mask,
-					      &node_states[N_MEMORY])) >= 0) {
+					      candidates)) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
 		 * distance group to make it round-robin.
 		 */
-		if (node_distance(local_node, node) !=
+		if (update_load &&
+		    node_distance(local_node, node) !=
 		    node_distance(local_node, prev_node))
 			node_load[node] += 1;
 
@@ -5874,8 +5876,22 @@ static void build_zonelists(pg_data_t *pgdat)
 		prev_node = node;
 	}
 
-	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
+	build_zonelists_in_node_order(pgdat, node_order, nr_nodes, zlidx);
+	*nr = nr_nodes;
+}
+
+static void build_zonelists(pg_data_t *pgdat)
+{
+	static int node_order[MAX_NUMNODES];
+	int local_node = pgdat->node_id;
+	int node, nr_nodes = 0;
+
+	memset(node_order, 0, sizeof(node_order));
+
+	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
+			    true, node_order, &nr_nodes);
 	build_thisnode_zonelists(pgdat);
+
 	pr_info("Fallback order for Node %d: ", local_node);
 	for (node = 0; node < nr_nodes; node++)
 		pr_cont("%d ", node_order[node]);
-- 
2.53.0-Meta

