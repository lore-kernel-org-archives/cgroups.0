Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793218258;
	b=puMHcRf2YOrYiXP6gxM2PlZmszCYlD0boABjtVZfuB066WODmV6uPdBQQLLFUjJdMZzk
	 bd+IrGzrB5fykuKbskV5nd0D7BnTSM+D9QTuDomR96PgArA6GU0Xe9HNNWOfeUmFC+TAZ
	 Sa/QaoYaSSlFLWBkBdbNrsWwWmpVf1SrgdjhoK/yUfBc4FoR+QH44+SPUy+bGR678vvlm
	 U+PE+HbRa6sZYh+SZte2i/whTHgj6rjhS4EUYGUj0l3tdcXC3xX6jlHKynRNyrj6VXwah
	 W/9oSMsUIAZwPQNszqvtEJI6y5TQqV3ancXauRuZo2WY7sUuB9eiQcNzaACxtyc9zIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218258;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=M/+CeRbT0qyE1g9JY9xgqgOlku9IIi6fz6AQMBy+up4=;
	b=BQZQ4NOR1eQk4jPA8QCFRxt51ifdEXE+zRBqTrVyxbjnysGZtx6KRTVScjEOVhxQ5FoZ
	 IQ+IWFO4t9oBi3aLrUspNrHlsaRu407iNs3Ca+FpPW7WKdGQHSSMo1y75lBwGjGoEHpSd
	 q9IGeBd19xq0vc8BRMWB3JCH+vKfvEiANJ4e38atzNS2q50R9Lox9eFVBa71UBQcEhDKg
	 O6LnC0Rxv2DbWebZgkUQGmUpsd67ebhhAqoTtk246HEilKVWpiEQuvZjJ8gj+0BT4Xx3X
	 7R/Kb7OY6RtXDgIPQYPly8mIBAKBiNBSpyPyX6Es2huiVFWv2mDElkUCEcpYR0OIsFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iUtWN+5u;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E098606A31F
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 20:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E098606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iUtWN+5u
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a018493d57so18185e9.0
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 13:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793218256; cv=none;
        d=google.com; s=arc-20260327;
        b=LWJy5ZCoNw38bHqi3pXhPno3Ayf0muhp0aeDPnnzevXML5qi6WlXgzxuAxNmQt4agO
         rJaUcsIqWZjg1CRG4SPSy7uY6SAvC0uzTkgqGc/0l6ZIxokcfkEqNae8MblnNrnmG8+x
         nUfgoR4wZqq8YzvxZ5KXb9ovfvZ3eeJxzVxfR0nAygopdb2ga521ag3aoPjqSxRESbQt
         zzXNr0JB7kw1RUGQ77Zs8i8qOcQHfLYI5aWIwXD/ooDv6MpIhcSKJSRAmh+EFxNc02x2
         95yFG8zRPiNhrK0+cE2vuKCyBrxsf8YcU6Arh77P9CxjZBbkyoxrBxy23fFEJX2gRI2y
         +Ltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M/+CeRbT0qyE1g9JY9xgqgOlku9IIi6fz6AQMBy+up4=;
        fh=ecZFFeOuE9DsRfx4x1SV4nBU+IJHEQHELUOqtRo8vgU=;
        b=G9JXsyQKd9bFszli1d7dlqdoDAJIxrSiovKnCmrE4GTgFPo5e8nJP4Fp4AESmaTGEL
         NmDgaEBAuUj7Jp6XkYQ2Cjy/OqzxvQ66/7zG28CQJe/oUhEH5AdkdF5/o1YN9kst/Yny
         b9LOYiVdLC4zIOXmX9/QBfYnXzovmFQcQZddTIxhO8qUYtJ3kXKu+trr9saD5zbnqkxL
         v/H67PybMsUnp6F7erGpSrPX5OTT58fItlWP1MN6n9Arzgf13+buYDUfsDM8Vd/qY7KW
         +ZAF5zAosD70sotl17LFA8J6JE4KrINtOWtTvSQMSp0Hta5FVvHOeptdtgiahSTnMYN4
         5fmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793218256; x=1793823056; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M/+CeRbT0qyE1g9JY9xgqgOlku9IIi6fz6AQMBy+up4=;
        b=iUtWN+5unboIwqYEr9cdb4sDKfIVfgStIrNneH5+7RcbV2nFzcbR/5qmaI0luhQkmu
         vVPz9r9cggfumX+IeX+1jTISpsBL+cikK4l9reQ98luAVFwIh5gms4P/mLc8wkVK0/fZ
         z7tPhUttiQsErI6FTBzeaOCD2DIztf346+6v5SkwdestX2hJQAwdarxlZy2wjNApZCjn
         wODGeucQ8K9a6oxSAyIElCwvCBrsM4h1pKlZn29+UXG6qxx529SgQ+k9qLNWIh7ThR88
         Ng/T1UdgIgqJaHPGArcSO18wrs5nZDA6dH2OKSz/91mlmwQcE8vv6oJwetzcypEjEm5o
         Ekxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793218256; x=1793823056;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M/+CeRbT0qyE1g9JY9xgqgOlku9IIi6fz6AQMBy+up4=;
        b=oHeseFfVieZ6Up1t8YqBRKeANwxCHYJXI2+t15oCC+872f3YaUwsrYlLaMZ4WDzEvo
         Z7x1gvp3NgCYpIi13sW+PzoTuvRDG1WPyyhF7d3rdqka8YNWy1wQPsAUO5INR/WISX2D
         IFJE7GECwdeBidYP5Cyx9JhXVetG2VAZo16inlzi/nlNzhRyT89rEBScUdSzAFCe/ugJ
         6SI6ouC/Zd34UkYoxbnanlFo9vqx8z1bmgAM44u896i+9CmWaULycHnOy/ycGD8HvXu+
         z77sUYLOvAoP7kquTlEIwtz8FV3G1g5V2i7emCwQIcEi3iOEF9ziJcpapODD/xhQpSST
         8Y1A==
