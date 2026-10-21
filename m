Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792613090;
	b=bBelb/FmG9vSLxsgMrVkE4A9oqE5uci0sfJh4ymjGCkustxCLCgEkCSx9T6vWAlpYHMm
	 7ig0r5kOYYrqZdyFFORHasgsHmRZQjiID+CQWtJuuDDd5vLA2i5xpPa97KONfKukOTeg/
	 OqpzAfeCy3sTURqjY/t9YIjTHUwXfI7HfQ475A/yl/JyljsxgmOgUm+cipGUI5VvKAyF3
	 dsq8byaFE6ynKdQBIIt2krmjo5mMySvQOfmem9Gcl2jr46qGdOIRB8FhbGu4fBTvbM8AR
	 +f+6UiW7hoKRmgJYqem1c1JbdQNYFBaeuC9utkdw6zfvMycun+0DDWcB+FlkonrRbHg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792613090;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=j1fxjuCDrdT5GfjnmUrHWkbOyMdCUNguBpXdd1GdKyo=;
	b=vkcY//u1sm7iNJ4hCspK7uKTxvhUmILed6uM2A5c0M59xVi4LV1TbosF4ISV73rryxRO
	 zYtEpFvpA/Y5cusmPqEC2hyNG/VWFeB6c8loX7zEzflRKGYf5AhQoy7WOvu5cYJFj0Jko
	 LpL85SFXZBoHeaaj1hlbWBMJt6anft0sIfVk+IfzLzJ88ZIfFgMyeXzKShJsHayAwT8uE
	 +RG03yisrL91WpIyjTKDUj2iUK2WsPL8wVoo+JOjhvuu6tav6i3wlQcMShkdU1GTrW2Rz
	 xZp0ha/eQP+zkcMqoBEIlov1Sg5NlfVgQ3qYYROYFfiCZ5mGnWZdRijwQNkg62wPjxw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OYWKgxfB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA32606A31A
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 20:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BA32606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OYWKgxfB
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso9410905e9.3
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 13:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792613088; cv=none;
        d=google.com; s=arc-20260327;
        b=kjVmj4CdRaFAV2+WZP/lX4jTmzW2eOtclRDTDBlrTN1Wkl/OGcUth/A64809JR16m4
         uUpHCavNuAGy5QMNPowFfR0FZwAF7MUxAJ4SQAukOAduSWZhnMBIhxUlZUsUxNf9i85C
         8NOts65m4SN704jg+sH+QWYjK6XyUY1cjgrcxqW6VMsbaYMPP6T35F0JxS9OwlncVSe1
         I6IqSHjkHiBVAtwbo+MyoLe7YKvDplnxTcAFhx0UX5ioM5BnLbzqrLvEn1ngO6Gpm2CJ
         0kkwM8gLluvm0IUBA2MWB++wRqFWZCddYnfeLM1kkTtkTawm/zZ3Pjui1woJT8cocwb1
         UHAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j1fxjuCDrdT5GfjnmUrHWkbOyMdCUNguBpXdd1GdKyo=;
        fh=XBuYIib52MLtC7wsquamVokn4Zk43tP5L/1WduPzi3w=;
        b=Kxjth0YthyboLKWCBGlVpjcAMALJEjl9ilIHsLnGlOCIWH+ZrNgVjUDlmglyCy3P5L
         2FQBFpTygfBZ+lS6MyNmPR3WbXW8OJT2Kvl9fs3DySlhwphOtHT4KtAYGqrCBbJz/QIh
         MiqdtHzikIkDZ5/NK0hokZ+1RjkhFhYJPQRKQ6/7X462UEWMZ4hYvch5P8sRhOuuvdZv
         r1Q6vRZPwZ/2UJAwRw68ZH2ceJqNLO3ujKZhZyWEmArRPtRF/fXvjb8rzD4C9z+FQwUX
         f8Gj+Dtyn0FBIFMTbp7NPE3SJVH25TsYP+8CFxfTwJtrpf0qtaVUlXt0d8HVQKU2AKma
         EUTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792613088; x=1793217888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j1fxjuCDrdT5GfjnmUrHWkbOyMdCUNguBpXdd1GdKyo=;
        b=OYWKgxfBB8ccYN3iVS4vgNZXyHDbjpy4wpoWSDHqHHzqdhA43sO0NhK1EMf89LG1pM
         3eBqgp7t1E2mYgPc/IuwWkETxUHq/YsaKxy5G5DQiOodPCxAV84LmaDv33ewkxwyRgzs
         dDNqfmMnfGLAkfvGkoPpTpC1p8HdlsMyBZGoMg1Nufvlme/K1jEPmMx8NxOw9xlNhP/A
         B9TqYzq/tF680frs3jyfje6nMFcyI0IDyA1Q2yEK2BsuRbLaYIjhPMBk5njkoThulfls
         bggUwaJq3ATD92W+781cUFR1X8wh4jP+oZp+X5XBGBwoEJTrcBaEFuWkKjahMOzYvDAu
         guXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792613088; x=1793217888;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j1fxjuCDrdT5GfjnmUrHWkbOyMdCUNguBpXdd1GdKyo=;
        b=m/ZIGty4AI8mg3Mf9Zvjb3Z+Nwl9Y/x46/3Fh1Fsh6ysCpHWtjgm5CqCbHL/GUKNCT
         ycnuGiYnHNMaepXo0ZYMZwh11Bh3gNnazdoFoKE0EmlpaFC76t1C7CRnhfRjg03j3ua9
         h585ex+aWRcxYkPLayzpN81EOHOxB+ZFumJJKXbnvcEOG8yNomIRQ33Mdz7TA+PrpzJy
         mmdjayCnGs9oAiiiU/ebhvuMLPw17etx7/9tM7+g8hR2CzfbSPLm1XPRo1v3grEKT2Jg
         KZllZ21i68t/4m66ACp6GQ4vOw2g7vDrOomPFNI7fhe1yZTxC02JCwkSZW2yGnjH3lKM
         qrXw==
