Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793661225;
	b=Si1Z27IZDmuoUxcs33WCJc/2ujamDC9WobGeGzj4jo7zMnY6d0d7oepDQbVxpVbjJTv8
	 4AKKNt7j8g1pAPxMHtBHFR/DboHrgHKXnEq353jRLCcfw+VC7XTP6oK9YOOj6o3uCLUxE
	 ArmaUDac0sUKm+yGcDykqy5evxMy/yJzIt8JxkCOULyo/t1K2XU6bH+jPM/f9DBh1H51F
	 4SNm0NB1QlbOOXhRFb0Hrv1l+e6HHRbwR037qWKIL2hvKcsEu0XsPpB0EOIJoRn1jTsoU
	 sji1HPh1MpqJUVYeqpmCl/MnxLAzP6LkJrOD9SkR4SRCt3kHdNcxUdSS9iwOeaUvEug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793661225;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=JcLuFHhw27HERXH0ZkmjvjZMMAATxckS1b23zRHt1ec=;
	b=JwMqR3PvQ1AUKJphv/zZTQ/cEtnFdMW90n+xAim5ALMT8ALNh81ymzVWMKjqYrOhgk8U
	 EP0+c07zY2BYN72RkbVB8gtjBPobVWuMG1OHPsfrdGBraP7wzOZfwTyC0NzZjECgphMeC
	 grud9aOOgR8ZPgtU+oYr+LVcIhu4tF+efviUsc538lcXTrWIZqqfnUYaQOZHbGvkVcKFf
	 OdIa9/oN9fcx3DG0a3T5WwPgWNmig2Le/8TLuhSVoLoBUEz+eKeHpTmunQrZyEbmGrt9S
	 8eqGohIvi18rRp+G1pg46z3BHm1cbr+uQT2s4gOwSSnvScOkOTQzlRYAcC+EH3Fl5cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=cCSq+FIV;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7CE606A326;
	Mon,  2 Nov 2026 23:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F7CE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=cCSq+FIV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=JcLuFHhw27HERXH0ZkmjvjZMMAATxckS1b23zRHt1ec=; b=cCSq+FIVgztQBXGHjc9
	J9lqFaU8kg3aabGctw6VG7NG5JiSSxsm2XYNGP8fvKH63780VAZ0XjU6SyqlnZQRqHnZsFkWRLJsL
	RoXP9dQtwG2HcCnCAOX3ZdB5Bh1m0uA6OmrKRGpzz7UJBd+jGRDWW9jMogZpn/8i+NIRbbxmSFERq
	3KBr5C2msJoCS9jPYECF0kbvyf6RKZqu7NnTzBsIO7BWIgmdWAPjiBQiiiEBBi2R2lmKuXsoLfMVS
	+UtEMnPKjxqXcnht/5i9O/qpPA+kbGi18pAjZXePg5C3oS7m+flNBeHP4T9zCUsusOda+yJLtUIth
	/0Jw4RC3GsTkydw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xO19a-00Ael5-1j;
	Tue, 03 Nov 2026 00:13:20 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH v2 0/2] mm/shrinker: per-memcg shrinker units in an xarray,
 allocated on demand
Date: Tue, 03 Nov 2026 00:13:18 +0100
Message-Id: <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-0-cf9b836859c5@virtuozzo.com>
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
X-B4-Tracking: v=1; b=H4sIAA4Z6WoC/62OTY7CMAxGr4KyxqipOg1lxT1GXaSJSw1q0nHSi
 B/17pMCEhdg+axPfu8hAjJhEIfNQzAmCuRdhnK7EWbQ7oRANrMoi7KWhWygq2BinCCF6BlkVSm
 pYEKGEUdzgjAwuUvG2VEM4B1YHLWzcNXM+gZ919tS6b2xdSOyJP/q6foM+G1fHObujCau1veC8
 W/OZfEzG2jV357ZSa7XrxUmCQXUFVrZq+ZHmeaYiOPs73e/M34U7bIs/3vX36M3AQAA
X-Change-ID: 20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-fbfd27a8cd69
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Harry Yoo <harry@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5869;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=l8oqwuaUy7RuuxR06b/KSffJSmt0GAqvDJ19zrGD2Kc=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq6RkWkXk3KAf4GavsGrXJmY1UgmJ0GLNDPQP9B
 PCANs4KYGeJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCaukZFgAKCRBRlgpH+WFc
 KgOSEAC82HYdytAXrqmBD615/PSf8PNEze9HKxSnwyzlVEyDEilcP2Pa4RVnPinQuw1Rqn3kQCI
 byPWe6nwXf12rHz979r8RI6nU9N9Sx/JWzsCvhiSvcT/q2yID/caPXTyMB3fd4wiA2at0earxf/
 zYrvMQZKVLeKyxgilZUDhquqrCNAs2isudeH/PWTaGO82ViPt//NECLOsnwOVDCY20t8hAoNaLj
 jTwec53ZsZZCli2ZmEb1cTwnu4S4hgK/ex1Ks/9YugwOILZZGbF8rKSJfaEQjpoG5a74EKRLldC
 5k95cCdP/FmaFyfoCx3Duo1vZDpiKhGhvXEMaLDtZjhd9xyz/cMYdDH2vbFdu2Sl7/CLAdCkuG0
 6zHtwF8a9KBbHg1vlQlp+Q+tUQiBij1UTYW9PJOp0ah2lzfxkK8gL1akncLfEoYyytMuOwfRF4i
 qydd8M82C3Y5XzCvBE4rRxAIXm4erzqXFx5OnSPkfYUm3afI08rwjfGiFiy7N4vLjdlc26MKoNA
 CArAnDvpfhumNiVqLkvszGpWiaevEYsP9S7Cy0sDN2SdPj8kW//bR1RKYtGdhZvUN37qXT1g9rR
 +32JPxr/QhA0baKJ8MwsZmvg2H6lvMAI+LyOal6CFTInnH28Nx5vn/UjguU/LPojdgbnRGfrtdu
 w2skggCI4yRoIUg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not
