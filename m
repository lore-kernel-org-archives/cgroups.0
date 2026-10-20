Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792523020;
	b=LejIqeDNRnM5eysyFJm0rZodHZKiOR4IeUugmELBOnbUt0K2B/SXzWHz80xxtguFqg+v
	 IZfSH7Fy08J9Z/rv5FCLzc57iTBbXi+O81ZNipIFUbD+a6DsTQmicWMn7wV5J7gBw3lk5
	 yqKLde9VOoApqDrDO5R6hWRgwM3tJOm1DGqANHiHfgRq0eDz7fGinnHAU01v1j/Dy6M9x
	 eBxIO5+18cAgxUvSa+/SZhJUdVLvpsKH2k0jLoQN3pHjK2HhTJlu+weQzRpQjw6NscovV
	 dE13k4YWR8nBeVWKNxguj+2nmFJPRTPI9LE90bVLUiSd7nImTtghYUYWNBA4PsdhAIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792523020;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dz9sk4E9ive+ns4UsYhR2kWDOdODtXZD9F+Re5l2VcM=;
	b=FePXFlgSBeYGgLANf42qHwGw2CEzHlSyFMcVvZZBXw4fo/G46REOP6+R4A/SxU/f1LLp
	 8SqIgg0Qgk2mEJmKbpW6U7xQ9bvUMkPu6gVX8GwUbJ+A0r20G64gJ37RJ/3qeYFF1yviX
	 c39K6PMyrpSnvVrG2MOBOO4oUOvirsPv8BkwocDtq5Tk1oZKHfRGh7Zu0UIxmld6bFeJD
	 A2SYZoWwmpJUMv7XMnCAQr/tUG61qEhDx68gkZECgxoqB0yO0+TGzS4aJrrwNtTRIuQBX
	 lQAi8vMNtEY19CMxIu0DYsgiuNFHJB4ekhmzeyMr8amji5tIAVPOLDVF9bcCJRMpiGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=F6LTqspz;
	arc=none smtp.remote-ip=209.85.128.170
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F221A606A32D
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 19:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F221A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=F6LTqspz
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b10d24345dso20800887b3.3
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 12:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792523019; x=1793127819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dz9sk4E9ive+ns4UsYhR2kWDOdODtXZD9F+Re5l2VcM=;
        b=F6LTqspzQ8t6vWGnBXRpTK7e/E/2yghnP7i9ZTBsB+71Opz2FKC6WGRoz9U/C8v9/m
         10nRaecamwsb+EujNCubt7xPAwCWSMWvpSEhhcvVh4DLXm/P2m88t6wbMQajS00WY1CG
         D2ws5Y6VKYj0HCnkmLskBSrrvK5fDL3fKDtiaZeXZPRwbP2DnadOu1MKg5kOtn7tgMR1
         th4bf9cSv3u06QOOiTI2Oa/m7TcQf1nzeLenz/hzoxB8ansV3wwj3DHzjeB6y1I9D7a1
         lp/ouzJfCSx/tux+9pGBMRGm6h9eiUT0aJfEISDKwWB66KJA6fmyI3B4WtXqnX76vcEJ
         37BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792523019; x=1793127819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dz9sk4E9ive+ns4UsYhR2kWDOdODtXZD9F+Re5l2VcM=;
        b=EbCs+dn/COalXwijxdq14/d3mU58Wh3rd0Y0mj0jRWrDV5ujHdwgI8bxWm3IkaEDYJ
         f2zDkzZ+n9LdKE1RoScSCn+ZbJiAfAGFj/OHCFfBNXPZGMqr9KnMIxD4POpVemG/cXGc
         Yn0y2dRMHbldnVBLPtkrRe4wkOUg/E+6M6W8pXDy0uRlrMWNQzh+grx6IvJEVUJjT9Kl
         1ubq6Gaf4zP7JTUups8yYZi+tgjCKf3EkVqYcdpVcAbN3BG019zhSTcA/h18SzgW8Lm/
         skAuZVBry0bmcNJRcejaHzJpydtU6xCqHhliNgETPGzA3KRnRkaW5H9f51U+t3129YV4
         zNXA==
X-Forwarded-Encrypted: i=1; AKwUvBzM/kOPn3+IfRa+oY41q0X5AqaXf4GD/WNkYtLRUns2/LN7B0EucrhuXGzmumljNE8ZMb3saVuX@vger.kernel.org
X-Gm-Message-State: AFq9FYIIAwywXgyL2WRpr0Yc6WMXPiQHYH95jE1UDVrJO2nQ9MZg5Dfw
	MpxE3Xp7bZvNGQ+8vHw407QFJKLHh0+ULR7YtVHN/EgMfBwKUetg1seT
