Received: from mta0.migadu.com (out-238.mta0.migadu.com [91.218.175.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B582283FE5
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 03:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787972425; cv=none; b=m75QSaz6BmWE7ctO2+FS5aRNeOVAOOgA3YMR5wUJRRFPA9NXxUXubsKRuvKPj6a4nfKiSthhsd4PE0emYe3rsFuJHKUqU8WojqQoZSDQSyKOYgoi5CFCZbbO6csfDqS45/aOJx0mN/+//zmrd2pFMhfzGNH90Fgs3hqHCK5cUZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787972425; c=relaxed/simple;
	bh=NOrUlbKMwb9Hf9uRBB2hPgRlJDS6GE9m2ZXH7xMBtKY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mp9emzv/8JBnDkrPDPDDMRYs8plR71wuBo9lsAvkV94TuvWimr1ps8s/eAqOapV4RLRw5vn75WmqhKjQ32b7c/tuPH9YnM44Itto355P1xNC0urXRCjJ23mwXDLlOVPAkS962RCcgEc96sdZwTS6IXU4/4cP5Qv9+VaA/1YeQJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eOTjjhS6; arc=none smtp.client-ip=91.218.175.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eOTjjhS6"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NOrUlbKMwb9Hf9uRBB2hPgRlJDS6GE9m2ZXH7xMBtKY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787972421; v=1; x=1788577221;
 b=eOTjjhS6wsCNhxi0blFeQDYJdCdPq8UjX7L3CBRlvReGBr4Sl9QiEZbO2d9BhPBDPoW6R7B5
 IJUQrhowsf5aMfZFPYM2hdLBn8c/xj1rTJx1WZF0TGUmkXS3LMZkuX3djJrElreQ44eOqE43HN5
 FlPUG2DHjtlOP0kinXbFCw3w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id ce6ac9aa603e1006;
	Sat, 29 Aug 2026 03:00:18 +0000
X-Mizu-Trace-ID: ce6ac9aa603e1006
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] memcg: avoid charging the root memcg from
 obj_cgroup_charge_pages()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260829023251.474083-1-shakeel.butt@linux.dev>
Date: Sat, 29 Aug 2026 11:00:00 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Farhad Alemi <farhad.alemi@berkeley.edu>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <17E1B73A-F6CD-422D-B7C9-95EB581F0ED3@linux.dev>
References: <20260829023251.474083-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On Aug 29, 2026, at 10:32, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
> try_charge_memcg(), which does not short circuit the root memcg.  That
> memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg =
the
> objcg was created for and is never updated, while =
memcg_reparent_objcgs()
> does redirect objcg->memcg to the parent on rmdir.  An objcg of a =
dying
> child of root therefore passes every obj_cgroup_is_root() filter but
> resolves to the root memcg.
>=20
> Folios keep the objcg they were charged with, so this is easy to reach
> through zswap: allocate anon memory in a cgroup, move the task out,
> remove the cgroup, then write to the root cgroup's memory.reclaim.  =
The
> reclaimed folios are charged through the reparented objcg and end up =
in
> refill_stock() with the root memcg:
>=20
>  WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
>   refill_stock+0x644/0x940
>   try_charge_memcg+0x12d6/0x1570
>   __obj_cgroup_charge+0x35/0xf0
>   obj_cgroup_charge+0x1de/0x210
>   obj_cgroup_charge_zswap+0x83/0x270
>   zswap_store+0x1620/0x2000
>   swap_writeout+0x94c/0x14c0
>   shrink_folio_list+0x3388/0x52b0
>   [...]
>   try_to_free_mem_cgroup_pages+0x30d/0x830
>   user_proactive_reclaim+0x504/0x840
>   memory_reclaim+0x1f/0x30
>=20
> Beyond the warning, the charge is asymmetric: =
obj_cgroup_uncharge_pages()
> skips refill_stock() for the root memcg, so the root's page counter =
grows
> and is never uncharged.  It is not user visible, since memory.current =
is
> not exposed on the root, but it is a leak.
>=20
> Use try_charge(), which returns early for the root memcg, restoring =
the
> symmetry with obj_cgroup_uncharge_pages().
>=20
> The above sequence was scripted into a standalone reproducer (zswap =
on,
> swap on a virtio disk, 512MB of anon memory faulted in inside a child =
of
> the root cgroup, the task then migrated to the root cgroup, the child
> removed, followed by "echo 600M swappiness=3Dmax > memory.reclaim" on =
the
> root) and run in a CONFIG_DEBUG_VM=3Dy VM.  It reproduces the splat on =
the
> first zswap store of a reparented folio, with the same call chain as =
the
> report.  With this patch applied the splat is gone while the zswap =
store
> count over the run is unchanged, so the same path is still exercised.
> cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
> failures.
>=20
> Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes: =
https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=3DfDN4Ozu7iASgryjv=
v8Tk8zQ@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

LGTM.

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

