Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2F24457D5
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 08:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788770414; cv=none; b=j2vG3qzbSmOcLtw9DZB+BYWhkgjJSH5t7WVOLK2cLmrKX48qM/Wbq5Oi1Ji+6yaNc9HfhSLIexOFJS1mniio3l1E0UIfQE6a7H6aYF0YCLS6Wly3HuPwnoxgFaaeTn9OcDSmQlo+zptQuTxKL22a5zObkWMIFjUhApyOjhu9XT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788770414; c=relaxed/simple;
	bh=GGO8eqN6d+o+o/h/2jMfZ75tLsSl7Qm1XxnpQIF2MLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u2yO77t8Y8Gvr81IFbdbsDzA1fNopJ/ZkHq4D2NQSyN51gMkRTe3IZtBETBLTZjhcpGk1q14Qv2RC8dH5joJzAeWAMA4DjNvgOictbIT6OYeaJ4dgfQ7bWM9jHmBnjTODVX8kpOe6UIIkctb7BELLRXiHZMpiklBMGxTh1kPXiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mimAj+tN; arc=none smtp.client-ip=91.218.175.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mimAj+tN"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GGO8eqN6d+o+o/h/2jMfZ75tLsSl7Qm1XxnpQIF2MLA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788770409; v=1; x=1789375209;
 b=mimAj+tNTstS2NFREbTdf492Qym2vL0fMboNBRUtTW4JnNus1vHg07l/KY9ZSBsPuNdnYjwS
 5aij5txNcIc1eshgmoO4YYSvlu00Fl4r/nxsSX7V4vOVAPfKV5wczM4OZEFH+ooSNYTHPJac2LB
 0luQVYqVunPm76ui+FWJJhNQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8cb33a948e3a62c7;
	Mon, 07 Sep 2026 08:40:05 +0000
X-Mizu-Trace-ID: 8cb33a948e3a62c7
X-Migadu-Flow: FLOW_OUT
Message-ID: <f1021240-ccb6-43dc-8e02-b94f0c4f5fb6@linux.dev>
Date: Mon, 7 Sep 2026 16:39:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v3 1/3] mm: memcg: redirect stats updates of dying memcgs
 for all hierarchies
To: sashiko-reviews@lists.linux.dev
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1788514750.git.zhuhui@kylinos.cn>
 <8a3fe5e6a076cdd9ac997125cb6c6a0948e1a6b6.1788514750.git.zhuhui@kylinos.cn>
 <20260904102113.DB9011F00A3D@smtp.kernel.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20260904102113.DB9011F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Redirecting dying memcg stat updates to the parent on cgroup v2 without reparenting the base stats causes permanent negative stat leaks and underflows.
> --
>
> commit 106b19246ac20191c0af6a41927414095cb5d019
> Author: Hui Zhu <zhuhui@kylinos.cn>
>
> mm: memcg: redirect stats updates of dying memcgs for all hierarchies
>
> This patch removes the cgroup v1 restriction on redirecting dying memcg stat
> updates to the closest non-dying ancestor. It unconditionally applies this
> redirection across all hierarchies in an effort to fix workingset shadow node
> budget calculations under MGLRU.
>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 9a65d7148c227..64eb59bba61cf 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
> [ ... ]
>
>> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
>> -							   bool *rcu_locked)
>> +static inline struct mem_cgroup *
>> +get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
>>   {
>> -	/* Rebinding can cause this value to be changed at runtime */
>> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
>> -		*rcu_locked = false;
>> -		return memcg;
>> -	}
>> -
>>   	rcu_read_lock();
>>   	*rcu_locked = true;
>>   
>> @@ -870,22 +864,8 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
> [Severity: High]
> Does this redirection cause permanent stat underflows in the ancestor under
> cgroup v2?
>
> In cgroup v2, base local stats are explicitly not reparented during offlining.
> Looking at reparent_state_local():
>
>      if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>          return;
>
> Because of this early return, the dying memcg retains its positive base counts.
>
> However, with this patch, when resources previously charged to the dying memcg
> are freed later on, the negative delta applied in mod_memcg_state() is
> redirected up to the parent.
>
> Since the non-dying ancestor never received the positive base counts but now
> receives the negative uncharge updates, its local stats (like NR_FILE_PAGES,
> MEMCG_SOCK, and LRU counts) will permanently underflow.
>
> Because lruvec_page_state_local() clamps negative values to zero, wouldn't
> this severe underflow mask the ancestor's own legitimate positive stats,
> ultimately breaking the workingset shadow node budget calculation and causing
> the exact premature reclaim and thrashing this patch aims to resolve?
>
The observation is correct: on cgroup v2 reparent_state_local() returns
early, so the dying memcg keeps its positive base counts while the
negative uncharge deltas land on the ancestor, and the ancestor's
state_local can permanently underflow and get clamped to zero.

One clarification on attribution, though: this underflow is not
introduced by the redirection.  Once memcg_reparent_objcgs() rewrites
objcg->memcg to the parent, folio_memcg() of the reparented folios
already returns the parent, so the freeing path applies the negative
deltas to the parent's lruvec directly, with or without this patch.
The redirection only matters during the short window between
css_offline() and the objcg reparenting.  So the missing base reparent
is a pre-existing gap that this series re-exposes rather than creates.

That said, I agree it needs to be handled.  I'm preparing a follow-up
patch that also reparents the non-hierarchical lruvec state_locals
(the ones count_shadow_nodes() reads) on cgroup v2, mirroring what v1
already does.  Will fold it into the next version.

Best,
Hui