X-Forwarded-Encrypted: i=1; AKwUvByMOaBkb6H+177Ko+ZgX0lOi2KjKdieVvys1rvUEDqQF1dJGxY6LZZ9xBJacMr6tSrzlVfFw2d/@vger.kernel.org
X-Gm-Message-State: AFq9FYLapAAu/Y34fE8muOi9uVtnW5HnSVDJs95M1qAyzCAhqgTxAiMb
	Cyv7r0jJ3SIoVmSTCXDYMH7UqzdQiB0YVCi4nAcBAad1hXrQVPyUEp0skBXYh69Zn+Irgw4/Uap
	YBlLT079AHxi4+y7Wu3aR6rxT7WJJdAETMVk7TDvR
X-Gm-Gg: AYBFou0wYQmpm2ZeweR2JeGRejZdnjZ1MZ+J+QqXOUtA+8chYQNlHqDFdiBHRYsUkuM
	gPpx6kGu8BYCHwz8yMaKZ5GRzamz8xi8L4+O2vpJSg/LDnB5FuSIgImh8GALR51soASSl8jdpku
	oOS6XvjJJqhSpWrKITYtCD+FgTBaKAHReW0yLaC80f6Omv01VA0HLEz0GDgjWCNWbqGcy4VP0St
	EQjU0qXV+ahPMLrAXyw0V9f+6jqr+iaCHlXsMe/n1PpypdsCAQsc95xsxDV1zHGYFL/RFbO5Ie5
	kQXWiKuRhef0igcCrUktZm+YnlRHtGNLvxsOCWU3AqO0zjASjrVXmFonCTkgEgqK8VqERWYNWMm
	uIV3i1PgvgyyciafDuOgYVAc51vAELidfWEPG80LEYcrSd5fx0VxMQ4xbMsyCFhaGDTCkQCMyNS
	OdvhH5AN90nDCgm1JJ4yeZiOc=
X-Received: by 2002:a05:600c:6048:b0:4a1:e7fc:fed3 with SMTP id
 5b1f17b1804b1-4aa97e58aefmr149895e9.13.1793218255229; Wed, 28 Oct 2026
 13:10:55 -0700 (PDT)
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
 <20261028010611.3929937-2-tjmercier@google.com> <auFerm6kHxeuPFpR@parvat>
