Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F49436BCC9
	for <cgroups@vger.kernel.org>; Thu, 26 Feb 2026 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772088128; cv=none; b=C4YVqdaShGCTrhscDbVOeTQxg2VJYfb4Hsbc5hbJuztD6hHiqAxS+0pBylLz8R71jYEgIoohu4SBAqwIcEe6q/5ENuNtNvU9JJ0HH/qvMeMt4noATW4Lu0sA/McyyQ0iD6jqbwebCa/2lMePpHyOpmrbGy6efeY77QBBRwp/PgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772088128; c=relaxed/simple;
	bh=O2KWkTqA1k3sm2mS8jx5Ci8gXsKcqxVZJQgrp68wGHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tcKFS2C34pF97EaVh2Lsuyk2bZZwovRW7KMOn7dha8VWAh4xs6ANpcufXpho752q/GEgPk6ZbCU9+FCEUML+Mw/KF2JBmgX5NsgdiZKL2uRtbMy03D12mmkwok9TNcO17FD0aSHAwmlFwfhIWOkYxAvpSRxPKmOfSMBNPANtlj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GH10D8cg; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GH10D8cg"
Message-ID: <d89afd07-edd0-465c-855a-935b9b55e93a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772088115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tsoNYUIXRY4czYRyOTo1YFJNlOMgkydQUEar5VWPZRg=;
	b=GH10D8cgG00SB31h6Il+LdJp6YDEXP7iGFxM0pnb/8gXr2wwfPQG+sYIw33iop0X5PIo1B
	+hcfWVme3JF8m61wizbiW6H/yAozr3BC0XTEKplh1nqIa774Bm7MRC6WZWnzjY3WhrTvAq
	i8y+roUbkTymN3mBUEnaPjT+YBppHeA=
Date: Thu, 26 Feb 2026 14:41:28 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Yosry,

On 2/25/26 10:58 PM, Yosry Ahmed wrote:
>> @@ -473,6 +493,29 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>          return x;
>>   }
>>
>> +#ifdef CONFIG_MEMCG_V1
>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> +                                      struct mem_cgroup *parent, int idx)
>> +{
>> +       int i = memcg_stats_index(idx);
>> +       int nid;
>> +
>> +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
>> +               return;
>> +
>> +       for_each_node(nid) {
>> +               struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>> +               struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>> +               struct mem_cgroup_per_node *parent_pn;
>> +               unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>> +
>> +               parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
>> +
>> +               atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
>> +       }
>> +}
> 
> Did you measure the impact of making state_local atomic on the flush

No, because this is not a performance-critical path, I did not perform
performance testing. :(

> path? It's a slow path but we've seen pain from it being too slow
> before, because it extends the critical section of the rstat flush
> lock.

Got it. Do you have any test cases that previously identified this
problem?

> 
> Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
> will update the stat on the local counter and it will be added to
> state_local in the flush path when needed. We can even force another
> flush in reparent_state_local () after reparenting is completed, if we
> want to avoid leaving a potentially large stat update pending, as it
> can be missed by mem_cgroup_flush_stats_ratelimited().
> 
> Same for reparent_memcg_state_local(), we can probably use mod_memcg_state()?

Thank you for providing optimization ideas; I will take a closer look.


