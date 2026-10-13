Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826703B9D8C;
	Tue, 13 Oct 2026 08:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881563; cv=none; b=g/ZaYm5ko/p+v7LiNI3u4oiWYdF1rboFuq8tzmI68n+l45yjla/dAu68APastQ45TmtN5PQUhAvHoWUrzlEgzLB1AuTVbcamx5GxF78kimSzKTjkexA+oLlgxs8Q1FS0749Qyu0TofWFtLVaIKrr9FdtfrK/mR0eQ5sHDwUunXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881563; c=relaxed/simple;
	bh=Fbdb+Ik5HuvM0X+FL4LuDIrjVgtG6QAf/crtrWIiA0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lv3/rH/I0C9RPEb3zVzco2Xkx+gy2wWgQXV0Ww19UvINNM3Wcj/rBIWN3iIeRkEkZN/mf1GZFppFLriwjnpVVnGsYcqIIKcdycVg/nWNzw1ncFjBQ4Ds7tkgcOVQWhOEVvbSFt/OcOo6e4PgbN/itwPJrlj1y0jBd9NkfVd5Ivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bU+MNADL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bU+MNADL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF791F000FF;
	Tue, 13 Oct 2026 08:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791881562;
	bh=fkY85AEaM1dcKivKhNaNHUeuabYCcoXX8xBxsWbUhJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bU+MNADLypUQVfbqs4yErGMSqSx8UTEensTSDlB3hILthlX7jXiysW5XCK8w3Wgne
	 +qsKvAVV67misGTcQFezprIijSe//cDAi61D+HiH+PrXDz66M+RQgAsyepQqatnOkw
	 C83dhwA6jl7P3WJ+2YNow3ButEoWQcQrQ381Wo2YqHbIp2FI1DvqBlI7RrrfpxPP3D
	 3WDNSNVnKR/z/zbtd8j1RgF5SPVBsqTN0aiF/CDe/xhAdL4+Nw2L8Xax6doYzIf9OB
	 svfE9gigE0RcgQBxJbDc8PiWLnzTi5f1OeCjkCKQRjfUTk1SJmatj/E3sZV6pc5eMF
	 mAVD56KO7uG+Q==
Date: Tue, 13 Oct 2026 01:52:42 -0700
From: Kees Cook <kees@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <202610130141.E186B6E@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
 <ask5kpMS4mpI8Api@thinkpad>
 <202610092014.AAB20B81@keescook>
 <01c89e02-28e0-4424-b32b-50363e4d2b95@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01c89e02-28e0-4424-b32b-50363e4d2b95@kernel.org>

On Mon, Oct 12, 2026 at 11:19:01PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/10/26 05:18, Kees Cook wrote:
> > On Fri, Oct 09, 2026 at 09:39:48PM +0200, Harry Yoo wrote:
> >> On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
> >> > When it falls back to kmalloc, kmem_buckets itself should provide a
> >> > compatibility layer when falling back to kmalloc.
> >> 
> >> For example, calculate_sizes() converts certain SLAB_* flags into
> >> GFP flags (s->allocflags) for allocation. We can have a similar
> >> logic when falling back to kmalloc.
> >> 
> >> Though current implementation does not allow this and requires
> >> some rework.
> > 
> > I think the current series does everything correctly in the sense that
> > nothing is allowing for mismatched fallbacks/passthrus. We could iterate
> > from there once we have a need for this where a non-kmalloc-alignment is
> > wanted, etc?
> 
> I think we can indeed simply make sure buckets have the same alignment as
> kmalloc. It comes naturally and should (more than) satisfy everyone. I doubt
> anyone would be needing a more specific alignment than that for a class of
> allocations with a variable size?

Right, the whole point of kmem_buckets was to replace general kmalloc
uses, where no callers cared about alignment.

> ctor removal is clear I think

Completely. I was blinded by the API of kmem_cache_create(). :)

> for __GFP_ACCOUNT and __GFP_RECLAIMABLE I think what we could do is not to
> drop the flags argument kmem_buckets_create and instead require that it
> matches the usage:
> 
> __GFP_RECLAIMABLE requires SLAB_RECLAIM_ACCOUNT and vice versa and I can't
> imagine there would be a buckets instance that would allocate both kinds
> (either with or without __GFP_RECLAIMABLE)

Okay. (We have no users of this yet, FWIW.)

> SLAB_ACCOUNT requires __GFP_ACCOUNT, memcg objexts are always created and used

Right.

> SLAB_MAY_ACCOUNT allows __GFP_ACCOUNT, memcg objexts are always created, and
> used when __GFP_ACCOUNT given
> - perhaps not as optimal as the separate kmalloc types, but good enough?

I think it's fine from studying what happens with the skb data. Though
right now, SLAB_ACCOUNT and SLAB_MAY_ACCOUNT are functionally identical,
yes?

> __GFP_ACCOUNT without either SLAB_ACCOUNT or SLAB_MAY_ACCOUNT is wrong,
> __GFP_ACCOUNT would be ignored

*ignored* is, I think, wrong here. It would create differing behavior
between SLAB_BUCKETS=y/n. If we passed __GFP_ACCOUNT through to general
kmalloc when the buckets lacked SLAB_ACCOUNT and SLAB_MAY_ACCOUNT, you'd
lose the isolation, but not the accounting. (And could WARN_ONCE about
it.) But if it was ignored, you'd lose accounting under
SLAB_BUCKETS=y.

> with SLAB_BUCKETS=y these rules could be checked e.g. with a VM_WARN_ON_ONCE()
> 
> with SLAB_BUCKETS=n these rules won't be checked but also not matter in practice

Agreed. That's what I was going for on this version. But like above,
"SLAB_ACCOUNT requires __GFP_ACCOUNT" means what? Under SLAB_BUCKETS=y
the allocation returns NULL? Or it passes through with WARN_ONCE? I'd
rather not break something completely; better to fallback on a mismatch
so the requested type happens (be it DMA, ACCOUNTing, etc).

-- 
Kees Cook
