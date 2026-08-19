Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37C13AEF4A
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787152685; cv=pass; b=XRXIjEyUJGXMdB+29z7Zg8WEDZhPml++UwkvVkEM6PbXrKwUH7FCKDVBPhJxGNaGukM+2vZeFAX/lgp4iKvb9q0leEa8FJpcOeiatUH8JuruJyLn1o0LMGmDKr6lf7o+QzG0F+S5OIIw2vJG9cpxPW0ZmlEvEps8/qpZr6uMdG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787152685; c=relaxed/simple;
	bh=NU6wj9ISozWZRp7egmiutUSvHkVcvPJYoAsvt9E0p9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ucEk7fqoi99jewnLrPoANXihH/qTU8E6RgFVT70OA8/pybfCNTLFvoo7XrpsT2IotXUzzOGeVMySlfmeAV0CQXor1Yzsr5s9Kxdt+2gqwFrAAd4Y4TFA/qOGJoRe8SyZ8ixsSkCmbCypryp3X+JEKEeX1BsthP6+rU8l8c3pGL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lON5DuV4; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lON5DuV4"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-495509b08ebso52145e9.1
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 08:18:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787152681; cv=none;
        d=google.com; s=arc-20260327;
        b=P0zkc4+6Zw+mWHbcVq2AfD8SxsIbUzEVivhfLeCLC3cyZLadkylmzmX78vuV5MQWTA
         oGCqSoG8d1Lz4kKpWvwH3+4XFlR45xC6WmgymaAbcT9ZjLSDyscoPMiF34V/4tv/01zc
         aBH2R5aFyQ63TXYVsclj7v9Jkn/JjApZYOqA1dJn5gjqtjQcboxVxOX2kT5zUV5fz98L
         rntjM85Z3RbVy/74F9Rz+HxkU1iUaFA9JUHKn/ZJEa9E2tlvTNGsGQXpVOLWq+OT9GQy
         b1OqTaTon+0OdZyVIocIOtPuNUTZjq0htBeBA6XIDRWmctydEPcwbzp3FpU+7F7HmWCY
         aDOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dA7U2ubhCpnou09rJaye2RELeJzotdjrKQldD8EV4vw=;
        fh=0tf+c+5ywPVK+0/y9JMMyrhU49G/Ib+VPk751c/ao+g=;
        b=b9LOZYPX97TsTKGmPQwp0eIFXshsKzNEIgbx3twm/CD06VUxnJiZ98HaF8B4ytPVuS
         QFpVcwRD1Oy+azQ8SpOsJ/emH/R2pvBNIJyF+HHO1BQD3IZef8yCHpDDjvDxexQivy2D
         dMRE7GY6Ed8JTsYLtcbxSsxtPnrRrVZ4H+sGO+q7sZ5TZipMrL1TJZghaiO5C82VW904
         dLD1amRZrUpzvdFu7Nk6XDzdfT+/wjpLD33bNnFYUtF/kfoHpCMpEP8BhNzOYfQ//RB8
         MwcVmDvd4dDOQKbaSWIXGX0QEANswJAWyTzNq0X4u2Ci2d7zvdytE2Q5Wv13oRrRg/vw
         ToUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787152681; x=1787757481; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dA7U2ubhCpnou09rJaye2RELeJzotdjrKQldD8EV4vw=;
        b=lON5DuV47dj72tVQ2UDXx7eyCueIB7/AhVrNkHPWq+pkxiqc1uoiKnbod581E0Zfi2
         QfQhP7eOftCmT0t4kdJ8f13fgFIzcCU/AMylnbuUuUJ14qB8YojqbfpWxfPl2VEUu4X8
         F6z3sFjeCTD8GWosToBy49DQwv+O4u3dlnzmvmtlrvf+H1RW4jM7DfPZSYmePoAHHZRI
         lghcciiBJIpxUIAXrR/6/QIuUo8nZjhAUSbG8IDIXWyggzasSHJTHS/aupLNmw0va+fN
         kfy06PsTOzV4Yb90spnsXnM2tc7V3N0gWSRrfQWEj9DRAWkrPr3t1OrxfT8rZ1RpCqy5
         qBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787152681; x=1787757481;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dA7U2ubhCpnou09rJaye2RELeJzotdjrKQldD8EV4vw=;
        b=S0gZKg5354p7G4XRuwExUv8OOMqzqMjhcoobMqhsHfKp6bEPZsaIZG3Ki0IpZlECHt
         /54tUN2c87hf4ZCQDg9SURIF5qRcWeQHNrUSeQQD+tJCMPamPawMskc5/TccCuVsUGfW
         CG48lA3i/+grBe8mC6cqt3cFll2jcDPUuesZhFXUmVwVg5P1vwu9TqGT/RoRUS4s7ZMm
         r2qCRgBOhz/Pl0iS69nhSL4svbge8jVnlyGzYAHponLBHZbjbxADFz4KWSyF0PHGlTfD
         JZLZRfaF0nXCg1tYaZ0IGFuIsUyqPULPJZud+ArBFItdVukBdCD0YO6br+QbHzM4rFSq
         QBQw==
