Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662260;
	b=tvh9lVaAhDKB/i82hF55L7zI8cYUVcvxhNNYu3qmgjvruSlwrkoB8VdktypE4umpV2l+
	 eJbkRMLiqgEAXeCwLmA/qSUUZDwo8N460GamZGg9nhUv2/V5AeXDY7YkS8mCIT47p94ZJ
	 /VOWmwgw/AWR3eDzmEsQdrjV02iLNaJDdz5orJ1HjW/yxHOpftsrd6Osehpon6TWo13IT
	 CUAjv2bgbNTqfubUuvntIWdOi90RHVFUGNmOGO3yNQEcGhfokOyjh2xy0xlogjAAqFrHh
	 +fe+lXEiBatP8IHppKTlhmgDVIPK3pS+6o3TsUQvxJz7rEPrKcKofYMiXhqy98nFDHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662260;
	h=DMARC-Filter:DKIM-Signature:Message-Id:Cc:From:X-Original-From:
	 X-Lms-Return-Path:To:Mime-Version:Content-Type:User-Agent:
	 Content-Transfer-Encoding:References:Subject:In-Reply-To:Date;
	bh=OUGHKG75J/Ha1UT9SfogPm3T2YK7q5WmnJNj8nl5ncM=;
	b=VajCaKvl3gAsx/mJkppx8wF7DMhUy6hnP9Pw/hY0RyU3t61YOxNom+/y2AAqQ1bLrI+3
	 cO6ipi1DdUN5wQNvcvnJf5p1oEzYfi9LYRMExRjQLE1j5JjIDEzmJiL6grLu7NBq+eZfz
	 yLCsQDFwtQxv3Bgw5luySSC9gj/u2tXz1akpmIHbJ4IeCJcdyocuQa62/Im6pu9CdwthX
	 4rYIgn2uhmh4CCbo5yyC0KxSCcNoFe4KbQhfL1wDfs49YIqlydU/xogVYPPdWZvMfPDYz
	 TRvEWplZvcKrT6dUOR+jtiJFspSLSwfSTbLv4em/wtvn0HxJSaO19zsl4cPM/COyNOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=QgXszFg8;
	arc=none smtp.remote-ip=209.127.231.113
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D557606A323
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 09:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D557606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=QgXszFg8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792662252; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=OUGHKG75J/Ha1UT9SfogPm3T2YK7q5WmnJNj8nl5ncM=;
 b=QgXszFg8BQyFzMHr+mS9D6ndBB9hF1GzlRV9C+V1WtRI0Da2uvUB2pOW7NBZM91KwRp8ge
 ECBtD77JopJSEPqWADA2RGCbdf7HlvhOPgm5jeY0WEM0y2v4dR6+vFliA+LfOGIzagobu0
 ZXhAArMow6hYHmdIIsTdsSMcBSXl6TQNvhAJ4GADIBJmpXqZtc2LqaHnDuLrIxhZfzj0hc
 rnV2MJmkp9PmZx5bceIzAUPApsI/MhQ+YmpZcp5zCIHi5wY/EcEzbAbpdAdtmYbiR/D8Q4
 ozameHasAU8fGA7RTuzeaxBP4GVu2EYi9bL4yR0O8WyC/EPfdjdbMh0cRkGcVQ==
Message-Id: <9b715272-3ed9-42da-a6ae-467e8ae00c0b@bytedance.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ad9daea+d8d221+vger.kernel.org+lizhe.67@bytedance.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
References: <20261019141401.11927-1-lizhe.67@bytedance.com> <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F> <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com> <179264138036.2549665.17429111144570830454.b4-reply@b4>
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
In-Reply-To: <179264138036.2549665.17429111144570830454.b4-reply@b4>
Date: Thu, 22 Oct 2026 17:43:49 +0800

