Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792782889;
	b=F1qqM4131FVUe7x3OGQjSPmPP0TykCU5ylwnwTIH8GX9piToJNmHxWc8RJgl5lgypbrO
	 /dUL1m163CYVvO2AO8aE28Ni55UtU5/SSgPIG6skwByO14Yd+xaN6ZkCT23NI8mi6LFnZ
	 V22ftd6qrR4IfHc+vYnNLZs0i1PjXUj+GMlk2j8VQHWC7w/nnqg9NPNZkv3eFHJqfj2ZQ
	 nkqK1YWi18Oi8y9RyRHk2mNIQgJK5AEXp4zfzzk8eqlBP9agBN2b7PKJ7vdfbOmJUDoj6
	 sJ33o7e6cKupoHXWIyLVavhde5nrovGj20xaq+KTlQLCsdrhBr05DPNSCohpHxj2kAw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782889;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=A2jt0a6l9f6vo437AmVJsxYQfFUUMXcLLfevdP1TEfQ=;
	b=F8E4qMpRNQec9ER3DD9zLoGzyPAKg5vM8dVHeWd15TcrfeGHBVHcU9u7WpSyCDMRFjf0
	 W/Hfnmwg2XGtoAFwc807h/A532A9iwc/9mgt3/8EVIji4JJOmdLAlX5mp4wl8CIOKuo6Q
	 sXKh3f7UMGxI8eCmXYHVOzLb7gZ9TB2TDahVORpBOHmWR4s7uetmTLNp1AgO/zkKEzgGy
	 lvmAGiNHNAlQbkUjgIfyFuk/H3ePKA4yamNKOi/tKSx7qaGIJJAVB0kCh4nSu1sAgwNm9
	 q5alYgn1CgG4FZvDuS36s79c6gqmELchtE7jYZzmhOKsh58OEkzp922t1TzSiDcva8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="j/nAHxx8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7D9606A31A
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 19:14:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC7D9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=j/nAHxx8
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a2d6cf958bso2102915e9.1
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 12:14:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792782887; cv=none;
        d=google.com; s=arc-20260327;
        b=SyfJxVqomWgCDTBKJEqwiHIQafpX7XXxAU0K4jOqdIEQ1xzRvFRE/c7l8ItWkQsxxn
         sK5r39lxX47HGc3+cQveipnYcgvNO3GRmd0Lafa1TsnseWcmnMbv3baQtIC2UekL4H+Y
         vLSfY8kNpp3uCUp0tsDXka2LWBoRHjYfV6f2aP4Ca8WKG6VnGkJPThU4OgIwbc4Gv5J0
         KSp/DxCwOFNpNlvpu7juYiSmXU8Ptm219c5IF+aQQ4n00exrIihWC4MY01x4qIL5k6LI
         x/ZjXgEYW5rVR65vAO7G/2/LYeN9LrxdTZZDuzJliGfUUko7z5N8N/bzZ7dLWM1Jail9
         KIjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A2jt0a6l9f6vo437AmVJsxYQfFUUMXcLLfevdP1TEfQ=;
        fh=l4xp2Y2J9n3V2i1BVCnP36NtwvLKOTE1MCSZgKJtsSc=;
        b=klZfkg7IjPDAvUiwAKiNmRbtVB1kMyPz0RyJRAgDSMpd7gXGDvnmj0tt1BPGdaJUON
         DoOCk8zCU9WUeoPQjOxqLCZLNhcIhpitGeRekvMjld5IDpAnE0ZQrVRK2nH+Hbx+naT+
         hbMWbUiX9FFU5qFY2in88eS6ANOuEJHTSSL5hRxEU8xRDO77w3U4k1Ai4SP7geXPZtAQ
         RB6L7rf4Ygwx0vJRbZZiw3XNJfRyiFUcWRw5CytWS7Cn3/AVOhCrBocFrT3rewK+/zIe
         BlZOUw8f27fwiY/+IzxPq9xJ53hGXap+EaIaZ1pPsoxcdBt6DzH2s9SISh6RbEoe+6NQ
         gAyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792782887; x=1793387687; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A2jt0a6l9f6vo437AmVJsxYQfFUUMXcLLfevdP1TEfQ=;
        b=j/nAHxx8refCsGF6GLBAF6diLCwhIn8RnlmDOlkuHmrE7TbBGh8zFS32SMmUCnE5uQ
         66+hEG4yxZQ17S+qO9f0lCzsEpP7HmU9RedoJUFCE6ts6wjI63QAp0xd6LeJyDSpEVeT
         mns1pkDD+Off2E16CUvfrZzqCnYl/UwhdLkZuaJKxKVPFgqLgE5mhPH6OKrE/+F5dkWY
         HByr75/7O4CFYtbXC0/4ze97W2+kUTI74yRr8P8CADTigiZwqFNmcXDoqvd+PwscCB2u
         ++YHsxQIRvfizE1/XvBkhFalmSlTlvr7ooIWjaI54G6RagqRiewi1oL3IOn4UiM0ag6+
         gMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792782887; x=1793387687;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A2jt0a6l9f6vo437AmVJsxYQfFUUMXcLLfevdP1TEfQ=;
        b=WchfEdCVP5oAPpH5LEmbSS0z1LQeY6P+eIZL/yFFazcbOrPHgbow3rSuBTdi2LXlbx
         0zeLlFdTchLx1KfvSM/OOW+L2QuLMH7hOhVcXDSxXBjXc2kREwxkItn5UqnmAErGYcUV
         YxdU1E0RSrRK6LvyAvjBUviINtAtf+LyCwHQIG4hbupFCmaUZ9gWI1rhdwVwD7kCXIMr
         lf+uIhVM8VMQBeCXglQ2C6/aoppV24b1CygmY8Z4p8U9f/hAP6fm0d6pDTTIe/RZGw/7
         XsaGInDZWJRqvP4b/TsL+zSMB+KR4ArQq9b0DDwh16Z29BhS6S7f+e9pwYIihFNskhAx
         Y0Uw==