it ever charges an object to those shrinkers, plus a pointer array
sized for shrinker_nr_max. Every superblock registers such a shrinker,
and shrinker_nr_max never comes down, so a host that mounts many
filesystems and runs many cgroups pays for every superblock in every
cgroup, live or dying, and keeps paying for new cgroups after the
mounts are gone.

Patch 1 keeps the units in an xarray per memcg and node instead of the
pointer array. A new unit is inserted where it belongs: nothing is
reallocated, copied or published under RCU when shrinker_nr_max grows,
and the readers find a unit with xa_load() or walk the present ones
with xa_for_each(). The units are still allocated up front, so this
patch changes no behaviour.

Patch 2 allocates a unit only when the cgroup gets a list on that
shrinker's list_lru, which is where map bits are set: a cgroup pays for
the shrinkers it holds objects of, not for every superblock on the host.
The install is an xarray insert with the gfp of the list allocation;
there is no array to race with, so no lock beyond the xarray's. The root
memcg keeps its units for the deferred work of global reclaim and is the
only memcg a shrinker registration still visits.

Why an xarray and not the on-demand array
-----------------------------------------

Allocating the units on demand removes most of their memory with either
container. The pointer array keeps three costs that scale with
shrinker_nr_max x cgroups x nodes instead of with what a cgroup uses:

- the array itself, per cgroup and node, also in cgroups that hold
  nothing;
- a registration that crosses a unit boundary reallocates and copies
  the array of every cgroup on every node under shrinker_mutex, which
  every other mount and umount waits for;
- shrink_slab_memcg() walks shrinker_nr_max / 64 indexes per cgroup
  and node on every reclaim pass, whether the cgroup has objects or
  not.

The xarray holds only the units a cgroup has, so none of the three
grows with the number of mounts. It is also less code: mm/shrinker.c
ends up shorter than before the series.

Measured on a 48-CPU, 4-node host with 50000 tmpfs mounts
(shrinker_nr_max 50112) and 20000 live, empty memory cgroups. base is
v7.3-rc7 with the kmem_cache patch, where every cgroup has every unit;
both on-demand variants sit on top of it. "old array on demand" is
patch 2/2 of "mm/shrinker: make per-memcg shrinker units cheaper" v2:

+--------------------------------------+-----------+-----------+--------+
|                                      | base      | old array | xarray |
|                                      |           | on demand |        |
+--------------------------------------+-----------+-----------+--------+
| unreclaimable slab per empty cgroup  | 1.6 MB    | 65 KB     | 34 KB  |
|   of it, the per-cgroup array        | 32 KB     | 32 KB     | 0      |
+--------------------------------------+-----------+-----------+--------+
| 640 mounts crossing 10 unit          |           |           |        |
| boundaries, 20000 cgroups alive      | 1.41 s    | 1.31 s    | 0.10 s |
|   the same 640 mounts, no cgroups    | 0.08 s    | 0.08 s    | 0.07 s |
+--------------------------------------+-----------+-----------+--------+
| echo 2 > drop_caches: shrink_slab()  |           |           |        |
| for every online cgroup, the walk    |           |           |        |
| kswapd does on every pass            | 23 s      | 11.3 s    | 1.3 s  |
|   of it, shrink_slab_memcg() per     |           |           |        |
|   cgroup and node                    | 22.8 us   | 10.7 us   | 0.5 us |
+--------------------------------------+-----------+-----------+--------+

This v2 on v7.4-rc1 gives the same xarray numbers on the same host.

Assisted-by: LLM
---
This replaces patch 2/2 of "mm/shrinker: make per-memcg shrinker units
cheaper" v2 with an xarray variant. Patch 1/2 of that series is in
v7.4-rc1 as commit faaf8b406c517 ("mm/shrinker: allocate
shrinker_info_unit from a dedicated kmem_cache").

Changes in v2:
- Rebased on v7.4-rc1, which has the kmem_cache patch this series was
  built on.
- Patch 1: memcg_struct_check() asserts shrinker_units in the
  read-mostly group, where shrinker_info was.
- Patch 2: free_shrinker_info() no longer takes shrinker_mutex, as a
  registration only visits the root memcg.
- Patch 2: __list_lru_init() keeps the SHRINKER_MEMCG_AWARE check of
  commit 6a100811c7c5f ("mm/list_lru: don't copy stale shrinker id from
  non-memcg-aware shrinkers") next to its own check for a per-memcg
  list.
- Cover letter: why an xarray and not the on-demand array, measured on
  a 48-CPU host, from the v1 thread (Harry Yoo, Andrew Morton).
- Move Assisted-by from the patches to the cover letter, after commit
  1e035297ffdad ("docs: remove Assisted-by references").
- Link to v1: https://patch.msgid.link/20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com

---
Konstantin Khorenko (2):
      mm/shrinker: keep the per-memcg shrinker units in an xarray
      mm/shrinker: allocate the per-memcg shrinker units on demand

 include/linux/memcontrol.h |   7 +-
 include/linux/shrinker.h   |   6 -
 mm/list_lru.c              |  20 ++-
 mm/memcontrol.c            |   8 +-
 mm/shrinker.c              | 377 +++++++++++++++++----------------------------
 5 files changed, 164 insertions(+), 254 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-fbfd27a8cd69

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team

