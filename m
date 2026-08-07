Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B023F328B
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 23:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786144265; cv=none; b=J/IERcI2o27nU//QuvvJPuAuE7rBA1aiDQmIZroWsigM803Q4AiSnkGa7EY7XoG/mAtfbJzu0kbAxXVZVSctlBml4AOiuEmAu4xZbp6FMrOU0SIQMSFe/C+IEtAQqJLeKnKOyb086Ydp9rbcQN7DcTyhT5HD+GFG39D2RfNfXMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786144265; c=relaxed/simple;
	bh=hswY0Dk1EOwpmmuqdfk2+MSA4QFgXsp064Ua4y3+Zng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QGtN+hgcUU5vupEzN2hqci5m6F3Cwn/MRmTg9SnKeOUQZW0hjCsBGM6rRD2XfQg1BExQ9j4Tm5gNr4BoPKkXcJePHkDMPPaH7NoY4oYhs83lMaikzuK2kF4rCZwTJ1dRtn5xWgr/XfjTa2cU6cHy5Iks6nJ0Gfimd9nWhMOX/gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWMWqjWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWMWqjWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A431F01559
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 23:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786144262;
	bh=GjEUQuQkEGtfQk63ntfLN6GvmM6krYsFGwZAiVs7jkg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HWMWqjWGaQvrvtZg4yyYY+2UhEMePhzJsXIWpCe0IpuymIFKD8Dykdgjh69pg8Yyn
	 zG535S42E8iw6Z48r4VJGV7uj3N1pRruMJCiIIDM1Neb4eMg4PlTRMFBksypPwLSjq
	 U/YkLHcJYa2vwgKmwRorQksoW535WcEPrXz9dM8Q+QWAOIqNGGs1aOwe0CCTq3WtUW
	 Mgsg9njBgpCtdRuP/qRWmuSgzVHrFXxWMQ34QZfjg64NLWsaX7+VXsYBkoJneyTkzC
	 Mw6cz0lTNb+JcntVHU5YIfFzg0od7fJNqKCrndBL0EFCT9cWGuIuU1WPfvL2pxkI6v
	 24e0hCwlLhkSg==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92f03daaa97so3226385a.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 16:11:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RosjbXniW7gEG4uEtnskL5kHu/UKDOeKAMFY5KuFyCmAdbKRIo+KtYZv5MRhbEdO3pmarZgZ9QS@vger.kernel.org
X-Gm-Message-State: AOJu0YxRE07TSmoTujyIm9tTcHpDUPqLB39zjlsFenwIcOA5q2iZG1nQ
	lVB0xorfPcv39c79vDx/I44r5mX8YSsurB8j/aOpsYWMGhycOVjMqMQNgjTQ33ee5pBzASVGZPp
	XxtasGEHK5J2fN429JHNKLvGWENNL5bU=
X-Received: by 2002:a05:620a:28cd:b0:925:56bc:b8bb with SMTP id
 af79cd13be357-93648fafb5bmr2749977885a.9.1786144262076; Fri, 07 Aug 2026
 16:11:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com> <anWAZ3T6Sz8bsKSo@KASONG-MC4>
In-Reply-To: <anWAZ3T6Sz8bsKSo@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Sat, 8 Aug 2026 07:10:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wL0fiVji16XCb37XYZh3s8RetndxPq76d=whhaxH4tcA@mail.gmail.com>
X-Gm-Features: AUfX_mxeQ7BnSG0as7KL-BR2yRh5hwB974upCVTv4g3-H2SP8bkySwta4PXLc40
Message-ID: <CAGsJ_4wL0fiVji16XCb37XYZh3s8RetndxPq76d=whhaxH4tcA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
To: Kairui Song <ryncsn@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2026 at 4:29=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Thu, Jul 30, 2026 at 08:23:02PM +0800, Xueyuan Chen wrote:
> > folio_alloc_swap() reports most allocation failures with a generic
> > negative error code. Reclaim cannot tell whether splitting a large foli=
o
> > could make progress or whether there is no backing space at all.
> >
> > Keep the global free swap count and the remaining hierarchical memcg sw=
ap
> > margin as separate inputs. The memcg charge path reports only its own
> > margin; folio_alloc_swap() combines the two layers when classifying an
> > allocation failure.
> >
> > Return -E2BIG for large folios when a smaller allocation might still fi=
t,
> > -ENOSPC when no global swap space is available, and -ENOMEM when the
> > failure is not helped by splitting.
> >
> > For early large-folio rejections, check global and memcg swap availabil=
ity
> > instead of returning -E2BIG unconditionally. On a memcg charge failure,
> > swap slot allocation has already succeeded, so use the remaining memcg
> > margin to decide whether a smaller charge might fit.
> >
> > This only refines folio_alloc_swap() return codes. The reclaim callers =
are
> > updated separately.
> >
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Suggested-by: Youngjun Park <youngjun.park@lge.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  include/linux/swap.h | 16 ++++++++++++----
> >  mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
> >  mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
> >  3 files changed, 67 insertions(+), 13 deletions(-)
> >
>
> Hello Xueyuan,
>
> Thanks for the patch!
>
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0544b2ec4c56..7d12058174ae 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct=
 folio *folio, gfp_t gfp)
> >  #endif
> >
> >  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> > -int __mem_cgroup_try_charge_swap(struct folio *folio);
> > -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> > +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margi=
n);
> > +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> > +                                          long *swap_margin)
>
> Am I the only one that feel this returning argument is a bit ugly? See be=
low..
>
> > +/**
> > + * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
> > + * @folio: folio whose memcg margin is queried
> > + *
> > + * Return: Remaining chargeable pages in the folio's memcg hierarchy.
> > + */
> > +long mem_cgroup_get_folio_swap_margin(struct folio *folio)
> > +{
> > +     long swap_margin =3D PAGE_COUNTER_MAX;
> > +     struct mem_cgroup *memcg;
> > +     struct obj_cgroup *objcg;
> > +
> > +     if (mem_cgroup_disabled() || do_memsw_account())
> > +             return swap_margin;
> > +
> > +     objcg =3D folio_objcg(folio);
> > +     if (!objcg)
> > +             return swap_margin;
> > +
> > +     rcu_read_lock();
> > +     memcg =3D obj_cgroup_memcg(objcg);
> > +     swap_margin =3D page_counter_margin(&memcg->swap);
> > +     rcu_read_unlock();
> > +
> > +     return swap_margin;
> > +}
> > +
>
> Will is be good if we just always check the margin use this helper
> on alloc failure? Alloc failure should be a rather cold path I think?
>

The only disadvantage is that we don't get the margin together with
the charging failure. If this happens infrequently, it may not matter.
