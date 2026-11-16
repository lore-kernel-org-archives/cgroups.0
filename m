Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794868263;
	b=BrWid9sMGmleNfPp8SqGUnyrd/NWJiP25TL7KByKSkdcr2rFOlsBdr3ZEXc1xcNtj0ts
	 wuxE4Z9VTT27khXpDbrMoKGadlSeFQG1eAIAgtKBmJjKfl+GQXiGlhDJEgjedrK3nCU2J
	 NBbE8LMmDhDKZrq8hKhetpn2dF65DzWLNUSLz7LXNEEwShJ+wdNRh6zNztLP47A5/5Qno
	 Y0Dw4ImpF3Rl5+eDEmfwiUQgKOSn4bPCnPM0JfxBIewGTNPiH57p+jwYPshDQklDBud2X
	 hTS09PP0DpWISaRygCZcmfIk9rS9BDoE4BpWJZqcTWirrNCfZoS/NtMIMjAHiRNwmhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868263;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=flBIwrkiz4CrL8ZnZbUIHi9/+ZYjmj62+yS9Tn5YAWI=;
	b=vTZbWWuJg1lsDCDnc4iOjt0T3YiWSvCORdUpEYc4GfTSfQ2C2MlUpfGH2WaDG0FruhWk
	 hW1dY2k/lnKptWpYSVJGEfy3e11YOyDtdf/Sh6kD8bgTCbm6WU5yOu7DBKWuaGKfg5D84
	 AvaFV5O38JUTWko3VI4zS8xDeYUUd9BK8f2DPVpWKHkszFT3kdS085x0UQBaPwnadeNjU
	 AYtvUm0o3ntzRVwQgOUzoZYGj1kaKKCDJGzaQSNHJLiwWQPqL8uPGXoirCOEV5LwIArYt
	 ZmZqdQgksY1zImqs+NRxHOMVlCF8pbFYqNHrVeNoLbRW1RMkjy7eQazAIluKHO5FPJQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iXNhvm5C;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA99606A33E
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 22:31:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEA99606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iXNhvm5C
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb5b33e2ffso6115e9.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 14:31:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794868261; cv=none;
        d=google.com; s=arc-20260327;
        b=hKTgD6G4LSx4rrCCid+F4asRW1VkRmCAIay57qMukK5bkiVVa/ZV26UQUDJx9Z5nyg
         u7Us+g6NFqSu2pmz/zXGMEHNmGagaITFa4IIGGv96pivEVDfkyWkzRaQyMv2WVrJSG0O
         exvqa2LCJHaqf05M548LFT8+jVG9ZLb1/qK7inARpd3lx0NrEdqnIYrl86o8vXdo9kZw
         +j8o/eO6//R/exGk/8k7l/fSm8kw/UEHMu0ft+FeKV+i5kK3VOJvMjI0xrlATpotvAoZ
         jM77dc5SQAzaxbV6vC1XiLs4zagwJHXkGzBUB4OGOCyMvu/a1pskTKfMK1W278tucX1c
         At2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=flBIwrkiz4CrL8ZnZbUIHi9/+ZYjmj62+yS9Tn5YAWI=;
        fh=WLpmXz7X7pSa2GGAkrk6ij6HdCfAICAsoyxhrqfVG7Q=;
        b=EVWmdN49fHH71s/XAFNZqSbVNMij5sXKl/OhaFoAiSkwzUJkX3NjvcvKigBGSnMi4B
         a9jEVDg0CoOeCY4QhMF6JEDKa4hepFQqP3139hzfdN8CWb7ab8dVXq50zBkr2dyAcxl7
         rJH3k7UJ1xrHTJXP9v05gHCXV/IaXDROdY9uYbiRvv8X+0VUEXEV39XPPHGbg+PXkiod
         2ftark9zh8/5/eHZhWT0VCwS3TURZic+NDkbYkYpS3HR2cv1HI2Q34M+WEj6v4dIZh78
         L2q0kLma3Rg71y24fAowIsow2YKxvvc5xAit0HUz3TWAfaMZC5+SK37WnPNPNCVS+7SG
         YM/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794868261; x=1795473061; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=flBIwrkiz4CrL8ZnZbUIHi9/+ZYjmj62+yS9Tn5YAWI=;
        b=iXNhvm5CBoV9+kqxjF33xBnxtOkXJX21/ia+FsPJWq8wIWgw2FMxvYuqhWcwvSNSJs
         gkCi7hAngX1UXxTkrzrTA3KP6pHwYkSSYQ6xak0MjxYKMS4Yy0ElpUQbSff/ZFLwSXed
         G1vzbE33KNM6p844F0eoXLlNrOq/l/ptLuCdJHw8iJFrIxHxiZJvvkG30gmdw/vVhu0h
         PFdZIRu5zk7JzDIlaJDvW/SVerrxGHrsihkEUO6HCU2HK9xBYMd7r+PBg/zoP13k8EQR
         4pkGMutu9QpaBHBMl6eDZC8G6G3ssLMLU7V+0cLZ8kS3+33rNG+QCvFRMSAVYfPnwZq1
         3SXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868261; x=1795473061;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=flBIwrkiz4CrL8ZnZbUIHi9/+ZYjmj62+yS9Tn5YAWI=;
        b=mKgVBaNljarm/1D+Y7kjhTbsox9SjW1x+PJSrhmgByhHY2acZasfkq6CFhQSUOiNlf
         F65asBa4J2Qpv4YANyNwyjxzsspvEz+7B/Aj/92mUqmq3gHUB2YTtw41bBjWZwSLqsxG
         dn2EmXjerLx6788/tLkS2WJ/VtVkURG1PdK2djmASYZSxMtjrn1rn75RUtb18po/coRL
         eJ1bcNriVVSNOI8TJwdpHDGXtRe/HyVEuf+k8C/KO8jEMl3acm5bWMsrZkD7u8YQWyUk
         je9Zzl0bOg/QhlrRHikfUCPPTHSqY6ros6ceoIAGmzpq5aBbxirHhpNI1Yjv8Hn5DjIi
         mPTQ==
