Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F16261B8A
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 06:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786429225; cv=none; b=JOWqzr7qwXmeVTTv3FZ15ywRtjRSl05LvZKZYWVDcaIsiUuWcaMpEOf74JlJDpdMVPJ0uJiikx5Ny8DESh02KuPBX0+U52iqUvo+AEXgsOBlAVuwwPhrGqz0uFjDDxidZiPTu8Wu4k0wj3+BZ0aCCWrLk0DzCituzpUaqwXDLok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786429225; c=relaxed/simple;
	bh=nBMYU3qU7s9tQXgvGQEswOG/tx1hWyFpUROlikBh4A4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=dx11RCu3shKSCk9da6ioEjW/WoBSe8DwV5T+HmoKIhaGCmfWnrWg1FZy8/XflbbYvIG8jz67NM9vVb63Bgu37h0tKAx1o8ElSkToc1b6Cc+Ohe4wHr4+sOcju/n0GrUKPUe9ksBRKvnSEO9eVmU9PbPqRYu2elGNVE3CqwbBwII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tdi5Xi3w; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tdi5Xi3w"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786429211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E2wRspdNGSNKevSyuudT8LxlyUn0RkignJpxE+V+MVc=;
	b=Tdi5Xi3wHJT+V8HosnAAazhpMW2oOpKLS9qWebcUVt8MlEdcpnZD4QfgQdKq+Lj6/zpeVF
	go6LwEA4zHOG4Amdv/2H1SZF8QM2gKv+o2UU+S/96v1PitVeRUE/CCuwj1N9T4vGw1SctW
	SnmLJW1Bwtg8/iM4ZzEVJELqqeEmlZM=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/memcg: fix NULL nodeinfo[] dereference on late-onlined
 nodes
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <53e05300-b84c-4a04-a7b4-5022285bcbdc@oss.qualcomm.com>
Date: Tue, 11 Aug 2026 14:19:49 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-arm-msm@vger.kernel.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2088EE7-69E5-4BCF-B753-47A85B317E01@linux.dev>
References: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
 <5059A780-9C10-4171-A254-38944464F1AC@linux.dev>
 <53e05300-b84c-4a04-a7b4-5022285bcbdc@oss.qualcomm.com>
To: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
X-Migadu-Flow: FLOW_OUT



