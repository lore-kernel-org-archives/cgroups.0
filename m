Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317351;
	b=HY38qLWkgXLmFQvKiu+rqxgckqof9iVNpZEfDHyN6KbpC1h5DTfeq9wOZIsPLjpkd5Dh
	 MaRKsGs9EDvhyx3Od0YxhRYzRG8GG9QT45ogs/GpAwn7XcBYAdXiJWTcnHdfPPqZXTUV8
	 u45Ct4PYNGIKDXHx1hDF6HrpR0SONh+Y5UGOsL6R9TDXWURdYUmvaNGpvENzGh1Fp/njM
	 dOpKNKwrjPmC/HOvl46e26mpayVUMXe9qjeVesqDe5phDyP/Mm21g3D9VY/cPn496FKMU
	 L9/rINrwCkGoLWvtiDsn+Mavy9kq8eLglKxomBbHJy7qfSWSpClspZyTYJV5noKUJUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317351;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type;
	bh=Tm9ik6SmFveJObzddD7RvCN+mOXxxypXf1joHKK0Mw8=;
	b=ib54exwRd/ueFIvyVBj5FxRiy7mxxYnkjIzL1QU5+bCxk1LySXK9jDhCiAljwng1UlxR
	 tqV0h9NYH681JBpLbD/+m2sZCRtPru/AKyc0Yi6QSartlGSNTZ611SQFKZSgM869lcUYJ
	 haZANEqLiTlYneh20MsprBTXaoM9RNcA22j+oEMl91jd1k8BA3Rnma7GqcXAU5q9nE81x
	 ekzq/2/KboICjQagbGW8dUYTNGKPFdpDagGUfkfUn3jgML1zxFBpMDrTgqDHCTfv+/3hw
	 6NWE9AXFyczu3qV5TdcJo0KAcvMZh0KnFko6YStGFHfAcZ6pzvgN0A5tcWJAqKEvltg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=feldt.systems;
	spf=pass smtp.mailfrom=feldt.systems;
	dkim=pass header.d=feldt.systems header.i=@feldt.systems header.a=rsa-sha256 header.s=protonmail2 header.b=YdRU7kuM;
	arc=none smtp.remote-ip=109.224.244.118
