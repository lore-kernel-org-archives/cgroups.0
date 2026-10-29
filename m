Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307781;
	b=2lHQPubWerhkVw15y87Ypd8iQTAVEEfc0KtiN2+wj97ng7qWxy3BQUNTpV7HiDyZioI6
	 o11Mj4swypvskHj+us/x9nO8Jwa5Upc/dh2mI6z/h4HioupSSHjlOBVpx+2yvS5soLHbI
	 YUprCmylsC/UupsprWyboOH819mr8+uXyHNzf9O6gTRbyWVwiVAvvszJNBCtTfIY7iH2W
	 vZz6icJD6MaAl+ZF6/AaPpYh54DRh0lqXEl9buINu0mkz56XW0c/0GvgW/21wZAs3b7JT
	 zYI5YcezoyMYHlvUlrclJjUT3YxQ7u0OvDBdFh9avGFaITc56c93ahL9g/Bi/e0trkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307781;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=pFdMJCwen6N9JrBbr+moXA8rlsyaQPsNKoYeVLEHUfA=;
	b=wScWnsiRSgkIYf64Tid8I+l+cznJLIfaBmuAq2Ew1Y6b/GgXYUf0y9o7+VinyPLVDcFa
	 YT0hOzTmz9M3k/plzDaj++zUl+tOrT56xh1La7omCr3UkJAheSuXZOryasCPV6qQgXRek
	 2ATKu6xcL990T5QF8Zj3S463GNdGUuMas8LAEQV9EjfoDoLwlH/oWeI2kO+/ow4pZ6PHL
	 lVBrcI7bOy7vmU0ddrdMc32PzckPy3+FRc7z9OkIpVs/r22yDN114puOClZeMf+Dyzk/Q
	 KmFCwkh0QwUFeYeQiLbPBXVnSw49pzsc8pH9Qgii/KrwVYmz6hLHx0zSQB6cMmkvhSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cUxhcSPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AFA606B7FF
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 21:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cUxhcSPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6511F01462
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 21:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793307781;
	bh=pFdMJCwen6N9JrBbr+moXA8rlsyaQPsNKoYeVLEHUfA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cUxhcSPi/tITdJen6fvOKkVtsXBb2MCcrCpPnkgTOWvdakP0TbT0tYFgdo2A0VH9v
	 Hhev/qm82oNN/H428O0soZv6TAmZb5OkNu0eTQXCKwgciEzMkLgaeFq2H1hyC9HOEh
	 zjXUmVuo1pAa6yVNj0RkvexznWCRRO0SiIvY6Ss2TYPlutNrh96KrtdOzQ2o2PjiGU
	 kWQ8BmBGS80kgIVrug2jckdtW6b1a3J1pwBoVZKEmZPgY0yU9zbR/XyzRYFthrnA6l
	 DAFHNiyHUJgM0MAvCAqnQ8p4U5hLyvOV0QXmsGvGy1Z2sYlop4zOl0rcwzYd1Nlx0J
	 oXfMA5s5v6bKw==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91c19fc50abso760946d6.1
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 14:03:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzXkxEGh1zhdlBMyLRpoZOxPuuCzI2WzHWC1A/FnbmvgBYtjK6NAuPUJFP2Z9i95CZbD9/RVIZ4@vger.kernel.org
X-Gm-Message-State: AFq9FYLoWhKue1ddQt+fLaNPWRPxSUmg/5gluAV7UpQLupwaEWHOnnfM
	MOjiepctqstnAQqEiJ3H4ajVjgnYOUAuXvgeqajYmwcn6LMXTbEGvYUUyHk2zi1MPQL/hX6CjWI
	Pxqj92UNs/glZuqQf9znLBtr+d2kwwww=
X-Received: by 2002:a05:620a:439f:b0:939:b099:d52f with SMTP id
 af79cd13be357-9442171b930mr72138385a.20.1793307780343; Thu, 29 Oct 2026
 14:03:00 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com> <auHMXBwnwuRwHLmo@KASONG-MC4>
 <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com> <CABdmKX1PvZjnJkqD48_Pb64Je_oZVO3F-oaxMsBYzHmY-GjbDQ@mail.gmail.com>
In-Reply-To: <CABdmKX1PvZjnJkqD48_Pb64Je_oZVO3F-oaxMsBYzHmY-GjbDQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 30 Oct 2026 05:02:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xggGnAhguPkCJ5k08v3QYKUv07_MhF-acXdBczMAEpdA@mail.gmail.com>
X-Gm-Features: AclHuK9dc7QMnH9xT-OkQ4nOME9fLgwIUxGnHM4PmofBeJVL-x30ExOe2tYWoAE
Message-ID: <CAGsJ_4xggGnAhguPkCJ5k08v3QYKUv07_MhF-acXdBczMAEpdA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old generation
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Kairui Song <ryncsn@gmail.com>, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 5:22=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
[...]
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 636152d8c94d..45a2c1021f4f 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapp=
ed_walk *pvmw, unsigned int nr)
> > > >  enum {
> > > >       MEMCG_LRU_NOP,
> > > >       MEMCG_LRU_TAIL,
> > > > -     MEMCG_LRU_OLD,
> > > >       MEMCG_LRU_YOUNG,
> > > >  };
> > >
> > > I think there could be other usage of this LRU_OLD macro, but indeed
> > > offline is the only user currently, removing it is cleaner.
> >
> > I'm imagining an Android use case where, after LMKD or similar
> > userspace killers implemented by various OEMs kill an application,
> > we may want to prioritize reclaiming its memory by making it more
> > likely to be scanned and reclaimed, while the killed application's
> > memcg still exists - not offlined.
>
> I think it's an idea worth investigating. I had a similar idea which
> is proactive instead of depending on reclaim hints. The code is behind
> a currently inactive flag - it runs memory.reclaim on an application
> cgroup before offlining it (so no zombie or reparenting), but I
> haven't had time to properly test it yet.
> https://cs.android.com/android/platform/superproject/+/android-latest-rel=
ease:system/core/libprocessgroup/include_platform/processgroup/processgroup=
_platform.h;drc=3D2ed7b05ab42dd67391ad2819b0ee399d89128ead;l=3D33-34

Thanks! I know Minchan Kim has explored something
similar: releasing exclusive file memory when processes exit:
https://lore.kernel.org/linux-mm/20260421230239.172582-1-minchan@kernel.org=
/

The idea probably wasn't well received because Android
workloads are quite different from typical server and desktop
workloads.

The fundamental assumption is that a killed app is unlikely
to be restarted shortly, so its memory is expected to lose
recency. In practice, this is usually true.

There are some exceptions, though. Some badly behaved apps
have monitors that keep restarting them whenever they are
killed. We might regress these cases by reclaiming their
memory, only for them to restart immediately and have to
read the data back from storage.

That said, this may not be common among apps on Google
Play.

>
> > Similarly, a foreground application might benefit from a lower
> > chance of being scanned and reclaimed. This suggests that Android
> > background-to-foreground transitions, or LMKD itself, could
> > potentially leverage the reordering of memcg LRUs.
>
> We are planning to use memory.low/min for foreground protection.

Thanks! I guess the challenge is figuring out what value
works best for different apps. Should we collect data in the
lab, learn the appropriate value dynamically on the device,
or simply hardcode a relatively large value?

Any thoughts on this?

Best,
Barry
