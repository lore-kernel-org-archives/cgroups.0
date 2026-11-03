Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793667648;
	b=ddrrpgCPNTB9i5jAJTjhOFMSkMU+OjQMkbixbY3/tmbw01LmBuFmZ90/Z61LPrjWVedG
	 HGRmuufjS1EoBveGzwOgxHhL9QtCoR+CF92XhuuwUQZwaZxhcMpgKG4643y2CFXB7/j1G
	 N6n7nTVgXAjyDlGtd4JTvMKLI4LCwXuz8hGeqw1BxJh8AiyXFsrWsUyhpwfZ7Nebdxp/x
	 qvIdoeRiaO1YDGf9r94c90chdbCDuoMpdNSM400CzsUDgixmyC29rFQ0TxB5CxwDDawYu
	 K8kI9syCtSj5WVlZKqXtSycn6+L89WXN/be4rYDnKyodzPyr2VZIdZ7vvJv3Pn8nloQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793667648;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=4HQ3Qgd7i2dVNUMZQt7YfeVDy1gbBVil90g1I4doNFE=;
	b=u+10Ai4DaJjpj/L1Zuj2Vk98a6gA6l01x+zX91NjBpElYpbkyGuWgAUfS8b1reIBFKbE
	 8L699YzxH79J0noNcI6N6gDjELo+knZYhE3I0SVGrZjiD0eAeWL5kjqrlH6ArTxdFb+Cz
	 t4ok00M1KzWHSM2DLswFSsupvsdi6s87h5Vegkd4gO5q/MiELdiFTWC4yO9dMUn5Kl9tn
	 n20b10ztClPYVEr69YmQRqdKAF6Z9tRQvB1XeS3cQuY61qcGbjxL0thGeWvEV6zIFqWZy
	 esRgI2i380VI6sYLFwL/tmgfVoxBq9RkDq0SpcSP52MP3b+I0J1dBx0+z5Ek39NjOkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgGv8lJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6607606A324
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 01:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgGv8lJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAEA1F00A17
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 01:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667647;
	bh=4HQ3Qgd7i2dVNUMZQt7YfeVDy1gbBVil90g1I4doNFE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BgGv8lJOHVEgop2gWiFbPShFWku0TCjm6MwzTYsrxTPTGPDILDl6x5fU6Q1UWKT2e
	 MQNOpygshQ0/ofvQ10Q3ccG8DqHWbje392YnCG1S2tnxMi4Qgo9vaUQ0HSJQwxuM8J
	 y0xc1HUsR9GiC4fAohVrc7jYr2h1hf00pZMGkMwuYMMHLCt+Xph6T+SGT7l5HfBv7w
	 cm9UFAAqtTlUWYTt2GeUfwqpNZfNMfIiRfm4dwTsjyoqjBWPjFPz1ARLIBqrD4VGn0
	 N0c4T5/GkF4pzmYOmcEubV/bs6fvsOa2gFk8mi7KeO4USRlFk5UTNJ8gCZPkVH5QxO
	 mzDoMkXY1sn6g==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c315869241fso512758566b.0
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 17:00:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwypxayMZTjnEPNZSxwUvqQu3Sd9FfWMHqA+OcYvgib0j9ptHE+AgtF32i63Mrzyzts6fo3Ovvl@vger.kernel.org
X-Gm-Message-State: APuU4Z8fbzxJzzKjr5zONJ6Gc9j0dsroVCNOPSbMItyf8ohMitHxfUvj
	09BZn9vtwmJ6io7QLaGGNzhZcsAk+izSQKyN65/yHHdVXtnCDagBV8q5EJc97ubE8JMdQhYOOAP
	zIJjBa/0N335tgkz3dBcsgiBnAtTxC7M=
X-Received: by 2002:a17:907:7fa5:b0:c40:eb1a:4c8b with SMTP id
 a640c23a62f3a-c4ca7a6d245mr897957366b.29.1793667646429; Mon, 02 Nov 2026
 17:00:46 -0800 (PST)
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
 <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
In-Reply-To: <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Nov 2026 17:00:35 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
X-Gm-Features: AclHuK-Nd_GMyDmaw4iY6A-BMZy3XZnuaOJfkxR3X8uJTpecvIovrO_sqKDwyjY
Message-ID: <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 4:34=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index ac6c43ea8c5a..938843346571 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const stru=
ct lruvec *lruvec,
> > >         return x;
> > >  }
> > >
> > > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > > +{
> > > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_me=
mcg(lruvec));
> > > +}
> > > +
> > > +/**
> > > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > > + * @lruvec: the LRU vector to read from
> > > + * @idx: the node_stat_item to read
> > > + *
> > > + * Like lruvec_page_state(), but for the root memcg the node counter=
 is read
> > > + * instead. For stats that only track memory charged to a memcg (LRU=
 sizes,
> > > + * workingset, rotation and reclaim writeback counts), the root memc=
g's
> > > + * hierarchical value equals the node counter. The root memcg can ju=
st read the
> > > + * node counter directly instead of going through rstat, which requi=
res
> > > + * flushing. Flushing the root memcg flushes every cgroup in the sys=
tem.
> > > + *
> > > + * Use lruvec_page_state() for other stats (eg slab).
> > > + */
> > > +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> > > +                                   enum node_stat_item idx)
> > > +{
> > > +       if (lruvec_is_root(lruvec))
> > > +               return node_page_state(lruvec_pgdat(lruvec), idx);
> > > +
> > > +       return lruvec_page_state(lruvec, idx);
> > > +}
> > > +
> > > +/**
> > > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for del=
ta sampling
> > > + * @lruvec: the LRU vector to read from
> > > + * @idx: the node_stat_item to read
> > > + *
> > > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
> > > + */
> > > +unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *l=
ruvec,
> > > +                                             enum node_stat_item idx=
)
> > > +{
> > > +       if (lruvec_is_root(lruvec))
> > > +               return node_page_state_monotonic(lruvec_pgdat(lruvec)=
, idx);
> > > +
> > > +       return lruvec_page_state_monotonic(lruvec, idx);
> > > +}
> >
> > Why not do this directly in lruvec_page_state() and
> > lruvec_page_state_monotonic()? They already fallback to node stats if
> > memcg is disabled, why not do the same for the root? Are there cases
> > where the node stats are not the right thing to do?
>
> Hi Yosry,
>
> Thanks for taking a look at this series! I don't think we're able to
> do this directly in lruvec_page_state()/lruvec_page_state_monotonic()
> because I think there's still some places where the node stat and the
> root memcg stat are not guaranteed to be equal.
>
> The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_B
> and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
> can contain memory/stats that wasn't actually charged to any memcg,
> which I think means for these cases, the node counter values can be
> larger than what reading the root memcg rstat value would give. The
> functions I was looking at were account_slab() and
> memcg_slab_post_alloc_hook() where the logic adds every new slab page
> to the node counter but the memcg stats only get updated if specific
> criteria are met (eg the cache had SLAB_ACCOUNT set or the allocation
> had the __GFP_ACCOUNT gfp flag set and the allocation was not from a
> root memcg).

If it's only the slab stats, it probably makes sense to special case
those instead of the rest of the readers, right? It would be nice if
the default behavior is reading the node stats that doesn't require a
flush.
