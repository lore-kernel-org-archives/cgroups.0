Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F64935AC3E
	for <cgroups@vger.kernel.org>; Wed, 11 Mar 2026 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773248425; cv=none; b=dEYq6m8VA3hCT7QC27s1EZb0Bs2+zdmKSTPqxEo+JX5mtgDmkTgWP+kobHz/2P2s002EuEHVKGJBedQzosVdy2CDyTG1TtdnNNAw+noiFXqv1Syc/ezWjXnS8GyNab5mZ6oOexauP1lLglo/fjPM+F0I/u7M3Va/xpBA5b8KqWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773248425; c=relaxed/simple;
	bh=35TT/u99aRALHa0hnM2POym+gxT3aGGRaU/TmPXQhL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eP9Uf5tmsEfElmkK33dNoh0F1NaLQBQEhrqPOHpJ5O1jnA5RfmpwzVnC82iRzcE68GGcImshFqwC2qyZ5f98qD3v2kswBmJ3wR2Fw8bCMKc2r9Xuvu81EFsRBxVbDhwzVhz46Sluad6oefNcnR7NxPgulus0UFEWVpVR2wXwS2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pjqpT2QE; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pjqpT2QE"
Date: Wed, 11 Mar 2026 10:00:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773248411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8u7gOfH94HKLacZFGszI8Rx3/Wm+sBV0C+t5lK8/D3g=;
	b=pjqpT2QEx4QK4mt9WWipNl59lZpDJsmlzMJx2BS0z9m7lFDATjsn4sT7L1t5WG0S8BWeR7
	30jtKuIoe2+ew2uhWL2YcasG+2v14BUqCRQ1kfYnUQH31uq5teDA8hxaVhrB9tOQ0locxG
	WlaeoTQ+EuQzlgyi0SYgYA6788FQ2UM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Muchun Song <muchun.song@linux.dev>, Geliang Tang <geliang@kernel.org>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, Emil Tsalapatis <emil@etsalapatis.com>, 
	David Rientjes <rientjes@google.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Message-ID: <abGdmslfvNTiQUJm@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <6076b8c2-c198-442d-974f-b3084a0cd1b1@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6076b8c2-c198-442d-974f-b3084a0cd1b1@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 11, 2026 at 12:57:34PM +0800, Jiayuan Chen wrote:
> 
> On 3/8/26 2:24 AM, Shakeel Butt wrote:
[...]
> > 
> > Per-Memcg Background Reclaim
> > 
> > In the new memcg world, with the goal of (mostly) eliminating direct synchronous
> > reclaim for limit enforcement, provide per-memcg background reclaimers which can
> > scale across CPUs with the allocation rate.
> 
> This sounds like a very useful approach. I have a few questions I'm thinking
> through:
> 
> How would you approach implementing this background reclaim? I'm imagining
> something like asynchronous memory.reclaim operations - is that in line
> with your thinking?

Yes something similar. I still need to figure out the details of the mechanism
but it will be calling try_to_free_mem_cgroup_pages(). More specifically the
context need more thought because we need to account the CPU consumption of
those background reclaimers to corresponding cgroup. Will we be using BPF
workqueues or something else, need more investigation.

> 
> And regarding cold page identification - do you have a preferred approach?
> I'm curious what the most practical way would be to accurately identify
> which pages to reclaim.

That's orthogonal and is the job of the reclaim mechanism which can traditional
LRU or MGLRU.
> 