> On Aug 11, 2026, at 13:16, Prakash Gupta =
<prakash.gupta@oss.qualcomm.com> wrote:
>=20
>=20
>=20
> On 8/10/2026 1:28 PM, Muchun Song wrote:
>>=20
>>=20
>>> On Aug 10, 2026, at 13:46, Prakash Gupta =
<prakash.gupta@oss.qualcomm.com> wrote:
>>>=20
>>> memcg->nodeinfo[] entries are allocated only for nodes present at
>>> css_alloc time. When a node is onlined after a memcg is created its
>>> nodeinfo[] slot remains NULL. Two call sites dereference these slots
>>> unconditionally:
>>=20
>> I don't think the premise of this patch is correct.
>>=20
>> memcg->nodeinfo[] is not allocated only for nodes that are present or
>> online at css_alloc time. mem_cgroup_alloc() allocates per-node info =
with
>> for_each_node(), and for_each_node() iterates N_POSSIBLE nodes:
>>=20
>>        for_each_node(node)
>>                alloc_mem_cgroup_per_node_info(memcg, node);
>>=20
>=20
> You are right. I rechecked and nodeinfo[] is allocated for all =
possible
> nodes at mem_cgroup_alloc() time, not just currently online ones.
>=20
>> If memcg->nodeinfo[nid] is NULL on your system, that looks like a
>> violation of this invariant, or possibly a downstream-specific =
change,
>> bad nid, allocation/lifetime issue, or memory corruption. I don't =
think
>> the generic explanation that "the node was onlined after the memcg =
was
>> created" is sufficient.
>>=20
> Agreed. I will investigate further before resubmitting that part.
>=20
>>>=20
>>> lruvec_stat_mod_folio() calls mem_cgroup_lruvec() which reads
>>> memcg->nodeinfo[pgdat->node_id] without a NULL check. On a system
>>> where a node is onlined after the memcg is created, any folio stat
>>> update for that node crashes with a NULL pointer dereference:
>>>=20
>>> Unable to handle kernel paging request at virtual address =
ffffffbebf7e1908
>>> pc : lruvec_stat_mod_folio+0xf0/0x444   [6.18.21-android17-5]
>>> lr : lruvec_stat_mod_folio+0x88/0x444
>>> Call trace:
>>>  lruvec_stat_mod_folio+0xf0/0x444
>>>  folio_add_new_anon_rmap+0xac/0x2b8
>>>  do_wp_page+0x768/0xc80
>>>  handle_mm_fault+0x37c/0x8c4
>>>  do_page_fault+0x140/0xa1c
>>>  do_mem_abort+0x54/0x74
>>>  el0_da+0x48/0x8c
>>>  el0t_64_sync_handler+0x20/0x130
>>>  el0t_64_sync+0x1c4/0x1c8
>>>=20
>>> __invalidate_reclaim_iterators() iterates for_each_node() and reads
>>> from->nodeinfo[nid]->iter without checking for NULL. for_each_node()
>>> visits all possible nodes, so this is reachable whenever a node is
>>> onlined after the memcg was created.
>>>=20
>>> Fix lruvec_stat_mod_folio() by checking nodeinfo[pgdat->node_id]
>>> directly and falling back to mod_node_page_state() when NULL, =
mirroring
>>> the existing !memcg early-return path. The fallback must not go =
through
>>> mod_lruvec_state() since that calls mod_memcg_lruvec_state() which =
uses
>>> container_of() to recover the mem_cgroup_per_node from the lruvec
>>> pointer; passing &pgdat->__lruvec there produces a garbage pointer.
>>> When nodeinfo[nid] is NULL the memcg has no per-node accounting
>>> structure for that node, so node-level accounting is correct.
>>>=20
>>> Fix __invalidate_reclaim_iterators() by skipping NULL nodeinfo[] =
slots.
>>>=20
>>> Also switch lruvec_stat_mod_folio() to folio_memcg_check() which =
uses
>>> READ_ONCE() to safely read folio->memcg_data in an unlocked context.
>>>=20
>>> Fixes: 6c77b607ee26 ("mm: kill lock|unlock_page_memcg()")
>>=20
>> The Fixes tag also seems odd. 6c77b607ee26 ("mm: kill
>> lock|unlock_page_memcg()") only removed/renamed the lock_page_memcg()
>> wrappers and does not appear to change nodeinfo[] allocation or =
memory
>> hotplug handling. Could you explain how that commit introduced the =
NULL
>> nodeinfo condition?
>>=20
>=20
> It did not. It seems I picked up the commit based on git blame on
> function as there were two related bugs reports that I was conflating
> into one patch as listed below, will fix that in v2.
>=20
> Variant A (missed to mentioned in commit msg) =E2=80=94 NULL =
dereference:
>=20
>    Unable to handle kernel NULL pointer dereference
>      at virtual address 0000000000000528
>    ESR =3D 0x0000000096000005 (read fault)
>    Workqueue: events delayed_fput
>    pc : lruvec_stat_mod_folio+0x5c/0x444  [6.18.21-android17-5]
>    lr : lruvec_stat_mod_folio+0x2c/0x444
>=20
> As you suggested this may need more investigation.
>=20
> Variant B (the crash included in the patch) =E2=80=94 stale pointer:
>=20
>    Unable to handle kernel paging request
>      at virtual address ffffffbebf7e1908
>    ESR =3D 0x0000000096000045 (write fault)
>    pc : __lruvec_stat_mod_folio+0xf0/0x444  [6.18.21-android17-5]
>    lr : __lruvec_stat_mod_folio+0x88/0x444
>    Call trace:
>      __lruvec_stat_mod_folio+0xf0/0x444
>      folio_add_new_anon_rmap+0xac/0x2b8
>      do_wp_page+0x768/0xc80
>      handle_mm_fault+0x37c/0x8c4
>      do_page_fault+0x140/0xa1c
>=20
> __lruvec_stat_mod_folio+0xf0 places it after the !memcg NULL =
check.This
> is consistent with folio_memcg() returning a stale memcg pointer that
> passes the NULL check.
>=20
> folio_memcg_check() uses READ_ONCE(folio->memcg_data) which seems the
> correct API for unlocked contexts. folio_memcg_check() has been
> available since becacb04fdd4 ("mm: memcg: add folio_memcg_check()")
> but lruvec_stat_mod_folio() was never updated to use it.
>=20
> I should also note that this crash is difficult to reproduce in a
> controlled environment =E2=80=94 the analysis is based on crashdump =
inspection.
> I have not been able to construct a reliable reproducer so far.
>=20
> let me know your thoughts on this, accordingly I can send a v2 to =
cover
> only Variant B fix as explained above.

I just want to point out that the Fixes tag you listed here, regardless
of whether this patch is correct, shouldn't be a commit that introduces
a bug. Because that commit is purely a code cleanup and the removal of
redundant interfaces, theoretically it shouldn't have any impact at all,
yet you cited it anyway, which doesn't make sense. It feels to me like
you didn't carefully check this.

Muchun,
Thanks.

>=20
>>> Cc: stable@vger.kernel.org
>>> Assisted-by: pi:claude-sonnet-4-5
>>=20
>> Given the Assisted-by tag, I assume some of the analysis may have =
been
>> tool-assisted. That's fine, but the author still needs to validate =
the
>> reasoning against the actual code before submission.
>>=20
> Agree, I will be more careful in next submission.
>=20
>> Did you confirm that the relevant allocation and hotplug paths were
>> manually checked against the affected tree? In particular, I wonder
>> whether this behavior depends on downstream changes around
>> mem_cgroup_alloc(), for_each_node(), node_possible_map setup, or =
memory
>> hotplug nid validation.
>>=20
> I checked all four paths against the affected tree
> (6.18.21-android17-5). Only difference in
> mem_cgroup_alloc() are cosmetic and do not touch the nodeinfo[]
> allocation path. The NULL nodeinfo[nid] in Variant A is not explained
> by any downstream change =E2=80=94 the root cause remain unknown.
>=20
> Thank you for the review.
>=20
> Thanks,
> Prakash


