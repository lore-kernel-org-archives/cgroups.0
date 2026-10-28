Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793218264;
	b=TUQPfZd4GSLNYYiYNY2Elr8OYDphLjTpkTWfzZVjLThV4PXoFqIb3vU8CUClCgLnBuCz
	 DAPuY5kqVbi5y2I2ywILbcMszD8MuilPqTEzeIHZPHSe5a7ujmRPdxN2ZuNks4enJpqlX
	 E8twSAjTitbM9e+Spp/GnowwvgWGh43iFBLGJo3eEiwfJ8cjHUzYFzsz/6KQbd6Q2pbaf
	 3vcjEN7s6CeYe490IfyidumCDbfUWwcWP1NjtZeLycQPDSSv4uRSuWRQUdvptt0XbMdXd
	 E6ElqkVEEqNo6CUfjn5zVJLNAIxN4NsNES7qpk9PhIQNfWbAwj4c75+nH059yqYO/Rw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218264;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ieVwSKOmF05EqHDhXoM6Ev5vmdo6Ln+FEC5KQGbFME0=;
	b=KIA/YMPl1/SH5j7EnJwEDPu5w4h05IAztbmHIc+O+VVnIxD4sGh7Z64rYT8Vt3UHKIyT
	 Munyo8y3lj93t7JohvMGZocUByufEewd7aBF9knAz+mri5ECw88rFrzwDHTZrRVKQ0S2g
	 fk1B7fK4flsvvtOPW5PYjXJPUz23prZMfou6DI/r6QEpcgc+6jBQE84ZNsfhebsUr68Lq
	 L5JFCq5Cf5t5YHUyuYfGsRr8NqGmCaADUG4yhpb+8oLlB2E6YdJdIyDlUkTk6y4w0VbOF
	 WTjBID0KZFHJ/b98ERQmX/Kl30SmGRzrJmI+nkutXZGPxccujh/fUmY+aMeoCBnDuaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fDIrzBye;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4A6606A334
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 20:11:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B4A6606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fDIrzBye
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a018493d57so18335e9.0
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 13:11:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793218262; cv=none;
        d=google.com; s=arc-20260327;
        b=onML5iGI2biL/NcZt2EynKaSWYI+2T6zUBeNAHnc0ApWdf/4MeMfMi4hxpiTG9w6lz
         f3zqVcDh1NZFTGJhnw8z11oIWZJiGfh5RAex5a04KSVvufr3/Oc34mlARH/TNWz37C/e
         OOKt0Oq18kYIjyb2w8jAprxPXhmvDoOmth7aWMLktgC1D4ZXF9ux25F1PxsmcSbi1TvN
         G0615029CJdoR29v3huAddIoaW/uVuvi3ZodQTKeKwdV58iVX0pry/azwMbJCW/Ei/ke
         GQCSDspjw2z/idsJ9u1/5/hZFkCAk4Grrx/q8XMacNzX84mRlXm9Pre1UaLGySeLpszz
         dkmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ieVwSKOmF05EqHDhXoM6Ev5vmdo6Ln+FEC5KQGbFME0=;
        fh=DMAnWtuCQz2owwVjcvXwadRyFk8xI3Q6LjTqVzsp7eY=;
        b=Z797ln3FcUj8zrHMa8zEvPqHjpNtc/qLSByIfPnl1WgC6wpSGMTaAqOYq68PRnGH9c
         QeBvw3gytMiawvK86ol4OIDDNGJGv5oxw1hIjk+VagRWCifaOe8X+bA0Bi3cVOoKl8eD
         2dTs+DthFZO/K316h3WMct6ygsl/KCbsVQcYyuMz1JVdOtpAfI9HkVrEbXOPzRdlVtU4
         x84lV2l5Dqi8wjZK48xBvFC9LTlHO0vt4EGBOtb6C9E1X9Nkrchy0aMyLvDwLvHCdj/q
         Q4qejQk6hzLpaK/85IvW1ofLWBDY7wPVAGkuS3oMHv30EAq3BN/zDwdG7s9iqmQYimbN
         K2wg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793218262; x=1793823062; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ieVwSKOmF05EqHDhXoM6Ev5vmdo6Ln+FEC5KQGbFME0=;
        b=fDIrzByeu5uJ91oTcxVQQoPpdjVfkc9ERgGteMiZPOeYYmXn2ISzvGVlAZlnhkMN7t
         uZRy1XEszlfgxAT91QuEpidct9ZCgaVU1VDeuiFcgDTvvvg+E4hKyk650JrTH65vXFCI
         qWJc9PpOfrIpIr3id65+AcaVMdsPEYw+6BDZbOXFWYraKKrsOSqqiHjozgSE7clEH5Le
         IN1opDxayZo+81LcguNWUFvP3ya+9+zlbiIcmcnKokUQ9CA11vu5k40/6kUHSTjzOcmC
         ENrDRTRomsTP//AjMoaCTtI+XlV/+mGgvvwqYTI5lUCIbrleQOHrAhd7nOyiUqNwTeNJ
         YnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793218262; x=1793823062;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ieVwSKOmF05EqHDhXoM6Ev5vmdo6Ln+FEC5KQGbFME0=;
        b=mqx8RoNsVzsb6fzbJyIWhLF4ZuoZr1LRpX3kgO7oC0nf+8rHXZ+Hc55EmSvre6hIyT
         h+JVyq3NE2Dw9itT/UvNdUuB0SoN1RWDGWqLVKIgmuooNivJaZ8P7sf2IDo2wj5hzSBP
         il87o9flcaR0JNFsJIP+rQujrGKGmMRE45zWRt8sY9lzpclX48+AA0nQtB/mOUzVC7j/
         oKLEpSqJBoQzHmsv1V1X8dL+3T/vFQvAcUSK369/mdUeAqjWotP0xfaCjdJAt+lvPA6r
         S+x1z5/B7L+6SXVbOvQu3Hb3ih9P7gQMRGXe/C11WGy+qLzHkkzh+OtHJUP9lmScXL+d
         uaSw==
