Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793734129;
	b=JGYkIc5HYHhkPPS8R5aXPSbnOxP9ur39DKmGfs0QXbsdQpLD6C1oNjdbhSHHcJiQrMFW
	 ZQ70u6n2BGD5GRVUiMrrOwVpZZ+W/b0+6FXf1Zgzis+FrN6p/TXpXUxTZo8rHzLzlHIIv
	 mV6GfWCpjY0s1IPGlEouzA/cAF++kzGHGneghTljuiuNpV093i+sFVV/H278Bv8bKyzVa
	 GAOzLeQo49tU0BculUIDzq0+c1DmuLGk2CdLdjaB/N2Th47TJ8+oHiCBJlrJqTHFamqii
	 lmAsFKZGRIyttNxrombVF1lvs3Yf20xht8HtaR2PTHT0Nfmxf6P3Te+Crl3O5jyV7lw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734129;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=t8nOrLjD6nwiDigTpfoc51j1sg2vY57/yO5mUWHgXYs=;
	b=O7Xf552Td7THeYgRy/z0IKeCRU//+vY3PIWZdZwTAI7xMZOl1j285CZWhK+48owuzxI4
	 3JMGuAwGCbk5duuB8IbwvXiifveg9Nqqqc2LbviIFDUd13RBJ3kj8Nd4KVKXl0LYTOc5I
	 Pn01rvaXu+F3E0DZgQY8go4Bu/sIcBAM8yv0IY0vDfosYyYTSARDjOHB8JGZXdcc5oQk4
	 cPLvzsnlD17qN/gIdR1oavS5GJftDtoKczj/WkISngwizZjUCXB1hFY/cvXVHVivkPCVw
	 RUpmSlnjh/RyAGN93ez9LzOs6l7q7LUhw2rV8v6jhFcHWZG1NdOaHnOd4Wrn2IWApgA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pwqo597O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D3B606A335
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 19:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23D3B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pwqo597O
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so722981f8f.0
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 11:28:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793734127; cv=none;
        d=google.com; s=arc-20260327;
        b=MJeydiQD0G9nrEDMK73I+SNCdKENhmB0ovHIga1gWoEnmFCY2Y0cC+Q3mN/L/kijpL
         5Z9wpJk/oebQ7emKreEt3hZKQv3/AJvGjGiHuXZEJkjQ2eHxwNbj9Xd1DM3vLGKDetAD
         IrSgcvZUsYyOvg22iUDytg8dvALvohaZPJ9iKwUtxG8dHHdDKG/+lEBLwTM7WgJ1OUEP
         dQ1VDz+APtNp/N2qr3XTq8j1XodqjaJPhO9kkKnuSInvNzOYycDLcmhs4HGi3wrSJJTs
         2KfeeEcw9//gl0zxG4iB042qFHsVBSOx4ff/jcD7I1wfyzHVSaUoNoC/LOo2hJjo5O8U
         Mi4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t8nOrLjD6nwiDigTpfoc51j1sg2vY57/yO5mUWHgXYs=;
        fh=tfsTpxR24RFKDMJdxZDUwRgc53fW3rxnLvJajfTFYUI=;
        b=sRBzjPU+DC99efrYaUgPNrCIEFNQ9id0c/XZyj69TwKpkqDremnAYRUvY6L9dlSUd+
         jQHIfohITdqbRDWLtsu/4A24zYSm5OzdXSn8lt99aOMtPcRGGwvBdf+DF/NVo7P2TEyK
         FtbUnD0VlUTg+Y7rfInxVK927ySNk8mwJs7UsVDmk4lWooFNPB04NpqC2FLgnTxTp6WM
         qV712Yar2BjMoGOR/XdxQI56ICeMDq7E4ulvOsWW7aXp4Jl+JwHzMu1pkzXzUjQszaEh
         EJkr46Zgq/552S/aJUs22bnecIJU10zRK7401bYqHdYYsNKnEgEJ3u/bEY0tZYkOHX60
         K2tQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793734127; x=1794338927; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t8nOrLjD6nwiDigTpfoc51j1sg2vY57/yO5mUWHgXYs=;
        b=Pwqo597OdfxMX2t1buBZneLyPV4yYM/CvRkRrcwRIyn016/PdJBUGqEQxap11hmSb5
         bjB+fiJ7SYrUDhUMYY5c9DJgGmEnCnK8sBZnNBzd/xAgYhbmyzkOxvgGzJl2ZUBfjPn/
         u6JSgwOQlRNPpy4rRLPHNhXZInEIb923HlhX9yMAxDiDJ+C35duN8Y+ngux5ARSS7PB9
         TtW+epDNzfv73JZ+KnJKXkUrhioRzSi9UOvs/DrJjQ7PD1tSYjDyISM3+edmZ30Zw+wt
         hwW6bgEjGc6fZtMNvrDs0jZEhUyghcmeJepPockYWXK6UI3F29lXm5y2ggFueLcD3Rcu
         rQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793734127; x=1794338927;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t8nOrLjD6nwiDigTpfoc51j1sg2vY57/yO5mUWHgXYs=;
        b=fpqw99UOxI2nucJpEZWxWkr2cluc/F9auPnIFmntc3zHf6c6RXnVSE1klvzQ065uZJ
         XVTkxIMTpoMF/9OpzI1OlmLbriiX5feCYridRsT9hk8uxf3fqsn8Fl8/+jAuI5xWvICq
         SCaJkBf2T1m+XU/213CnxPlJekLOsWaZoXvJAmoQNBcCWxxGCfa0y2gUVvioiDsdi6vR
         Keyxy3yCrbpPMOA9Wt+zsgSq2NxoZKVc27NRRnTzov7kXFrFHA/c+8Gys1Zun2csF6vp
         w/cx3UFcOVWzes+WjD0+Soi64xL7Vmt8RLrkWJ+Pr4Dul4yW/NvY9qYiNKrAm2mwXtbn
         Q+VA==
