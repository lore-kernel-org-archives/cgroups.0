Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793037727;
	b=sqSgpAo6ipkB74T1cljj26iKtOHqLDKHv/eVYDbwtNiWBreu+pUL7SVRlO2x+KRzdOg7
	 6a/eMJFoXt3qTUteHlscm9TguyT1+OoXSvi4yg+FIcmQhK+P2keBlg80h5nSa3GVe/KXq
	 FjYujQ2YYFiRFYCM4vtnE/DD5CMccS+P1hDRePZrvjGCLnwJ5bhihOgpfoip7Rlglojjr
	 XDCTh9hmdO0QF9By5MOwA22ElFXZLC1gcNjSWFu4fKe64snahu58aoqXzgaqIwwy9QkNH
	 oePVL188nhg8XeWNkt2fWPEVQHThTbHQjCyhHZzzz/wvUCORQW6/B4I/sOVI2squGIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793037727;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=tE7RP4VYsHqrXApguz8sNdRczbXmH+5NrdAtgpflwuU=;
	b=dk3S5+JOPTtKuV/MrLdSlsITRwOQ+P/eMHCrQTc1ahc35qmugSpbpQuWTwHySyoDPxG+
	 jqfmddu4VJWjc6r339QYujG+V4JirwoZIacq+hMwunwCjlxIA1u39aLwE5dBnonEkx2Pg
	 17VUSD1kq0S9G7M9Knd8zCjBWbnUiVX7XsTuumQl00g3pSMZZPXceoxoDN30IVK8zVqqc
	 hBLviDWbn5XmOirzxfN9cDF8fwdQ1BIdZ9GxuCatIze4+KFNuNywbVFhNgYWQUpjNZ5pI
	 oXYrh2G+XdBu0vjl1Qspo/Cmgsg/juRxNX/bLC8xurwfRSedDMPJ40LFM4l/GzAwE4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=GSt8eQMm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A450606A320
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 18:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A450606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=GSt8eQMm
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a20d7a8984so3605e9.1
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 11:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793037725; cv=none;
        d=google.com; s=arc-20260327;
        b=TZbMuphsy/em9Xs3yAKO6URYGnR34W0oEiP9s0SR+6Wa26Xi/gF/qy7dTc0IQcgLwM
         bvYi/+OHs3N2PG1Yl91WNphesob7EmCvalafkZypP++5iNxPrVUuHswDCWnYGR0dvF9e
         eVVHrZeOTvbv8ABSkfBqNLQxby4rOQtEgmqIAUULzgJPcsL71em7oVUprpK/RKBF5aid
         9B62z2N1H+Ml7LbPSx20ngYbTvf6j9QEQYAb5svlMjpCUCJVeCsFmYb+R++qxo3VFeT1
         NOD9YVDgmzq8lABlhvPtQO08Geqfb4Hms7e3JkKZz2OJ/WPbbCRJT8hufIlamrEvF08w
         sjaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tE7RP4VYsHqrXApguz8sNdRczbXmH+5NrdAtgpflwuU=;
        fh=U9Zj4sHa1ia/yFDPJCJMJY/E+eTEjkNI4saRVnR7mF8=;
        b=H6Jzzd1WSXxp5ZLBM6QLIC2wQScPlmJ3Lih7XarTj1Nh/DlLii0nhqNfSWNOjSJaal
         GJlV2VTL+ojH2n3uUglWd2AbFkjY+9d40LltQT7/Bq3n4FiUAH0SF1LPliG+DJ0M0qFz
         RJJ1dtCnD2DkAgqpL8ZTx6ulhRefazDcTyzUFNaSFLaSfSE/njyPEXHiQAG/IzIoeVAn
         KpONeXxxFIhSHsZPBOHxBuLxoGU4GBkv7cZQ+xgQpT+j8d1vvdVslv34rA3uOZewg6gY
         tsMnyQ7RQTndbYtExXVu1KQLbCn8iYpE9YuWc05Jgr8TBK5AsWIFs+rdX0CnFerDXl+M
         WR7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793037725; x=1793642525; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tE7RP4VYsHqrXApguz8sNdRczbXmH+5NrdAtgpflwuU=;
        b=GSt8eQMmyonsmu51tnuB3OOoCLAG5Ub3saP+6hzbZxjvXs2HavzZWqdru6q9odLc4x
         8LZgJ89V0wIRfGdc7DhIluw7u2J5YCb9BrvVTFuHpuCVo+Dh63PI4bO6EdT/unM+OkvQ
         fdm85tXjnIrCIlStBx5JtUdJV2+GE7Ymx6AobqUFzfBG6IkIaCVYdsqs0rpUNtzdqMGo
         G5pbGkRiBT08huUAERs6p1O+qMMPoGSQ/EQfuk1JgUcg9wyGzK1sxkCBpYJ6wjVEHIBN
         f0qJBda99t9zffio2My9RsJ+qhwXwPAlb011+xum5s8GmE9XRsgQo3ncrBNVFI/jihAe
         PcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793037725; x=1793642525;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tE7RP4VYsHqrXApguz8sNdRczbXmH+5NrdAtgpflwuU=;
        b=b5uS73XOfyk7qkSmrviQ28J6dLIiJSQeNqM7+ONx39hiT4s3UMRnT9yVuH1reyggOm
         JnbyhVdblaB3IS0dVx7eLMdQItLt6htmyvO8eXgH0gY/R5SxNqpIkaoVQP5a0QdR4Gxn
         3HLDei2EpFMzjHWiRxkUVJ3BY3xg0sTTOUI7ILwZuSK2FBn3Cbp6tQXWawLAgpifQf/3
         7WAmEzJ6S/famMaoxAYhUXNh8krTSXovRGwZ5cfCBvv1YtUjOWaNdlMyjOzSJNfp+ixU
         JdG8bHomr6yfJ/+iqWGEhz6qyypuv6FBW4vjsIGXqmFdRp7GrRBdfYjxKVMcuWe8a90B
         J8Nw==
