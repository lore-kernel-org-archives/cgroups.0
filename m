Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793800460;
	b=5OWXaXtdU9SCRYl1dy6Ym5zudvJFUJv0Q2F3aNe/ORl0/J4ISwMdZHPklkOJhLE0SZfB
	 dOMPIzrw3MjIrzdQkjqFqFfFGVg22qZN1VXuJD81FNbmvM/8Xv8Ghs7291V/VMEgLLtT5
	 PV/Uu+wUFfilIzvYAY8HUOGFj12/y8kAT5CHL9+M4VdD5ETLu/RIK2fQmGJxz2B1IIQYV
	 uge59ZF6oUIOD5RfQRJDrTZqpC+QVMrHVX6S6rREZ3f2w44Bkc8c3wpXeHsguH8u8DskU
	 Kg6WocByynvi8MKMssPQ85N6kzrQ2azCwJIsaRgZ0IyXvz9LWnKlN1KzEb60TofEeIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793800460;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=S3pJmErjwAa/a8tAUggZF8o5Tv6d/nci7fJnbo3TZA0=;
	b=FPCqx/2Bt95Qc0Vb9TvQVXr70z09UwXAQCRzBkXorB5C/D2rs9+xWXFeL0qhBACc0RRW
	 GMkhmibShHFyEK98DbNVdrhYIiGPep0dxkfYcfs3LYgAayYiPWG+QX+UTH4Bti7kEaHeg
	 VsjecJ5toADagsztHzMcCry/4/PdFfSAEkDg7L8whi0hsyXwYJZ2SamnMh1VYIFywmBD3
	 Lz3bxDHqD/fETalHb6yf+UrJM/2KjK1uxfpOlJjVjMGBPDWv2Cx7udT5D5nO2IEyfgZSR
	 koG/0uKCz3nAC2pHdOuZfsXohyY8MV8nEdKCedq6BZPb3nYzgRNMOeQXnKEy59wfoAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YU5qEs60;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55956606A33F;
	Wed,  4 Nov 2026 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YU5qEs60
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7C21F00A1B;
	Wed,  4 Nov 2026 13:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793800460;
	bh=S3pJmErjwAa/a8tAUggZF8o5Tv6d/nci7fJnbo3TZA0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YU5qEs60XjjUeEBD77pQbg6/xmWoJP8iudizS9+1/E7nnNXmYGw59U2ramn/5rrTK
	 OD1X3UZz7EgwiGUY/WeJjjFtt6IvRLpiQP3KfDftk5vwCeJcgduxzng3yDOZvjiFpu
	 98OgYiPISL1njTo4Q9Pg4Ey6pUQJMNQhnQmwmAtEGo7w1irLbSHdTeJKkvE+0nDWO1
	 GIN0oUc8AqvtG3ipgHjgtTMBiaOTJ8or53xksbnHg8tTYfC0koIDBHbTMVvhX3a9rx
	 z6h/DFs5bdITuquTEa0tk4FJHuqShBrmszpyItePwFbBjP1DhxgEN5zDZ78ycH46cP
	 fIVlxbZylxC5A==
Message-ID: <f31885cd-57c2-428d-9760-a76a0137f989@kernel.org>
Date: Wed, 4 Nov 2026 14:54:13 +0100
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next-fixes v2 2/5] mm/slab: handle allow_spin in
 slab_free_hook() instead of open coding
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-2-19167cfe4779@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-2-19167cfe4779@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> kfree_nolock() deliberately skips slab free hooks that should not be
> called in unknown context. However, there is one more place that
> needs the same thing: memcg_alloc_abort_single().
> 
> Instead of open coding slab_free_hook(), let it handle the allow_spin
> parameter. This is required to correctly handle allocation failures due
> to memcg charging.
> 
> There are two functional changes from this.
> 
> First, memcg_alloc_abort_single() -> slab_free_hook() path no longer
> calls free hooks that acquire spinlocks if !allow_spin.

Hm, since this is only changed by patch 4, I don't think it needs mentioning
here, as it's not any functional change yet.
> Second, kfree_nolock() now follows init_on_free which has been ignored.
> 
> Besides that, no functional change intended.
> 
> Closes: https://lore.kernel.org/asiSUpAYYU8Od4HM@gmail.com
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> ---
>  mm/slub.c | 104 +++++++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 56 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 45e077c7526c..36e7bb93418a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2686,41 +2686,54 @@ struct rcu_delayed_free {
>   * - memcg_slab_post_alloc_hook()
>   * - alloc_tagging_slab_alloc_hook()
>   *
> + * slab_free_hook() assumes that memcg_slab_free_hook() and
> + * alloc_tagging_slab_free_hook() are already invoked.
> + *
>   * Free hooks that must handle missing corresponding alloc hooks:
>   * - kmemleak_free_recursive()
>   * - kfence_free()
>   *
> - * Free hooks that have no alloc hook counterpart, and thus safe to call:
> + * Free hooks that have no alloc hook counterpart:
>   * - debug_check_no_locks_freed()
>   * - debug_check_no_obj_freed()
>   * - __kcsan_check_access()
>   */
>  static __always_inline
>  bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
> -		    bool after_rcu_delay)
> +		    bool after_rcu_delay, bool allow_spin)

