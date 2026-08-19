Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2861F19F115
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 09:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787132299; cv=pass; b=mZo7jBmoh7JRnfh7CMWWuUyE1540qGnCX6CyUxblhxClPwSLzq20ZWzF7w03H50n0w9XF49+8HWs3p417xmAc8O+CPTO0FM1R/HWqPlFOakEZOPVNaeFCb1fbc3Wqw6g/LR0VT+ltLcXHErUfG13TayWCRMl7O2jAHcvRxJccWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787132299; c=relaxed/simple;
	bh=XuMshy5jIIrjHEuhWCiZ4YuDTPW/Ryn00pGvLvGrZz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JKCFbujVVrEl+JY87Q4vwJ0r2XrmWXU1RzjsehKnmkEMs4dPEGbtkywdkTnn7QiVQHjaidvSlwO7VQMF4aIiCGD2BOMgVIVPfkEGn0Gtj679JWTBPtMKRI1QW+qitpoP37pJTqjJFuKbdRiqjHufaNgAmJYYu8vx0kDcUOkuVKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHFxP47k; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHFxP47k"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a10b20634fso1622176a12.3
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 02:38:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787132296; cv=none;
        d=google.com; s=arc-20260327;
        b=XYRTUt3xAy1g64ZSlE/3+tDASc0fyxWqA5G02W+dZb2k3O/GxndVocQg+DrDvdoV0S
         OPDHXYAK6/aUEXWufN8rYFYN7oD6+phbDsjegTBGdZ5zu8XbN0B3gkDXklACvW2yu/5m
         EgpoIoHJG7QKomNuJKzIVo/UaE5i1henavesnPpwHpL+RWvMrMV+29ungb34ebP450zo
         0vwb7wkx7WmKnr66dKg5ly71uiyQ0YS3TOBxte+oYagarVvLiW7UEHz1+ssHhBQCI7ap
         PJCHqOSWBQ9BOhBoHRVOD5W+EIpOg7L8SMkvL98BLD//v5dGJlgiMoXq0x0BYEjQogPN
         oOLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WgGv6nXJvnSh4Pf2o6FlfLapyYXpkV1y0u8uDjsQr1w=;
        fh=dBrvEOxcvvsQNR/s1JWSNjyAHylkGyY4l3zJOpVo8Pk=;
        b=CdQcq4VLj9oTSd5N4/YIf2Yhg7ZLc0OiYH9Jm1BjBPPa62md6BDxkszFB1hQWaBG3O
         tMtv3DpxXZWcHAwknaW1FtAQozj3JKeEOmqx+4KMsyQsPpaVNuEnM9jBNkAWkAIpj/Uh
         UUT11P8O9gVaH4njy9w1qQ1u90iLXDPAetcAKYFCoUDo3Zx4cwIP38uomwhIgUf3lTod
         q6QC3aXsyzju+nZg27pio7irq8M+JOZaMH8Q5JHC/UE+Uyr3HaPL2czIZ/rKQ8pE1kel
         duNyLYT1GVXeROKiFUzj39TX/nRj5lcWrroBfvyui1R/VhrbkHM+PDWKRJ5Tf1g9vOcP
         +QFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787132296; x=1787737096; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WgGv6nXJvnSh4Pf2o6FlfLapyYXpkV1y0u8uDjsQr1w=;
        b=nHFxP47kps6Nb/VBLrAFGxrzelDPl2FsCkDgsd1B7+Ktbl+mJ5mkp9DHwMFBf/jYh6
         3sbwkJXPaRhHhBBaISKpMMov0pFUveufPw3rxAc7kGnMnnFuG98ZqulU1X/F/CA8pRWR
         ebsxQ6kHE9LyIaq7Gv8a7xRxZwQU6Dr8V4QlVV2LaqWcwuMPqAxNN2armd5BPrAYNYWG
         FbiG49xNkaoyfCbnUWQrknFywiiW4yLSfO1EftSsREkyZsW3NBFjXU3B15IX1kHJhzNP
         FGFzyY8V5Fdy0u/0pFH4HGSU0xbWKgPmr4iwysUekiWtuvFfHlBP11eGaV3Fa9a2woFl
         H8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787132296; x=1787737096;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WgGv6nXJvnSh4Pf2o6FlfLapyYXpkV1y0u8uDjsQr1w=;
        b=mUPE03O8crweZY8djpvM0qpKYZgBKzRlCCGAyPRfUACPKBsZML1hbyvkNeihbiq18M
         uI9tMTMl8fH5tCZIu6PEQ0w4+/PyAEvIX+jI3PUFND7HEZyZcCUbAOb71G4ul+z/e/Rg
         lvdo0StII/7dMyR0qYzIpLRdtu7DI3EsTASkHikln31YbAb/Bd9jQrucV0EuLh85H0Gp
         vTHhOQW6JLVEGicGBV61dBKPuE8/eCi51+s8gDqtOdMvsvyyJ2ZMRAEIM6blZ98qk4ZZ
         elNX/eDDoR62c8in+riMn/R4a8ln822xHJLzYX7vDr/R+GlzuDsfB5yBKONDjiYTrRGx
         /aNQ==
