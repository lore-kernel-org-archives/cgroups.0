Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792426323;
	b=33bunp8BZUeskxhi3q8wsf3Gg1kR2F4fO6xavCHKQ/VY70OcUi15bvL/zCD9ipcTSdCH
	 RCtlUAJup98BxABdvxQgIsVsaBNedpnxDoj69UvhaLypEiokf+51ItNfw9d3/6x8yZ7aA
	 pGO1Kw28bYX2oMBQTNDZJZCPFrq/TEIhCopWVnPZqzW25TkgYTlkmH6q99e+jD/9nlVoM
	 BmliEAhzSwLq3aLaQG53NeunmBvXpQYUlfs6+9HhBRT6FniAgXBrgWxOnG8kuvwGceFoS
	 SGvb+4gMn/vvFD5bJdDrhJHkSYaAJ7E+82tu+oqP6seHrOIvFgh5sUEA+3zpOZnANGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792426323;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=CDrohwjJTpsso8SgDTwYh9k//AsOTFOPCFpSoWxu9xY=;
	b=jcoxuzoOjIEShOZ/lJq6yKA7wGGRtMmX68XCAhTmAqcT28pmPl3TN+CfVhsosa9AyPAb
	 faueIlRHbMK0ZgymxK294/ggX4hqv/GX3yZAVSUd85WXvuVfO1+Dpo/LyZVFfGzgLPuQR
	 CcB8YseOuFikI5w6zC6h3io6WyCNFMCiTU66jatNspx07354kkeH5vhh0rzz/v05hPbKV
	 aB5XjheRQEiVrOLV51Lh94iGr/6/xENKp0/XZJgIVYGMLeayE8rPWnS9V1BSvOPy9dBM3
	 nbL9hZ4VgtH3EEIfZtXdP6YLR2OcdpEjMscV9o6O9s1WOKoRZcwk25Aro2ao2UiYSHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=mrUcQDHo;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6578B606AF8C;
	Mon, 19 Oct 2026 16:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6578B606AF8C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=mrUcQDHo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=CDrohwjJTpsso8SgDTwYh9k//AsOTFOPCFpSoWxu9xY=; b=mrUcQDHoDdhAxO5d5pT
	N4DrI8T/1uGOrNTpfFOL6qpIFU404DQlweHurDW2pcJAEdzNbVT3XmuZYqgyGk9k3tzucoNhFnkR1
	cDMY2lBcoNwmwHkL92bYBomIt0sogQPMK8FFVQkzcPjUqB17qAfI2dk3uWWcTgcA23XMBzh/u1klD
	ALJXOji8fYkLa4oXelQgS9QMxeN8icD0IyDmZt9nrUGdiibupnCJEX1dJAfIdiUfmVQsSFiV3Tf55
	yXdhB4OazT0t/Osbr+2qqrk4iOmOPOGyIYgy+iiz5FS9kKHgqQi6E8mEwSqtPKm3USDDCQLaB4Wc0
	2wFgFSsPILVIrig==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xIpuE-005W7Y-2G;
	Mon, 19 Oct 2026 18:11:42 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 19 Oct 2026 18:11:44 +0200
Subject: [PATCH v3] mm/shrinker: allocate shrinker_info_unit from a
 dedicated kmem_cache
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
X-B4-Tracking: v=1; b=H4sIAD9B1moC/yXNQQ6CMBBA0auQWduEUijqVYxpoE7tSGjJtBATw
 t2tunyb/3dIyIQJrtUOjBsliqFAnSqwfghPFPQohqZutKylFlvKkYVs2152InmmMCEbCi6aNVA
 W04yzsYP1KPQFB+X686hVByW4MDp6/2a3+99pHV9o8/cAx/EBwWIgko4AAAA=
X-Change-ID: 20261016-vstor-144715-shrinker_info_unit-kmem_cache-69ea3f78b635
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4716;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=A02/K9KBXa2vsDlxYeUgtKBEVpOgUV2FhLca4x06Ks0=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq1kFGx9BvQsfXRTLTJ30NLwN8MLEz/PrdwIfXC
 y763+LJIu+JAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatZBRgAKCRBRlgpH+WFc
 Kr/6D/9d6PZqCp6vtGcQOvsbJvB0d6vZcjylCrCPwKSyjLvdu765yH5uakjNmj/1qF5YqbqczOR
 TZcjSs6xzH2nMcbs6PN3ShXsWKlOSl8Ywx6H2aWBIRTefbXQ0YW2nec6HdwO9nyivcNiuXEith8
 ZRjj8Xwa475s/DLxl5fYjUdpEXP1hZHzYFFpWH819GkOm9Xm5rHGQJRVySQcCaHdOx48IkjV9mf
 rbXX8XTSoF6h2qdi7SircBvupck0IFXvWPFLHWu3Dp8S2XkYVFqjhYigMZ27hYTQPLdeh5acjFu
 EM1L/pNePbFrTxdMX0/y7gnyZAPnn9ARrpHF3Wfk++0hXw7g765IVtGCA5CZge8M+tWn14Dmj6f
 FNAvs5aSV4lUYXwICfDS9dxS7aaAcaUyIhUWKK+e5oDAgB2qAyH9Wn76UwWGqtLX3A9qLN06YGS
 /63yQ/H6jkyJyWqH070a/9olC0rci2uLoJQr/yPp+6dxj5jrdB7BrsIGHd85FlzF1mvZfUDAw4s
 VsqmSxt9pmKt1q3NjEoOislEo1E0eTVVJsMqIx0r0FQJJP4rbfBCqNPVgL5jBQ7yTJ+jymuIcDF
 pEE5SENtgRRV6/wo4cTqoMi2Tl80hHEfQXzdL5ipXabRqeKvoPTANdbUFm/PM+xZInWFNDrzLVz
 WKWuizsDy8Zoezw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

