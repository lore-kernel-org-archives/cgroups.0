Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66941DF72
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 07:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792137297; cv=pass; b=Oct/K3jfXaPpWQ8nor3OLPVNP0CwmHphoj6nQgsb/I+SrY5av3Nauva5j6vLWsCGox+wfGl+F07iBbTPwkiJIBD4+qMODuqhuMdZNwXE/YEv6Pi1oyfKT2LYCYG0HXyvWaHaliC+oTFNKcA+kBnqXOqquonEZTueF8F5pxjZxMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792137297; c=relaxed/simple;
	bh=Asd1LyXfmZ/wMvQJmtWaI8YOR4sVcoYcjj3fIBEE5QQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UbHWpPFVVIlZ9umZJnnX2leXFvkN3eAt4iyi61HFonruEPRC0uJsv7VpgmaNzcPLzRPQQJro7hN/oedmy6c2ydRzWZ8RvKDNqmMtIOve+yOV3laUuD7d9L+6g+UsRFceuKgO+R5YbA3STIncBEGVZW2A0ow9c1rh3+RhT+3iQrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RyCQhiob; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RyCQhiob"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c350db5a761so40089566b.1
        for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 00:54:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792137293; cv=none;
        d=google.com; s=arc-20260327;
        b=dUNlXZVO9Id3LMtUCN5YWllmqxRkEiDz193+wNeozcI4W9gSxZOU87j4adzEHDtf18
         arneORsFMImLINHaRo2DscFpk/7QRU3erz1IcnmMImks90L6jA9jMQWuqZ/fhYa2cTFx
         h1UNpwel5pZ5saDjF2TWfoy9UD3iUZmZMfCIb+4RB653Wj7rB7gCIVT3yGjP+oEQINpa
         ucuhoCmlC7qY+Ic4PRFwSds4SLJOIJQxe1PEZg5hdav2G/4Pu1qkkhqbGYpCiI9wvj6H
         F4TL4WqbS1mMRWP+OVxo6V38VRNTzUxJtt7/GWaZWf4Y4xAJJZs+thhU99RJUSyapkf2
         f3XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sTydiIf1dz0lwLgVUeftG7/xPlIHpWwfPGV7qf09584=;
        fh=2MKY95LsYW6Zh7rOnFKdwubOj/9nnerhFuCQ0J0WVrQ=;
        b=gd8hki16k20f8NL7YWa8YP8KGb6uX2E/pvDRRLju3jKp+vSAfqHlg8v6RcOYM09/Zl
         m0GisfLU5CWrngBPUgisgFdQvD91l7yOEM2wg0+j/qaEUBBJI8ao24nOAF8PMCEAWhP0
         pe1UCd0E/p/txaFUSGiGt0lNfoYl2D3DiT6l8QH0DDSoCEIAN63UbsyNqqJv2Ten/ndU
         Lh6vCnFHGpHiWthTMS6j5TthB9vAXUYMSAj8sc01ybT1y17eEojszRphMm/nNCoDLqI9
         TZP55uHnhMZ0YRdQMo5maL7QFy47gkiBPP3lUwCqxwT9xHHAkdsOJkaLnzRCCXPuBhhv
         DRdA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792137293; x=1792742093; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sTydiIf1dz0lwLgVUeftG7/xPlIHpWwfPGV7qf09584=;
        b=RyCQhiobmg7+oR8HaTH9P/HSiR5vcRktzRPc8cfuIHUBBiY4vLw4l4aTriMy4Wwhss
         1Z7yIrGVLg6USy23x/7sGnm83/pXvIkYASwGRFlHRtLzSqTPDXrUEBg8KPiVl1FJj2AW
         NUNHMbD7BjjcMwsrs9JR92IBXlAPskLP6sCs/c06x3yEcQromRcNgHTcAxpB0gaMvfr0
         ZzmWwWaF8OamMyHXV4Nno1lKLmGo41cuziFIOrFik7UUBWmdE9WPoJbwjE8/Pr089XFK
         5v5WKjbbILpoeCkoBUAj7ZPzYBtOvUspVWe0JPW41Dh5UwuVXhDV0UqlGV2SWmlpy9fF
         m/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792137293; x=1792742093;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sTydiIf1dz0lwLgVUeftG7/xPlIHpWwfPGV7qf09584=;
        b=FV3/lzO7w4+9LbrH2zd1gAleR2TS122jUUHyJK7iEw1JBGnrQ/J5hNmOWE6RDs0/FT
         sOT6RCdLsucEZsHwblN346tkqthKLKyj7a3J+Y2lWMuKojy5bfSYtdm9cAVmANMscVKh
         r71nHiQR163SNlevoK8yvjvEB7NFZBJaAEnbU8z0yznvIYhLWEB5WDcIQ3uDB6w1zbXZ
         CS5BGqTVm/CgcHvQ2SOoeofr0I34Cm3dREuKpyjt+CKewp+vzFkHyfJe4BVrfS4QmSjT
         eiQMMlPoFC1MenDH100pkvgmHOH2jush8/b64TuslGcFtTI8VnO67wVQOZiE999XwTgi
         Qrkg==
