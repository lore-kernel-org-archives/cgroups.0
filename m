Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367030;
	b=zBeGaR9E7iMgl6Cwexo94f437UXezYu4GOLHU5XHl961bADVBkeLi/Hu4owaepxJj9JV
	 GdrVDEJdSpr8GxVk9UZoE8WCdvPPxwwOOcg/KODF0U1htz0DfGDgqOqUf+kUJI++hmSfz
	 7EfoJbR0Gq3ldoRCwHaLqw/iFaQWA6hPVJYR1xJf/laCldAZ2QkHrmNcq1y2b+l87/kd6
	 jbAmcbntavweg69os0qpc47LvKZv9UGa8Kv4BzMdkXNrojiTV+aJPwcsI2GIy0UbGY1/q
	 PsDdBQGGDcCCg3SVbXjOa+k0qtB68P6Yjo+1pnEzoG0v//qrKByMnKHIw/qju9nLkTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=pmTrwXa44wNwYeC7jaSDYKhs1kagM9vZS4uaKGYPdVA=;
	b=DJq5wdOx5Gnaaf+TfjzN3kO3rdtar5QKnDOCGyOLjdrKEwg0MJVt+0IM/jbh27OBajti
	 w3/7RsHz1j/hqTQD+z1TE0zkCqoW+qr4KHcwlkXSd1XNpxgX/jnuhyxOhhmy5Y5nOHxPv
	 YQ6aDxZwQJV1g2XTFENGX7YZWDi8EZ79jH/0asGBJaAKXrZxLLe9UJwXcZTs6HOZMAiJ3
	 0K2P8CqSwHCX0RWq1eY+Zc+qqAryEHdB9jJxIt3CcCIjeXYi82zsD17bBI4A6skSqpf0F
	 PpnBz4wztUfKVAtOpcBqN6PtBrodw1prbnCbZDC6AnUoGY+zrCbk9vKUMr5wKzlo3cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S+EDjXl5;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6B5606A32A
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 17:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E6B5606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S+EDjXl5
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f04ad2c46dso11935505ad.2
        for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 09:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795367029; x=1795971829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pmTrwXa44wNwYeC7jaSDYKhs1kagM9vZS4uaKGYPdVA=;
        b=S+EDjXl5x9/onQ9QBL2h4s608i+Iv1fYa3RapZ2gSXWpIlrZy/Cjig6y47F/NkAT/F
         UFOT1MiPKDDEizIXETtlSq0L//tRVBWAtaaeqLzq4IhwfG6Lf2DdZDzge/Yy33Tf8/2f
         aXG1MnXwawTJJuz1LTesilgK68UdB+CM4IgERtzl7I1UwxBJHaKE8DGRXb+r77ohEKSU
         cvOiDvu+4clRldEoMQ+AWbw4WWcBNgCIg5g38OsyLtWym3aBZcvbAbuWYdwFU3D2TrsZ
         Bnqw5O1UKyFJ97iUdWK1zVB1bkcuYJgmfL1w2F3Ayfs3N4454b44TjyNfp231GIPb4Vh
         TuhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795367029; x=1795971829;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pmTrwXa44wNwYeC7jaSDYKhs1kagM9vZS4uaKGYPdVA=;
        b=ij3A16lRfXcRF6pZIexwp8S9tytrB/tpr24iH2lNnrsqPdzfLtV3cKLo8emck8PcJm
         iGTfFnAkARWz8wRjpq4jH2LOSuoWEZlSlipRosCq3l48WHBsjW8m4D1Rz5Y3gK2HPXll
         56ti/vHEcEejMe8xMk5M8GZDoRDyYTnvBuN3ADt1Z+9i1mp2MHJye8SP0G/r9XQGdAVD
         1LgQ5xyOLzW4dc+pr3Ucg/EFYwDLLGNLWWcRStG/w61iBHQZJ9N2CAwAM3aJjGLzdPKc
         0ex9YYjihVmvEbXLHuOmpjd9KpaybK/hNH2eVfyWJEFsuUVsXQRw02Ezu8XO1TWQ60Uy
         0/UA==
X-Forwarded-Encrypted: i=1; AL+hErFHFG8/03yTEUAxin358V0XPlgC0/Z/1JosPvd/SiLMq5oN4lXcxtuPw6g+uRbkLLU06FdMJLR0@vger.kernel.org
X-Gm-Message-State: APuU4Z8cpvyWLTok8IRBlfJa1rMo2zzbllqtNqnuw7nr8Bhrfm1zU5RH
	7XKkY7JpanThpJMfYsXqUWFAqbhiGPImwkhn28WT+MfXEqEMr6o0QUbb
