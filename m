Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A01114A60F;
	Sat, 10 Oct 2026 03:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791602341; cv=none; b=Z9U1WBnRhtIA3ON12Itv9Fj+XVbCarDrlKMuQ4pWLaJ3jLrl0brkEv9VkTGvDsEnBJNtEa1SoTt4hlLywyVUkCGabORUH+1B7iw39HgxLwrFHFruPPvuYBfgN/mibSS2FhUjYQf9MP2uwFm8M7uvgjyWS5QNlYyyWrQ+sO1NvFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791602341; c=relaxed/simple;
	bh=QhscVVAhAWdzZMvxnfWngyElPv80yj6D4SS6D1Dq7yQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3wInzgAs0HwweI8jJ5yX0QFymdAvWYfVgjD+3lgjl3EOlQsbzxQlREU5Gj/bZcoQCsmU38eBnjuMQlVi92OkDbQP9JhdfTPuPWH7BvYnx/OTJfzEebEtVDl9l+qsjYYe4a4jJyunIEATMgYGvhMFQaaykW1iHjnkJa/RZX7O9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVmjNQFt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVmjNQFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42761F000FF;
	Sat, 10 Oct 2026 03:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791602339;
	bh=mvErx1WWrmavZpAWawNx/SxSWFSIPpRG5LFKnvSw2A0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jVmjNQFtVai+W7WXC+h3kBaL0yjWXjUQJYTf2QnXM6D3GAH9/NAhARUSIpFOV0ocz
	 ldAQ277Wo7iqm+PAjlF23ZdAK1uixhqlEROEG4z6b13Dftr/BL+rzd6RoAuKK5qweZ
	 CUe5/3NsUdVjpRG/ava7nnO58ZC5r8ewUiFIB+xTaOUcmHx1krhNwlHvU6+KWDQplT
	 RA1laodn+A61NsVE/vx1EED1Ew5/AINNnK9pSkEWxhOllREjl9+3cxE6oRP+GKBfdc
	 Jj9BT6Foz6Is5IHwk76OmFoK50H788A3TiXNzSJGWK9kt+ceeBVH3TG0EOeu4FAfwo
	 j8pwAY4y1zMdw==
Date: Fri, 9 Oct 2026 20:18:59 -0700
From: Kees Cook <kees@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <202610092014.AAB20B81@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
 <ask5kpMS4mpI8Api@thinkpad>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ask5kpMS4mpI8Api@thinkpad>

On Fri, Oct 09, 2026 at 09:39:48PM +0200, Harry Yoo wrote:
> On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
> > And now I see the initial kmem_buckets design did not sufficiently
> > tackle the question "How this should work when kmem_buckets falls back
> > to kmalloc?"
> > 
> > I suppose the kmem_buckets' abstraction should not be too tightly
> > coupled with kmalloc caches. Creating a kmem_buckets should be
> > conceptually equivalent to creating a set of caches with speicifc
> > slab flags, size, align, useroffset/size. (for variable size allocation).
> 
> Just to clarify... I have a few concerns on this area.
> 
> 1. Complexity.
> 
> It's very counter-intuitive to understand how it works when
> SLAB_BUCKETS is not compiled. My brain cannot easily process two
> different implementations w/ and w/o SLAB_BUCKETS.
> 
> A "compatibility layer" allows us to assume certain expectations
> and ignore all implementation details when SLAB_BUCKETS is not compiled.

I'd rather make kmem_buckets not have a SLAB_BUCKETS option. :)

> 2. Making kmem_buckets tightly coupled with kmalloc's implementation
>    details is not reasonable.
> 
> Let's say, at some point we make SLAB_BUCKETS always enabled and drop
> the config option. Then all kmem_buckets users will now have certain
> assumptions inherted from kmalloc (e.g. alignment), which is not
> reasonable.

Until it's always enabled, I don't see a reasonable way to separate
those assumptions.

> 3. __GFP_ACCOUNT and __GFP_DMA should be applied to all allocations
> in the slab cache. For kmalloc, these flags are only used to select
> the kmalloc cache (which has equivalent SLAB_* flags for __GFP_ACCOUNT
> or __GFP_DMA) to serve the allocation.
> 
> Specifying it on individual allocations (rather than as SLAB_ flags)
> makes it easy to break the assumption.

As in, you don't want a "pass-through" mode for __GFP_DMA?

It's a lot of overhead for __GFP_DMA to have multiple providers, so I'd
rather allow kmem_buckets to allow pass-through (perhaps explicitly
opt-in) where then the other options (e.g. alignment) must match the
general kmalloc caches so that pass-through is consistent.

> > When it falls back to kmalloc, kmem_buckets itself should provide a
> > compatibility layer when falling back to kmalloc.
> 
> For example, calculate_sizes() converts certain SLAB_* flags into
> GFP flags (s->allocflags) for allocation. We can have a similar
> logic when falling back to kmalloc.
> 
> Though current implementation does not allow this and requires
> some rework.

I think the current series does everything correctly in the sense that
nothing is allowing for mismatched fallbacks/passthrus. We could iterate
from there once we have a need for this where a non-kmalloc-alignment is
wanted, etc?

-- 
Kees Cook