X-Forwarded-Encrypted: i=1; AKwUvBwpZElL6XjlYQruorcEV9n6NF3Ekjfm/q8+fb3s7gZxAOAxwquv9k7eG58pDDeOxq/cLXMq5feJ@vger.kernel.org
X-Gm-Message-State: APuU4Z9Kjud0B4FyPhrA2yYK56sqCz4OfQLSIHhGgmCip66b83ftdIzy
	7dye+1rzx/hPOXfZYTBmZc8FZC+VL5xjnRM2M8h6UyRQlHQi7K+chzZnVeopJMPqrRE/mdiogJk
	Cf4BtmPFyGJrFZASHBlSCZwlPlX8dFT4=
X-Gm-Gg: AYBFou3eANhR3OW4Kmo+taXazJguFWZL0VLo8o7kvzK6hwegsjn+5Yn7IMGuGRWy8lp
	372rH5PNlYZJswcZNCS08qlC6iI9drI+DVQ4gX97iJtCqx3FnNyr6K9uGHpkazrjIirFkIQ/GXn
	TIsoXbjJOcWtrZzEGOQlSbhJfBAbEMYmivrzkBRGbkQk4pCIVLY7c36UxOfSaDKbOmQIp+kzSc4
	0+1vC/6OM6nxb2W2OW1WRu6K1NrnxUMuv/UQ9ExuUaml0J0GoYX+n+dHOEDK+5Nmd8Geerhncb3
	iYODoUQdPaBJBRWEfmPJnVWYYdzQF2Xu2QVgzHgJWuFtk7Zfinsw8jksR6HdRpALx7oJOVura02
	zLzZTFO4R6IbSdfKGvATXIOEK/cUm2XXQsdTaGmIeEfydd/zcucyws/wFDt1cjW7O3FGCl/DKgk
	Rb0qYlz3sI9bCTNHd7rttw7yoNY69OKttwwDAzXlA=
X-Received: by 2002:a05:6000:3101:b0:48f:bbb5:61c2 with SMTP id
 ffacd0b85a97d-48fbbb563a3mr5372701f8f.4.1793734127208; Tue, 03 Nov 2026
 11:28:47 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
 <20261102225030.2743129-3-joannelkoong@gmail.com> <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
 <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com> <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
