Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9AB3EA955;
	Fri, 26 Jun 2026 10:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782469725; cv=none; b=jaGQfQenSLO+AWdxB53wVm7Yo53C893iZofpJrYPHRm+De1F1bxSIAvqf91DGuNFQ1j7W+WJqUFA4IlX5nphdik6LOHljiBpyZzchs2F6mKkpAPW2Psct4VF2wj1xi7GER6WO0yWNwz+wiyycCsNzR+C/MjdLYi7CwhxJq5cCfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782469725; c=relaxed/simple;
	bh=qAh6YJSDnTyx9ziOYYwMYWr6tkKB5Pd+Z9m4uXeBldg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtWpBdXVcf7+lOIbwKui5UL9XjaQmNQ1uBc5vMx0VQQ2OmNgyWKKO7LjM9mI4SNCiTfU7hxIyTg/2KdBIftdulWREzjPpjzcAYTmfqpXLzbcsaUAxuMNcaN7LTH62qXLrpihNNf3kBJOt3crJbxssoXoP4HyHmfwZaEfpH2aTQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id C680A3E97D;
	Fri, 26 Jun 2026 10:28:33 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 4/9] mm: percpu: Split memcg charging and kmem accounting
Date: Fri, 26 Jun 2026 12:20:53 +0200
Message-ID: <20260626102358.1603618-5-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGnYIDq9A11TftEatbke2wSLsM4U/RRnbCHpAUAIQBwHbVmowa+ke86M8Z6PPn5o7UKBvUMbr2gZWgcRiFc7ixLzqgLUvmoF1f6yq0GAxvM7ym0xa3n5f10aBqF/6aF0YuddnSkH5x50aCnRuJBlmRRybtyRnTHEtDjNABLsbF8/J37ko6Bm3zG+eW4NfAtWrkoIM0OVuVjH1i1R2t7kHuPQJtjQvB5ayDwVI8gcfE8wIDI8ctauyWpfQVDC9X4EX6LKQuBwn+BvrBeBO0dxg0WQvW3qtFakFlV8vs7Ehg02InoNEqwXY73y16xKIg4BKzVJqVRXZF2evXpKGHtjYSRNxlbUiwuS2sOBwb5wzBvPVvTjrFl2004zwsSACTxdhfQeaavFBDsBF/b3hO966Jk2xT286aRYLCJv6XwNbFEkAfxCaBELfb9yeTEv+1sqCgoZ0XBPTFLOkXm7zqbESobHistHSi0hRUaSIx9L7tENTV9ORLM0vsetphGk4KGc5C/n2ebSZtv4nRM5KVpX3vblXPWGGn5TDd+TjYRALl4wWch4Sqf6eVD/d0rtPP660OvESHW0Y7XELo8EckP8J2Ajbj4waaKFEqb5ifOJcGIODUI1k0zpSRXko+dJ2mRwIidMIWaKZILquumPc3Ip5SsGQ+sISDnb13Fg8RlO3qHxg

This is preparatory patch for upcoming per-memcg-per-node kmem
accounting.

Percpu allocations charge memory before knowing which NUMA nodes the
pages will land on. So we need to decouple the memcg charging from the
kmem accounting:

1. In the pre-alloc hook, obj_cgroup_precharge() reserves pages for
   memcg limit enforcement without updating kmem stats.
2. In the post-alloc hook, obj_cgroup_account_kmem() accounts kmem
   and places the sub-page remainder into the obj stock after the
   allocation succeeds.

Because of that decoupling, we must not rely on the stock in the
precharge function and always charge the necessary pages that will
be accounted after the allocations happened. That means we may
temporarily overcharge the memcg but the obj_stock draining will get
things back to normal.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/memcontrol.h |  4 +++
 mm/memcontrol.c            | 50 ++++++++++++++++++++++++++++++++++++++
 mm/percpu.c                | 15 +++++++++---
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..8f419ee54510 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1704,6 +1704,10 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
+int obj_cgroup_precharge(struct obj_cgroup *objcg, gfp_t gfp,
+			 unsigned int nr_pages);
+void obj_cgroup_unprecharge(struct obj_cgroup *objcg, unsigned int nr_pages);
+void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages);
 
 extern struct static_key_false memcg_bpf_enabled_key;
 static inline bool memcg_bpf_enabled(void)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3bcc20e72914..480fba12a217 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3536,6 +3536,56 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 	refill_obj_stock(objcg, size, true);
 }
 
+/*
+ * obj_cgroup_account_kmem - account KMEM for nr_pages
+ *
+ * Called after obj_cgroup_precharge() when the allocation succeeds.
+ * Accounts KMEM for nr_pages on the objcg's node.
+ */
+void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	account_kmem_nmi_safe(memcg, nr_pages);
+	memcg1_account_kmem(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
+/*
+ * obj_cgroup_precharge - reserve pages without KMEM accounting
+ *
+ * Reserves page counter credits for limit enforcement. Does not update
+ * KMEM stats or the per-CPU obj stock, because precharge decouples
+ * the page counter charge from KMEM accounting (which happens later
+ * per-node via obj_cgroup_account_kmem).
+ *
+ * On failure, use obj_cgroup_unprecharge() to release the reservation.
+ */
+int obj_cgroup_precharge(struct obj_cgroup *objcg, gfp_t gfp,
+			 unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	css_put(&memcg->css);
+
+	return ret;
+}
+
+void obj_cgroup_unprecharge(struct obj_cgroup *objcg, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	css_put(&memcg->css);
+}
+
 static inline size_t obj_full_size(struct kmem_cache *s)
 {
 	/*
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..01c87e39d366 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1625,7 +1625,8 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
+	if (obj_cgroup_precharge(objcg, gfp,
+				 PAGE_ALIGN(pcpu_obj_full_size(size)) >> PAGE_SHIFT))
 		return false;
 
 	*objcgp = objcg;
@@ -1640,15 +1641,23 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		return;
 
 	if (likely(chunk && chunk->obj_exts)) {
+		size_t total = pcpu_obj_full_size(size);
+		size_t remainder = PAGE_ALIGN(total) - total;
+
 		obj_cgroup_get(objcg);
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+				total);
 		rcu_read_unlock();
+
+		obj_cgroup_account_kmem(objcg, PAGE_ALIGN(total) >> PAGE_SHIFT);
+		if (remainder)
+			obj_cgroup_uncharge(objcg, remainder);
 	} else {
-		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+		obj_cgroup_unprecharge(objcg,
+				       PAGE_ALIGN(pcpu_obj_full_size(size)) >> PAGE_SHIFT);
 	}
 }
 
-- 
2.54.0

