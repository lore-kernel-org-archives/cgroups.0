Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793737320;
	b=Ne7AgaQq7V/fNygofWY88cUEAi7CgzgoVQKt6bRa85hSdp2yAbfsjiP/T759dlkHtSIY
	 WHvKr+shdDC55gn8eDcVd4tW1Qqpcsk+Zw9Ru8dVJacpD1wNJZ0da8wkSN88U85o9kbRe
	 gj6SfrvtbTd2JmSriSENSoBVmhTpcycoTvPDE8Wd10tXMwMJqImt2H9I4QbJdZr9RETGk
	 6xXigxOw96s/FV1XZdyzv6ZDu3bG6Cgb/FlKZQp/wJVlwisSoOdL9/r3fZzmWCjzjPVGo
	 60zhUos83+OotMxhEr1OFnpQ3lVbSWj/R7oU3bWSEUhNZZwQsss1JHEv+CfGAYJHj3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793737320;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZI36IvN614wZfc+9bgno27AitbTt9jTYGJEoJ2XdrFY=;
	b=RQ7C+k1i8/OEaN/LNlOld3ru8mf0xxic8YMRdtVRJAbwHF0jise7Lz8dqbVXvJPPtAVR
	 VKMLt3YjOTNvl3EB1UkzIY9bPddIKSKzfKovOcg//kMXFcK3UIjTlIst1zdqipvzAEHMK
	 1LJJTl/i726Clih7nBbUPi8LwVQQH6jaDSXljdt8PZskAWw6rodPIbCy3ETv+vpleG1Ui
	 313zhIBnQ7wmGHGdw+BjIkbEJPJKYFCFcCNosEwzocDFsQxYSixq0peo6HDelv5BXy248
	 fG2u1NwZwrzMTBRrPceXuRMJr1k6Z0dA3KO+S51Fh6sxUfy6pm/8HS/KV4tfFV/NFBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RcoDvnjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB603606A329;
	Tue,  3 Nov 2026 20:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RcoDvnjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54161F000C1;
	Tue,  3 Nov 2026 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793737319;
	bh=ZI36IvN614wZfc+9bgno27AitbTt9jTYGJEoJ2XdrFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RcoDvnjE7moujvLfJtbEFbra0suwdCXxNcVPBt9C+MQr2fIm0ROIdyzWvCf0r6dPm
	 h1Yua3KwN/dXEbvecfBPraEq1DvHkQMvoF2Bp11NIyhrTb2NCMYj2w27/1eh/hNvWH
	 O6IP9cDUNObqZD1pqWdB6kNJNl7EUFpDky9G3OiS6bKFKY1mVeKeMUUn4DvFnIuQJ5
	 MfPvPYy2mOBhzLy8ZAizjeqfuKz6tTG4VQwTE83YJIVdVX9wArgcLLkJtkotpfWXyF
	 9aX10naWVt/B4m4NQciKHVny928DYGf/UA8QtXJSt4Dc85L5sZuX2NERO9yskptzgY
	 fgwK4+Cxd5s8g==
Date: Tue, 3 Nov 2026 20:21:57 +0000
From: Harry Yoo <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Message-ID: <auo5G__ac1qA9JRs@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
 <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com>

On Tue, Nov 03, 2026 at 06:40:09PM +0000, Alexei Starovoitov wrote:
> On Tue, Nov 03, 2026 at 06:47 AM Harry Yoo (Meta) <harry@kernel.org> wrote:
> >  	if (likely(size == 1)) {
> > -		memcg_alloc_abort_single(s, *p);
> > +		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
> > +
> > +		memcg_alloc_abort_single(s, *p, allow_spin);
> >  		*p = NULL;
> >  	} else {
> >  		kmem_cache_free_bulk(s, size, p);
> 
> can we call kfree_nolock(*p) here when spinning is not allowed ?
> Karl's patch did that. You replied that memcg_slab_free_hook() should
> not see an object that is not charged:
> https://lore.kernel.org/all/asaAwg1KeZoEYd4K@thinkpad/
> It's fine. __memcg_slab_free_hook() skips an object with objcg == NULL.
> The else branch relies on that. kmem_cache_free_bulk() also gets
> the objects that are not charged yet.

While this is technically true, this relies too much on the current
implementation details and makes the code hard to follow.

> > +	if (likely(allow_spin))
> >  		__slab_free(s, slab, object, object, 1, _RET_IP_);
> > +	else
> > +		defer_free(s, object);
> 
> That's an irq_work interrupt per failed charge.

irq_work overhead should not matter by the time memcg fails charging.
the kernel can't reclaim memory in unknown context and allocations
won't succeed anyway once we hit the limit (unless somebody else
reclaims memory for us). We have a bigger problem there.

> kfree_nolock() tries free_to_pcs() first. It calls defer_free() only
> when that fails.
> 
> Then no need for allow_spin in memcg_alloc_abort_single(),
> and the fix doesn't depend on patch 2.

Patch 2 is an independent bugfix as-is already. We should really stop
open-coding slab_free_hook(). That ended up missing init_on_free handing.
 
> Something like this (compile tested only):
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 45e077c..fb92b48 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2551,7 +2551,10 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
>  		return true;
> 
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		if (likely(alloc_flags_allow_spinning(ac->alloc_flags)))
> +			memcg_alloc_abort_single(s, *p);
> +		else
> +			kfree_nolock(*p);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);

-- 
Cheers,
Harry / Hyeonggon
