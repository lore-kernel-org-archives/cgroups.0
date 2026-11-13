Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559824;
	b=pNIwiaNIqUPgDXykc0HV0jkjktSJfX3psM0YXZbyU1wUwURGZhLwd/OBoLRs09SJ2x5M
	 5rCjrhkZweMjANNWjXZQ3O5iWppFHymTBbRAMZH36fUjNKRrcUh9rNDNEKfUvPBVi6jSG
	 W8PkJ5HnqkZRBSKqWyVT2OlHsgWuXW2P7kniD/lNt6o5uHALO9sQOf1ddw8zlAdSdxCHH
	 WjM0QJwDx8JB8sE74PBQM9OJqzh0nvw+njzDvdsVIXqwTJ9QsFphjs7Mxu2PPJ2PARXOR
	 ld50IxwwGir3j2cF+THdEkU2d57jWJoLp4Vr4KSffaZ0MbupWDtd7bkbquGN3592Cqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559824;
	h=DMARC-Filter:DKIM-Signature:Date:Mime-Version:In-Reply-To:X-Mailer:
	 To:Message-Id:Content-Transfer-Encoding:References:X-Original-From:
	 Content-Type:Cc:Subject:X-Lms-Return-Path:From;
	bh=BRtBrIkCJ4EaL32K9DlOPnqwkNfnHFCSjQCoKgoeAeI=;
	b=q4M0rWokOUW92KMYlF31BSgsRcix5BFAci4ip3CET4SaZTVnt5+MlI201XAW79khzv5x
	 kTEoUugWD+NdEfL+Mw9PILI4rJ0VrEKcE8QBW3HBnukLNphJy2kfsL+wju0tWhD6Pb5Bt
	 yn6aorqRkUP3tB4fVLEl6yKa+neFRJltGfT1NaYUQqqp4NhjXDFonM4oJS6t36KAYQnrf
	 R/FfnjSMkjI8m6NHmJ8thyqtfa3laavFW4BicBKVbwuxMwSpPKH0wFl27PekKRxx5eq8n
	 kcWzGo/Vtz+7orQQMqQr3UeJr5k0PQszsP5oLeZjq9vCS4nDOpOM1moMKTaYQ17xPbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ZY2stnAD;
	arc=none smtp.remote-ip=209.127.230.112
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B281606B366
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 08:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B281606B366
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ZY2stnAD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794559817; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=BRtBrIkCJ4EaL32K9DlOPnqwkNfnHFCSjQCoKgoeAeI=;
 b=ZY2stnADnBSZLTMueZuBwBnVrnWvuCAPBP083b5OepDDuwjhTxIbTnD9WN4S5S2+Pa7jag
 IU5M2Vbwy3zUK5iA9m4XWHeWpc++Rd7ENZmwA9+dtD6VCShjhjWLUdyXnXCxjNJwdLgymE
 xZCbBzDgEFp4NiLZDM9NGrghe9Qx/cBwpP4U1PF9vy76w062zD/cJUNoRNJo82PXaPSkNL
 +dG4gyG9HTfb/6bWpt+dxt2YTAhAjrbyJj0rJI1wd1C8KC1k8xD16ovob2UX8nsnyD4iU1
 rgCvknXCu/pd75VLatZW+RCzPglfhLjxug6scq+nF49BM9jcso8w+NBnzSBa3A==
Date: Fri, 13 Nov 2026 16:49:48 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <179455442014.482102.4069329165987986914.b4-reply@b4>
X-Mailer: git-send-email 2.45.2
To: <gourry@gourry.net>
Message-Id: <20261113084948.78661-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <179455442014.482102.4069329165987986914.b4-reply@b4>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <cgroups@vger.kernel.org>, 
	<david@kernel.org>, <joshua.hahnjy@gmail.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <ljs@kernel.org>, 
	<mhocko@suse.com>, <muchun.song@linux.dev>, <rakie.kim@sk.com>, 
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, 
	<weixugc@google.com>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Subject: Re: [RFC v2 1/1] mm: add source selector to memory.reclaim
X-Lms-Return-Path: <lba+26af6cf45+407931+vger.kernel.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>

