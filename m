Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858304718FD;
	Tue, 13 Oct 2026 09:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884911; cv=none; b=lEFNbhq8/4Z+AEFP3grx0bnvDo1NrkfXV4iDNsMbwmQ0S4u/jx48Va8x4Au+Kc61aZRYvEcVCFzma1J5tgmXbnTmJ6vazfHCeu+fChspzGUk9nsjieB5lf9NQVACdWENyNPydeBITmPtJoalpaP6A0FO2i5nkLKO6FCSSOzv/fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884911; c=relaxed/simple;
	bh=adYx3/9qwjzcfl0P1PH8mIts+UkvzybnFPplU/EoSJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxrWDlRgx7Wvi1dTYF4uuao20qgfNGw+0bnVoHCpmOx2YvitRCmk5EpYciGPd2xONrB5mMLNGYCF1tv2Gy2JeLQa8MZwWZjjzFrnbVZm+npEevkOmbZdfHNtzUXJO5wi9vZimBe8lp/nYVa2zMGcEyB1jUURxY+raBmk8+YaB+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=no58pOgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="no58pOgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2091F000FF;
	Tue, 13 Oct 2026 09:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791884910;
	bh=ZWMA85UhpZgb1xgUdrTwIN+V9GMQeZAE1Tnoo9sRrhQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=no58pOgzSmPldS01bBjuPk++JqubDKPmL2Ty43rG1Dk1gxqKDHTt3ug4IEX1R4Anh
	 upFo/sfwURQy4YZ1YuyVJVdC6ZALMDx1eotH8YIlnJy5/3O/63McAEAgeSofDFjwNF
	 SGSWr1MOetWEtNIx3rkdpKcOEKeeCbKJee5svlDnIlW2F045FDvVE2QC2F/kvaFMJ5
	 y/tawclwKENd1WOydkibyRSlBpXUqEdLBI95yeEdlBWhYSsAd9WBcq2i+NugsSlZvg
	 r7dyVlS0osChdnjP0KmEkjI7QLIMNBtensaF3go3Bji51QP5cFa2P/g9eZB+F4o/xy
	 4QthqCk5pq7Tw==
Message-ID: <2d970074-c6db-4c18-8103-da0744ca86bb@kernel.org>
Date: Tue, 13 Oct 2026 11:48:24 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
To: Kees Cook <kees@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, Pedro Falcato
 <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org> <asjhg2e4-WSeKuXd@thinkpad>
 <ask5kpMS4mpI8Api@thinkpad> <202610092014.AAB20B81@keescook>
 <01c89e02-28e0-4424-b32b-50363e4d2b95@kernel.org>
 <202610130141.E186B6E@keescook>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <202610130141.E186B6E@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/13/26 10:52, Kees Cook wrote:
> On Mon, Oct 12, 2026 at 11:19:01PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 10/10/26 05:18, Kees Cook wrote:
>> > On Fri, Oct 09, 2026 at 09:39:48PM +0200, Harry Yoo wrote:
>> >> On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
>> >> > When it falls back to kmalloc, kmem_buckets itself should provide a
>> >> > compatibility layer when falling back to kmalloc.
>> >> 
>> >> For example, calculate_sizes() converts certain SLAB_* flags into
>> >> GFP flags (s->allocflags) for allocation. We can have a similar
>> >> logic when falling back to kmalloc.
>> >> 
>> >> Though current implementation does not allow this and requires
>> >> some rework.
>> > 
>> > I think the current series does everything correctly in the sense that
>> > nothing is allowing for mismatched fallbacks/passthrus. We could iterate
>> > from there once we have a need for this where a non-kmalloc-alignment is
>> > wanted, etc?
>> 
>> I think we can indeed simply make sure buckets have the same alignment as
>> kmalloc. It comes naturally and should (more than) satisfy everyone. I doubt
>> anyone would be needing a more specific alignment than that for a class of
>> allocations with a variable size?
> 
> Right, the whole point of kmem_buckets was to replace general kmalloc
> uses, where no callers cared about alignment.
> 
>> ctor removal is clear I think
> 
> Completely. I was blinded by the API of kmem_cache_create(). :)
> 
>> for __GFP_ACCOUNT and __GFP_RECLAIMABLE I think what we could do is not to
>> drop the flags argument kmem_buckets_create and instead require that it
>> matches the usage:
>> 
>> __GFP_RECLAIMABLE requires SLAB_RECLAIM_ACCOUNT and vice versa and I can't
>> imagine there would be a buckets instance that would allocate both kinds
>> (either with or without __GFP_RECLAIMABLE)
> 
> Okay. (We have no users of this yet, FWIW.)
> 
>> SLAB_ACCOUNT requires __GFP_ACCOUNT, memcg objexts are always created and used
> 
> Right.
> 
>> SLAB_MAY_ACCOUNT allows __GFP_ACCOUNT, memcg objexts are always created, and
>> used when __GFP_ACCOUNT given
>> - perhaps not as optimal as the separate kmalloc types, but good enough?