X-Gm-Gg: AZFdTZe/aES6EJB5wOgLHKQV3Lc6++jvSNocUPYVpOSW2XK7ymg7cfUNXqPOVw42/ko
	JIE71d4rg9oRInCWa/b+b7nrbKRmVjDpESUUxt1qm53SIYWyl1n2th/jrfdiWMO/YHuJKtsmiK8
	9R88MQ1AffBtvRC/Qgc5y6jqVTeNTPv/QDHTdnChfCjT/WvkEKhneK/ccwNunD0kSF+KHM1HS1k
	woBAwEv7x3i/06aPqOoet07V41nh6PIQ+8XTlZ/pUCs+wOO7kenfvSCPT7+DnspSM824XLkVNDF
	1Iiq9P9ev5F6iwFsUc7aW1Ulg8NV52wGw/o7plOcHpHfFNbsiJR2FKq1z6ODgUeo3WMNg5ewpJW
	TXZMhvycQAkGRLGS54pZfm3NgyLUHt67iEjM0uCuhpx1hTI4pq2+gTad4xfBMgMWZ2/bLefBqif
	s08epsoBRtecmoD1XsK04LgKnIUXO4WPsBBGRll8KKOtYXbqQgiw+z9k79+vnJvprTJm447LiOz
	mnR/VIgDeuGRGRM3wTGfaPSPDW8FC3ofeJFkmoORfU3N0r5XphjNG8XGlnxANHVXzPt/HCCPOT7
	f386B2Jy8FumrYdTNYN49+vciUFe2GoDUSj3M667QYDfEgq2CJD6hQTA5sVqW++yMkgSjI4=
X-Received: by 2002:a17:903:41cd:b0:2e9:8bd4:577d with SMTP id d9443c01a7336-2f03f1bfa6fmr95419565ad.37.1795367028759;
        Sun, 22 Nov 2026 09:03:48 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c42b1sm39111735ad.17.2026.11.22.09.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 09:03:48 -0800 (PST)
Date: Mon, 23 Nov 2026 01:03:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: kasong@tencent.com, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
Message-ID: <awMX9W-Ykjw4maRg@KASONG-MC4>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
 <42207e26-ba7f-4df5-8c80-71fa1b84d26e@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42207e26-ba7f-4df5-8c80-71fa1b84d26e@linux.dev>

On Sun, Nov 22, 2026 at 03:53:44PM +0800, Muchun Song wrote:
> 
> 
> On 2026/11/19 05:03, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Add a helper that resolves a live lruvec for a folio under RCU
> > without taking the lruvec lock.  It takes a folio directly so the
> > lruvec lookup happens inside the RCU read-side critical section,
> > which a lruvec-based interface cannot guarantee.  The first user is
> > the lockless folio_inc_lru_refs() path later in the series.
> > 
> > Factor the ancestor walk out of lruvec_live_lock_irq() into
> > __lruvec_get_live(), so that both entry points share it, and spell
> > out why the walk is enough while only the RCU read lock is held:
> > reparenting of a memcg that starts dying waits for a grace period,
> > so it cannot race with the caller until the lock is released.
> > 
> > Move memcg_is_dying() up in memcontrol.h, next to the other memcg state
> > predicates, and use it for the walk rather than repeating the open coded
> > css_is_dying() test a few definitions away from where it is explained.
> > 
> > No functional change for existing callers.
> > 
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> 
> Some nits bellow:
> 
> > ---
> >   include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
> >   1 file changed, 56 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 980358bc6f49..441a5d57e723 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
> >   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
> >   }
> > +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> 
> Let's make it const for @memcg along the way.

Good idea, but css_is_dying isn't constified, maybe we can do it later I think.

> > @@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
> >   	spin_lock_irq(&lruvec->lru_lock);
> >   }
> > -static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> > +/*
> > + * Reparenting moves a dying memcg's LRU state to its parent at any time,
> > + * so anything added to that LRU afterwards would be lost.  This helper
> > + * walks up to the nearest live ancestor while the caller must hold the
> > + * RCU read lock: reparenting of a memcg that starts dying waits for a
> > + * grace period, so it cannot race with the caller until the lock is
> > + * released.
> > + */
> > +static inline struct lruvec *__lruvec_get_live(struct lruvec *lruvec)
> 
> Cound @lruvec be const as well?

The argument is fine, but tricky for the return value: when nothing is dying it
hands back @lruvec unchanged, so a const argument means a const return (which
isn't right) or a cast dropping it again.

> > @@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const struct folio *folio,
> >   	       lruvec_memcg(lruvec) == folio_memcg(folio);
> >   }
> > +/**
> > + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> > + * @folio: the folio
> > + *
> > + * Same as folio_lruvec(), except that a folio whose memcg is dying is
> > + * accounted to the nearest live ancestor, which is where reparenting
> > + * would put it anyway.
> > + *
> > + * Return: the live lruvec, with rcu_read_lock() held.  Pair it with
> > + * folio_lruvec_live_put().
> > + */
> > +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
> 
> const folio?

This is doable, will do!

Thanks for the review!