On Fri, 13 Nov 2026 02:20:20 -0500, gourry@gourry.net wrote:

> > On 2026-11-02 15:04 +0800, Li Zhe wrote:
> > +	Specifying a source value constrains where proactive reclaim applies
> > +	pressure. Currently only source=nodes:<nodelist> is supported. For
> > +	example::
> > +
> > +	  echo "1G source=nodes:0-1" > memory.reclaim
> > +
> > +	This reclaims memory of the target cgroup resident on nodes 0-1.
> 
> you buried the fact that you want to allow source=zswap in your cover
> letter. I was confused by nodes: was needed here until i re-read.
> 
> As Joshua mentioned, i don't think you need the separate cover letter,
> and I agree this is far too long for the proposed change.

Agreed. The nodes: prefix was meant to keep source= a typed selector,
but I made the motivation and possible future extensions too long and
distracting. I will make v3 much clearer and shorter, and keep the focus
on source=nodes.

> ---
> 
> When I asked for testing, I wasn't concerned with the functionality,
> I was asking what problem this actually solves. performance? fairness?
> 
> Shaping the distribution of memory is neat and clearly works, but why
> does userspace want this?
> 
> The interface "lacking flexibility" is not a problem in and of itself.

Thanks, this is a fair point. Sorry, I also made that earlier
explanation too long, so let me summarize the intended use cases here:

https://lore.kernel.org/all/67fcd8db-269d-43f1-aea2-8c41165747d0@bytedance.com/

In short, performance, fairness and cost are all part of the goal. One
target is mixed DRAM/CXL systems where user space keeps each memcg near
its own DRAM/CXL resident ratio target, based on the workload's
latency/throughput and cost requirements. Another target is the case you
described below, where user space wants memcg-scoped reclaim to apply
pressure to the desired tier first, rather than reclaiming from warmer
memory on the top tier. This is especially useful when a memcg is close
to its memory limit and user space wants charge-reducing reclaim to
start from colder/lower-tier memory first.

> I CAN see why you might want to proactively shape what data is swapped.
> Let me give you an example:
> 
> ---
> The global node reclaim interfaces allow us to put pressure on distinct
> nodes - which lets us shape which node is swapped from first.
> 
> Example: node0-1=DRAM, node2-3:CXL
> 
>   echo 1G > node2/reclaim   # swap from CXL
>   echo 1G > node3/reclaim   # swap from CXL
>   echo 1G > node0/reclaim   # demote to CXL
>   echo 1G > node1/reclaim   # demote to CXL
> 
> But the memcg.reclaim interface only allows us to pressure the complete
> set of cpuset.mems nodes for that memcg
> 
>   cat cpuset.mems           # 0-3
>   echo 1G > memory.reclaim  # makes progress from any of 0-3
> 
> Presently, proactive reclaim iterates nodes in node or fallback order,
> meaning it attempts to make progress from the fastest node possible
> first - which attempts to demote by default.  If the lower nodes are
> full, this demotion will fail and we'll swap directly from the top tier,
> which is (presumably) warmer than the bottom tiers.
> 
> Enable source-bound reclaim in the memory.reclaim interface so that user
> space can have the same control over memcg memory tiers that global
> proactive reclaim has.
> 
>   echo 2G source=nodes:2-3 > memory.reclaim  # [z]swap from CXL
>   echo 2G source=nodes:0-1 > memory.reclaim  # demote to CXL
> 
> This lets user proactive reclaim to target the coldest memory first
> rather than preferring to reclaim from node0 first and potentially
> swap out memory warmer than what is present on a CXL tier.
> ---
> 
> With this, you might be able to demonstrate fewer refaults and less
> DRAM (node0) memory consumed by zswap. These are clear benefits.

Thanks for the example. It makes the problem much easier to discuss. I
will refer to it when reworking the v3 motivation, and will avoid
framing the issue as a generic flexibility problem.

> I would argue that memory.reclaim should operate this way anyway,
> and that would could make proactive reclaim do this by default, but
> I could see the policy bits in userland being useful as well
> 
> Performance may not be the only reason you want this, but you need to
> help me understand what you're trying to accomplish.

Thanks again for the review and suggestions.

Thanks,
Zhe