X-Forwarded-Encrypted: i=1; AHgh+RrR22KsUWQMckA9ywa4bvx3jUC94XxkdgxgHWty63U8KFrEx83XPOFu2TFrjDDJ3PiDi1v/d4TK@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp5iyj7ff+AU2xXinGNb4G1Azit7agnHof24TF6UVHJNOs/qUP
	d8v2A0twzyuQdScRFgQxi/3atGsTkigF+nmavOvg0LicMJ0xwrQXfSLyv5Vg8dackT+9u8erHy+
	KNjEuFRZC5RLpcPLfB4SazdcTamZQ+dwbrXWkZTdT
X-Gm-Gg: AR+sD11Mb1knbVoy74durGHxjt2RklmKdC8HekvOhhain8Y3KJX9xiwLEX8x3jTH/h/
	FuOMbW6qrE0Pf77bB1iOv9HtBFNsNaF40nrAbyL/HSr+gyLdnYvEiV09ugn3znUmwZHwohk49oJ
	ctMnxEzXWQW0J34HklitISDY5vqaCi/spc2I7OUkDAQGxmNvmKGHR77PLTO9ejPzJR1Rc4F1Qyq
	Tw/1+Ykfd6SE4CSPxq0Ev75Z6el5Gls+WtpDwgxbgmTUExtadtt6qHANcITpRnL7r7ISCRzxjwW
	W0Tzmo1e0YxJ6QPbGWwxHxvHNZLfYaiFwl5U6L7bp40/g2jSilW06nAHGzE/s31AkFBhFI8Kjag
	=
X-Received: by 2002:a05:600c:4d0e:b0:495:5515:3c00 with SMTP id
 5b1f17b1804b1-499abd0b9damr816445e9.9.1787152680616; Wed, 19 Aug 2026
 08:18:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-7-shakeel.butt@linux.dev> <an1_z6V5l7CNaCSb@tiehlicka>
In-Reply-To: <an1_z6V5l7CNaCSb@tiehlicka>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 19 Aug 2026 08:17:48 -0700
X-Gm-Features: AcwNN1Ulg1tGco4bBKbK_ME6II0uAPH6pfpMeFoRn8Pigcnf9zHc2CjVhJLZ3VQ
Message-ID: <CABdmKX2EXGEX3wNnsKa15hzZ1-VXWVHDJOwhWbD+co31iZoHZg@mail.gmail.com>
Subject: Re: [PATCH 6/9] memcg: remove lru_gen_soft_reclaim()
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 1:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Tue 11-08-26 13:32:00, Shakeel Butt wrote:
> > The soft limit rbtree was the only caller. Dropping it leaves
> > MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg wit=
h
> > that op, so remove the op too and update the memcg LRU comment.
> >
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>
> I am not deeply familiar with MGLRU to give my ack but from a quick look
> this looks right.

This looks good to me.

Reviewed-by: T.J. Mercier <tjmercier@google.com>

>
> > ---
> >  include/linux/mmzone.h | 30 +++++++++++-------------------
> >  mm/vmscan.c            | 16 ++--------------
> >  2 files changed, 13 insertions(+), 33 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 94f9c3ff5416..01fabd0ece0d 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -635,35 +635,32 @@ struct lru_gen_mm_walk {
> >   * For each node, memcgs are divided into two generations: the old and=
 the
> >   * young. For each generation, memcgs are randomly sharded into multip=
le bins
> >   * to improve scalability. For each bin, the hlist_nulls is virtually =
divided
> > - * into three segments: the head, the tail and the default.
> > + * into two segments: the tail and the default.
> >   *
> >   * An onlining memcg is added to the tail of a random bin in the old g=
eneration.
> >   * The eviction starts at the head of a random bin in the old generati=
on. The
> >   * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GEN=
S) indexes
> >   * the old generation, is incremented when all its bins become empty.
> >   *
> > - * There are four operations:
> > - * 1. MEMCG_LRU_HEAD, which moves a memcg to the head of a random bin =
in its
> > - *    current generation (old or young) and updates its "seg" to "head=
";
> > - * 2. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin =
in its
> > + * There are three operations:
> > + * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin =
in its
> >   *    current generation (old or young) and updates its "seg" to "tail=
";
> > - * 3. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin i=
n the old
> > + * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin i=
n the old
> >   *    generation, updates its "gen" to "old" and resets its "seg" to "=
default";
> > - * 4. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin=
 in the
> > + * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin=
 in the
> >   *    young generation, updates its "gen" to "young" and resets its "s=
eg" to
> >   *    "default".
> >   *
> >   * The events that trigger the above operations are:
> > - * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
> > - * 2. The first attempt to reclaim a memcg below low, which triggers
> > + * 1. The first attempt to reclaim a memcg below low, which triggers
> >   *    MEMCG_LRU_TAIL;
> > - * 3. The first attempt to reclaim a memcg offlined or below reclaimab=
le size
> > + * 2. The first attempt to reclaim a memcg offlined or below reclaimab=
le size
> >   *    threshold, which triggers MEMCG_LRU_TAIL;
> > - * 4. The second attempt to reclaim a memcg offlined or below reclaima=
ble size
> > + * 3. The second attempt to reclaim a memcg offlined or below reclaima=
ble size
> >   *    threshold, which triggers MEMCG_LRU_YOUNG;
> > - * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LR=
U_YOUNG;
> > - * 6. Finishing the aging on the eviction path, which triggers MEMCG_L=
RU_YOUNG;
> > - * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> > + * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LR=
U_YOUNG;
> > + * 5. Finishing the aging on the eviction path, which triggers MEMCG_L=
RU_YOUNG;
> > + * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> >   *
> >   * Notes:
> >   * 1. Memcg LRU only applies to global reclaim, and the round-robin in=
crementing
> > @@ -696,7 +693,6 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg);
> >  void lru_gen_online_memcg(struct mem_cgroup *memcg);
> >  void lru_gen_offline_memcg(struct mem_cgroup *memcg);
> >  void lru_gen_release_memcg(struct mem_cgroup *memcg);
> > -void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
> >  void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
> >  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
> >  void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgrou=
p *parent, int nid);
> > @@ -737,10 +733,6 @@ static inline void lru_gen_release_memcg(struct me=
m_cgroup *memcg)
> >  {
> >  }
> >
> > -static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int =
nid)
> > -{
> > -}
> > -
> >  static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid=
)
> >  {
> >  }
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 790b50c78a2e..71244cf33d59 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4373,7 +4373,6 @@ bool lru_gen_look_around(struct page_vma_mapped_w=
alk *pvmw, unsigned int nr)
> >  /* see the comment on MEMCG_NR_GENS */
> >  enum {
> >       MEMCG_LRU_NOP,
> > -     MEMCG_LRU_HEAD,
> >       MEMCG_LRU_TAIL,
> >       MEMCG_LRU_OLD,
> >       MEMCG_LRU_YOUNG,
> > @@ -4395,9 +4394,7 @@ static void lru_gen_rotate_memcg(struct lruvec *l=
ruvec, int op)
> >       new =3D old =3D lruvec->lrugen.gen;
> >
> >       /* see the comment on MEMCG_NR_GENS */
> > -     if (op =3D=3D MEMCG_LRU_HEAD)
> > -             seg =3D MEMCG_LRU_HEAD;
> > -     else if (op =3D=3D MEMCG_LRU_TAIL)
> > +     if (op =3D=3D MEMCG_LRU_TAIL)
> >               seg =3D MEMCG_LRU_TAIL;
> >       else if (op =3D=3D MEMCG_LRU_OLD)
> >               new =3D get_memcg_gen(pgdat->memcg_lru.seq);
> > @@ -4411,7 +4408,7 @@ static void lru_gen_rotate_memcg(struct lruvec *l=
ruvec, int op)
> >
> >       hlist_nulls_del_rcu(&lruvec->lrugen.list);
> >
> > -     if (op =3D=3D MEMCG_LRU_HEAD || op =3D=3D MEMCG_LRU_OLD)
> > +     if (op =3D=3D MEMCG_LRU_OLD)
> >               hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->me=
mcg_lru.fifo[new][bin]);
> >       else
> >               hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->me=
mcg_lru.fifo[new][bin]);
> > @@ -4489,15 +4486,6 @@ void lru_gen_release_memcg(struct mem_cgroup *me=
mcg)
> >       }
> >  }
> >
> > -void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
> > -{
> > -     struct lruvec *lruvec =3D get_lruvec(memcg, nid);
> > -
> > -     /* see the comment on MEMCG_NR_GENS */
> > -     if (READ_ONCE(lruvec->lrugen.seg) !=3D MEMCG_LRU_HEAD)
> > -             lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
> > -}
> > -
> >  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
> >  {
> >       struct lruvec *lruvec =3D get_lruvec(memcg, nid);
> > --
> > 2.53.0-Meta
>
> --
> Michal Hocko
> SUSE Labs
>
