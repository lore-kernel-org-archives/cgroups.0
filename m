Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2A93E7152
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 19:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780948238; cv=none; b=lpfHd0A9xBc7pgC+uhhruGDqQx4HSnDw1tVLo8tJX8i7VThFVdOVBybuplPRoxAUY3jXbWQoZwn1yWam9hO9Cj9QBRE/6T5Rfucsx+JDpXVPJFYybFBkJey10vmLHrtI5y67ec86MH3uDc0fwT5TZtaPz00/2yvv4eYqo9XYhPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780948238; c=relaxed/simple;
	bh=QbpVzfVc4z1sGneEviDuKx+1h4GgvHHeeDGNVEAHAfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiMODl6EHri5zlfu7TdXWT4JyHa6tmGcSTJSWZb2/oG7NNSyhTIYVowjUdVuY1ockuQOY0LGdK35xnIDrU/7G2DKheZfwW7XwZ4h5Jcx6SgaZEYQDYAdnfg7k9+/r3ntt8U4ta9OFgA7AT4Kc8Eo3Li/3RCmAYieeGcoKqxoXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c2/gonYM; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c2/gonYM"
Date: Mon, 8 Jun 2026 12:50:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780948224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gpMcdQqQNsSXJkHf7o33LPCAH/sDumLYvx0osSZwQns=;
	b=c2/gonYMrRlOyUbx6j7slsmXtXB/NhjBZq7g94qgLh/kp1ZYqDCE+V3jnmCSdBXVF9PVPq
	jsm3Fnnh3v1Xi6aHkZM9o1sgYR2Thfk/7YUjCIPUFQBqZDQ3YQ8qjkvXsR/Lend79SC2X3
	tHEq9iEQPu6KM9KQ7LjZiPKoUudHkUk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, youngjun.park@lge.com
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aicZ-5GX9De3MAU7@linux.dev>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
 <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aicJBVT4pBvmyooT@linux.dev>
X-Migadu-Flow: FLOW_OUT

+Youngjun

On Mon, Jun 08, 2026 at 11:30:30AM -0700, Shakeel Butt wrote:
> On Wed, Jun 03, 2026 at 10:36:07PM -0700, Yosry Ahmed wrote:
> > > >> But doesn't it make more sense to specify the compressed size, which is
> > > >> ultimately the amount of memory you actually want to reclaim.
> > > >>
> > > >
> > > > I personally prefer compressed size to pre-compressed size. That's
> > > > kinda what user cares about, no?
> > > >
> > > > One thing we can do is let users prescribe a compressed size, but
> > > > internally, we can multiply that by the average compression ratio.
> > > > That gives us a guesstimate of how many pages we need to reclaim, and
> > > > you can follow the rest of your implementation as is (perhaps with
> > > > short-circuit when we reach the goal with fewer pages reclaimed).
> > >
> > > Got it. I will change it to use the compressed size in the next version.
> > >
> > > Yosry, Nhat, should we continue using the zswap_writeback_only key to
> > > trigger proactive writeback?
> > 
> > I *really* want the memcg maintainers to chime in here, it's
> > ultimately their call.
> > 
> > Michal? Johannes? Shakeel? Roman? Anyone? :D
> 
> Between the options of having an explicit interface (i.e.
> memory.zswap.writeback*) or a key (i.e. zswap_writeback_only) to memory.reclaim
> interface, I prefer the key option. I have not looked into how much proactively
> reclaiming zswap memory or proactively triggering zswap writeback makes sense
> but from the perspective of memcg interface, I think the key option would give a
> more clean solution if we decide in the future that this whole thing was a bad
> idea.
> 
> Next regarding future proofing zswap writeback trigger, do we expect any
> potential additions/changes/new-features for this interface? For example do we
> expect in future we may want to trigger the zswap writeback only from a specific
> node or lowest memory tier?

Youngjun is working on swap tiers. At the moment he is more interested in
allowing a specific swap device to a memcg or not. I can imagine in future there
will be use-cases where there will be a need to demote data on higher tier swap
to lower tier swap. What would be the appropriate interface?

BTW does zswap folks think of zswap as a top swap tier or something different?