X-Forwarded-Encrypted: i=1; AKwUvBwIfslhdxq0WvHhfUfBUublvfMQeetrgFV/43nm5Z5p+WKmCGuUusKC15O0XBWmSrBcgEjyPley@vger.kernel.org
X-Gm-Message-State: AFq9FYJzD2wVwwHGsGwuyPvQCCw2RtVVB8ex1yz5W7dT3ip0RQmKtxxK
	4Hra6MMumqFXpmnudXRutgV6LvUHU3wNnfE6CjDb10K+iTOOFMdFy4szp6aIfvDeWDCzVI8HBPE
	tVQiYR8rrn/UKIDdUVmU87OXjTgk8LUg=
X-Gm-Gg: AYBFou1ZOWinzxtCcRc6WxIXCVNiirsraQ0nIc4q8vEzkIGFsm246Yv9Q3T7jvLZxJ6
	cq8Rs1/RxTokO6Onng9fNZv4tTu68XryB8yaj/cp5/TB51amDN14/TMmkeQuoy9oi1Nr0ALiMIq
	F0djfkz9Hv/1r5cEYvK9MGtkRt6FjhD23ILS2pb761TJ3FVTrP8BenOz064MKWM8thm6i/UmvdI
	uWIY1dJcbeq9Ld1L3t0990DDW+KAqT22Ll5Xcvw34yZAOoPKVTTyUen/2Pq1R0hgyeYX+Jd4bSx
	DAnBxhG7BnRxdTmHHPtCB435BIo4ihhqHbrBWgSzea2VkWpx5xT6IGr/yTG50i1facSdc1uJFT0
	6FJoTiQ0u2PapEkwgD9dYlRPtYNot9xXw17wylkFQxAbM6W+K2i2Mf5BHnAoNaEBjl0nwLA==
X-Received: by 2002:a17:907:7213:b0:c31:6bd8:b13e with SMTP id
 a640c23a62f3a-c31a9fd33d1mr1854131766b.11.1792137292409; Fri, 16 Oct 2026
 00:54:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com> <342E57E7-9B7F-4193-805E-D1EBB41299FF@linux.dev>
In-Reply-To: <342E57E7-9B7F-4193-805E-D1EBB41299FF@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 15:54:16 +0800
X-Gm-Features: AclHuK8lfaJLkt55oh9aygbGuPc6XqqQ5L-gpY7DcUfl3-ol56sFY5yxSCzcN1I
Message-ID: <CAMgjq7D-2HyvuD5U58ohv4YuyuCEbxYAO_wxkx==WxhsNQrXXw@mail.gmail.com>
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
To: Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 3:39=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
> > On Oct 16, 2026, at 02:15, Kairui Song via B4 Relay <devnull+kasong.ten=
cent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Add a helper that resolves a stable lruvec for a folio under RCU
> > without taking the lruvec lock.  It takes a folio directly so the
> > lruvec lookup happens inside the RCU read-side critical section,
> > which a lruvec-based interface cannot guarantee.
> >
> > No functional change.
> >
> > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> > include/linux/memcontrol.h | 39 +++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 39 insertions(+)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 74110a324f9e..829ab776ab44 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct lruvec=
 *lruvec)
> > spin_lock_irq(&lruvec->lru_lock);
> > }
> >
> > +/**
> > + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> > + * @folio: the folio
> > + *
> > + * Computes @folio's lruvec and walks up to the nearest live ancestor
> > + * if the folio's memcg is dying.  Paired with folio_lruvec_live_put()=
.
> > + * The result may be stale: RCU keeps it alive but does not pin @folio
> > + * to it.  That is fine as the counters are fixed up on reparenting.
> > + *
> > + * Return: the live lruvec, with rcu_read_lock held.
> > + */
> > +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio=
)
> > +{
> > +#ifdef CONFIG_MEMCG
> > +     struct lruvec *lruvec;
> > +     struct pglist_data *pgdat;
> > +     struct mem_cgroup *memcg;
> > +
> > +     rcu_read_lock();
> > +     lruvec =3D folio_lruvec(folio);
> > +     pgdat =3D lruvec_pgdat(lruvec);
> > +     memcg =3D lruvec_memcg(lruvec);
> > +     while (unlikely(memcg && css_is_dying(&memcg->css))) {
> > +             memcg =3D parent_mem_cgroup(memcg);
> > +             lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
> > +     }
> > +     return lruvec;
>
> Hi Kairui,
>

Hi Muchun, thanks for the review.

> Actually, we don't have any means to guarantee that the memcg
> to which the returned lruvec belongs will not become dying
> after the return, right?

Yeah but Qi once mentioned that RCU prevents reparenting, right? Even
if the memcg is dead after return, things happended to it
(non-hieratical counter reparenting, ones in __lru_gen_reparent_memcg)
will only occurs after RCU unlock so we can apply counter update to it
without grabbing an ref, just hold the RCU.

> > +#else
> > +     return folio_lruvec(folio);
>
> Then, I'm wondering why folio_lruvec() doesn't apply to the
> memcg scenario.
>
> Internally, folio_lruvec() obtains the memcg through
> obj_cgroup_memcg(). So when the memcg becomes dying, it should
> be reparented to the parent memcg within a short time.

I wasn't sure if grabbing RCU can ensure an already dead cgroup has
not been reparented yet. If we apply the counter update to a already
reparented lruvec, then the counter is leaked. This new helper is just
a folio version of lruvec_live_lock_irq.

I got the idea from commit de4660898b7a, which says:

"""
.... check CSS_DYING under RCU before
flushing the pending batch.  A non-dying memcg keeps the original lruvec
stable against RCU-delayed offlining; a dying memcg redirects the deltas
to the first non-dying ancestor.
"""

Applying counter update to a dead but not reparented lruvec is fine though.