X-Gm-Gg: AYBFou2Rbtf721V5Tbf1GQYvyXfXe5poUE9A+pOOGk02kDo64k5fET0XreT2T4GbW1G
	MWUZOnyiw5xlZb0DNbvfvOUhD2jEd5v722eEkdnL8fPy9JrUFTQaga0p9iZb4IuXbzVmpz9IPZ3
	DvSRt5SJ2I29vpfpP6VNYKZPWFDPKTR72Xto2fwsS0txPnfeQ320mkuP57w8QZLQ2FWT6Nx2/TJ
	ZeORfpOUQp3or2WhoCZdUOk5ZXPgmQfaOdONLuZbYvJtFOy6Q612RRzzmVXD8D99Rsu9wRoZahS
	+YTl6ejL6EunKYtAgACBmqxjMUveataKVSH85oG59ZezAEUNc+Bk2LrUijlP9NSgee1RzoAeZL2
	CqEacMDiXQ/UY7kLhEVKjybuIHYpCNX3MD1uKWJKeEUKNP4uYFIThf2dVtIoNfJAqmATWwze+rs
	a+EpV7Oc88TMfSXFmsj0abhPlcRCJ33oENu0JgQUW17p6ePR8R4Ug9jz1r2yBoP8tg5J2/PNTcQ
	92P31X4xRWFswgH+IERnd/v8uTH
X-Received: by 2002:a05:690c:4513:b0:891:c494:1a99 with SMTP id 00721157ae682-8b0f2170891mr45756487b3.24.1792523018791;
        Tue, 20 Oct 2026 12:03:38 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b13016fce2sm1798577b3.40.2026.10.20.12.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:03:38 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 12:03:36 -0700
Message-ID: <20261020190336.3754557-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ateuS_d6hRKFFeZW@linux.dev>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 20 Oct 2026 11:13:27 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Tue, Oct 20, 2026 at 09:56:26AM -0700, Joshua Hahn wrote:
> > struct memcg_stock_pcp hold references to cgroups that it tracks to make
> > sure that the memcg never gets freed with unaccounted charges still
> > living in the stock. The cached stock can be cleared either via
> > drain_stock() or consume_stock(), which drop the reference if the
> > stock goes to 0, and then clears the pointer from the stock.
> > 
> > If that was the last reference, the memcg is freed after an RCU grace
> > period, but this can happen while the pointer still points to the
> > to-be-freed memcg. Then a reader that enters its read-side critical
> > section after the grace period has started is not waited for, and then
> > can dereference it after the memcg gets freed.

Hi Shakeel,

Thank you for the very quick review! : -D

> These are per-cpu fields and are accessed within local_lock. How can there be a
> reader where a cpu is still between css_put and WRITE_ONCE and within
> local_lock?

I think there is a case where a different CPU can actually access the
percpu stock. drain_all_stock walks every online CPU's memcg_stock
and calls is_memcg_drain_needed, which reads the value with READ_ONCE
with no local_lock. So I think there can be a concurrent reader that
doesn't need the local lock. 
 
> > In practice, this is very rare and I have not been able to reproduce
> > the issue in my own testing.
> > 
> > Switch the order of the reference drop and the publishing so that
> > we first publish the NULL pointer, then drop the reference.
> > 
> > This is based on a report from Sashiko, who found this pre-existing
> > issue in my page_counter_stock series [1].
> > 
> > [1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
> > 
> > Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/memcontrol.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e7d7db5718f9a..a05d9a8baa1b6 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  			stock_pages -= nr_pages;
> >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> >  			if (!stock_pages) {
> > -				css_put(&memcg->css);
> >  				WRITE_ONCE(stock->cached[i], NULL);
> > +				css_put(&memcg->css);
> 
> This css_put can not be the last reference for the memcg from this path as the
> caller of consume_stock() (above the stack) should be holding a reference to the
> memcg.

Ah right, that's true!

> >  			}
> >  			ret = true;
> >  		}
> > @@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
> >  		WRITE_ONCE(stock->nr_pages[i], 0);
> >  	}
> >  
> > -	css_put(&old->css);
> >  	WRITE_ONCE(stock->cached[i], NULL);
> > +	css_put(&old->css);
> 
> Here this can be last reference but I don't see any concurrent readers of stock.

So for drain_local_memcg_stock I agree, since FLUSHING_CACHED_CHARGE
is set, so you can't have it concurrent with drain_all_stock since it
will skip that stock. But refill_stock also calls drain_stock when
it evicts the slot but the flag isn't set, so is_memcg_drain_needed
can read it at the same time.

What do you think I should do? I think reordering makes the intent more
obvious and maybe it's just me but I did find it a bit misleading at
first that we were dropping the reference and then publishing. 

Thanks again Shakeel. Have a great day!!
Joshua
