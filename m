Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11D3BFACC;
	Sat, 10 Oct 2026 03:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791602061; cv=none; b=gZocttB///qLUUXvtzcmKrDFzPhsNQe0L1dpSeRXu0Q/wuO8H3v7yCZfT//6uW08dHZ7tuoXOp0H88ZsHO2AwF+bDphluYVrx1X6Agq6ceRMK32Xp6M/SCXjFfQh5ZIaEgbj8dQDaoa57LolYDI0YlVJ6v8vH6BGkqr2ARcpRd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791602061; c=relaxed/simple;
	bh=2G+C11ZvH5kUHczR3s9dcogVUbiZlWzUB8uhJk5uIK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7OtvGah48YoW3X+OzII7gNrPE0mrkJZVruuTdtxdG2d0cshibsgTF+gonfifCZLSbiluyn/3ODhIq4S0uXOb49dLUdrSzbORinOONwSy+1KBAAEYD3v+g7Sis5lqvfMRtGNE7sHaLrBoxW7cm5IKSKWKfy8aPLQw/R5/uYwOnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oc1T4x/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oc1T4x/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B551F000FF;
	Sat, 10 Oct 2026 03:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791602060;
	bh=yx/JVeS1tmYz5AP+LsJLVcBiKsmoT3twRZPPXFAPFaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oc1T4x/g5lQjaBIT/nueAYeZavtGP25+leC8be+gNguhGbZjR6bQbufUOCFqkGJse
	 fZfUGdwCrIvpkUvDT/bELtH+vWc7VCf8BIbqu3Y0DyABc/Yxaz4t0+VeFClAM5baES
	 PEo323XO8rYESGmi6Y2zH0mJ5kJHZrUfPOO9FAz1cjpGA/0gM0AagD/iwfcZxxgbby
	 OBTJyyRUkt884jgmmXoGZRJsXiiM+/SzsSRQ68LVNndJ02kfx9gF9dOaGpNqRkEJua
	 41Hov7gvPXLYJMP6HGMp+vHU0iagrg8j2hCnI+lEhujPCNEIQEfQxNbauTe9p+WZRJ
	 /73/mYX4wJAEw==
Date: Fri, 9 Oct 2026 20:14:20 -0700
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
Message-ID: <202610092010.934197B@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asjhg2e4-WSeKuXd@thinkpad>

On Fri, Oct 09, 2026 at 04:22:01PM +0200, Harry Yoo wrote:
> On Tue, Oct 06, 2026 at 02:20:28AM -0700, Kees Cook wrote:
> > Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> > alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> > accounted only through SLAB_ACCOUNT on its bucket caches.
> 
> > With
> > CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> > kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> > which do not account it; the same happens when kmem_buckets_create()
> > fails. Either way, the allocation is not charged to the sender's memory
> > cgroup.
> 
> Ouch, now I see what's gone wrong here... 
> The fix for this bug should be Cc: stable IMHO.
> Allowing to escape memcg charging is not good.

Anything with Fixes: will end up in stable, so I just leave off the
stable CC these days.

> > Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
> > charges such an allocation in whichever cache serves it, so drop the
> > SLAB_ACCOUNT, which no longer adds anything.
> 
> Hmm in the long term we don't want allowing __GFP_ACCOUNT allocations
> that are served from slab caches without SLAB_ACCOUNT, as this wastes
> memory.
> 
> See: https://lore.kernel.org/linux-mm/20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org

This is how I thought things worked, so my original version of this
series kept separate caches. (I can return to that too, but it doesn't
seem to be needed today?)

> And now I see the initial kmem_buckets design did not sufficiently
> tackle the question "How this should work when kmem_buckets falls back
> to kmalloc?"

Right. We could just make kmem_buckets non-optional, too? Then they
could have all the caller personalization they need.

> I suppose the kmem_buckets' abstraction should not be too tightly
> coupled with kmalloc caches. Creating a kmem_buckets should be
> conceptually equivalent to creating a set of caches with speicifc
> slab flags, size, align, useroffset/size. (for variable size allocation).

In my mind, the general kmalloc caches are just a specific instance of a
kmem_buckets...

> When it falls back to kmalloc, kmem_buckets itself should provide a
> compatibility layer when falling back to kmalloc.

IMO, it'd just be better to make kmem_buckets not NEED a compat layer...

> (Okay, allowing ctor is completely broken, but other attributes are fine)
> 
> ...I don't agree with the idea that "since kmem_buckets can fall back to
> kmalloc, kmem_buckets can only have the same requirements as kmalloc
> (slab flags, alignment, etc.)".
> 
> By that logic, shouldn't we give up specifying useroffset and usersize
> too? :-)

Yup, but I kept that since only the hardening guarantees change under
that condition -- nothing operationally depends on useroffset/size.

-Kees

-- 
Kees Cook
