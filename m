Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465DD2D3733;
	Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723140; cv=none; b=NhfVbkkLCraAQNfUslvo6bpOBFS62tBwVNR6H1mmYtaM8DJaADE1nd/NFQYD3Wpw7OwmaxKzdP7xBMH/cldjYjprAr35lu6orwfKCTvNrNpJxNkKkApXDFzvODSJoTlJ/aC2RyokwcgBm4+05ukfTp8bM2+scBC5mEAY6woyHug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723140; c=relaxed/simple;
	bh=hP6DiKHP1Uc9RaIourNerlT7Ph3Y4wow5AD623XN+Q4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jGZMR6tOfJv4jZ/186ZKZ5ejf501wBQ1QBW4kIIEpXNYGp8tMEhvr3yJSWzPHx0cwoUZaDlmlv+s0NYosh85xKCFMQ6CR8O9jt05y/UPf5nFasWeIclzwf9ezAkbv5a8gntitually+9424NwOQa3hHAszM6qwieMUEaJkydb7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8LdeBNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8LdeBNK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E65F2C2BCFA;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789723140;
	bh=hP6DiKHP1Uc9RaIourNerlT7Ph3Y4wow5AD623XN+Q4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=B8LdeBNKdJ3wtDnDHMchqGFjCuVjH+ToJvR9NcjyNddJoI0ChMUK/+FuRdpLmhLZc
	 yhUJ/YGWXVDH+Q1wpphFoz9r0SXG+09ZwHeC5XE4+PVK4abKNq7xBKL+zynXwRsLWr
	 Gem1ckC/EH5GRXhMMYols2acGK4bz9v2vXI36LJ3qbt0gm2KLsmVqyJPoNI0Ls6QCv
	 qIfAtfAtBqWUSXma0Sdhn8aOg79DsprrH1jzJovrb/W1YlDRkmI178pdoAC9Tlf+5O
	 KpBss+BXIOD4xBFxtHQUPoExPpiWJ2GjEltHUMGcCqcAtXoNhifvG73+P5T4B+5Z3h
	 AichhMGyW0G3w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8875C982DA;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 17:18:41 +0800
Subject: [PATCH 2/4] memcg: base swap charge accounting on memcgid root
 status
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-bingfangguo-memcgid-rework-v1-2-5bbf3220d88f@tencent.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789723137; l=4703;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=keWbZOvEsjhpQI5UWIYf9RawqjSwL3RBr8uJHFAQWMQ=;
 b=spR77VUIfZyg808RonfMqNMBmWjRn22uOgEi75/oCt05YRBn5v7VOpT0U5xctGim4lOhcb34P
 9tx7NAgCxj3CKbd26yb+ucyOUe/EXqt7knbMtop9nI0dd3yyJH4dRvV
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

A private ID currently pins its original memcg, so testing whether the
ID belongs to root is equivalent to testing whether the resolved memcg
is root.

That equivalence will no longer hold when IDs refer to objcgs. A
non-root ID may resolve to root after reparenting, but its swap entries
still carry counter charges inherited by root. Skipping their uncharge
based on the resolved memcg would leave those charges behind.

Use the private ID's root status to decide whether a swap entry carries
a counter charge. A root-ID entry carries none, while a non-root-ID
entry must release its charge even if its current accounting memcg has
become root.

This patch adds a new helper to check if the memcgid equals to that of
the root memcg.  For swap uncharging and v2 swap charging, simply decide
whether to charge/uncharge memsw or swap counter based on the swap
memcgid is root or not. For v1 swapout, don't recharge the memsw
counter, just cancel the charge if the swap memcg ID refers to the root
memcg.

This makes memory and swap charging have similar semantics: one relys on
the objcg's root status, and the other relys on the memcgid's root
status.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol-v1.c | 16 ++++++++--------
 mm/memcontrol-v1.h |  5 +++++
 mm/memcontrol.c    |  4 ++--
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b1..ed015fdd95123 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -271,6 +271,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	struct mem_cgroup *memcg, *swap_memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
+	unsigned short private_id;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -293,25 +294,24 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
-	 * ancestor for the swap instead and transfer the memory+swap charge.
+	 * ancestor for the swap instead and cancel the memory+swap charge
+	 * if the ID refers to the root memcg.
 	 */
 	nr_entries = folio_nr_pages(folio);
 	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
+	private_id = mem_cgroup_private_id(swap_memcg);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
-			  mem_cgroup_private_id(swap_memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
 
-	if (!obj_cgroup_is_root(objcg))
+	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg != swap_memcg) {
-		if (!mem_cgroup_is_root(swap_memcg))
-			page_counter_charge(&swap_memcg->memsw, nr_entries);
-		page_counter_uncharge(&memcg->memsw, nr_entries);
+		if (mem_cgroup_private_id_is_root(private_id))
+			page_counter_uncharge(&memcg->memsw, nr_entries);
 	}
 
 	/*
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 2cd37e1792d79..23be2512702dc 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -22,6 +22,11 @@ void drain_all_stock(struct mem_cgroup *root_memcg);
 
 int memory_stat_show(struct seq_file *m, void *v);
 
+static inline bool mem_cgroup_private_id_is_root(unsigned short id)
+{
+	return id == mem_cgroup_private_id(root_mem_cgroup);
+}
+
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 72522ec827c9a..bfe53e4392f09 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5976,7 +5976,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	/* memcg is pined by memcg ID. */
 	private_id = mem_cgroup_private_id(memcg);
 
-	if (!mem_cgroup_is_root(memcg) &&
+	if (!mem_cgroup_private_id_is_root(private_id) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -6006,7 +6006,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
 	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
+		if (!mem_cgroup_private_id_is_root(id)) {
 			if (do_memsw_account())
 				page_counter_uncharge(&memcg->memsw, nr_pages);
 			else

-- 
2.43.7


