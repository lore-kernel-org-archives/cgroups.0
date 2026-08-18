Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C433A38C2D0
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 07:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038898; cv=pass; b=IHkNRpuUd/fedCOfJR+yNXqfDmtMq0sjbdi8mAZwbesEdWlqDOakzNkMTtKu4IYjje9BbNUiAsY6s5VzZJ2+pIdjVsEYIGmkZBI+xUPGPaaq6380dPj6nUXEk9wppxB6DefZy0B+Q2/5CkOWuuuxNDyZw9cJ2l0ng1Ets4NN2OU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038898; c=relaxed/simple;
	bh=kttDwe/zqAmJqMUIbmlXJ3Z8A6yQLgmYerT6kF+giWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=liMjO151mxnjD7O5nxGcy6GW8ggTr2bZa/bofYLrGWW6EBdrhy6O3ESVlLRBs9yLjwKc2e/TrzaFrQl/xRJWIbD1K2Petq4NgFru7ocZHl20xIR6zbyTWt7HZ2ZhEEb6vZ3vsknRMe796SaKxocJDOC+GJ2V9rdzUvJHtYmsv60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQx2l197; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQx2l197"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a18e24ad25so5519118a12.1
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 00:41:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787038895; cv=none;
        d=google.com; s=arc-20260327;
        b=Lia4Jt4X988s0Qt509tcwivWM9lymSqj5iVk2tk9DlmMX+HKAlFM0JtgEqDjoc7HRZ
         Re9QHtJ0Jw6Cmdth0OTrox1njlHBOpmaV0QDLKBo5rTlXbRcpjs/3AHb381O3dUdSzs+
         wgOkuU7U7gd1BX2Q3glqdd+/dF3naSZbvwsRvURptygAkT93tMGT3inU6qwGNTvU5cyR
         EOAbuvDbk5SIK/ERTZShyKnKmSoRgVBBF+qnD4v+LtSaT/QDSCnGSI3Tm5ssd4dh6u4H
         rGjaMJIwvTYsXua65Kx8L+qchyFJRqi+/vwmVbQAaDb0nBV/Dwz+8nsPYKnNqCHA/BFE
         7ovA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VahNcEYmw+mGcn7LtyCZe2us9vTkZlTxAEikuZwKYxg=;
        fh=RPw5DxBTLVhcf55ne2DCqTaHWrHWuZoqDSw0ZQ+q5Yk=;
        b=gfqcWKMf9EhA1waS10KLGpaLAgfuU+d/pTF5ZO2RDnwFw8tPNbyw+cSXeB3u0QV4l+
         B8nCdKN9PaHFBufISIuljIWAiV1pdVuYP4GjEPvq2iLRiCRqeEiYg2o3cCvq2uJgf3ch
         HrbhOfXXVZBLBDbQsCAt5besEDHHlW3QA2+Bz5EtgdoP4rnt6JtlRebPHppLd8mQy9jZ
         frJegwSEw53cI+2S09g15qHOjI22/0aiGQw/ZCUwtFcBkVxbPC7brC7B2uNw8vCqBQMo
         UdiC23r6qStT/S+mHcMSxTIpv/9RNkDc+iRysTWR6cdbKTpgpqpry5D+2E5/xTIulbn9
         WMJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787038895; x=1787643695; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VahNcEYmw+mGcn7LtyCZe2us9vTkZlTxAEikuZwKYxg=;
        b=fQx2l197IR0a0rxqXMdg37zie+ulKabDgbeXrNKXi/OS0jjQl+Wtx8I1mwaMUMvG+g
         s0/Oltjx8gtz/7hLju4x45gSEiUT8znLDMj/aUJzmVpR5vcEry91xtl7ZMzmH3XjE6Bb
         4car3uM83sF7jGTd+tl/bN+f170YhzgQT9GwdO2iPNXK3CLLUo2s3cP7X6emXGhsgjhi
         l5SKjwHQXiEgj6OqXmZzYDauAJbSdotu+XwcHxcoc3+hgnA01r32ZvVbpTvYQB7ssSEc
         uaKykjwUXePqA2XMQM7YJETBkaLN0nITO9QJi/9y/IqC7Q+RXM4N7Y6I+Rqe4guYMNEY
         BBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787038895; x=1787643695;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VahNcEYmw+mGcn7LtyCZe2us9vTkZlTxAEikuZwKYxg=;
        b=rKhcFH27RxljNMbP8EZFQBi82SYOsNqQsiT1GMPCwPJG0QhG0qxqCbK/GnW4fwDxoZ
         koDmncucUZZ6wCgxPjMfCiqFxGQLCFHzKUCHEGau3P3hbXUmI7kCKK0QvZEm8LkQTqDm
         8RMED5+R6Ua/DiW5lq7gLH0BfRTfrirQwsYGUwHWtgoIt9ZMUeFj+BcaI+BT4ucPs2jZ
         u2xlpEK51zdI28ac5xx+9M55JKDQJyMrAavKGcHdBqLL7nQrTMaa1IW5RzeRnOw53xM7
         b3H0GMAutSVx25Gni+cHLpPaWwYyYq1AIWEVS/MZtRd/aT0awOqTgG0X++NJ2PBu1SZU
         +o4A==