X-Forwarded-Encrypted: i=1; AKwUvByqYBcgB68PKb/ujC4YOL13WMOSBvqouQszenek4kB8MG5ypq9OZSEPoZkz64e8HBin0dN77EHC@vger.kernel.org
X-Gm-Message-State: AFq9FYJyUMK1IAsSfl7bLVlsIzQQaWQyay96gM6Vy32v3pn8Jw+7Z4++
	Z0hvHTu2HL5ACvV7Ra2Jyjo2LsnAkPB3Up6ZBQhNXe/st+AwIxhCpHE8GDchLMdvwBjIYs0cjY5
	X1RBylMpQVcz2mtW5USlCZti/z57t4npzGbqr19oZ
X-Gm-Gg: AYBFou2tcnn+YtfTGZhm1EXvoEOFnbkQ/e9HxQhPwPu3adZgvyEHOwYeL/FrPf2S/US
	+aWEhuKXfniKE2qPIyMBl4475L7badBYP+voVHjFv6RfnhaKqwxmBppGr0L3S9ENNKwZHkFxrON
	uTrqqt9pk8nAficRVHLSA/RFraYKGqKDpyyHcd8vGG6ylDtI8cQfMHsFUGVnmRvjI4BJD2ZwGpz
	5enDydLspl1cg1YltaXjP5j7/qGL/QYAv+hcEn+sLxejTOUTRycZ0hy2n2QGruq8WPDGP8ki4R7
	J658R2cAtnBMwe5QIW6M/KjBtJnif+9tEi7gDsivkVkyvFlbC3Xas2LjLbno7QcL+PiGWLty4wH
	EAP5V6SnmJYsBkZRBuiz+Sf4QvzzHnnX4F1C+U8l877HM5wFn7GZ73b4vi7I2577CatIdCvZHTw
	TaCWaBwUhkVGzBJSIj2UjZeco=
X-Received: by 2002:a05:600c:5903:b0:4a2:a8c:22ae with SMTP id
 5b1f17b1804b1-4aa9617c228mr122895e9.12.1793218262038; Wed, 28 Oct 2026
 13:11:02 -0700 (PDT)
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
 <20261028010611.3929937-2-tjmercier@google.com> <auHLzLazLr4iA_Pn@KASONG-MC4>
In-Reply-To: <auHLzLazLr4iA_Pn@KASONG-MC4>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 28 Oct 2026 13:10:48 -0700
X-Gm-Features: AclHuK8Bs1IRBhRVIWz--v-y6aB5LNo_Pu_T9E7KUcmFBJKynmoafpKWfnr2kyE
Message-ID: <CABdmKX2xEPL3tTWS22rDeVeCKuT9QhW9QAQdXGLSjUJEvSnWiQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online() checks
To: Kairui Song <ryncsn@gmail.com>
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

On Wed, Oct 28, 2026 at 3:20=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Oct 27, 2026 at 06:06:05PM +0800, T.J. Mercier wrote:
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
>
> Nice!
>
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
>
> This part looks much cleaner, thanks!
>
> Reviewed-by: Kairui Song <kasong@tencent.com>

Thanks Kairui
