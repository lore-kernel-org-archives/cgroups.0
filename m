Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C538889D
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 07:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786348721; cv=none; b=SqoiOXgRRxiptQaUiHphkY3BkcgvSs6dk2CenYu5zc01Hf8KMaZR8pilObwTH4nd4yg8HLuNN7cMzAuhFMypcNsg4ld6Xtpoc20VbNCA9qgdIkvjKctyVuSWICp2s5aui5EKvNwfVeteMJ6DARydVWxm5iEMQBK56ifmSZRLl+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786348721; c=relaxed/simple;
	bh=doEjhmeMrC6/DILFWnsSqq/o66HeFkwDyN5nBfnoTck=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=F+j8eS74WP+fvWf1qRzlMFzk9tQV8LMSjTQ7JhpaxBBJyNYxVDAqXD8UdorKLxYBczpbufzVYxNwedB7LVyb8heMqFgpUVYkMpulEdJb13+SsLhdyzRZpKxSGzkp6pSAw5lLLbFMweS+iAh8o/AmN+n8RfOttCKJLzt4+H6WRQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c4t+qkeF; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c4t+qkeF"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786348707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eXqpPmFg3NAwqefW6Q/q19TF5DPxz3Lme5BVQFRJrFQ=;
	b=c4t+qkeFJKO/1yXLiMbdEWCssRIOIcrOPElW099+wv7sX6aO4srSJ3FbT9mjc+joDKS+Ab
	G49Gpx2XnYxtUrTjqEQEZG82xw5N2mjeA25QjGxPiYdgD7HBJnSKEpmlWfVkkjyGvg8KBM
	5mvMDdShimSb30wXJ2s2BWtHv6dicYg=
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
In-Reply-To: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 15:58:09 +0800
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
Message-Id: <5059A780-9C10-4171-A254-38944464F1AC@linux.dev>
References: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
To: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
X-Migadu-Flow: FLOW_OUT



> On Aug 10, 2026, at 13:46, Prakash Gupta =
<prakash.gupta@oss.qualcomm.com> wrote:
>=20
> memcg->nodeinfo[] entries are allocated only for nodes present at
> css_alloc time. When a node is onlined after a memcg is created its
> nodeinfo[] slot remains NULL. Two call sites dereference these slots
> unconditionally:

I don't think the premise of this patch is correct.

memcg->nodeinfo[] is not allocated only for nodes that are present or
online at css_alloc time. mem_cgroup_alloc() allocates per-node info =
with
for_each_node(), and for_each_node() iterates N_POSSIBLE nodes:

        for_each_node(node)
                alloc_mem_cgroup_per_node_info(memcg, node);

Memory hotplug also rejects memory being added to a node that is not in
node_possible_map. So a node that can be onlined later should already
have a nodeinfo[] entry for all existing memcgs.

If memcg->nodeinfo[nid] is NULL on your system, that looks like a
violation of this invariant, or possibly a downstream-specific change,
bad nid, allocation/lifetime issue, or memory corruption. I don't think
the generic explanation that "the node was onlined after the memcg was
created" is sufficient.

>=20
> lruvec_stat_mod_folio() calls mem_cgroup_lruvec() which reads
> memcg->nodeinfo[pgdat->node_id] without a NULL check. On a system
> where a node is onlined after the memcg is created, any folio stat
> update for that node crashes with a NULL pointer dereference:
>=20
>  Unable to handle kernel paging request at virtual address =
ffffffbebf7e1908
>  pc : lruvec_stat_mod_folio+0xf0/0x444   [6.18.21-android17-5]
>  lr : lruvec_stat_mod_folio+0x88/0x444
>  Call trace:
>   lruvec_stat_mod_folio+0xf0/0x444
>   folio_add_new_anon_rmap+0xac/0x2b8
>   do_wp_page+0x768/0xc80
>   handle_mm_fault+0x37c/0x8c4
>   do_page_fault+0x140/0xa1c
>   do_mem_abort+0x54/0x74
>   el0_da+0x48/0x8c
>   el0t_64_sync_handler+0x20/0x130
>   el0t_64_sync+0x1c4/0x1c8
>=20
> __invalidate_reclaim_iterators() iterates for_each_node() and reads
> from->nodeinfo[nid]->iter without checking for NULL. for_each_node()
> visits all possible nodes, so this is reachable whenever a node is
> onlined after the memcg was created.
>=20
> Fix lruvec_stat_mod_folio() by checking nodeinfo[pgdat->node_id]
> directly and falling back to mod_node_page_state() when NULL, =
mirroring
> the existing !memcg early-return path. The fallback must not go =
through
> mod_lruvec_state() since that calls mod_memcg_lruvec_state() which =
uses
> container_of() to recover the mem_cgroup_per_node from the lruvec
> pointer; passing &pgdat->__lruvec there produces a garbage pointer.
> When nodeinfo[nid] is NULL the memcg has no per-node accounting
> structure for that node, so node-level accounting is correct.
>=20
> Fix __invalidate_reclaim_iterators() by skipping NULL nodeinfo[] =
slots.
>=20
> Also switch lruvec_stat_mod_folio() to folio_memcg_check() which uses
> READ_ONCE() to safely read folio->memcg_data in an unlocked context.
>=20
> Fixes: 6c77b607ee26 ("mm: kill lock|unlock_page_memcg()")

The Fixes tag also seems odd. 6c77b607ee26 ("mm: kill
lock|unlock_page_memcg()") only removed/renamed the lock_page_memcg()
wrappers and does not appear to change nodeinfo[] allocation or memory
hotplug handling. Could you explain how that commit introduced the NULL
nodeinfo condition?

> Cc: stable@vger.kernel.org
> Assisted-by: pi:claude-sonnet-4-5

Given the Assisted-by tag, I assume some of the analysis may have been
tool-assisted. That's fine, but the author still needs to validate the
reasoning against the actual code before submission.

Did you confirm that the relevant allocation and hotplug paths were
manually checked against the affected tree? In particular, I wonder
whether this behavior depends on downstream changes around
mem_cgroup_alloc(), for_each_node(), node_possible_map setup, or memory
hotplug nid validation.

Muchun,
Thanks.=