Received: from mail-244118.protonmail.ch (mail-244118.protonmail.ch [109.224.244.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65770606A74C
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 13:29:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65770606A74C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=feldt.systems
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=feldt.systems
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=feldt.systems header.i=@feldt.systems header.a=rsa-sha256 header.s=protonmail2 header.b=YdRU7kuM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=feldt.systems;
	s=protonmail2; t=1794317347; x=1794576547;
	bh=Tm9ik6SmFveJObzddD7RvCN+mOXxxypXf1joHKK0Mw8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=YdRU7kuMCNHT+dX/aNW42vwTfCdXk0BBc7nyBQMGlE3NSAU6XwgkYpgPjtxwF5/eG
	 HqgnBw3lZLhJyW/JqMVV+BwO+UMLEi9/5Gfv+eViwuHOBC2//rs2esM1hLaPatS1Kv
	 UKwXfrSxcIzB1DIRG/Zm8HpmsfVyyhlZHmw0MYqgCuJ4pcxcTLytLsq+3grcR/wDTD
	 qvWQ7t0zs5PW9AdtNoPAyKj0e/AEARZfplX12QAW8J/XdR0dcPCxC+f3E/cTGmSp/2
	 SAD3p/SlSRP/RC3EO4gWX5QUIQlE+niEgO76jCNN4g+8+LP1SCzhcjH/rAJWkUqem7
	 8KOtNf43pOVzA==
Date: Tue, 10 Nov 2026 13:29:02 +0000
To: Shakeel Butt <shakeel.butt@linux.dev>
From: Noah Feldt <noah@feldt.systems>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Karl Erik Hofseth <karl.e.hofseth@opoint.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, regressions@lists.linux.dev
Subject: [REGRESSION] mm/memcg: list_del corruption on memcg LRU on 7.2.11 despite bf4ade7dbd76 (single NUMA node machines)
Message-ID: <20261110132853.71228-1-noah@feldt.systems>
Feedback-ID: 113045274:user:proton
X-Pm-Message-ID: 1b093913891b0d2bc6fb796bb6c6aa31983b626a
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------b18b6120c6030061e1225a42a0132a3263a9c01fa07275d24bf39956cce819ce"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------b18b6120c6030061e1225a42a0132a3263a9c01fa07275d24bf39956cce819ce
Content-Type: multipart/mixed;
 boundary=e7b0ba2e7c37b4766ae18e46f2318176cce4015ea32e8a4d02671084f264
From: Noah Feldt <noah@feldt.systems>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	regressions@lists.linux.dev
Subject: [REGRESSION] mm/memcg: list_del corruption on memcg LRU on 7.2.11 despite bf4ade7dbd76 (single NUMA node machines)
Date: Tue, 10 Nov 2026 14:28:48 +0100
Message-ID: <20261110132853.71228-1-noah@feldt.systems>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0

--e7b0ba2e7c37b4766ae18e46f2318176cce4015ea32e8a4d02671084f264
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

we are hitting list_del corruption on memcg LRU lists on 7.2.11. The
signature is the same as in Karl's report [1], but 7.2.11 already
contains both fixes from that thread:

  bf4ade7dbd76 ("memcg: keep folio's objcg same as its node")
               -> 7.2.y as 6165478eaa, in v7.2.5
  0e0ac326c511 ("memcg: move LRU size accounting on reparenting
                instead of copying it")
               -> 7.2.y as 007bc18423, in v7.2.6

All three affected machines are single-socket with a single NUMA node
(AMD EPYC 9655 and EPYC 7702P, "NUMA node(s): 1"). So cross-node
migration, the trigger fixed by bf4ade7dbd76 and a requirement for
Karl's reproducer, cannot be involved. This looks like a different race
in the reparenting/LRU code.

We saw three panics in eight days on one cluster, on hardware from two
vendors. Nothing in v7.2.12..v7.2.15, v7.3.3, v7.4-rc2 or the
mm-unstable/mm-hotfixes-unstable branches looks like it addresses this.

Kernel:   Debian 7.2.11-
1 (7.2.11+deb14+1-amd64), PREEMPT(lazy), MGLRU on,
          cgroup v2
Workload: Kubernetes nodes (CRI-O) with high pod and cgroup churn:
          constant pod start/stop, frequent XFS mount/umount of zvols,
          memcg OOM kills with memory.oom.group, and memory.high
          reclaim. Every crash was preceded by memcg OOM kills and/or
          heavy mount/umount churn minutes to hours before.

In all three cases the corrupted pointer is an LRU list head inside a
mem_cgroup_per_node (slab start + offset == the bad pointer):

  #1: next == head, but head->prev == head (head list is empty)
  #2: prev == head, but head->next == head (head list is empty)
  #3: prev == head (different list, offset 368), but head->next points
      to another folio

So in #1 and #2 a folio still points at a lruvec list head that is
already empty, which looks like a folio stranded on the LRU of a memcg
whose lists have already been spliced to the parent. #3 may or may not
be the same
 event.

The entry paths differ (memory.high reclaim via lru_gen_look_around,
and compaction from an XFS mount), which suggests that the list is
already corrupted and the next LRU operation trips over it. Both
signatures match Karl's in-vivo cases #1 (lru_activate) and #2
(isolate_migratepages_block) in [1].

#1: 2026-11-02 08:19:59 UTC, Giga Computing R163-ZG2 (1 socket, 1 NUMA node)
-------------------------------------------------------------------------------
[1165000.986266]  slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 size 1920
[1165000.995872] list_del corruption. next->prev should be ffacf881ccc70e08, but was ff31bfa36a3ca010. (next=ff31bfa36a3ca010)
[1165001.014102] kernel BUG at lib/list_debug.c:65!
[1165001.019464] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[1165001.048442] Hardware name: Giga Computing R163-ZG2-AAJ2-000/MZG3-GU0-000, BIOS R20_F18 10/23/2025
[1165001.058744] RIP: 0010:__list_del_entry_valid_or_report+0xd2/0xf0
Call Trace
:
 lru_gen_del_folio.constprop.0+0x194/0x390
 lru_activate+0x80/0x380
 folio_batch_move_lru+0xb5/0x280
 __folio_batch_add_and_move+0x7c/0x100
 lru_gen_look_around+0x3ea/0x6b0
 folio_referenced_one+0x262/0x4e0
 __rmap_walk_file+0xb4/0x1a0
 folio_referenced+0x109/0x130
 shrink_folio_list+0x910/0xfd0
 evict_folios+0x126/0x5b0
 try_to_shrink_lruvec+0xb4/0x200
 shrink_lruvec+0x119/0xfe0
 shrink_node+0x22f/0xd00
 do_try_to_free_pages+0xb3/0x4d0
 try_to_free_mem_cgroup_pages+0xf0/0x210
 reclaim_high+0x83/0xd0
 __mem_cgroup_handle_over_high+0xf1/0x2c0
 exit_to_user_mode_loop+0x1c4/0x560
 do_syscall_64+0x263/0x640
[1165001.906773] Kernel panic - not syncing: Fatal exception

#2: 2026-11-08 ~04:58 UTC, Giga Computing R163-ZG2 (1 socket, 1 NUMA node)
-------------------------------------------------------------------------------
[1670289.398643]  slab mem_cgroup_per_node start ff16459986b32580 pointer offset 528 size 1920
[1670289.408376] list_del corruption. prev->next s
hould be ffc1e319d5020a08, but was ff16459986b32790. (prev=ff16459986b32790)
[1670289.426642] kernel BUG at lib/list_debug.c:62!
[1670289.431977] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[1670289.461060] Hardware name: Giga Computing R163-ZG2-AAJ2-000/MZG3-GU0-000, BIOS R20_F18 10/23/2025
[1670289.471224] RIP: 0010:__list_del_entry_valid_or_report+0xb2/0xf0
Call Trace:
 isolate_migratepages_block+0x9d1/0x1720
 compact_zone+0x6da/0x10f0
 compact_zone_order+0xa1/0xd0
 try_to_compact_pages+0x124/0x290
 __alloc_pages_slowpath.constprop.0+0x70b/0x1400
 __alloc_frozen_pages_noprof+0x2e9/0x330
 alloc_pages_mpol+0xa6/0x180
 ___kmalloc_large_node+0xbc/0xf0
 __kvmalloc_node_noprof+0x4b5/0x730
 xlog_find_verify_log_record+0x43/0x210 [xfs]
 xlog_find_zeroed+0x19c/0x1f0 [xfs]
 xlog_find_head+0x52/0x370 [xfs]
 xlog_find_tail+0x53/0x380 [xfs]
 xlog_recover+0x3d/0x190 [xfs]
 xfs_log_mount+0xb5/0x1f0 [xfs]
 xfs_mountfs+0x439/0xad0 [xfs]
 xfs_fs_fill_super+0x756/0xa00 [xfs]
 get_
tree_bdev_flags+0x132/0x1d0
 vfs_get_tree+0x29/0xd0
 fc_mount+0x13/0x90
 path_mount+0x34a/0xc40
 __x64_sys_mount+0x121/0x150
 do_syscall_64+0xea/0x640
[1670290.504046] Kernel panic - not syncing: Fatal exception

#3: 2026-11-10 09:53:55 UTC, Supermicro H11SSL-i (1 socket, 1 NUMA node)
-------------------------------------------------------------------------------
[585952.686020]  slab mem_cgroup_per_node start ffff8af9df25e180 pointer offset 368 size 1920
[585952.695593] list_del corruption. prev->next should be fffff38a68aff788, but was fffff38a202f8808. (prev=ffff8af9df25e2f0)
[585952.713751] kernel BUG at lib/list_debug.c:62!
[585952.719475] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[585952.748716] Hardware name: Supermicro Super Server/H11SSL-i, BIOS 3.2 01/24/2025
[585952.757460] RIP: 0010:__list_del_entry_valid_or_report+0xb2/0xf0
Call Trace:
 lru_gen_del_folio.constprop.0+0x194/0x390
 lru_activate+0x80/0x380
 folio_batch_move_lru+0xb5/0x280
 __folio_batch_add
_and_move+0x7c/0x100
 lru_gen_look_around+0x3ea/0x6b0
 folio_referenced_one+0x262/0x4e0
 __rmap_walk_file+0xb4/0x1a0
 folio_referenced+0x109/0x130
 shrink_folio_list+0x910/0xfd0
 evict_folios+0x126/0x5b0
 try_to_shrink_lruvec+0xb4/0x200
 shrink_lruvec+0x119/0xfe0
 shrink_node+0x22f/0xd00
 do_try_to_free_pages+0xb3/0x4d0
 try_to_free_mem_cgroup_pages+0xf0/0x210
 reclaim_high+0x83/0xd0
 __mem_cgroup_handle_over_high+0xf1/0x2c0
 try_charge_memcg+0x4e3/0x650
 charge_memcg+0x55/0xc0
 __mem_cgroup_charge+0x2c/0x80
 filemap_add_folio+0x61/0x210
 page_cache_ra_unbounded+0x13e/0x250
 do_page_cache_ra+0x5e/0x80
 filemap_fault+0x7e0/0x12b0
 ...
 asm_exc_page_fault+0x26/0x30
[585953.604861] Kernel panic - not syncing: Fatal exception

We are happy to test patches or debug options on affected nodes.

[1] https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/


Thanks,
Noah Feldt
mittwald

--e7b0ba2e7c37b4766ae18e46f2318176cce4015ea32e8a4d02671084f264
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - noah@feldt.systems -
 0x9B02BBB4.asc"; name="publickey - noah@feldt.systems - 0x9B02BBB4.asc"
Content-Type: application/pgp-keys; filename="publickey - noah@feldt.systems
 - 0x9B02BBB4.asc"; name="publickey - noah@feldt.systems - 0x9B02BBB4.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCkNvbW1lbnQ6IGh0dHBzOi8vZ29w
ZW5wZ3Aub3JnClZlcnNpb246IEdvcGVuUEdQIDIuMTAuMAoKeGpNRVpuV2ZveFlKS3dZQkJBSGFS
dzhCQVFkQWpjOWlieHJoOExkN2E3YjdBM1hXUnZSdGt6V2cwcEZUaUpDTgoza3J1ZnM3TkoyNXZZ
V2hBWm1Wc1pIUXVjM2x6ZEdWdGN5QThibTloYUVCbVpXeGtkQzV6ZVhOMFpXMXpQc0tNCkJCQVdD
Z0ErQllKbWRaK2pCQXNKQndnSmtFQlN1OWFxLzJDcUF4VUlDZ1FXQUFJQkFoa0JBcHNEQWg0QkZp
RUUKbXdLN3RGM0s0QUt5ZXdZWVFGSzcxcXIvWUtvQUFFSjdBUURaRlZLOGpTa3FDSk9oS1NsTVp6
T01Ibk4vQjhyYwpHZzlXei9UdW1lejVwQUQvV2l6V2xGem4xT3NibzBzV0U3L25FLzRMaXRKS2k0
bjlObUVGczRob01BVE9PQVJtCmRaK2pFZ29yQmdFRUFaZFZBUVVCQVFkQTc4U0JLZkc1Ymd6SjQw
bVZxTmNGUnhqc0lTT0ovVW4rZU1TaC83MkQKVUVJREFRZ0h3bmdFR0JZS0FDb0ZnbVoxbjZNSmtF
QlN1OWFxLzJDcUFwc01GaUVFbXdLN3RGM0s0QUt5ZXdZWQpRRks3MXFyL1lLb0FBTWJHQVA0anZ3
YlBacnFSY3dzRk5VdWI3aSthSFVTY2pwQTJIazFUdTBKTG5HWTlMQUVBCjRBOGQrWGNsdEVhUEtp
Vi9sbzh2RFdPaFBBQVBhbTFuQi8wQWhlenh1UTA9Cj1jQkVoCi0tLS0tRU5EIFBHUCBQVUJMSUMg
S0VZIEJMT0NLLS0tLS0=
--e7b0ba2e7c37b4766ae18e46f2318176cce4015ea32e8a4d02671084f264--

--------b18b6120c6030061e1225a42a0132a3263a9c01fa07275d24bf39956cce819ce
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wqsEARYIAF0FgmrzHB0JEEBSu9aq/2CqNRQAAAAAABwAEHNhbHRAbm90YXRp
b25zLm9wZW5wZ3Bqcy5vcmfnJcwfO31tZ+MWKQGfT0VaFiEEmwK7tF3K4AKy
ewYYQFK71qr/YKoAADIiAP4hPFGvdIURoIulfVBiYSOJB0RwaBpDuJN9WsaT
yFp3nQD8C2mtr7uf4piZueGYChdmuMxyk+O7CsX/NWoHdvTvwAc=
=qEeq
-----END PGP SIGNATURE-----


--------b18b6120c6030061e1225a42a0132a3263a9c01fa07275d24bf39956cce819ce--