In-Reply-To: <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 3 Nov 2026 11:28:35 -0800
X-Gm-Features: AclHuK_fv28I1LSA-uaRqmIKjly-WVjyuC4Z8VHCIcHxkEADag6Zx2F__lXwrn4
Message-ID: <CAJnrk1ZAz2ro0-8CC7n8mEjpuRQ64=v0rABtygaw5e2Aohq3=w@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 5:00=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Mon, Nov 2, 2026 at 4:34=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index ac6c43ea8c5a..938843346571 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const st=
ruct lruvec *lruvec,
> > > >         return x;
> > > >  }
> > > >
> > > > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > > > +{
> > > > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_=
memcg(lruvec));
> > > > +}
> > > > +
> > > > +/**
> > > > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > > > + * @lruvec: the LRU vector to read from
> > > > + * @idx: the node_stat_item to read
> > > > + *
> > > > + * Like lruvec_page_state(), but for the root memcg the node count=
er is read
> > > > + * instead. For stats that only track memory charged to a memcg (L=
RU sizes,
> > > > + * workingset, rotation and reclaim writeback counts), the root me=
mcg's
> > > > + * hierarchical value equals the node counter. The root memcg can =
just read the
> > > > + * node counter directly instead of going through rstat, which req=
uires
> > > > + * flushing. Flushing the root memcg flushes every cgroup in the s=
ystem.
> > > > + *
> > > > + * Use lruvec_page_state() for other stats (eg slab).
> > > > + */
> > > > +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> > > > +                                   enum node_stat_item idx)
> > > > +{
> > > > +       if (lruvec_is_root(lruvec))
> > > > +               return node_page_state(lruvec_pgdat(lruvec), idx);
> > > > +
> > > > +       return lruvec_page_state(lruvec, idx);
> > > > +}
> > > > +
> > > > +/**
> > > > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for d=
elta sampling
> > > > + * @lruvec: the LRU vector to read from
> > > > + * @idx: the node_stat_item to read
> > > > + *
> > > > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
> > > > + */
> > > > +unsigned long lruvec_lru_page_state_monotonic(const struct lruvec =
*lruvec,
> > > > +                                             enum node_stat_item i=
dx)
> > > > +{
> > > > +       if (lruvec_is_root(lruvec))
> > > > +               return node_page_state_monotonic(lruvec_pgdat(lruve=
c), idx);
> > > > +
> > > > +       return lruvec_page_state_monotonic(lruvec, idx);
> > > > +}
> > >
> > > Why not do this directly in lruvec_page_state() and
> > > lruvec_page_state_monotonic()? They already fallback to node stats if
> > > memcg is disabled, why not do the same for the root? Are there cases
> > > where the node stats are not the right thing to do?
> >
> > Hi Yosry,
> >
> > Thanks for taking a look at this series! I don't think we're able to
> > do this directly in lruvec_page_state()/lruvec_page_state_monotonic()
> > because I think there's still some places where the node stat and the
> > root memcg stat are not guaranteed to be equal.
> >
> > The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_B
> > and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
> > can contain memory/stats that wasn't actually charged to any memcg,
> > which I think means for these cases, the node counter values can be
> > larger than what reading the root memcg rstat value would give. The
> > functions I was looking at were account_slab() and
> > memcg_slab_post_alloc_hook() where the logic adds every new slab page
> > to the node counter but the memcg stats only get updated if specific
> > criteria are met (eg the cache had SLAB_ACCOUNT set or the allocation
> > had the __GFP_ACCOUNT gfp flag set and the allocation was not from a
> > root memcg).
>
> If it's only the slab stats, it probably makes sense to special case
> those instead of the rest of the readers, right? It would be nice if
> the default behavior is reading the node stats that doesn't require a
> flush.

If we were to special case it, it would need to exclude more than a
couple, I think. I asked a LLM and it says NR_KERNEL_STACK_KB,
NR_PAGETABLE, NR_SECONDARY_PAGETABLE, NR_VMALLOC, NR_HUGETLB,
WORKINGSET_NODERECLAIM would also need to be excluded. We could add
this special casing in, but we would need to make sure any new stat
that gets added in the future that belongs on the exclusion list gets
put on it. If it's missed, the failure would be silent whereas with a
separate helper, callers have to explicitly opt in. I'm happy to go
either way though, so if there's one way you prefer, I'm happy to do
that for v2.

Thanks,
Joanne