X-Forwarded-Encrypted: i=1; AHgh+RraI90QBkT/wejGBoJ9HiYJ2MFZXLXg3quLMC/koLsvrqn84NvROJw9zEYsg+eDPU77KChIuMii@vger.kernel.org
X-Gm-Message-State: AOJu0YxpHAN6XZvprJYXSa4xL0J+2TgPz9VLEcobBQfAUP723AM4vV8p
	LFYhFiEuErDuZOwoashbzwXtqvMilj2Kh7ZSz2JZ/yc98whFO9h1DQRGy5RYR+knVnc9pzXDSUS
	VyiRg0ejS/wNa+ddJwIUR9/8qkjyp7xQ=
X-Gm-Gg: AR+sD11mRpg7L+cSAVHUCRnx8wtiRZXQbLAXqK3Dlr2iRutg+YK5TwMUEME17QEpS8/
	NTWf/v9tZiPmEvsGV9zMCfMBvFP54ODctN+TFIOiLSGqK8R50OTw3pogOKon5JzmlSHWQshDDIm
	NWiXqdzPd3VtCPD+c0K4KS3zipfWbiKVggBbOcEri8QnGVwXzw4DUVUNZVP4RZxzMxgwfVfPoFf
	E7o1njSid6i8jjxLbO19K7jM/9tjWGOGYRUiNSbiYgkbSLWmsKiwjarIabUbXLdkONfaxmHf2Y+
	OF2wVGvRZwjdYBVL4XPZ9mILqXytpRcE9QB9BA/a0PaBxBvVeGMWX57JPwzkz1Kbq8MCKj/f2N5
	JPQ==
X-Received: by 2002:a17:907:c08c:b0:c12:8b1c:454f with SMTP id
 a640c23a62f3a-c23f93526e3mr229900966b.2.1787132296096; Wed, 19 Aug 2026
 02:38:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com> <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com>
In-Reply-To: <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 19 Aug 2026 17:37:39 +0800
X-Gm-Features: AcwNN1XIO7w1cQkVglUK5M4lcFYaaWx4tr5pD5YpKIBS4-hwuLixwZYGsbWPDNY
Message-ID: <CAMgjq7A1nK5EiRvN-o1Lg_Q2+Ek7oj4Fnm1qAy5A=ULfLz+t+w@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 5:03=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > adjusting folio's refs and gen info, make the code easier to debug and
> > understand.
> >
> > No functional change is intended: some combined atomic operations are
> > split into two, which only creates harmless transient states.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> Thanks for the cleanups. One comment below.
>

Thanks for the review!

> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 94f9c3ff5416..32d9354a754f 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -496,7 +496,9 @@ enum lruvec_flags {
> >   #ifndef __GENERATING_BOUNDS_H
> >
> >   #define LRU_GEN_MASK                ((BIT(LRU_GEN_WIDTH) - 1) << LRU_=
GEN_PGOFF)
> > +#define LRU_GEN_MAX          (BIT(LRU_GEN_WIDTH - 1) - 1)
>
> There are still many places using MAX_NR_GENS to compare gen counters,
> so I'm concerned that introducing a new macro would make the use of the
> max gen counter even more confusing.

I think I'd like to get rid of all LRU_GEN_MASK and LRU_REFS_MASK
users, MAX_NR_GENS is fine I think? Manipulating the bitmask looks a
bit hard to follow for me since:

set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, <number>);
set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
set_mask_bits(&folio->flags.f, LRU_REFS_MASK, <number>);
new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
new_flags |=3D ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);

Things like this are everywhere and I found it really hard to follow
what is actually going on. And adding more operations to refs/gen
looks ugly and painful to do, and, it's impossible to add any sanity
check. With proper gen and refs helpers, we can ensure every time
gen/refs is modified, the value is valid (in debug builds).

Mean while, a "% MAX_NR_GENS" or "/ MIN_NR_GEN" seems not hard to understan=
d.

Oh and this LRU_GEN_MAX is only used for sanity check for now.