On 10/22/26 11:56 AM, Gregory Price (Meta) wrote:
> On 2026-10-20 21:01 +0800, Li Zhe wrote:
>> On 10/20/26 12:10 AM, Gregory Price wrote:
>>
>> I agree that the kernel reclaim and demotion behavior still has room for
>> improvement, and the watermark changes and the bottom-up proactive/async
>> reclaim idea you mentioned may be useful to explore for some tiering
>> scenarios. But I think there is also an unavoidable userspace policy
>> component here. The kernel can improve whole-cgroup reclaim, but it
>> cannot know every controller's placement goal.
>>
>> For example, one controller may want to keep a specific per-tier
>> resident ratio for a cgroup. Another use case, as Joshua pointed out in
>> another reply, is reclaiming from a lower tier first so that later
>> top-tier reclaim has room for demotion. A single default memory.reclaim
>> algorithm cannot express these per-cgroup policy choices.
>>
> The latter of these should probably be some level of the system default,
> that's why I brought it up as well.  (proactive reclaim should prefer to
> make progress from the coldest tier first, then work its way up).
>
> I'm not convinced a reclaim interface is the right way to affect a
> per-tier resident ratio policy.  That feels like a hack to get around
> solving the harder problem of something like tiered memcg counters
> (which would otherwise drive reclaim to work exactly the way you
> describe for resident ratios).


Thanks for the detailed comments.

I agree that improving the default proactive/async reclaim behavior can
be useful, and I also agree that tiered memcg counters/limits would be
useful. I do not see source=nodes as a replacement for those directions.
They solve different parts of the problem: tiered counters/limits provide
accounting and policy targets, while source=nodes is only an actuator for
proactive reclaim.

So I think these directions are compatible. A better default reclaim
policy or tiered memcg limits can improve kernel-driven behavior, while
source=nodes gives userspace an explicit way to apply reclaim pressure
to a selected resident source.

>
>> I am not sure whether changing the default whole-cgroup reclaim behavior
>> in this direction could affect existing userspace dependencies. In the
>> old nodes= discussion, Mina mentioned that Meta's reclaim stack relied on
>> memory.reclaim triggering demotion [1].
>>
> Yes and on its surface this is something I could see Meta using, however
> I question whether we're simply trying to find a convenient way around
> fixing reclaim to do the right thing (not invert the LRU, apply per-tier
> memcg limits, etc).


That is fair, and I do not intend this to avoid improving reclaim or
adding better tier-aware memcg accounting. A better memory.reclaim
algorithm would also make source=nodes more useful, because source=nodes
still uses the existing reclaim path after selecting the resident source.
The goal here is narrower: expose a source-scoped proactive reclaim
actuator while keeping the kernel's reclaim policy in control. The old
nodes= discussion had ABI problems, but it also showed that a
nodemask-like source selector is a useful primitive for finer-grained
proactive reclaim control [1].

>
>> I also do not intend source= to lock in current reclaim implementation
>> details. It should stay consistent with the current design: source= only
>> selects the resident source to which reclaim pressure is applied, while
>> the kernel remains free to change the reclaim policy.
>>
> Well, sort of, you get exposed to the implementation details by having
> to negotiate what is considered progress under different scenarios.
>
> Lets take one example - what should happen when:
>   - 2 node system, node0=DRAM, node1=CXL
>   - zswap is configured
>   - echo 1G source=nodelist:1 > memory.reclaim
>   - node 1 is pressured, zsmalloc falls back to node0 to allocate
>
> Should that be considered progress? We reclaimed from node1, but
> increased pressure on node0 - which might have kicked kswapd or memcg
> accounting to demote memory from node0 to node1.
>
> Should zswap also take that nodelist as a constraint?


This is a good example of why source=nodes should not be described as a
one-shot net footprint guarantee. Assuming source=nodes:1, the request
applies reclaim pressure to memcg memory resident on node1. That may
free some space on node1 in the short term, which can provide room for a
later node0-to-node1 demotion step. If zswap allocation, kswapd, or memcg
reclaim later moves pressure back across tiers and node1 usage rises
again, that is part of the dynamic reclaim/tiering behavior.

So userspace cannot rely on one write to memory.reclaim to produce a
final per-node distribution. The intended usage is a feedback loop: the
controller observes the memcg's resident distribution, chooses the source
nodes it wants to relieve, applies source-scoped reclaim pressure,
observes the new distribution, and iterates.

I do not think this patch should make source=nodes constrain zswap pool
allocations. That would be a different and much stronger semantic. The
current intent is only to constrain the resident source from which memcg
reclaim applies pressure, while completion accounting remains the
existing memory.reclaim accounting.

>
> At the very least i think you need to add details in your cover that
> demonstrates the process of doing something like per-node resident
> ratios, and show that it works as you intend.
Agreed. I will update the cover letter to make this model clearer. I
will also make clear that source=nodes is not a final net per-node
footprint guarantee and does not change memory.reclaim completion
accounting.

[1] https://lkml.org/lkml/2022/12/14/194

Thanks,
Zhe
