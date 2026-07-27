Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB9D37DAD5
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785162536; cv=none; b=bL3jz5jBHTv8nr/gQ+Vt1PaEXbtEY50/wsG0Eo3CymYFCnnj4SUd6X9zUg3L95qSZtTSILeRxqGREES5AkUychwc2S5KScDQB0mTguDD22GMmzXazEZxt0SRWXJoXuTedgW06z4bxugtgekwJVH3C8zSy1KTS0/8Tq2AjpAT7ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785162536; c=relaxed/simple;
	bh=J1YR1miIhxDC9uZM0Wft8l657L+k53A+aQLGVzbk27M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5pLL8Sd/7aNh2WkzFC+1uOw4GmEAZSr2X2H9/bmxoBxE1n66IFqPxBB8KXhbfsH4miGmxHlZQ1IR5H40xDYMQXaCMC6SzslBUw4aOW0nGpu5NlVwMLahF03Qpkye+2ke3ibA2U/SFEBo7EWzNMCxlymoxww8HfFVAxZVOnKVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sq0VHDUf; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sq0VHDUf"
Date: Mon, 27 Jul 2026 07:28:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785162520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkkRTdV74rQTeXkzTGoMJcqmPwizpsosvteuIcTbWAA=;
	b=sq0VHDUfO8mBCuDnqVS/iAsGgZNRheiKOoC7299q6YQPK9G345lofQ9RyQwQETwGq9bnPF
	ImTJlcG9yd3KB1Tzi1h+73urjzX0vbtw/eO2aa4SYHCU6OUWiBHtglYkGkv4rKFzykdRlY
	F0qcemM12BAMWiVXU0yHY2+OsE/4vL4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amdn2Kcfe9owkDWN@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
 <amK-ApfqfwkPheC5@linux.dev>
 <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
 <amOv0MlF1S-oFZHX@cmpxchg.org>
 <amdjsVuNYW98Q--Z@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amdjsVuNYW98Q--Z@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 09:57:05AM -0400, Johannes Weiner wrote:
> On Fri, Jul 24, 2026 at 02:32:52PM -0400, Johannes Weiner wrote:
> > On Fri, Jul 24, 2026 at 02:29:23PM +0100, Usama Arif wrote:
> > > 

[...]

> > > 
> > > > 
> > > > The patch looks good but I have one question. We already have concept of
> > > > pgrotated through /proc/vmstat which represents number of pages we have moved to
> > > > the tail of inactive LRU to make them next reclaim candidates. This patch is
> > > > exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> > > > the number of pages we scanned but didn't reclaim plus number of pages given one
> > > > more trip in the active LRU.
> > > > 
> > > > Older and newer pgrotate metrics kind of represent something different. It may
> > > > cause confusion. Now before suggesting to change the name, let me ask do we
> > > > really need to expose these to the userspace? How exactly users can use these
> > > > new metrics? I think you can use them here without exposing to userspace. So,
> > > > does it makes sense to delay userspace exposure later when we have a more solid
> > > > usecase for that unless you have it already.
> > > > 
> > > 
> > > I do think the userspace counters have diagnostic value. They can be another metric
> > > to show how much anon/file reclaim work is spent on pages that are not immediately
> > > reclaimed, including pages retained on actie LRU. It could help explain if there
> > > is elevated reclaim CPU usage.
> > 
> > Hm, this is an interesting discussion.
> > 
> > The existing PGROTATED is kind of useless. When it's bumped:
> > 
> > - truncation fails and moves folios to the LRU tail for faster reclaim
> > - writeback ends on folio that was tried to reclaim, moves to LRU tail for fast retry

Yes PGROTATED only tells number of pages moved to LRU tail and nothing about the
why. I can see that from user's perspective the why part is more important.

> > 
> > Ok, who needs to know this? The new counters you're adding, on the
> > other hand, they capture the information you frequently need for
> > understanding reclaim behavior.
> > 
> > That said, looking closer at this one more time, you can already
> > (almost) derive them fully from existing counters:
> > 
> > drotated = (dPGSCAN_ANON - dPGSTEAL_ANON) + dPGDEACTIVATE_ANON
> 
> Talking with Usama offlist, there are two problems with this:
> 
> - PGDEACTIVATE is obviously wrong. We want the the pages we don't
>   deactivate (hot file executables)
> 
> - PGSCAN includes things that didn't work out due to caller
>   restrictions (reclaim_idx) and race conditions (tryget, !lru) that
>   shouldn't contribute to the balance.
> 
> So let's go with PGROTATE as Usama proposed.
> 
> But I'm against hiding them from the vmstats.
> 
> I'd rather remove or rename the existing one if we're worried about
> confusion. We've historically applied a much lower bar to vmstat
> stability. It's geared towards understanding detailed MM behavior
> behavior, which undergoes constant changes.

Let's keep the deprecation part orthogonal to this series. No objection from me
if these new metrics help in understanding the MM reclaim behavior. The only
request I have is to introduce these metrics as a separate independent patch.
First introduce the metrics with the detail on how they can be useful and then
later use them for the internal balancing algorithm.