X-Forwarded-Encrypted: i=1; AL+hErEYIgx655xbQqdK6WTdbfdxGNsClafztXNRD3kcPrO87PZkbP5OBl0vWEUoldCNElUZw6oSAIgy@vger.kernel.org
X-Gm-Message-State: APuU4Z/YteuzCCorWEOt2mrvtc75GIToBgjBQaXm6p22n942BharOJdl
	maZ8R6geakFL9Zafe3pwYYOnZN08f8ykhY/L7bpopK2D6fTw/mV4oOI3MUI4HCQBjh1Fhkle3xZ
	QFHvJ/F5jT7b/SPDaHg9dS9oAdICkFzqODSINkUHU
X-Gm-Gg: AYBFou0pfjgtbCXfxmmeQg36fkAmSfpKYVyh1oJXJdDlfEVV4JVKlFcfVAbV6HhclcA
	RCf3cINR6N/aylSTa4FfQEiIf7h8G2Rl7qAMaJq5gBqo+zF/RysWjMoCMnOLOQoenRVaLa9aDpX
	Z5NKUzRlSS99oC+HtfuKyTFkwgQ3jz8dOVbSQ8rttwJweiAoQxhlro9vW4Hnja73ep+OHBU4pgB
	UunFkM79Ib7dB3wZHt85+1dQ+AwB0Axc/EC9L8MbKRJiJWe4GWPBRXacHjeDu0t0uo3WdEOK310
	hgL7ZZCWj+er8kzFUQIdb4ut3dwkDlFguxawyATOk8GQSvMz5NraXGiY+V+zyDcdeUe6UqSVdE0
	Smael3VjftM5pgnojo99OdJ2MICbgN7oWO4JPMcMU9SZEUHrezt1rFGMYgiZ+r+oOdbEHx78SHo
	4+xwBCCHEiMWQbI71abVW+YKA=
X-Received: by 2002:a05:600c:58da:b0:4b6:5035:d54a with SMTP id
 5b1f17b1804b1-4bb7899bf04mr226565e9.1.1794868260939; Mon, 16 Nov 2026
 14:31:00 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106235904.1092712-1-tjmercier@google.com>
 <CABdmKX1gdOH8R6qyjw6XN5VdpAZKVR8NZ=R7Y9Db-BEhUrX-1Q@mail.gmail.com> <CAGsJ_4w4rNzvaOK9f4D56opW7TtUWL_6srxJoyWXWDzhfgm4ug@mail.gmail.com>
