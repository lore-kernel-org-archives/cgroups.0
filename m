Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793353970;
	b=LqJAQSvIqbqHHHssAiZSz4u3qr021GL0BGrY8DE/5s0MkXYx//ptkKZQYKnIVseTfikx
	 hUI1UaKg8xWqz1u2VxsWmAevSliE/wZDiiLkjlBwqvvVbwSzVp/rRM26fAk3pKPEqDY6W
	 H4mOZv5zk8ccKyvIO8setkbT/S0PTLUpOYR3cvV5tMg1PoFUWgTJHq1xdZY97CrNjVkub
	 evTUPud7qkTPZEGD9b6pQyFtcw8Fu4YmEcCLcWxQTTEZjYiiWzAc6SOWoQeCmPyREd9ut
	 pr4JHWx5A1pzStBG7vP4yyQtIMSgW4xlCkvptwPKMkYZ84Z8gn2wwEnioPM44q4+Iaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793353970;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=a5h34MN+qOPMphkpctmq7PgnicM+ioLs6tA1qYi+SyA=;
	b=ek9spPyN4kBMsofqWG+2SuvDetdIunPlyLa6G2cHISMBut2Ts9SiCr4H6MvEo/2xaYwD
	 0FU6L3st84GdR1r0Qp5m/TtDW4li+j45h19hefk+d6cEBZlLTsakYzk+vXKn+mQ9SxpJv
	 vlcRQrD8inScnIJXOG+mlmvWoqqK8GnR6bqp5ZwQ97+0CwXvhGw6ZPwDDOFVYRbMcy17M
	 w9pCYwv3KVaaRiodCtg6jmWPpGxMVCacbK2bM4ZZH1VjLUUQFU6IZMsOZs76yRY80L6vs
	 /IKKRY5y28N15CCHBaaELCfOfCLrOk+KE27x6Ye8Dseom+oLUcKSF7fA/8ZfcCplpKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e7ZtoHmT;
	arc=none smtp.remote-ip=91.218.175.119
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA72606A329
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 09:52:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDA72606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e7ZtoHmT
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=foVTesr/V5lJ4MJRpdzJaGLpzqZmZIMatmV4b2e35so=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793353967; v=1; x=1793958767;
 b=e7ZtoHmTO5KUTXLAQ+JZAKb7lcSrMohTBaA2G1mfILdQDyCAG7ETgPeUItwiTj8Y+UudbeeL
 gkOKM7+uoVfERNo66453F5aFgUchwU291ViOH8J2LgK1dppw+vfDwRV++VRNYcJDsiXdb+srAkV
 iAVrx+Vk1PP7MsTO9HvfVOio=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c362bb1e45826fc4;
	Fri, 30 Oct 2026 09:52:47 +0000
X-Mizu-Trace-ID: c362bb1e45826fc4
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-new v1 1/2] mm: memcontrol: split mem_cgroup_may_zswap() out of obj_cgroup_may_zswap()
Date: Fri, 30 Oct 2026 17:52:17 +0800
Message-ID: <20261030095223.325309-2-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261030095223.325309-1-jiayuan.chen@linux.dev>
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
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

zswap_store() asks obj_cgroup_may_zswap() whether the memcg is under
its zswap limit. The next patch wants to ask the same question from
reclaim, where it has a memcg but no objcg.

Move the walk into mem_cgroup_may_zswap() taking a memcg and make
obj_cgroup_may_zswap() a wrapper around it. Either way the answer is
the one zswap_store() gets.

No functional change.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 include/linux/memcontrol.h |  5 +++++
 mm/memcontrol.c            | 26 ++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..dab15db2c61a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1943,11 +1943,16 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg);
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
+static inline bool mem_cgroup_may_zswap(struct mem_cgroup *memcg)
+{
+	return true;
+}
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..f32105a08a91 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6261,8 +6261,8 @@ static struct cftype swap_files[] = {
 
 #ifdef CONFIG_ZSWAP
 /**
- * obj_cgroup_may_zswap - check if this cgroup can zswap
- * @objcg: the object cgroup
+ * mem_cgroup_may_zswap - check if this cgroup can zswap
+ * @memcg: the memory cgroup
  *
  * Check if the hierarchical zswap limit has been reached.
  *
@@ -6272,17 +6272,14 @@ static struct cftype swap_files[] = {
  * spending cycles on compression when there is already no room left
  * or zswap is disabled altogether somewhere in the hierarchy.
  */
-bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg, *original_memcg;
 	bool ret = true;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 
-	original_memcg = get_mem_cgroup_from_objcg(objcg);
-	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
-	     memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long max = READ_ONCE(memcg->zswap_max);
 		unsigned long pages;
 
@@ -6301,7 +6298,20 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 		ret = false;
 		break;
 	}
-	mem_cgroup_put(original_memcg);
+	return ret;
+}
+
+bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+	bool ret;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return true;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = mem_cgroup_may_zswap(memcg);
+	mem_cgroup_put(memcg);
 	return ret;
 }
 
-- 
2.43.0

