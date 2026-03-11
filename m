Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEDD358375
	for <cgroups@vger.kernel.org>; Wed, 11 Mar 2026 20:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773261558; cv=none; b=QSL3KFkxl9jg9nP7q0ALl8mmZm2OhPCB8XIVFmigezwEQI3oNDs8LmC6QjHYlMDmPwyP9sfIX5yUpQCaNfZOM5RVK1iXKfvc3A/AO3o4HhqD7jbzER4AMvjA2rkJ9w1bgBeVS2Jw5ouZ/4e6Ov0QgLELVWX92FWYl9SS+aBrY5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773261558; c=relaxed/simple;
	bh=tSWD3M4HidTSq9Bq42B5WqUwH+sIJInGjN1RInkRHCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxeDcxH6X+W4bf8AUnlQ2ntHTB2bI6XV1hfP+jwUa96VHrlrgtIWak6mJE1I05DOW3L1lpIvBibWGn8q+MKghQ2YkDH6huX98LeOAI/1xNXT0VwKfdoUn4y8SwDZI7VDdd8bARzmer4EGpjnE5+QRK9jxQ6gLs7i8u+ubStIPEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RElTbM1F; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RElTbM1F"
Date: Wed, 11 Mar 2026 13:39:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773261554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EwfKeZ56gyoF6sCCv42pKYEgEb5eXyBSdLdTd3tijNU=;
	b=RElTbM1FwjqljucTmdeVwDIoKFhMo33LPh8IBRa+k7zUaN5agQSCK/giiJSuNYntvKf6IP
	+Em8Pl6YTKXHnwLvk5U/qqTIXI5LsN/XNmGxC7BzoGxlsz5md3nPd6WwVq2gYh1hNlLKL8
	J/ZHH1ikawcxl/HfrMWR2Iphd6nAd/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Geliang Tang <geliang@kernel.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Emil Tsalapatis <emil@etsalapatis.com>, David Rientjes <rientjes@google.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Message-ID: <abHPsCypwo7ZhqIt@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <3ECC9B38-6C1A-4F60-9C18-98B7A1A56355@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ECC9B38-6C1A-4F60-9C18-98B7A1A56355@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 11, 2026 at 03:19:31PM +0800, Muchun Song wrote:
> 
> 
> > On Mar 8, 2026, at 02:24, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 

[...]

> > 
> > Per-Memcg Background Reclaim
> > 
> > In the new memcg world, with the goal of (mostly) eliminating direct synchronous
> > reclaim for limit enforcement, provide per-memcg background reclaimers which can
> > scale across CPUs with the allocation rate.
> 
> Hi Shakeel,
> 
> I'm quite interested in this. Internally, we privately maintain a set
> of code to implement asynchronous reclamation, but we're also trying to
> discard these private codes as much as possible. Therefore, we want to
> implement a similar asynchronous reclamation mechanism in user space
> through the memory.reclaim mechanism. However, currently there's a lack
> of suitable policy notification mechanisms to trigger user threads to
> proactively reclaim in advance.

Cool, can you please share what "suitable policy notification mechanisms" you
need for your use-case? This will give me more data on the comparison between
memory.reclaim and the proposed approach.


> 
> > 
> > Lock-Aware Throttling
> > 
> > The ability to avoid throttling an allocating task that is holding locks, to
> > prevent priority inversion. In Meta's fleet, we have observed lock holders stuck
> > in memcg reclaim, blocking all waiters regardless of their priority or
> > criticality.
> 
> This is a real problem we encountered, especially with the jbd handler
> resources of the ext4 file system. Our current attempt is to defer
> memory reclamation until returning to user space, in order to solve
> various priority inversion issues caused by the jbd handler. Therefore,
> I would be interested to discuss this topic.

Awesome, do you use memory.max and memory.high both and defer the reclaim for
both? Are you deferring all the reclaims or just the ones where the charging
process has the lock? (I need to look what jbd handler is).