Hm 3 bools. Could we bite the bullet and try doing free_flags (extended to
cover init and after_rcu_delay) here already? :) Given it's not intended for
a stable backport.

>  {
>  	/* Are the object contents still accessible? */
>  	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
>  
> -	kmemleak_free_recursive(x, s->flags);
>  	kmsan_slab_free(s, x);
>  
> -	debug_check_no_locks_freed(x, s->object_size);
> +	/* Hooks that acquire locks or kmalloc_nolock() skips alloc hook counterpart */
> +	if (likely(allow_spin)) {
> +		kmemleak_free_recursive(x, s->flags);
> +		debug_check_no_locks_freed(x, s->object_size);
>  
> -	if (!(s->flags & SLAB_DEBUG_OBJECTS))
> -		debug_check_no_obj_freed(x, s->object_size);
> +		if (!(s->flags & SLAB_DEBUG_OBJECTS))
> +			debug_check_no_obj_freed(x, s->object_size);
>  
> -	/* Use KCSAN to help debug racy use-after-free. */
> -	if (!still_accessible)
> -		__kcsan_check_access(x, s->object_size,
> -				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> +		/* Use KCSAN to help debug racy use-after-free. */
> +		if (!still_accessible)
> +			__kcsan_check_access(x, s->object_size,
> +					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
>  
> -	if (kfence_free(x))
> -		return false;
> +		if (kfence_free(x))
> +			return false;
> +	}
>  
>  	/*
>  	 * Give KASAN a chance to notice an invalid free operation before we
>  	 * modify the object.
> +	 *
> +	 * If KASAN finds a bug it will do kasan_report_invalid_free() which
> +	 * will call raw_spin_lock_irqsave() which is technically unsafe from
> +	 * NMI, but take chance and report kernel bug. The sequence of
> +	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
> +	 * -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
> +	 *  is double buggy and deserves to deadlock.
>  	 */
>  	if (kasan_slab_pre_free(s, x))
>  		return false;
> @@ -2729,6 +2742,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
>  	if (still_accessible) {
>  		struct rcu_delayed_free *delayed_free;
>  
> +		VM_WARN_ON_ONCE(!allow_spin);
>  		delayed_free = kmalloc_obj(*delayed_free, GFP_NOWAIT);
>  		if (delayed_free) {
>  			/*
> @@ -2776,8 +2790,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
>  		set_orig_size(s, x, orig_size);
>  
>  	}
> -	/* KASAN might put x into memory quarantine, delaying its reuse. */
> -	return !kasan_slab_free(s, x, init, still_accessible, false);
> +	/*
> +	 * KASAN might put x into memory quarantine, delaying its reuse.
> +	 * Skip quarantine when spinning is not allowed as it uses a spinlock.
> +	 */
> +	return !kasan_slab_free(s, x, init, still_accessible, !allow_spin);
>  }
>  
>  static __fastpath_inline
> @@ -2789,9 +2806,10 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
>  	void *next = *head;
>  	void *old_tail = *tail;
>  	bool init;
> +	bool allow_spin = true;

Then we wouldn't need tricks like this I guess?

>  
>  	if (is_kfence_address(next)) {
> -		slab_free_hook(s, next, false, false);
> +		slab_free_hook(s, next, false, false, allow_spin);
>  		return false;
>  	}
>  
> @@ -2806,7 +2824,7 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
>  		next = get_freepointer(s, object);
>  
>  		/* If object's reuse doesn't have to be delayed */
> -		if (likely(slab_free_hook(s, object, init, false))) {
> +		if (likely(slab_free_hook(s, object, init, false, allow_spin))) {
>  			/* Move object to the new freelist */
>  			set_freepointer(s, object, *head);
>  			*head = object;
> @@ -3031,6 +3049,7 @@ static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
>  	void **p = &sheaf->objects[0];
>  	unsigned int i = 0;
>  	bool pfmemalloc = false;
> +	bool allow_spin = true;
>  
>  	while (i < sheaf->size) {
>  		struct slab *slab = virt_to_slab(p[i]);
> @@ -3038,7 +3057,7 @@ static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
>  		memcg_slab_free_hook(s, slab, p + i, 1);
>  		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
>  
> -		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
> +		if (unlikely(!slab_free_hook(s, p[i], init, true, allow_spin))) {
>  			p[i] = p[--sheaf->size];
>  			continue;
>  		}
> @@ -6479,6 +6498,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  	bool init = slab_want_init_on_free(s);
>  	void **remote_objects = p;
>  	unsigned int remote_nr = 0;
> +	bool allow_spin = true;
>  
>  	/*
>  	 * Process the free hooks and separate out remote objects by
> @@ -6494,7 +6514,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		memcg_slab_free_hook(s, slab, p + i, 1);
>  		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
>  
> -		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> +		if (unlikely(!slab_free_hook(s, p[i], init, false, allow_spin))) {
>  			p[i] = p[--size];
>  			continue;
>  		}
> @@ -6624,13 +6644,17 @@ static __fastpath_inline
>  void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  	       unsigned long addr)
>  {
> +	bool allow_spin = true;
> +	bool init = slab_want_init_on_free(s);
> +
>  	memcg_slab_free_hook(s, slab, &object, 1);
>  	alloc_tagging_slab_free_hook(s, slab, &object, 1);
>  
> -	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
> +	if (unlikely(!slab_free_hook(s, object, init, false, allow_spin)))
>  		return;
>  
> -	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
> +	if (likely(can_free_to_pcs(slab)) &&
> +			likely(free_to_pcs(s, object, allow_spin)))
>  		return;
>  
>  	__slab_free(s, slab, object, object, 1, addr);
> @@ -6643,10 +6667,12 @@ static noinline
>  void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
>  {
>  	struct slab *slab = virt_to_slab(object);
> +	bool init = slab_want_init_on_free(s);
> +	bool allow_spin = true;
>  
>  	alloc_tagging_slab_free_hook(s, slab, &object, 1);
>  
> -	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
> +	if (likely(slab_free_hook(s, object, init, false, allow_spin)))
>  		__slab_free(s, slab, object, object, 1, _RET_IP_);
>  }
>  #endif
> @@ -6675,6 +6701,8 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
>  	void *object = delayed_free->object;
>  	struct slab *slab = virt_to_slab(object);
>  	struct kmem_cache *s;
> +	bool allow_spin = true;
> +	bool init;
>  
>  	kfree(delayed_free);
>  
> @@ -6688,8 +6716,9 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
>  	if (WARN_ON(!(s->flags & SLAB_TYPESAFE_BY_RCU)))
>  		return;
>  
> +	init = slab_want_init_on_free(s);
>  	/* resume freeing */
> -	if (slab_free_hook(s, object, slab_want_init_on_free(s), true)) {
> +	if (slab_free_hook(s, object, init, true, allow_spin)) {
>  		__slab_free(s, slab, object, object, 1, _THIS_IP_);
>  		stat(s, FREE_SLOWPATH);
>  	}
> @@ -6938,6 +6967,8 @@ void kfree_nolock(const void *object)
>  	struct slab *slab;
>  	struct kmem_cache *s;
>  	void *x = (void *)object;
> +	bool allow_spin = false;
> +	bool init;
>  
>  	if (unlikely(ZERO_OR_NULL_PTR(object)))
>  		return;
> @@ -6952,33 +6983,10 @@ void kfree_nolock(const void *object)
>  
>  	memcg_slab_free_hook(s, slab, &x, 1);
>  	alloc_tagging_slab_free_hook(s, slab, &x, 1);
> -	/*
> -	 * Unlike slab_free() do NOT call the following:
> -	 * kmemleak_free_recursive(x, s->flags);
> -	 * debug_check_no_locks_freed(x, s->object_size);
> -	 * debug_check_no_obj_freed(x, s->object_size);
> -	 * __kcsan_check_access(x, s->object_size, ..);
> -	 * kfence_free(x);
> -	 * since they take spinlocks or not safe from any context.
> -	 */
> -	kmsan_slab_free(s, x);
> -	/*
> -	 * If KASAN finds a kernel bug it will do kasan_report_invalid_free()
> -	 * which will call raw_spin_lock_irqsave() which is technically
> -	 * unsafe from NMI, but take chance and report kernel bug.
> -	 * The sequence of
> -	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
> -	 *  -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
> -	 * is double buggy and deserves to deadlock.
> -	 */
> -	if (kasan_slab_pre_free(s, x))
> +
> +	init = slab_want_init_on_free(s);
> +	if (unlikely(!slab_free_hook(s, x, init, false, allow_spin)))
>  		return;
> -	/*
> -	 * memcg, kasan_slab_pre_free are done for 'x'.
> -	 * The only thing left is kasan_poison without quarantine,
> -	 * since kasan quarantine takes locks and not supported from NMI.
> -	 */
> -	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
>  
>  	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
>  		return;
> 