X-Forwarded-Encrypted: i=1; AKwUvByz5K0GZZyZ8r7vnSRQb5dzYCoXd0MnNvFm0LLNU/HsFhTUQpWofP5e5tm1wAF9/lahXomXCgMu@vger.kernel.org
X-Gm-Message-State: AFq9FYLVvAj1uRfunhmRTLow80IpNSFbGXPfCI5NbRrvE9SX7TYfY8OU
	C+2ZLGhScZNBYNnGbaOACi2JhPbWfrghUKbeT+oaWqQIgoUmwOK/iC5+9Xa4rqqZuEHtm60+N6e
	bXGS+5Tq0QQjkaAabThfeXPir0/nBiiI=
X-Gm-Gg: AYBFou3gqolGgNqrf9fD1933250pus782wwwgNv5+OxwEOa7iG1RAfK6u1Gk9cmdVAe
	tLdFwi0vlT70S6rlyqxY55DqXmXSbYwJJZWCTRgaLxTRWYq6qHRLUsf61snLm3hv9QKf4ag6rea
	P86CVKkXqLhtpGKRV8tTR9Ob2AiIVR4735UgksYnH7fimIHZQRHUb2fRZ6CwN0g8wNPQ3AxhK2G
	J9GhHT5LBvuhm0ePOa29xrPomZzFyrmTo96/rkpajDGiM9xSIv5QW+5k0uHxOO7bdBFTw6g1u+8
	w9esyPmzwIaFHNd7WZ6LCWKSE/NGlyw95f62F6ql8YHv9mcAu8YW6C+NfYbQrJ1lt5kb3B4Ma07
	n26cvvogXs9fnDjQPsdviuWMGCkeK7TWSUn+p4p37FJWdWtn2eNUs7aM3PyWHI5AXvNx/cio4Gl
	4qxXrfV33M/GWb+MQ2NdMnDNtI7O1bu/8Phii1R3I=
X-Received: by 2002:a05:600c:46c9:b0:4a1:d36f:1ba0 with SMTP id
 5b1f17b1804b1-4a211f371bbmr59163375e9.35.1792782886886; Fri, 23 Oct 2026
 12:14:46 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022200313.2354350-1-joannelkoong@gmail.com> <atp7tN-UfEAu3wdk@linux.dev>
In-Reply-To: <atp7tN-UfEAu3wdk@linux.dev>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 23 Oct 2026 12:14:34 -0700
X-Gm-Features: AclHuK9GOSg39fW35zWfZPhaCmkMiyUa4Zn9exIqhsrQZdxL_FAMLVB4ykhQxBQ
Message-ID: <CAJnrk1bDfg=uEO5xU3S8nK3AY-Zg=j3oYX1+cv8kVqmFiD8dCA@mail.gmail.com>
Subject: Re: [PATCH v1] mm: move LRU size stat updates out of lru_lock in
 folio batches
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 2:17=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Oct 22, 2026 at 01:03:13PM -0700, Joanne Koong wrote:
> > folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
> > once per batch, but they update the node and memcg lruvec stats for
> > every folio in the batch while holding the lock. Only the LRU lists and
> > the memcg lru_zone_size need lru_lock. Updating the stats while holding
> > the lru_lock is unnecessary, and they make up a large part of the
> > critical section, as seen in [1].
>
> Can you please add a tldr from [1] here? Too much text in that link.