X-Forwarded-Encrypted: i=1; AHgh+RpIaV6LzdpJZTYlX6kBWHP7khXw04CH7SKb+rgJIFDvhl74JRiqrGay4lAk9zjDrMVZnkVBbtHN@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/qhyDc70raBsBg+e5x1oMGG2aBqe4juXRudDTJq/xF0d6oNtk
	+xusb8oSal8JYMz4MJNsIOCnpNJ76t9nGoxXk66+rThmr+CJmYOZ8gYn1MmZH+TjXq1JO/Uw7ZB
	469mKBp1d1096vgrTvUG+0YX8Kkmk9pg=
X-Gm-Gg: AR+sD12cS/use/SERR0rPdErdRcWbR9ZEeEmvCpGB4G/TyngIa3q9PaJnv+CNvsXmOP
	6nSrPl5Fxd1jzH0MyuDyvA9HySf3Gn0DeHIWG2mj23VbttOskjZ7YjHkEy2tWcsky+ckDxZCc5i
	S8SJy8soQppGxxGE5RY+LizUsOd7ZI65Cj+Kh78BBa+YS1k1tsQgZI4sXzAj0BcM9vWc7sm9Tke
	GK2P9DPg6sCrEAykPTmAW3m9YZEETyRV3xhgQsIOOIiNoaYKyHpxZc1Ag1p94jz1fHvrZl98bdA
	IkZsER6JA6hpnidG513fZ/SUx+68tnZr49TwCh6lbdwIEff66hK78NTMULd2wOV9kP/G6irvqzb
	Dig==
X-Received: by 2002:a05:6402:3250:b0:6a1:df2c:cfa3 with SMTP id
 4fb4d7f45d1cf-6a38a8d884cmr12171377a12.4.1787038894697; Tue, 18 Aug 2026
 00:41:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com> <aoQFw_SWJBAdO8w-@MiWiFi-R3L-srv>
In-Reply-To: <aoQFw_SWJBAdO8w-@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 18 Aug 2026 15:40:57 +0800
X-Gm-Features: AcwNN1VRYTzbtiXYoU92qfjSmVzpQzxLtJTMmiPxSS8NOzR75LT-X-q805MIN_s
Message-ID: <CAMgjq7C1nFb92FGE+uSapZZS+14R95OG9w8ji+ZBkF=fOQ2Eag@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 3:12=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> ...snip...
> > +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exe=
c)
> > +{
> > +     int max_gen, min_gen;
> > +     int type, refs, gen, new_gen;
> > +     unsigned long new_flags, old_flags, max_seq;
> > +     struct lru_gen_folio *lrugen;
> > +     struct lruvec *lruvec;
> > +
> > +     type =3D folio_is_file_lru(folio);
> > +     lruvec =3D folio_lruvec_live_get(folio);
> > +     lrugen =3D &lruvec->lrugen;
> > +
> > +     old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > +     do {
> > +             new_flags =3D old_flags;
> > +             gen =3D lru_gen_from_flags(old_flags);
> > +             refs =3D lru_refs_from_flags(old_flags) + 1;
> > +             new_gen =3D gen;
> > +             if (!(old_flags & BIT(PG_lru)) || gen < 0)
> > +                     goto out;
> > +
> > +             max_seq =3D READ_ONCE(lrugen->max_seq);
> > +             max_gen =3D lru_gen_from_seq(max_seq);
> > +             min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_seq[ty=
pe]));
> > +             if (gen =3D=3D max_gen)
> > +                     goto out;
> > +
>
> I am a little confused about the new mechanism. In the current mglru, it
> does have the issue both mm walk and fd read set PG_referenced at the
> 1st access, this is a obvious drawback. Now with the change, the ref
> count is clearer, while the mm walk and fd read accessing is still mixed.
> Imagine the cases below:
>  - one fd read; then mm walk; directly move to max_gen;
>  - one mm walk; then several times fd read; promote to next gen;
>
> Can I understand the final effect as:
> 1) explicti ref count;
> 2) more drastically promote mm walk based on the mixing ref counting;
>    - compared with the old behaviour: move to next gen when 2nd mm walk

Hi Baoquan, Thanks a lot for the review!