Ah there's already a precedent, e.g. specifying __GFP_RECLAIM means you get
a KMALLOC_RECLAIM cache, but it may or may not be accounted depending on
passing also __GFP_ACCOUNT and there are no separate sets of slabs for
these. Also same can happen with kmem_cache_create() cache when only some
allocations are __GFP_ACCOUNT.
> I think it's fine from studying what happens with the skb data. Though
> right now, SLAB_ACCOUNT and SLAB_MAY_ACCOUNT are functionally identical,
> yes?

Both mean that objcg pointers might exist for the slabs from the cache, but
SLAB_ACCOUNT also implies __GFP_ACCOUNT for every allocation from the cache
even if not given. But for kmem_bucket_alloc() with SLAB_BUCKETS=n with we
have nowhere to store that this implication should be done (that would be
the "compatibility layer").

>> __GFP_ACCOUNT without either SLAB_ACCOUNT or SLAB_MAY_ACCOUNT is wrong,
>> __GFP_ACCOUNT would be ignored
> 
> *ignored* is, I think, wrong here. It would create differing behavior
> between SLAB_BUCKETS=y/n.

Yes that's why we must avoid it. SLAB_MAY_ACCOUNT is a new thing and because
there were already many caches that may or may not pass __GFP_ACCOUNT, we
just assume it for now in __kmem_cache_create_args(). But that's a TODO to
start tightening it. With buckets we only have a handful of users so we
could try doing that right away, and have warnings in place to catch any
changes that push it into the "wrong" state.

> If we passed __GFP_ACCOUNT through to general
> kmalloc when the buckets lacked SLAB_ACCOUNT and SLAB_MAY_ACCOUNT, you'd
> lose the isolation, but not the accounting. (And could WARN_ONCE about
> it.) But if it was ignored, you'd lose accounting under
> SLAB_BUCKETS=y.

We could warn and fallback then, I guess.

>> with SLAB_BUCKETS=y these rules could be checked e.g. with a VM_WARN_ON_ONCE()
>> 
>> with SLAB_BUCKETS=n these rules won't be checked but also not matter in practice
> 
> Agreed. That's what I was going for on this version. But like above,
> "SLAB_ACCOUNT requires __GFP_ACCOUNT" means what? Under SLAB_BUCKETS=y
> the allocation returns NULL? Or it passes through with WARN_ONCE? I'd

"SLAB_ACCOUNT requires __GFP_ACCOUNT" means that if it's not done and
SLAB_BUCKETS=n, then we get the issue that patch 2 fixes, and have no way to
actually find out and warn that it's the case (with SLAB_BUCKETS=n... the
warning can be issued with SLAB_BUCKETS=y and then it passes through as if
there was __GFP_ACCOUNT).

> rather not break something completely; better to fallback on a mismatch
> so the requested type happens (be it DMA, ACCOUNTing, etc).

Also instead of the scheme above, maybe we could explore the idea of
"compatibility layer" too. It would mean that even with SLAB_BUCKETS=n,
kmem_buckets_create() would create some object to hold the gfp_flags we want
to append to all allocations from that bucket. But then kmem_buckets_alloc()
would have to do something a bit more than map to __kmalloc_node_noprof
(with PASS_KMALLOC_PARAMS directly). Of course SLAB_BUCKETS=y would be using
this way too then to avoid further complication. Maybe the result would be
more cleaner (simplifying PASS_KMALLOC_PARAMS and getting rid of
PASS_BUCKET_PARAMS?) but I can't say immediately how well it would work.
