Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F88237266D
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 04:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784177764; cv=pass; b=Dy1429LvVpbQnPaC+N2n55SegDsbx9hVDS0julOvYMRLa4JmOEb9Ot2rEuDHLJeZKZxkISiXJBb30JNNohp7CCbjn5g2uTAVcMV9f3WWqEvAe3Xqu1r7Cw1GnsmNdWrij1Y0A1GObbOOLnlFdzJt8RykJ1lsahFMD4gwD5Y1ONY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784177764; c=relaxed/simple;
	bh=FwQNxHjUS/9BAx82HL3adWHdlUQgXQ5/Xdc9egae3M0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YrKkJYDDuyBuLkoVCA6sIRhg1Kcx6LQfCqm47HJNEan4VEt889YOPfmZ/hcRFjPGljEHK1LU+9Fo0PE7uhK2aSMRnsDk+2m9OON/Cds3tQ/gz/YnZQDjUt7Iaeq4uV6kLsASaGxOrQXrnF2fdvEggVi5hIAT8DzoTC4i0LJclnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PntnDs++; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PntnDs++"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c15a5b265so164831cf.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 21:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784177762; cv=none;
        d=google.com; s=arc-20260327;
        b=mdqUFRV5cyDV9KnousdDe5N7unVXu+RPTs8fdCvzipA3jeIGNOQvjERJxZy6mg3nRl
         yo8DU01y3QDnyyJji8jCJACJk9f42KqzwQKL99WkSqYHwqditaDxjjCXqiFGJrzWy7ms
         OlXJUUAC21ZPnCElgFKMwRJvmL4zFOCfaxzleZ4etPEj0kiTzLHRg8dJ5ZwqSsCVS65b
         rjc/dXa0YkYFN/4Bi5NwuU5HjvixqCpsOSq3lCfBUzIslU0T8ErauH8nm4aVbraJsHbZ
         JCyFX7DO7ls1N3gJpeaL70ql1/tg9cF+shyXH9eqmuo7AqbaeoTUpdBAc9Z568f4o4j3
         O8Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bS/QNlnrbXpOGhrS6iLoq0SdHzM7UbN+ODYuLLYXyPI=;
        fh=M07fwFlicujWymMGIZEsFMZu17pBhXeLKWCrcoeopoE=;
        b=iw+Rvr7kZeW87yfSX85KBFFjH9TDnkua7Lkr0wPsdD8S0co2+FDG+q/5lL8t274xfh
         E7GToVUxTb028AeRkGcDu5iL+ioNRByAt0Vuu4/RfqUijhSUYo/DiAkfpOX/q4fC2EPt
         6frlmTtovO+rOt5dgrslkTSlNKXbuBfm8eZrzEf5IsuAq20NO3P0m1FfI8ACZ0tAP6mZ
         0wMVG2emau4lDunbrn9DEd0RKqWWkEjSLBxTuOIfnpQG+T9wpurleV4WD5FGfUbEmt83
         KAsxmxOQ0bSKRkCmraLcb/Z5QPahGR5fENMHRC7BElmeP6i4hY+fT0mXsQWAqy0+eUdj
         clng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784177762; x=1784782562; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bS/QNlnrbXpOGhrS6iLoq0SdHzM7UbN+ODYuLLYXyPI=;
        b=PntnDs++01r6xlD4nx1mRzm5IqMkCGEUPchVYp2jcBYzkxf70UQJDBEnxRApeg7Yiw
         1xGCean8yuJG/6RPzpsPTkTtr2ZEei+DUvu2nbB84AhHSR3HB8Jb46G5je9ApuIW3fKl
         fDTWkkJvd/GliOZoLPNkCxoK84F7eVUgCGxEQhbP9n5p2YmqzS732sQ780ZiSs8O1Gnk
         CB3jsLW3ZbFDavoNxnL/Y02hh1bMo9cMHF7LYYMklnIuRmwWvNyTUuUUMEB0ZeKLHNCi
         H4Djwnew6jLpZ9zgXZbbDpvQyLd4KCYjK/xlamp286WRBIR0sTrob4PfAqea0q1VBLSj
         OhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784177762; x=1784782562;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bS/QNlnrbXpOGhrS6iLoq0SdHzM7UbN+ODYuLLYXyPI=;
        b=Gb6QUaTs/pEfS6YRuLVvj6D3McVgvVOT29GGX8tEiz3a6YwJhTBw/utgVfW252pXEF
         HlPdls7aVrhTWzLwrsXloxXFQjOw8qwV+MaLkxfclGZoYR2L/Ri5t/026TK82HRRHv7f
         qdla2Reobq6bwIKl2fZfv783cjHBxzVmRkyA9rTWTywZNtbCnFP3a142J1leFieHOAXo
         p1+RFmONgqpsQvVSpxb+4p92RN+kO8kMYKYtztciF3nQwm2cXgujI7k5zWBiYzrQztKB
         4uUM9ClfK+UHRKLfBER500OMPKztvpcqdlRYL8u5/Jdl9OzKc40zLq/SzH0ZU0z6xCsi
         MeMg==