The old behavior is move to max_gen on walk access (unless it's the
first access of a folio), and only protect non-mapped folios with PID
refaults. Now, the non-mapped folios are also promoted after multiple
accesses.

The promotion is more proactive but not that drastic; it still
requires 8 accesses (2^3, which overflows tier 4) to force promote one
folio.

For anonymous pages, this also provides a more consistent and explicit
reference count mechanism, and you will see folios distributed fairly
among tiers now, as repeated page table access will increase the refs
above LRU_REFS_PROTECTED. Previously, all anon folios were stuck at
tiers 0, 1, and mostly 3, skipping tier 2 completely.

Also we reduced the bit usage by 1.

This new mechanism is supposed to work as a whole, This new mechanism
is supposed to work as a whole; it is documented and described in the
chunk of comments in mmzone.h (maybe not the best place but old
MGLRU's comments are there so I just updated it inplace). I tried to
split it into smaller parts, which doesn't seem doable.

And I think the three folio_inc_lru_refs* helper are also kind of self
explaining on this.

> I can only see one benefit and one significant change. Do I understand
> it correctly, and is it worth?

I think it's definitely worth it, if you look at the results in the
cover letter :), especially the zipf access test (1.2, 1.1, 0.9, 0.8
have similar results, zipf is commonly used standard to simulate
realworld access patterns) and a few other cases; 90% of the
performance gain comes from this design. I tweaked the refs &
promotion rule many times to double check and ensure it fits well for
different workloads.

And note that this is not an anon/file reclaim balance tradeoff issue,
both anon refaults, file refaults, and pgpgins are reduced, meaning
MGLRU is doing better at protecting both hotter anon and hotter files.

It's widely complaines that MGLRU was actually performing poor on
unmapped folio protection, worse than classical LRU in many workloads
(Not the LRU overhead, MGLRU had lower overhead, but the actual
ability to protect the hotter cache is not good, provable with the
zipf test in the cover letter). After this change, its performance is
obviously better than that of classical LRU.

Attachment: a typical tier layout of a workload before this change:
 node     0
         35       3910      37524           0x
                     0        238r      15596e          0p          0x
         0x          0x
                     1        409r       6429e       6211p          0x
         0x          0x
                     2          0r          0e          0p          0x
         0x          0x
                     3        895r      39182e       8588p          0x
         0x          0x
                                0x          0x          0x          0x
         36       3244      84684           0
                     0          0x          0x          0x       2882r
      6059e          0p
                     1          0x          0x          0x        448r
       964e          0p
                     2          0x          0x          0x        298r
       439e          0p
                     3          0x          0x          0x        416r
       721e          0p
                                0x          0x          0x          0x
         37       2858     221580        4269
                     0          0x          0x          0x          0x
         0x          0x
                     1          0x          0x          0x          0x
         0x          0x
                     2          0x          0x          0x          0x
         0x          0x
                     3          0x          0x          0x          0x
         0x          0x
                                0x          0x          0x          0x
         38       2183      29167         242
                     0         12R       2499T          0x       2496R
      4101T          0x
                     1        322R      29241T          0x         92R
       156T          0x
                     2          0R          0T          0x        100R
       144T          0x
                     3        150R      75764T          0x        741R
      1161T          0x
                         20903930T    5439295Y      48822F      19595A

And after:
 node     0
         47       3227     197247           0x
                     0        967r      35231e          0p          0x
         0x          0x
                     1        412r       6871e       1051p          0x
         0x          0x
                     2         12r        639e       2319p          0x
         0x          0x
                     3          0r          0e         49p          0x
         0x          0x
                                0x          0x          0x          0x
         48       1623      49290           0
                     0          0x          0x          0x       2065r
      3586e          0p
                     1          0x          0x          0x        338r
       836e          0p
                     2          0x          0x          0x        352r
       817e          0p
                     3          0x          0x          0x        107r
       139e          0p
                                0x          0x          0x          0x
         49       1491      91927        4865
                     0          0x          0x          0x          0x
         0x          0x
                     1          0x          0x          0x          0x
         0x          0x
                     2          0x          0x          0x          0x
         0x          0x
                     3          0x          0x          0x          0x
         0x          0x
                                0x          0x          0x          0x
         50       1305      10444         674
                     0         69R       6630T          0x       1082R
      2586T          0x
                     1         21R       2509T          0x         55R
       168T          0x
                     2         71R       2322T          0x        111R
       288T          0x
                     3          0R          6T          0x        114R
       619T          0x
                         31126090T    7780753Y      72142F      27409A

For file heavy workloads, the file folios are also now fairly
distributed amon gens instead of being stuck at tail gen. And it's not
just looks prettier, the performance is indeed better.
