Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880590;
	b=WHIplZsxk3wJ1jQsTd2Gk0XI20iEsmDjWYBeU9VL2JrHvLgwsZ6V0fJnQzC4egXSWAAX
	 BMTfh3/qM9a+DhiipKw4J2A11+FP/b4nZsnw1T18Ruj3gP6olwm13DaHg62iceAFV1JuM
	 CDid+gl7QyOYivaoSH6TGzd2vpAMlkNdsEJaGIDJy5u+6351u0eApC8jWf7NNoWyrIIYu
	 xqn8o5QHmnk/Sw873loYzvvIAMDfD0mEScJY1i4B90Dw9A+4lBXg8EaJm9OZRQX9Ie0Ze
	 MNptEN4r5Nii6bBOeqa+g2guW1d0VkvbbofUC1I7YLbbVT8GdA/BsE3MLUaMcbRTr3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880590;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gukOYmvYDHX2QKSOGio7z+vsfvmKRfuVGQNVt9yzjww=;
	b=C715gJ7hkcqOw4X8J80Aa/lQ5vw7+LVBbayv93omZ40pjxcPiDh7k5qasCPjS38U9iW2
	 OReDVxgoni00z6DTvEJgRx8x5XZzSUrc/NdO35BBO+C+aW60sVnMe2bhx9SQtyVSfJT40
	 btsCqB5RMCivfBbmuC3G4M8EBp85RnjAshFWhGjBJc0dvpgfTsFnMI7E3ESSlQJU9lQKR
	 MTIAaamkaiTOuOxRkgZL/rn3QaYJnbqS3VirfcAWVSrZo8zLgq2RS/vdqzUm7nl4Ki3SQ
	 inmxok4H5FZ3eqn5M4CZEXk/9cQgRoNN78qTgx0SI7s4vPiTZ5gfnS5JlfytbrU/W0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAAW3W8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BEA606EEBF;
	Thu,  5 Nov 2026 12:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAAW3W8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38CE1F0093A;
	Thu,  5 Nov 2026 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880589;
	bh=gukOYmvYDHX2QKSOGio7z+vsfvmKRfuVGQNVt9yzjww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aAAW3W8zrqhI1GlZKqclxuzopsOsI5eRflWVb+u4vb5PXFTYkgJ0rp9Kj8p5k/PnJ
	 dz9x5vflTBj+DeSq6KDVaKKWH4IO1ANMazHhA8U7XpsUFlwUQv3pPtBE5apiquXHF8
	 VIijSfbzJWIZ0u8nFhus81QZCpCdrEIkdEEVT9qcVLTnlF9X7DDYJUpALeqULAdBUk
	 gG3qH+UW1A7HkPJle0v+Ro9VJBDQIiBephkzM1sYS8P/gd5M72p1JtRoV4TPOtMTPm
	 lTV9zl9RBf9VsgqSb5pKIdsUflUPUNRZjRUAYJW6CA56tI1pSDaFNGwOyrBwhQLiSh
	 TJOgN9lfoSL8g==
Date: Thu, 5 Nov 2026 12:09:47 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH for-next-fixes v2 2/5] mm/slab: handle allow_spin in
 slab_free_hook() instead of open coding
Message-ID: <auxxnr3iVYNOOoci@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-2-19167cfe4779@kernel.org>
 <f31885cd-57c2-428d-9760-a76a0137f989@kernel.org>
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
In-Reply-To: <f31885cd-57c2-428d-9760-a76a0137f989@kernel.org>

On Wed, Nov 04, 2026 at 02:54:13PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> > kfree_nolock() deliberately skips slab free hooks that should not be
> > called in unknown context. However, there is one more place that
> > needs the same thing: memcg_alloc_abort_single().
> > 
> > Instead of open coding slab_free_hook(), let it handle the allow_spin
> > parameter. This is required to correctly handle allocation failures due
> > to memcg charging.
> > 
> > There are two functional changes from this.
> > 
> > First, memcg_alloc_abort_single() -> slab_free_hook() path no longer
> > calls free hooks that acquire spinlocks if !allow_spin.
> 
> Hm, since this is only changed by patch 4, I don't think it needs mentioning
> here, as it's not any functional change yet.

Good point, will adjust.

> > Second, kfree_nolock() now follows init_on_free which has been ignored.
> > 
> > Besides that, no functional change intended.
> > 
> > Closes: https://lore.kernel.org/asiSUpAYYU8Od4HM@gmail.com
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> > ---
> >  mm/slub.c | 104 +++++++++++++++++++++++++++++++++-----------------------------
> >  1 file changed, 56 insertions(+), 48 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 45e077c7526c..36e7bb93418a 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2686,41 +2686,54 @@ struct rcu_delayed_free {
> >   * - memcg_slab_post_alloc_hook()
> >   * - alloc_tagging_slab_alloc_hook()
> >   *
> > + * slab_free_hook() assumes that memcg_slab_free_hook() and
> > + * alloc_tagging_slab_free_hook() are already invoked.
> > + *
> >   * Free hooks that must handle missing corresponding alloc hooks:
> >   * - kmemleak_free_recursive()
> >   * - kfence_free()
> >   *
> > - * Free hooks that have no alloc hook counterpart, and thus safe to call:
> > + * Free hooks that have no alloc hook counterpart:
> >   * - debug_check_no_locks_freed()
> >   * - debug_check_no_obj_freed()
> >   * - __kcsan_check_access()
> >   */
> >  static __always_inline
> >  bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
> > -		    bool after_rcu_delay)
> > +		    bool after_rcu_delay, bool allow_spin)
> 
> Hm 3 bools. Could we bite the bullet and try doing free_flags (extended to
> cover init and after_rcu_delay) here already? :) Given it's not intended for
> a stable backport.

Ack, will try to bite the bullet.

> > @@ -2776,8 +2790,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
> >  		set_orig_size(s, x, orig_size);
> >  
> >  	}
> > -	/* KASAN might put x into memory quarantine, delaying its reuse. */
> > -	return !kasan_slab_free(s, x, init, still_accessible, false);
> > +	/*
> > +	 * KASAN might put x into memory quarantine, delaying its reuse.
> > +	 * Skip quarantine when spinning is not allowed as it uses a spinlock.
> > +	 */
> > +	return !kasan_slab_free(s, x, init, still_accessible, !allow_spin);
> >  }
> >  
> >  static __fastpath_inline
> > @@ -2789,9 +2806,10 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
> >  	void *next = *head;
> >  	void *old_tail = *tail;
> >  	bool init;
> > +	bool allow_spin = true;
> 
> Then we wouldn't need tricks like this I guess?

Right.

-- 
Cheers,
Harry / Hyeonggon
