Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315678;
	b=JogP/RofqdK1oPbmx8Yh4dr7gEA5UE9DYyRUlaaReL0xY3XFsxv/608q0PhDc5+Oider
	 Q1CWb+7B4WJhD8upY7UCS1fkQUEeBkhABqTxvP/8EB3/rGuTpODTJzMsKEBQXxvu2hI8+
	 2+zSJVj5hvjMTZ67PGIwHzjn2MuKXllNGerAn76DKJf2wKIF0rSsJnu6Qbv4p/4JGSNwn
	 vPe9r7vAZ8k5AR6pScM1+F6PXHhZJOEzmFvNYsuN/FNzwheovwRKHQval9JgPcp7fhGsn
	 V/RxZj+Gzo7h/l+y7mQ6htBfvsR1Hi4Glw2T0CH1pL+PbGUWpT2gOM8zFsPD1teRTGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315678;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UXpp8sp/GRVRsUtSepKaptGcuvVFgYldxI029IWKwww=;
	b=J4Ncx/FK/Rxdilniqb+8jlqiVVhkennRSjkVxzQ+6b8QcDgEtYxQnMFLj+vufOuulNdA
	 wcazPQ5EZ5TZ0toU4Lq8iD67RVLrkPFC7NDu4b/HWE8bDsbbn0Vj+w5+i+pRBS4T2BpS/
	 2RVg1p8vheBhz6Ul6hrs9Qttx35WbETPxBhDdv6R+ra11o4jGSVEPlfGKpDUUtCPQzVSf
	 nlklS9kiV0nLQIhHuaUvNPn/MMwQey/mryQFQ3AcXu9FYp/ZpRxv4F6m2EB1OT0S+dh43
	 2Bx5Nhotok5nin29eIX4hrp6tWvVr7dIEN6M+xXUH5FgbpsAVyK9istTYHrJtXANYFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SB3XWdtX;
	arc=none smtp.remote-ip=91.218.175.184
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C16606A690
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 02:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1C16606A690
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SB3XWdtX
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4VmPcRtrp5VsXyo2a9LQORInZeHKK19ZabzxdfHobDU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315676; v=1; x=1795920476;
 b=SB3XWdtX9vVAhV2yqIyXR+Z3FAT3/zOTjYraEr2dZNCwA6Bf6Tyn/9wM94ZqX1O3zQFQDyHK
 w+qv72ybnzH9+o2vqiQ+uVhC/3MoHj0fm0ZzoW+xl/oBGO1XZ8JfBvM2xoNMl5z7VKJu3Odj5Cv
 /kJz20WwIl4HstMbzIeJdiL0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6514b70c0cb31dcf;
	Sun, 22 Nov 2026 02:47:56 +0000
X-Mizu-Trace-ID: 6514b70c0cb31dcf
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/7] memcg: add helpers to handle memory.high overage in long operations
Date: Sat, 21 Nov 2026 18:47:31 -0800
Message-ID: <20261122024737.2741569-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit c9afe31ec443 ("memcg: synchronously enforce memory.high
for large overcharges"), a charge that can block handles memory.high
overage right away once more than a batch is pending. It reclaims and
sleeps with whatever locks the caller holds, so tasks in other cgroups
that need those locks wait too.

A later patch removes that step. Operations that can charge a lot in
one call then need another place to handle the overage: a point in
their loop where they hold no locks, or only the locks of their file.

Add two helpers for them. mem_cgroup_over_high_pending() says whether
more than a batch is pending, the threshold the synchronous step uses.
mem_cgroup_over_high_throttle() handles the overage if so; its comment
says where to call it and which gfp mask to pass. Export
__mem_cgroup_handle_over_high() for filesystems built as modules.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 34 ++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |  1 +
 2 files changed, 35 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..77115fe1873e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -942,6 +942,31 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
+/*
+ * True if the current task has more than a batch of memory.high or
+ * memory.swap.high overage pending. Each charge that finds overage
+ * counts at least a batch.
+ */
+static inline bool mem_cgroup_over_high_pending(void)
+{
+	return unlikely(current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH);
+}
+
+/*
+ * Handle the current task's memory.high overage if more than a batch is
+ * pending, for operations that can charge a lot before they return to
+ * userspace. The task may reclaim and sleep here, so call it only where
+ * other tasks won't wait for it: with no locks held anywhere up the call
+ * chain, or only the locks of the file being worked on. Pass GFP_KERNEL
+ * if no filesystem locks are held, and mapping_gfp_constraint() in file
+ * read and write paths.
+ */
+static inline void mem_cgroup_over_high_throttle(gfp_t gfp_mask)
+{
+	if (mem_cgroup_over_high_pending())
+		__mem_cgroup_handle_over_high(gfp_mask);
+}
+
 unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
@@ -1376,6 +1401,15 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 }
 
+static inline bool mem_cgroup_over_high_pending(void)
+{
+	return false;
+}
+
+static inline void mem_cgroup_over_high_throttle(gfp_t gfp_mask)
+{
+}
+
 static inline struct mem_cgroup *mem_cgroup_get_oom_group(
 	struct task_struct *victim, struct mem_cgroup *oom_domain)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..6d147153bd06 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2707,6 +2707,7 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 out:
 	css_put(&memcg->css);
 }
+EXPORT_SYMBOL_GPL(__mem_cgroup_handle_over_high);
 
 /*
  * Called after @nr_pages were charged to @memcg. If @memcg or one of its
-- 
2.53.1-Meta

