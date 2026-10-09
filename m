Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED724F55BF;
	Fri,  9 Oct 2026 19:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791574802; cv=none; b=o75kpSaYuU5wncBdwoGfUNKD7U9lkgpwkQZTFsknVdAa8+chw0bfp58AWwCQT2bbuwCwJjfLb0qpnwX0NQVmlqlaC3jfP4QUJYgGxQn6UmNnnxQDfsyISIMujRMb0WFhjGseysETPs2Jd+lBvHibA9MyaXf8Ma7eGpVdCIIrtwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791574802; c=relaxed/simple;
	bh=A1afFb/uLK5QLrZzYFQc61hLyu5KFVxEsuF7yOPAjUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCmQYQIQbpL8zwk3LkgVxOjFdzKHv9UJl4goIpaeNPEpmTXMaatF1KhgR5k/qUQCrt5W3PBC6eVsqqQxfR+nynIxj62pgC+OYzm5e5R0Ct0xXrgeNzPHR5hbXXbZrcglXgZhen3GyM5sZptcvWxQfn2YmVcKP+zruie4GID/Mu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8e8DRo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8e8DRo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026761F000FF;
	Fri,  9 Oct 2026 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791574791;
	bh=i1X2Q68ZmYsPWobrAu7yZxvAEcunRnI0QLmJSHkQTsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z8e8DRo/AVA9dOkXV7/WAaZmDrCtuRLJu70W9RqRnnftfwEJwAggklQbJlzDjomCd
	 NcHAvYULKuYrlqcHTP/2dAMwl0XqXyUaa6ZerBn90d3OY9P2HOV1Dns7S9gUcKPRWt
	 HqeiVb4t7i6RFj+5LKvCj+utjJrsZxcthA5QPKEEFd7/adEixO8ONBnyFVZg/8/vTe
	 UNyW1qR75zam1ahjU+AIr1Xk7PGei6iSHn46USHvDHsroYic5ZgokBtFw2lRdfp/dv
	 4DMyQDex+LEiF+I6GU5CFrF/C1yL2LUmemOIqlM4IQ1FSL0EAhAWt3u/zds14kWPay
	 uSYH8xBv2i/HA==
Date: Fri, 9 Oct 2026 21:39:48 +0200
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
Message-ID: <ask5kpMS4mpI8Api@thinkpad>
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

On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
> And now I see the initial kmem_buckets design did not sufficiently
> tackle the question "How this should work when kmem_buckets falls back
> to kmalloc?"
> 
> I suppose the kmem_buckets' abstraction should not be too tightly
> coupled with kmalloc caches. Creating a kmem_buckets should be
> conceptually equivalent to creating a set of caches with speicifc
> slab flags, size, align, useroffset/size. (for variable size allocation).

Just to clarify... I have a few concerns on this area.

1. Complexity.

It's very counter-intuitive to understand how it works when
SLAB_BUCKETS is not compiled. My brain cannot easily process two
different implementations w/ and w/o SLAB_BUCKETS.

A "compatibility layer" allows us to assume certain expectations
and ignore all implementation details when SLAB_BUCKETS is not compiled.

2. Making kmem_buckets tightly coupled with kmalloc's implementation
   details is not reasonable.

Let's say, at some point we make SLAB_BUCKETS always enabled and drop
the config option. Then all kmem_buckets users will now have certain
assumptions inherted from kmalloc (e.g. alignment), which is not
reasonable.

3. __GFP_ACCOUNT and __GFP_DMA should be applied to all allocations
in the slab cache. For kmalloc, these flags are only used to select
the kmalloc cache (which has equivalent SLAB_* flags for __GFP_ACCOUNT
or __GFP_DMA) to serve the allocation.

Specifying it on individual allocations (rather than as SLAB_ flags)
makes it easy to break the assumption.

> When it falls back to kmalloc, kmem_buckets itself should provide a
> compatibility layer when falling back to kmalloc.

For example, calculate_sizes() converts certain SLAB_* flags into
GFP flags (s->allocflags) for allocation. We can have a similar
logic when falling back to kmalloc.

Though current implementation does not allow this and requires
some rework.

-- 
Cheers,
Harry / Hyeonggon