Will do in v2. THe relevant part of [1] is that a change that added
just a few instructions to the memcg stat update path cost about 2%
throughput because the LRU stat updates run under lru_lock and the
overhead went away once they were moved outside of the lock, which is
what motivated this patch.

>
> > With many threads faulting and freeing
> > memory in a single memcg, about half of all cycles are spent waiting fo=
r
> > lru_lock, and the hold time of the lru_lock directly limits throughput.
>
> Do you have perf profile showing this? Mainly I want to know where in sta=
ts
> update we are spending the CPU most.

The perf profile run on the top commit of mm-new (commit fcec4f4bcc
"riscv: mm: fix concurrency in mark_new_valid_map()) using the same
benchmark setup (80 threads, shmem) shows:
- 52.8% of all cycles are spent spinning on the lru_lock (evenly split
between folio_batch_move_lru() and folios_put_refs())
- About 25% of the time spent holding lru_lock in those 2 paths goes
to the LRU stat updates (the ones this patch moves to outside the
lock) and the rest is the list manipulation itself
- Most of the cost in __mod_memcg_lruvec_state() is cache misses
(loading pn->memcg, pn->lruvec_stats_percpu, and the per-cpu
counters).

The stat updates are only 0.7% of total cycles but I think it's the
lock contention on callers waiting for the lock that ends up hurting
throughput.

>
> I wonder if we can find a lower bound here by removing the stats update
> altogether in this code path (just for experimentation) and measure the
> throughput we get.

With the LRU stat updates removed from these paths entirely, I'm
seeing that throughput is essentially the same as with this patch
(within noise):

                       mm-new   this patch   no stat updates
    shmem, 80 threads  7.94M    10.33M       10.31M
    anon,  20 threads  3.04M     3.35M        3.33M

I think once the updates are moved out of the critical section
entirely, they don't cost much to do.

>
> >
> > Accumulate the stat changes per LRU list while holding the lock instead=
,
> > and only apply them after dropping the lock (while still inside
> > the RCU read section that keeps the lruvec's memcg alive). This moves
> > the stat updates out of the lru_lock critical section and turns the
> > per-folio updates into at most one update per LRU list per batch.
> >
> > The batch is attached to the lruvec while lru_lock is held so that the
> > LRU add/del helpers don't need to pass it down. To keep struct lruvec
> > from growing, cost_lock is moved into the hole after lru_lock, which
> > leaves room for the batch pointer in the same cacheline as lru_lock.
> >
> > The stats can now lag behind the LRU lists by one batch, which is well
> > within the per-cpu batching they already have.
> >
> > On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
> > CPUs repeatedly faulting in and freeing memory in a single memcg,
> > average pages per second over 7 freshly created memcgs per run, 2 boots
> > each:
> >
> >                      before    after
> >   shmem, 20 threads  4.74M     5.47M   (+15%)
> >   shmem, 80 threads  7.94M    10.33M   (+30%)
> >   anon,  20 threads  3.04M     3.35M   (+10%)
> >   anon,  80 threads  3.23M     3.41M   (+5%)
> >
> > Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76=
izMS=3DqGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> > An alternative that avoids adding the lru_size_batch pointer to the lru=
vec
> > struct is to pass the batch down explicitly, but the plumbing for this =
is a
> > bit ugly (and doesn't cover mglru paths). The code looks like [2]. Happ=
y to go
> > with this if that is preferred.
>
> Do you expect there might be opportunity to batch the stats other than LR=
U stats
> you batched in this patch? If there is then I think we should at least ex=
plore
> if a more general stat batching can be done.

I had experimented a little with doing this for LRU size stats in the
reclaim paths in vmscan and deferring the count_memcg_events() calls
in the same batch paths, but none of them made a measurable difference
to throughput. For the reclaim paths, I think it's because there
reclaim rather than the lru_lock is the bottleneck, and my benchmark
doesn't really exercise the paths that call count_memcg_events(). As
far as I can tell, the rmap stats (NR_ANON_MAPPED, NR_FILE_MAPPED) are
under the page table lock but that lock isn't really contended. I
think the other maybe-potentially-promising candidate is the page
cache stats (NR_FILE_PAGES, NR_SHMEM, ...) that are updated per folio
under the mapping's i_pages lock but that would matter only for
threads working on a single shared file. I can look more into the page
cache stats and see whether the complexity would be worth it there.

Thanks for taking a look at this patch!

Thanks,
Joanne