shrinker_info_unit holds BITS_PER_LONG atomic_long_t of deferred work
plus a one-word bitmap, 520 bytes on 64-bit. kzalloc_node() takes it
from kmalloc-1k, so almost half of every unit is padding.

Allocate the units from a cache of their own, sized to the unit. The
cache is not cache-line aligned: the counters of a unit already share
cache lines between shrinkers, and aligning the unit would only keep
neighbouring units off each other's boundary line, at the cost of part
of the saving.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
This is v3 of patch 1/2 of "mm/shrinker: make per-memcg shrinker units
cheaper", sent on its own as Andrew asked in the v2 thread.

Patch 2/2 of v1-v2, "mm/shrinker: allocate the per-memcg shrinker units
on demand", is not part of this posting. It is the change that makes a
memcg pay only for the shrinkers it uses, and it is discussed separately
in the v2 thread.

Tested on a 4-CPU, single-node VM with the test from the earlier cover
letters: 8000 tmpfs mounts, then 2000 empty memory cgroups. The units
move from kmalloc-1k to the new cache, 31 per order-2 slab, and the
unreclaimable slab per cgroup goes from 144 KB to 87 KB. Removing the
cgroups and dropping the caches returns the cache to its earlier size.

memory.reclaim on a cgroup still frees its objects on 140 ext4
superblocks, and cgroups making their first objects while mounts keep
raising shrinker_nr_max leave nothing in dmesg, also with
slub_debug=FZPU on the cache. selftests/cgroup test_memcontrol passes.
test_kmem_memcg_deletion also fails without the patch, by a similar
margin.

Changes in v3:
- Allocate the unit from a dedicated kmem_cache instead of shrinking it
  to 63 ids so that it fits kmalloc-512 (Andrew Morton, Muchun Song).
  New subject, since the unit keeps its size.
- Link to v2: https://patch.msgid.link/20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com

Changes in v2:
- Patch 1: check the unit size with BUILD_BUG_ON(!is_power_of_2())
  in shrinker_unit_alloc() instead of an open-coded static_assert()
  in the header (Muchun Song).
- Link to v1: https://patch.msgid.link/20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            |  2 ++
 mm/shrinker.c              | 11 +++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a88..b5a89594c263c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1675,6 +1675,7 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
 }
 #endif
 
+void shrinker_unit_cache_init(void);
 int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586cc..7a817181168ed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5717,6 +5717,8 @@ int __init mem_cgroup_init(void)
 	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
 				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
 
+	shrinker_unit_cache_init();
+
 	return 0;
 }
 
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7ec2a9704f6f2..4fb424e721bca 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -12,6 +12,12 @@ DEFINE_MUTEX(shrinker_mutex);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
+static struct kmem_cache *shrinker_unit_cachep;
+
+void __init shrinker_unit_cache_init(void)
+{
+	shrinker_unit_cachep = KMEM_CACHE(shrinker_info_unit, SLAB_PANIC);
+}
 
 static inline int shrinker_unit_size(int nr_items)
 {
@@ -33,7 +39,7 @@ static inline void shrinker_unit_free(struct shrinker_info *info, int start)
 		if (!unit[i])
 			break;
 
-		kfree(unit[i]);
+		kmem_cache_free(shrinker_unit_cachep, unit[i]);
 		unit[i] = NULL;
 	}
 }
@@ -47,7 +53,8 @@ static inline int shrinker_unit_alloc(struct shrinker_info *new,
 	int i;
 
 	for (i = start; i < nr; i++) {
-		unit = kzalloc_node(sizeof(*unit), GFP_KERNEL, nid);
+		unit = kmem_cache_alloc_node(shrinker_unit_cachep,
+					     GFP_KERNEL | __GFP_ZERO, nid);
 		if (!unit) {
 			shrinker_unit_free(new, start);
 			return -ENOMEM;

---
base-commit: a5ebb76233b79db01e82e061173cb73c6d2b5c6b
change-id: 20261016-vstor-144715-shrinker_info_unit-kmem_cache-69ea3f78b635

Best regards,
--  
Konstantin Khorenko <khorenko@virtuozzo.com>