X-Forwarded-Encrypted: i=1; AHgh+RqpZ+F9DSLZ2z2McfXPWTLmgZ40KSN3hmmoghSo8MY8zDeqRA7YoyrK1unuJ/9MNpOkxyh0SF3B@vger.kernel.org
X-Gm-Message-State: AOJu0YwkxXhsUI5DtdZPgWxTFIYldi5xc2dZ5oMRZYkQgTwM4Y9Vhecz
	ku84p/lb0nQ4BI9oyDf0kFba1h32vJylISaRpKJzQsax99t3LBiP4z7QmTG7Gr0ouPO1XjTThbp
	d5HLytzhF9FM5hwgFFLi9YG4Ly8KVoeMB/Irts6js
X-Gm-Gg: AfdE7clw+2wowIpCGQ5808V/yMsEKOf0Qyj6DoenaWUEwpoi0Ye4G+3G18dj+ntSBV9
	zkhlqwTIVaWEtLr/BUfO5WkPpbCxDEPQnwX/6UKmOXir67b+nV/ZZ/iJ6E2fj0lolkJNhdGlCix
	B9qghuxJhSGauB4Pj7CPQV5FwNqxElVrmZBY9HtauUEgXqVk1MBYRjTK0rAKXy9Y9cTl8T+acPt
	SVJQoLPU823JzcjKeVVCXfpOnzsV9XYqyNyIHELScQm53HgpTBPFkz2ZbEIIhF6sHvr+zw=
X-Received: by 2002:a05:622a:293:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-51fa44b7219mr3962941cf.11.1784177761873; Wed, 15 Jul 2026
 21:56:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <CAJuCfpEVQU6s58s9XWCVDUXzr=7bbatmCi35vxnSiyA1pe1P6g@mail.gmail.com> <0d191478-43fb-4286-a2e6-3e7f3047b42a@kernel.org>
In-Reply-To: <0d191478-43fb-4286-a2e6-3e7f3047b42a@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 21:55:50 -0700
X-Gm-Features: AUfX_myzkvAFS4o6DwQPPiPbod62HAR9bJIYi6k3dRczP2dn9_9CQkC9qjxhTUs
Message-ID: <CAJuCfpGGp1Yt7Jz0J_a-0+TRA7gX6mkYhZiqvAMbF86q3avJeg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/12] mm/slab, alloc_tag: reduce obj_ext memory waste
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 8:29=E2=80=AFPM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 7/16/26 12:32 AM, Suren Baghdasaryan wrote:
> > On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >>
> >> The recent fixes for objext array handling inspired me to look into th=
is
> >> finally. It's been bothering me that the memory usage of struct
> >> slabobj_ext depend only on config options and not whether the fields a=
re
> >> actually used.
>
> +1 one more person bothered by this...
>
> >> So with both CONFIG_MEMCG=3Dy and
> >> CONFIG_MEM_ALLOC_PROFILING=3Dy there is always objcg field and codetag=
_ref
> >> field. And thus:
> >>
> >> 1) Having memory allocation profiling config-enabled but not
> >>    boot-enabled means wasted memory on unused codetag_refs. This makes
> >>    it less suitable for a general distro config and the page allocator
> >>    side doesn't suffer from this, only slab and percpu.
> >>
> >> 2) Complementary, with memory allocation profiling enabled, there are
> >>    caches/slabs that don't need the objcg field, so memory is wasted o=
n
> >>    those.
> >
> > It's funny because yesterday I started working on a prototype for the
> > same optimization. But your patchset is much more mature, so I'll
> > focus instead on reviewing it.
>
> Ouch, a race condition!
>
> >> This series should solve the point 1) fully for slab, pcpuobj_ext
> >> handling can be perhaps improved similarly, haven't looked into that.
> >>
> >> For 2) it avoids allocating objcg fields for KMALLOC_NORMAL caches whe=
re
> >> we know they are not necessary because kmalloc() with __GFP_ACCOUNT wi=
ll
> >> pick a KMALLOC_CGROUP type.
>
> Unless KMALLOC_RECLAIM !=3D KMALLOC_NORMAL! (yes, SLUB_TINY)
>
> >> The named kmem_caches are tricky. They can be created with SLAB_ACCOUN=
T
> >> and then we know objcg fields are always needed. But also they can be
> >> created without SLAB_ACCOUNT and then some allocations have
> >> __GFP_ACCOUNT and some not and we don't know that in advance.
> >
> > Do you know how often this happens that a named cache with no
> > SLAB_ACCOUNT is used for __GFP_ACCOUNT allocation?
>
> Not sure about how often, but one thing I recall is xarray
> (radix_tree_node cache), which decides to account the objects based on
> xarray flags.
>
> >> A possible future solution is to introduce e.g. SLAB_MAYBE_ACCOUNT, ad=
d
> >> it to caches where we know __GFP_ACCOUNT is used, and only honour
> >> __GFP_ACCOUNT for those, while warning for an unexpected usage
> >> elsewhere.
> >
> > I wonder if for such caches we could create two separate caches, one
> > serving __GFP_ACCOUNT and using extentions containing objcg and
> > another one for non-__GFP_ACCOUNT with optimized extentions?
>
> You mean transparently to users? (e.g., user thinks it has created
> a single kmem_cache but actually there are two of them, multiplexed by
> __GFP_ACCOUNT bit)

Yeah and only when we detect that a cache that does not have
SLAB_ACCOUNT is used to allocate with __GFP_ACCOUNT set. Not sure
about the performance impact though...

>
> --
> Cheers,
> Harry / Hyeonggon