X-Forwarded-Encrypted: i=1; AKwUvBxc73bGAdei8ExD+sI2vgFNZrIO88iGuMQ3EhY831lVAv6nLCnhzXBfbeMa6YkjT4fpQ8Mqquea@vger.kernel.org
X-Gm-Message-State: AFq9FYIaLS2hbMHTsDZT1VlM2PWT/1Bf6gg0reiusJdXPg/vpYWf2pZH
	I2cD94dBAhreAFuzjiBY9dpQVMGmX2QH4fISmef+jSIbMfLzAKv3rFfSKBZ4h2EmuomyNkHlX14
	2aM7swhMXyylPD1Pj4QJlI6k2DBV5DAgKXcbVxycV4Edzh8FMLyiKp6hc
X-Gm-Gg: AYBFou0u+t/RTI7pRqhKTXEEeSLwvXJR+cs1hS3e7S4c0jG+4hkcvrlI+vGh/3+DcPJ
	WqAAYCP/6MSl85hxHhsnKAf1ju/wo0v52uij33nl+tIuNhi+LHELrR9F0S0nSL12yJpHGZcYBxV
	SFfu2dpneZunJfwnlLyi422KeZEePd5IXoaImBBjE49DXo9e2SZt+RLmJ0V+uBGJix3aqfhXdZe
	yfnGlZMMNN93cPzTua3AArffhdnt0cDDjERICnhTWa+442pV6rXJtumPBPAJo60Mf9rOjgm+rvf
	6TV7x2gB/EsSX46Dgvrohv6RPoneKaYTzsOXYivch5MgImwermE3mL+6lHQaun52QZxwTWkb5Ou
	hzkg4gAE6v4ZwUuv8DoNJrmURU1sS6CBT2ZREnEI6A/goX1HcDLL5ZIdWgDjeXLMdX8KUlGvjIB
	WXpUvT45aG0RLpKSfaZxwQlw==
X-Received: by 2002:a05:600c:2295:b0:4a2:bd1:a80a with SMTP id
 5b1f17b1804b1-4a7d73b0af0mr46865e9.2.1793037724801; Mon, 26 Oct 2026 11:02:04
 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023222313.3979455-1-tjmercier@google.com> <at9U2HvyUP-iYOCt@tiehlicka>
In-Reply-To: <at9U2HvyUP-iYOCt@tiehlicka>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 26 Oct 2026 11:01:51 -0700
X-Gm-Features: AclHuK-fek2ms36qxSTQ8kH_qS9sI-bAShEDJFdyR3pRLqFaZUwSwPiYlTTU9KA
Message-ID: <CABdmKX1mLKEJNiecW+meJ=LB_Kb8-ieeWdZDd4T6rNR9gKuq_A@mail.gmail.com>
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 6:25=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Fri 23-10-26 15:23:13, T.J. Mercier wrote:
> [...]
> > ---
> >  mm/memcontrol.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a05d9a8baa1b..84f4a8fd4d16 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *w=
ork)
> >       struct mem_cgroup *memcg;
> >
> >       memcg =3D container_of(work, struct mem_cgroup, high_work);
> > +     if (!css_tryget_online(&memcg->css))
> > +             return;
> >       reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> > +     css_put(&memcg->css);
> >  }
>
> OK.
>
> >  static void high_irq_work_func(struct irq_work *work)
> > @@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_=
subsys_state *css)
> >
> >       page_counter_set_min(&memcg->memory, 0);
> >       page_counter_set_low(&memcg->memory, 0);
> > +     page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> > +     page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
> >
> >       zswap_memcg_offline_cleanup(memcg);
>
> Should we simply disable_work_sync when the memcg is going to be
> released instead (mem_cgroup_css_released)? That should both prevent
> the run reclaim_high during the memcg shut down and and also avoid
> plaing with limits to work around.

Hi Michal,

Unfortunately that won't work for shrink_many() ->
!mem_cgroup_tryget() -> lru_gen_release_memcg() which can occur before
mem_cgroup_css_released() runs. (mem_cgroup_css_released() happens
through the cgroup_release_wq.)

The high limit reset is also needed for targeting live ancestors above
the offlined child in try_charge_memcg(). Without the resets,
high_work is never attempted on them since it gets dropped when
attempted on the offlined child due to the first hunk, and
try_charge_memcg() breaks out of the loop.

Shakeel's remote charging patch
(https://lore.kernel.org/all/20261010210957.1350874-4-shakeel.butt@linux.de=
v/)
sends remote charges through high_work too, so without the resets
those would lose ancestor reclaim the same way. Before that patch not
performing the resets means reclaim_high() runs unnecesarily against
current's memcg (not the remote memcg above memory.high).
