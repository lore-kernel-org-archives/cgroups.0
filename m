Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47EE455607;
	Mon, 12 Oct 2026 21:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839107; cv=none; b=erAzmntCm/Uzso3eBUno8seRIqmpug9jYl7K8gxTR1nP8zj+QVs6RFuRyOgXRiUHIxAggrrAtddnPIQAW4Hm1Nh1nc3ohYGRGWVZOUVX3z52F5tXxiTCPJyDhBUd4mzuX4GVU+GaDIC0RO/PK05a4UM3MeoF6QP5fxc3l5x9p2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839107; c=relaxed/simple;
	bh=Q90JH24E3KQ4rNRarUBSo9Jspz/yKvJGgfgHiOI0Z2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPfdTn4PmYRCIHf1ZGEz7zsst7fcNsnpcssMKdPy8Gdo9XVggyWpRMC6YtIKH6/ZjdFJrF5mIxpRI835OASn/9dN81Ib9LKRx1EhWaoqfjILfocwgdG+jMpS+Pb0gZp0FJz1kMrZJ1hIOpXufEV8FRFvaEjhnb+Nnhe3q05Yb0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6KuxaON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6KuxaON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC491F0089B;
	Mon, 12 Oct 2026 21:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791839106;
	bh=OEthCKb0rkLjJTmItEReVKIpiCN+N7TNwVq0rSj7hO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C6KuxaONUZ6vdX4/61BIkmE1jjMCaFkuoNssbRGuxhkoCoRChHiehx/gflbLzFTeg
	 ePOcsf0OZjJENTZ+rxQ045XvO2AzDuRNVvqnqgK2D8ZxHtPOQXKbAmkVAAaFMN1ZOH
	 5e1S5n3vivd2CiL0xcGXjF5tiT+7ariYKigSpk9BjeIso8kyBUgT03n3Big7tljZdV
	 0IKhGJUaoh3AejelgkYiqRzPYeypahhFE5zfrvqtWCZkbN7ALVTfUqUgkY4GMZbIj+
	 A/nSG7mgEh1s3SbdbAkEJGvHiBwYKT/Q9TjSH0/p36KXG6AIsMCYaeZBYSO6Hn8kso
	 SjFx/g21JgAUA==
Date: Mon, 12 Oct 2026 22:05:04 +0100
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <as03h8sgRzpw7JXI@thinkstation>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
 <ask5kpMS4mpI8Api@thinkpad>
 <202610092014.AAB20B81@keescook>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202610092014.AAB20B81@keescook>

On Fri, Oct 09, 2026 at 08:18:59PM -0700, Kees Cook wrote:
> On Fri, Oct 09, 2026 at 09:39:48PM +0200, Harry Yoo wrote:
> > On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
> > > And now I see the initial kmem_buckets design did not sufficiently
> > > tackle the question "How this should work when kmem_buckets falls back
> > > to kmalloc?"
> > > 
> > > I suppose the kmem_buckets' abstraction should not be too tightly
> > > coupled with kmalloc caches. Creating a kmem_buckets should be
> > > conceptually equivalent to creating a set of caches with speicifc
> > > slab flags, size, align, useroffset/size. (for variable size allocation).
> > 
> > Just to clarify... I have a few concerns on this area.
> > 
> > 1. Complexity.
> > 
> > It's very counter-intuitive to understand how it works when
> > SLAB_BUCKETS is not compiled. My brain cannot easily process two
> > different implementations w/ and w/o SLAB_BUCKETS.
> > 
> > A "compatibility layer" allows us to assume certain expectations
> > and ignore all implementation details when SLAB_BUCKETS is not compiled.
> 
> I'd rather make kmem_buckets not have a SLAB_BUCKETS option. :)

We'll need some data but looking at the discussion thread [1]:
> I wasn't able to measure any performance impact at all. It does add a
> small bit of memory overhead, but it's on the order of a dozen pages
> used for the 2 extra sets of buckets. (E.g. it's well below the overhead
> introduced by CONFIG_RANDOM_KMALLOC_CACHES, which adds 16 extra sets
> of buckets.)

[1] https://lore.kernel.org/all/202404280921.A7683D511@keescook 

If the data still shows that the cost is still "dozens of pages"
for a few buckets w/o measurable performance overhead, I think that's
certainly doable.

> > 2. Making kmem_buckets tightly coupled with kmalloc's implementation
> >    details is not reasonable.
> > 
> > Let's say, at some point we make SLAB_BUCKETS always enabled and drop
> > the config option. Then all kmem_buckets users will now have certain
> > assumptions inherted from kmalloc (e.g. alignment), which is not
> > reasonable.
> 
> Until it's always enabled, I don't see a reasonable way to separate
> those assumptions.
> 
> > 3. __GFP_ACCOUNT and __GFP_DMA should be applied to all allocations
> > in the slab cache. For kmalloc, these flags are only used to select
> > the kmalloc cache (which has equivalent SLAB_* flags for __GFP_ACCOUNT
> > or __GFP_DMA) to serve the allocation.
> > 
> > Specifying it on individual allocations (rather than as SLAB_ flags)
> > makes it easy to break the assumption.
> 
> As in, you don't want a "pass-through" mode for __GFP_DMA?
> 
> It's a lot of overhead for __GFP_DMA to have multiple providers, so I'd
> rather allow kmem_buckets to allow pass-through (perhaps explicitly
> opt-in) where then the other options (e.g. alignment) must match the
> general kmalloc caches so that pass-through is consistent.

Having both "Specifying __GFP_DMA for slab caches without SLAB_DMA is
illegal" and "However kmem_buckets is an exception because creating
separate buckets for SLAB_DMA is costly" in mind is confusing and
easy to get wrong...

Perhaps the user should bypass kmem_buckets and fall back
to kmalloc?

> > > When it falls back to kmalloc, kmem_buckets itself should provide a
> > > compatibility layer when falling back to kmalloc.
> > 
> > For example, calculate_sizes() converts certain SLAB_* flags into
> > GFP flags (s->allocflags) for allocation. We can have a similar
> > logic when falling back to kmalloc.
> > 
> > Though current implementation does not allow this and requires
> > some rework.
> 
> I think the current series does everything correctly in the sense that
> nothing is allowing for mismatched fallbacks/passthrus. We could iterate
> from there once we have a need for this where a non-kmalloc-alignment is
> wanted, etc?

Making kmalloc tightly coupled with DMA alignment requirement was
a mistake, and now it's too late to fix that. It's better to not
repeat the same mistake again?

-- 
Cheers,
Harry / Hyeonggon