In-Reply-To: <auFerm6kHxeuPFpR@parvat>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 28 Oct 2026 13:10:43 -0700
X-Gm-Features: AclHuK_GdOj6cBCMgskUWEzvtIHw2HGovxaKUq0R2OOOuhOoVrm0zxPtUkNd7mU
Message-ID: <CABdmKX1PT4oOKdRMGsWDHZRFmRB3VR9zxgnp8W5QXqhTErFOzg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online() checks
To: Balbir Singh <balbirs@nvidia.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 7:32=E2=80=AFPM Balbir Singh <balbirs@nvidia.com> w=
rote:
>
> On Tue, Oct 27, 2026 at 06:06:05PM -0700, T.J. Mercier wrote:
> > Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> > move LRU size accounting on reparenting instead of copying it"),
> > mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> > and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> > memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> > afterwards. A folio that is off the LRU during reparenting looks up its
> > lruvec through its objcg, which now points to the parent so it is put
> > back on the parent's LRU.
> >
> > As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> > when !mem_cgroup_online(memcg) is true, making the offlined memcg speci=
al
> > cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> > code. Remove them.
> >
> > With the get_nr_to_scan() special case removed, an offlined memcg that
> > still has stale effective protection now has
> > apply_proportional_protection() applied like get_scan_count() does, so
> > the MGLRU and traditional LRU behavior is now the same.
> >
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > ---
> >  include/linux/mmzone.h |  8 ++++----
> >  mm/vmscan.c            | 28 +++++-----------------------
> >  2 files changed, 9 insertions(+), 27 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 3b96d6c7123b..7f078ff0dd76 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -638,10 +638,10 @@ struct lru_gen_mm_walk {
> >   * The events that trigger the above operations are:
> >   * 1. The first attempt to reclaim a memcg below low, which triggers
> >   *    MEMCG_LRU_TAIL;
> > - * 2. The first attempt to reclaim a memcg offlined or below reclaimab=
le size
> > - *    threshold, which triggers MEMCG_LRU_TAIL;
> > - * 3. The second attempt to reclaim a memcg offlined or below reclaima=
ble size
> > - *    threshold, which triggers MEMCG_LRU_YOUNG;
> > + * 2. The first attempt to reclaim a memcg below reclaimable size thre=
shold,
> > + *    which triggers MEMCG_LRU_TAIL;
> > + * 3. The second attempt to reclaim a memcg below reclaimable size thr=
eshold,
> > + *    which triggers MEMCG_LRU_YOUNG;
> >   * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LR=
U_YOUNG;
> >   * 5. Finishing the aging on the eviction path, which triggers MEMCG_L=
RU_YOUNG;
> >   * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9959ca158ce8..636152d8c94d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2754,13 +2754,6 @@ static void get_scan_count(struct lruvec *lruvec=
, struct scan_control *sc,
> >               scan =3D apply_proportional_protection(memcg, sc, lruvec_=
size);
> >               scan >>=3D sc->priority;
> >
> > -             /*
> > -              * If the cgroup's already been deleted, make sure to
> > -              * scrape out the remaining cache.
> > -              */
> > -             if (!scan && !mem_cgroup_online(memcg))
> > -                     scan =3D min(lruvec_size, SWAP_CLUSTER_MAX);
> > -
> >               switch (scan_balance) {
> >               case SCAN_EQUAL:
> >                       /* Scan lists relative to size */
> > @@ -2769,14 +2762,8 @@ static void get_scan_count(struct lruvec *lruvec=
, struct scan_control *sc,
> >                       /*
> >                        * Scan types proportional to swappiness and
> >                        * their relative recent reclaim efficiency.
> > -                      * Make sure we don't miss the last page on
> > -                      * the offlined memory cgroups because of a
> > -                      * round-off error.
> >                        */
> > -                     scan =3D mem_cgroup_online(memcg) ?
> > -                            div64_u64(scan * fraction[file], denominat=
or) :
> > -                            DIV64_U64_ROUND_UP(scan * fraction[file],
> > -                                               denominator);
> > +                     scan =3D div64_u64(scan * fraction[file], denomin=
ator);
> >                       break;
> >               case SCAN_FILE:
> >               case SCAN_ANON:
> > @@ -4355,12 +4342,11 @@ static bool lruvec_is_sizable(struct lruvec *lr=
uvec, struct scan_control *sc)
> >  {
> >       unsigned long total;
> >       int swappiness =3D get_swappiness(lruvec, sc);
> > -     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >
> >       total =3D lruvec_evictable_size(lruvec, swappiness);
> >
> >       /* whether the size is big enough to be helpful */
> > -     return mem_cgroup_online(memcg) ? (total >> sc->priority) : total=
;
> > +     return total >> sc->priority;
> >  }
> >
> >  static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_c=
ontrol *sc,
> > @@ -5199,10 +5185,6 @@ static long get_nr_to_scan(struct lruvec *lruvec=
, struct scan_control *sc,
> >
> >       evictable =3D lruvec_evictable_size(lruvec, swappiness);
> >
> > -     /* try to scrape all its memory if this memcg was deleted */
> > -     if (!mem_cgroup_online(memcg))
> > -             return evictable;
> > -
> >       nr_to_scan =3D apply_proportional_protection(memcg, sc, evictable=
);
> >       nr_to_scan >>=3D sc->priority;
> >
> > @@ -5325,13 +5307,13 @@ static int shrink_one(struct lruvec *lruvec, st=
ruct scan_control *sc)
> >
> >       flush_reclaim_state(sc);
> >
> > -     if (need_rotate && mem_cgroup_online(memcg))
> > +     if (need_rotate)
> >               return MEMCG_LRU_YOUNG;
> >
> > -     if (!need_rotate && lruvec_is_sizable(lruvec, sc))
> > +     if (lruvec_is_sizable(lruvec, sc))
> >               return 0;
> >
> > -     /* one retry if offlined or too small */
> > +     /* one retry if too small */
> >       return READ_ONCE(lruvec->lrugen.seg) !=3D MEMCG_LRU_TAIL ?
> >              MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
> >  }
> > --
>
> In some of the places do you want to consider adding a VM_WARN_ON_ONCE
> for memcg_online not being true?
>
> Acked-by: Balbir Singh <balbirs@nvidia.com>

Thanks, does this look ok to you? We could also put it on the read
side in lruvec_lru_size(), but that backtrace will just show the
reclaim stack rather than whoever is trying to mutate the size of an
offline memcg.

@@ -49,6 +49,7 @@ static __always_inline void __update_lru_size(struct
lruvec *lruvec,

        lockdep_assert_held(&lruvec->lru_lock);
        WARN_ON_ONCE(nr_pages !=3D (int)nr_pages);
+       VM_WARN_ON_ONCE(!mem_cgroup_online(lruvec_memcg(lruvec)));

        mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
        __mod_zone_page_state(&pgdat->node_zones[zid],