X-Forwarded-Encrypted: i=1; AKwUvBxbHUn2i1xcvqmOeSJ3nbZb69NA1B6wMOpx0dGxkjV/nCSHu5h2Xil1931HydbNmw39t6v1s+rq@vger.kernel.org
X-Gm-Message-State: AFq9FYIDm6Ez3j3hI9GLPeEZ2fciBGClL/jQEuKHrAdIcLTsDTsmChey
	/5u/CDcP/w1mSzRBpFoukJ/8D9qRUEbWZgyNh++8ek8ur5XZeRppCev8/W6wGaDTSR67MuvNMdw
	TosyepEahVAGJSVL1fCjxC/G/rtX1DX8=
X-Gm-Gg: AYBFou0mbK72qyCKtU2tOH00oj4qgDHmjH17P5AOxtpkDEHqHvTBBkLr+PWG7ez93SY
	R/Y4VpqfRdmAHIEYkmY+zQQaoG98Iyr7janjLgQjp0GD9y5H/SyLWd2/hwRLT4d55hUF5iIHY9a
	AF5rStSECsUXE5rII78ffanvCBbpX+RMLzmQp1tMR2Q5K88koKOoH3Rqw+xLvU9ASCf71ClDlw9
	HxHHuyo/h1B1HHlzF/yO7WPLVKsiPhQEW61Ek5PY4kq+7AioQMtO3nW7Kz7Pz07p1dGrlWa5akP
	mY0+rrUL4YEk7DIxFMNF+OJBLj49DpBtOuTs5fk2VYy0r4sTKWhSJXv3RNJf6cOBoK+TNjakJzt
	Xsv8y2NK6JXETEemUGEPeUzfg+Cr66pVuJtfncQX0leImd/BnT+p3XIq22uArDHjHl5BTb7W7ft
	juP9d3WfKg6q0wPeqYUHnVIjeXWgzChTE5SA==
X-Received: by 2002:a05:600c:a11b:b0:4a2:5db:1f35 with SMTP id
 5b1f17b1804b1-4a205db30famr3506195e9.11.1792613088329; Wed, 21 Oct 2026
 13:04:48 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020200730.250189-1-joannelkoong@gmail.com>
 <atfrhsr6bft4t7SI@linux.dev> <atjhiAxEyoP48e0X@linux.dev>
In-Reply-To: <atjhiAxEyoP48e0X@linux.dev>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 21 Oct 2026 13:04:36 -0700
X-Gm-Features: AclHuK-XJg9p2pKQVLaqzPUQYnGGSxOsrQ6EL7MNtlukpZPxKO3UA7_Kxk1IV7I
Message-ID: <CAJnrk1Z=ZqTvfO_VYjG=KnHRvwmhNBfYfxpiZiKWPdMYnsA2qg@mail.gmail.com>
Subject: Re: [PATCH v1] memcg: fix cacheline contention between lruvec stat
 updates and LRU lists
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 9:12=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Oct 20, 2026 at 03:35:59PM -0700, Shakeel Butt wrote:
> > On Tue, Oct 20, 2026 at 01:07:30PM -0700, Joanne Koong wrote:
> > > Every memcg lruvec (per-node) stat update reads the memcg and
> > > lruvec_stats_percpu pointers in the first 64 bytes of struct
> > > mem_cgroup_per_node, and the ones that go through mod_lruvec_state()
> > > (such as lruvec_stat_mod_folio()) also read lruvec->pgdat. These upda=
tes
> > > are extremely frequent (eg these updates happen several times for eve=
ry
> > > page that's faulted in, freed, dirtied, or written back).
> > >
> > > The memcg_pn_read_mostly cacheline group keeps those read-mostly fiel=
ds
> > > on a different cacheline from the lruvec, but on CPUs that do spatial
> > > prefetching [1] (which is most Intel CPUs / modern CPUs), cachelines =
are
> > > fetched in 128-byte aligned pairs. Depending on where struct
> > > mem_cgroup_per_node lands in its slab, that cacheline can be paired w=
ith
> > > the cacheline holding the LRU list heads, and the lruvec->pgdat
> > > cacheline with the one holding lru_lock.
> > >
> > > When this happens, every stat update also pulls in a copy of the LRU
> > > list heads and lru_lock cachelines, which are written to constantly b=
y
> > > other CPUs under the lru_lock. The stat update has to fetch them from
> > > another CPU, which is unnecessary overhead since the stat update does=
n't
> > > use the LRU list heads or lru_lock at all. But even worse, the lru_lo=
ck
> > > holder then has to invalidate those copies and wait for the
> > > acknowledgements to come back before it can do its next write, which
> > > makes the lru_lock critical section longer for everyone waiting on th=
e
> > > lock.
> >
> > Can you please reproduce on a non-intel machine?

I ran this on an arm64 machine but the results don't reproduce, so
this looks specific to intel's prefetcher.

> >
> > Second, can you try the following patch instead of your on the intel
> > machine?
>
> I see there is also removal of access of lruvec->pgdat from stats update
> function. Let's break up the patch into two. One will remove lruvec->pgda=
t
> access and the other one rearrange the fields in mem_cgroup_per_node (I p=
refer
> rearraging than removing the lruvec stat pointer).
>

Sounds good, I'll go the layout rearranging route then. I verified on
the Intel machine that rearranging + the pgdat change gives the same
results as this v1. Do you want me to include your rearrange patch in
v2 (with your authorship and signed-off-by) or do you prefer to post
it yourself and I'll send the pgdat change on top?

Thanks,
Joanne