In-Reply-To: <CAGsJ_4w4rNzvaOK9f4D56opW7TtUWL_6srxJoyWXWDzhfgm4ug@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 16 Nov 2026 14:30:48 -0800
X-Gm-Features: Aa3M54qWwlAq7r7UGFJTztgBBMUBZhaJaGwzwqSekoGuVRPRGEupivlWBRBOvBQ
Message-ID: <CABdmKX1v0Bs4U255krWQF7eh2gfuL7-zsvSTEtO3_vMs0OKgDA@mail.gmail.com>
Subject: Re: [PATCH] mm: workingset: compare shadow nodes node-wide without
 kmem accounting
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jaewon Kim <jaewon31.kim@samsung.com>, 
	Jaeseon Sim <jason.sim@samsung.com>, Youngchan Kim <ycshark.kim@samsung.com>, 
	Dmitry Skiba <dskiba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 12:04=E2=80=AFPM Barry Song <baohua@kernel.org> wro=
te:
>
> On Tue, Nov 17, 2026 at 1:40=E2=80=AFAM T.J. Mercier <tjmercier@google.co=
m> wrote:
> >
> > On Fri, Nov 6, 2026 at 3:59=E2=80=AFPM T.J. Mercier <tjmercier@google.c=
om> wrote:
> > >
> > > count_shadow_nodes() limits the number of xarray nodes holding shadow
> > > entries to 1/8th of the pages that could be using them. For a memcg, =
it
> > > counts the LRU and slab pages local to that memcg.
> > >
> > > With kmem accounting disabled (cgroup.memory=3Dnokmem), shadow nodes =
are
> > > not charged to any memcg and __list_lru_init() makes the shadow_nodes
> > > list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
> > > single list. shrinker_alloc() falls back to a non-memcg-aware shadow
> > > node shrinker, which shrink_slab() only invokes for the root memcg.
> > > count_shadow_nodes() therefore compares every shadow node on the NUMA
> > > node against the pages local to the root memcg.
> > >
> > > When most tasks run in child memcgs, the root memcg only holds a smal=
l
> > > fraction of all pages, so the shadow node limit derived from the root
> > > memcg page count is far below the number of shadow nodes on the NUMA
> > > node. Since the shrinker has seeks =3D=3D 0, every root shrink_slab()=
 call
> > > trims about half of the "excess" shadow nodes. Most refault informati=
on
> > > is thrown away, so refaults of recently evicted file folios are not
> > > detected. Refaulted folios lose PG_workingset and the workingset_refa=
ult
> > > and workingset_restore stats drop.
> > >
> > > In testing on devices with kmem accounting disabled, moving tasks fro=
m
> > > the root memcg into per-application memcgs dropped workingset_nodes f=
rom
> > > ~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
> > > pgsteal_file rose by ~12%.
> > >
> > > When kmem accounting is disabled, compare the shadow nodes against th=
e
> > > whole NUMA node, as is done without memcg. Behavior with kmem
> > > accounting enabled is unchanged.
> > >
> > > Cc: Jaewon Kim <jaewon31.kim@samsung.com>
> > > Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
> > > Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
> > > Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
> > > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> >
> > I'm guessing there aren't many other nokmem users?
> >
>
> Out of curiosity, is `cgroup.memory=3Dnokmem` commonly used
> on Android devices? If so, what's the rationale behind it?
>
> As for the patch itself, it makes sense to me.
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks Barry.

It's a mix since we don't currently require kmem accounting. The main
reasons vendors use nokmem are to avoid kmem-specific overhead, and to
avoid bugs they've hit with kmem enabled. We had one report of kmem
increasing clone latency by ~25% because of kmem charging in
dup_mmap(). Another report of a NULL pointer dereference in
list_lru_add() during eviction on 6.6 also resulted in kmem accounting
being disabled on the affected device. Those issues were from over a
year ago, and I haven't seen anything else recently.
