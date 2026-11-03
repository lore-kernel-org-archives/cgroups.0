Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717908;
	b=wJwCEFRxJR8QY2perOSamme99dZvhfvm+NRmlq8SH/ZhEhsJX7sVMNis7uBaOKkI0csi
	 WUPXJFJKke55EU3sNKs81SL36T0eRow7L8+Xgu2wkVdcyCAOLu5LShLdpD6OIUBAvoFYY
	 W2RpaNqljrArw1Y8KC+3/6jjFSiNhEj+jTZt4lSGiaeoUo0Uf8OLc7EQ5NgW+iZ03MkTF
	 c8AKC8DjCRb7sAmQIvz8nwtRKjyQil9vcD5gesHHgIN5JwPje7PHQ6zV4/0a6seG3mVEQ
	 /6d4aB2CXvZCZ1Z0AxWfpA5HzTwwYUFBw2A9JaA/UsdKtVL82LYKAs+LC4qWHExzG6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717908;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=JxIxJVDR0m557SNz1wHD6xc/rB/AEhEzdsgGBjmaoHY=;
	b=M55BLlqBNyyEi4S+15V4/BO7UCWwTA6K+VMPmUzNIqmExCtGahEuN8n4CWOiyG45ka3G
	 xKaMxLpWTV1WBKjRywnwTcsJge81XLxrZUHGV3p2mrn6WzOjEiUrURZmdw9d69dmgcJyE
	 L2uMMH909hht/QeqFlajUok1tFxgoSShvnx83koJWqzxxMILs8mLeE2Ms/IuKCLk/aiAw
	 4BBZJtZP9K30j0cc75WLF4oGS+wYr3S8oYyxZ9lzHSFYIqnVnqVbTTubxHAaet3EmjiKH
	 l5O6dtWm1SblZVGZ/BMRBG0Hr0wz9rbwdw1KXKpsx/rTSJ3jv07EbS7/4btYxHuntSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6dv9eQB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843F606C810;
	Tue,  3 Nov 2026 14:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6dv9eQB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3354F1F00A02;
	Tue,  3 Nov 2026 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717907;
	bh=JxIxJVDR0m557SNz1wHD6xc/rB/AEhEzdsgGBjmaoHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F6dv9eQBS3DHoFKwspKTOCxDhh2PQeBeZFPAVKhlhtwy8OktZf6MQUUnEbC2Cv/UF
	 24vR9wkvQDqKQpNZqrT2lzrUkHWRjCipIVudLSxtXHpZ0JESeyVqpCfVYo60JMs3lb
	 Cf7aAdbx4uI2M8tj/XRul15/yMFO+uqoiz6/p0jZbKVpXi91pcdiyQX18AWU7jzeW3
	 JZ3hVRdB8PZCkJMTfG8YHfMMYiMATCrkqr4MekNd7C0asp+cDRBHSpJS6vvciIUup2
	 dAuxhiLgwoBqeIGoUfjqGqR6LWyaiU7ub8hVOsWRoPrDtw0ZFZM224IET5Lux/F+qk
	 nv7G8gSm/n5Qw==
Date: Tue, 3 Nov 2026 14:58:25 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] mm/slab: handle allow_spin in slab_free_hook()
 instead of open coding
Message-ID: <aun1uxYrS0imczik@thinkstation>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-2-fdf4d17351dd@kernel.org>
 <91776136-ecaf-4687-be63-a2c074435462@kernel.org>
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
In-Reply-To: <91776136-ecaf-4687-be63-a2c074435462@kernel.org>

Apologies for the late reply...

On Fri, Jun 26, 2026 at 04:41:22PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 32672a92581b..85760c8ff2e2 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2611,41 +2611,52 @@ struct rcu_delayed_free {
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
> > + * Free hooks that have no alloc hook counterpart, and thus safe to call
> > + * when spinning is allowed:
> >   * - debug_check_no_locks_freed()
> >   * - debug_check_no_obj_freed()
> >   * - __kcsan_check_access()
> >   */
> >  static __always_inline
> >  bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
> > -		    bool after_rcu_delay)
> > +		    bool after_rcu_delay, bool allow_spin)
> >  {
> >  	/* Are the object contents still accessible? */
> >  	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
> >  
> > -	kmemleak_free_recursive(x, s->flags);
> >  	kmsan_slab_free(s, x);
> >  
> > -	debug_check_no_locks_freed(x, s->object_size);
> > -
> > -	if (!(s->flags & SLAB_DEBUG_OBJECTS))
> > -		debug_check_no_obj_freed(x, s->object_size);
> > -
> > -	/* Use KCSAN to help debug racy use-after-free. */
> > -	if (!still_accessible)
> > -		__kcsan_check_access(x, s->object_size,
> > -				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> > -
> > -	if (kfence_free(x))
> > -		return false;
> > +	if (likely(allow_spin)) {
> > +		/* These hooks acquire spinlocks */
> > +		kmemleak_free_recursive(x, s->flags);
> > +		debug_check_no_locks_freed(x, s->object_size);
> 
> This line shouldn't be here?

You mean because debug_check_no_locks_freed() doesn't acquire a lock
when there is no bug to report?

That's fair, but I didn't want to introduce functional changes
in this patch as kfree_nolock() hasn't been calling it anyway.

So separated this (and KCSAN checks) to patch 3 in v2 as they only
acquire locks when reporting a bug. (Taking risk of deadlock for bug
reporting just like KASAN).

> > +		if (!(s->flags & SLAB_DEBUG_OBJECTS))
> > +			debug_check_no_obj_freed(x, s->object_size);
> > +		/* Use KCSAN to help debug racy use-after-free. */
> > +		if (!still_accessible)
> > +			__kcsan_check_access(x, s->object_size,
> > +					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> > +		if (kfence_free(x))
> > +			return false;
> 
> The whole block now misses free space lines that it had.

Adjusted in v2, thanks!

-- 
Cheers,
Harry / Hyeonggon
