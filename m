Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632821;
	b=rIPRX2XQ9W6BllZWVe9uO6wqICq7xVOdjUr2eYWt9bnVzS86jfZO0byF9vbr/GWW1mar
	 J34fx2CFsE41re6FkBWZf7IBjJ8AOFk1Hz/piCuUA1BJdjvrlwaXRi1zw21/Rzm/oL8bD
	 uz/uvJnHPLKUnkG9nh+9usvti8WbvKp4ydFBVRH8ehAUGq+7s/2sefCLAg9D3RuG2kNXC
	 XVr8Xa4YwD4NVpMaOmV3w8bOkvXYh1ErLTnk1Xxmet58jSEmaIsHT+1/Uqf8J1vG3jJqx
	 3P/GdW75G/b4cJhfHm/OTiL5lTulfl9CMiTEPy6S0mcnIz+Gvfst4ZpZRUPRafp6zAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632821;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sSGTZ1xgzqrwbhvUAaYmxuAHPwq3oOxMzrzwAdYGKgg=;
	b=lQsUaNw8Xzt8MrK86aJURppdix1ypE9VjmV+gGuQkBlcBrLJ3uGc3BrdNuRwYnmN5hjk
	 kVKccp5UYkzUw6FzIQre1P92VnjMbVXKTeXvQ9LoIvy7IMXjODwLeZgel3DitwMtaWRJ6
	 hh6+QwFD+L0JVBlUhkhYcN4l/XQn3xdxdlqvhgIviJF2doqwtbDczXpazaJzHhMLwS9WX
	 jLAeleOzQuDqNISY2XHd+udWEcVUjP4lyqEcRtVoRcTcstYEIc4dg53vwOAv/iYob09Er
	 LA1WvRb7eRPF7E9YB4uB74FgsHFygu22SY6FhwPGPBLaKWqAuhS5N3susmkdIMkh/Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SD8P3Egv;
	arc=none smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4697760C1587
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 15:20:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4697760C1587
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SD8P3Egv
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b12b1ee403so17571617b3.2
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 07:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793632820; x=1794237620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sSGTZ1xgzqrwbhvUAaYmxuAHPwq3oOxMzrzwAdYGKgg=;
        b=SD8P3EgvYGl2azkjcnpUsZJnVAt6qOCOFAhdRyNODtZdaR1GXChiW1NA308xk606ZN
         bRIuKlzA7n+KZRUNfFj3JV1QELCPchL6rtEy0iW4o4hmOWsBNWgX+XRAW9NOyfpQ3vmf
         xHIX9zHYGcaFSk40WiDwWsVXvxusg55e8YKHQ3bPx4GEckLZ6xf2MgbBiS0cQMo5/Z3G
         2GJvNQO0DqN/YJJCW39xrZaKfcy8ZO8QvC3ErwhstwyIvpZnWA7zCL52XkgW0+NgtBVe
         H/TO5KM6bMcReqBRJFyvWBnhIcuP/JWczvviH+n0AOOQMcCPfBS2tnFFBPLW0P+tHRao
         AUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793632820; x=1794237620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sSGTZ1xgzqrwbhvUAaYmxuAHPwq3oOxMzrzwAdYGKgg=;
        b=Hdjk0R3kPbkVuaIaPdWo+y0ZSMrPE6JGsbBdb7EiAmsSN9bC9Pa9J4JDtR6rIkzNEf
         j/l3wt3s9SMVEmQiFyCui4nUiW9U2y+nLviGpMFNcsUkQ0y9Dw0PogNlzAkRBo0tPL20
         Rc5TnbiPOaE7If1MTEQ8i4Hne7K+Sa3w2utlrh2f/QvimVNs9GCmX7NZ2BAvV2ZXZzDi
         UV9aU8I25zf+OUvM6Ac508xwwOHIL/G2VIGvXTeoAzTESolU5Sw7Ha1xm0ygTJEVFsZo
         LjsOgsro1uJapNu1BRO5c8DXwYTlBZq+Oda5Ry4hcLSJzjCt+DOTHcf7HYXDutimXANk
         5K9w==
X-Forwarded-Encrypted: i=1; AKwUvBzaDvCDSv0ElDVOBSB+4U2NpRHC9nDewIYYBBJcNht70C9wBG8FnDYJnvEgEd7+ydq/t4/FLwfl@vger.kernel.org
X-Gm-Message-State: APuU4Z/bhQwxaLGUVgA/znL9Runrfc9InVYlL5WtHP3lNCP//WWYABtx
	F6IpWumtyMw+J8tKwWfpA5XVZAzLzBsbF/hk3k5PmfSvorHE09DmKfIB
X-Gm-Gg: AYBFou11sdDZOB6IUFkLe4MhJ+dOrZrYA+4xE6RR35Zhbd49EV5EtfD1HpYeGgBQRhQ
	5tINTSm+dgPZ8UAyCVoNfdqPuX6Gf1Lng9QzIjS6zrq7VEqlcoh39qU6XJgYUrXTuVPsQm+gbZZ
	ExCtHEt+dSLKC2iODz2OlTWsD8Eo+1x82+BTvvy7PF8Nqv6R2Fw1tVUG5YTQsHAol0fgnHHd9RJ
	Mx/HUjUcHNg/l6FQ67bXXaiT90N05wO+b7Ej9uPKXjcT7Ls4PRuLW1kA2C/J/OrTIB/rhVrIB9k
	+kCmtupzw6ps8qQLnIRI7fGC5QmIDvGpJkfpiuCJY+/9BmQD5eA7rErhu47vWxXCMQ6NQNT1xBH
	GECR+pHSHmqkqOobm2/kiAQ1El8pLCo6MK4oHgSczmGACwQGTj6aToUyc8Elw/NqYpoARy4y/k1
	xgN6GnqOIHdFfpKVmb7OqGcuggYwf68vk+nRzKxlaP3IrkPwtoL5Ccgr9Q+5xnou1/nswfhEsOH
	aFWbTItNdXvcDefunnWuM8LfvEB0XtFn3A+AiOj1MaofyuH755NBtggTlekLxrkOD66S4HBXy3d
	EbJREzc1KffbLs+G2jZoclshlIPr6iHkgaZ/msolnqs1ZdAJEh9YwCa4t1VL
X-Received: by 2002:a05:690c:6d81:b0:8ae:ed29:c4c0 with SMTP id 00721157ae682-8b2b682de50mr71858797b3.66.1793632820195;
        Mon, 02 Nov 2026 07:20:20 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7123dfasm55131787b3.10.2026.11.02.07.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:20:19 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Mon,  2 Nov 2026 07:20:17 -0800
Message-ID: <20261102152018.2773572-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <auiBOBfRIiup8Aob@tiehlicka>
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

On Mon, 2 Nov 2026 13:25:28 +0100 Michal Hocko <mhocko@suse.com> wrote:

> On Mon 26-10-26 08:59:37, Joshua Hahn wrote:
> > > > To make future page_counters scalable and performant, move stock from
> > > > mem_cgroup to page_counter so that each page_counter can opt into its
> > > > own per-CPU cache of pre-charged pages.
> > > 
> > > What does it mean that each counter can opt into its own per-cpu
> > > caching?
> > 
> > So right now for cgroupv2, there's kind of a 1-1 mapping between
> > page_counter and memcg. I say "kind of" because there still is a
> > page_counter for swap, but it takes a completely different charging
> > path (i.e. not try_charge_memcg).
> > 
> > This means that currently stocking charge for memcg is equivalent to
> > stocking charge for the memcg->memory page_counter.
> 
> correct
> 
> > However, one of the series that I'm currently working on [1] adds new
> > page_counters to struct memcg to track the usage of memory
> > per-memcg, per-tier. The goal is to (1) track how much memory of a
> > cgroup lives on which tier, and (2) to limit the usage so that a single
> > cgroup doesn't use up all the fast tier memory alone, and shares it
> > fairly with all the other cgroups on the host.
> 
> Right. I guess you have layed down your motivation quite well in your
> original cover letter.

Thanks, Michal!

> > When adding a new per-tier page_counter to struct mem_cgroup that gets
> > charged for every memcg_charge, I cannot use the stock fastpath since
> > the stock does not distinguish where the memory resides. It would
> > essentialy boil down to this pattern:
> > 
> > try_charge_memcg
> >    \__ page_couner_try_charge(memcg->tier[0])
> >    \__ consume_stock()
> > 
> > Where every path still has to do a hierarchy charge to the tier it's
> > charging to, whereas this patch gets us:
> > 
> > try_charge_memcg
> >    \__ page_counter_try_charge(memcg->tier[0])
> >           \__ consume_stock(memcg->tier[0])
> >    \__ page_countertry_charge(memcg->memory)
> >           \__ consume_stock(memcg->memory)
> > 
> > So that we can avoid the hierarchy walk for most charges.
> > 
> > I'd be happy to submit a new cover letter which better explains this
> > idea!
> 
> I guess I still do not understand what you mean by opting-in to the
> caching.

Reading my original cover letter again, yeah. It does feel a bit strange
to call it "opt-in"... I guess I just meant that not all page_coutners
will be getting it, it would only really be the memory page_counter
(and memsw page_counter for cgroup v2). I'll change the wording in the
next version.

> I believe you should focus less about what you plan to do and
> rather explain what _this_ patchset achieves and how it works.
> Also focus on describing why do we need to keep caches on all layers of
> the hierarchy.

Yes, I'll do that. Actually, this patchset is really quite limited in
what it does. I actually explicitly tried to do no optimizations or
behavioral changes at all, this is mostly just a clean-cut code
move from memcg code to page_counter code. 

You may recall earlier versions of this series did a bunch more stuff
(making the stock scale past 7 memcgs, dynamically allocating the stock,
at some point I even had a version that only cached leaf cgroups, etc.)

I got some feedback that these optimizations were orthogonal to the
movement of stock from memcg to page_counter, which is why this version
explicitly does none of the fancy optimizations on top. It mostly is
just moving code from memcg to page_counter.

> > > > We get an added benefit of simplifying try_charge_memcg(), which now
> > > > has all the stock management handled transparently within the
> > > > page_counter layer.
> > > 
> > > This is quite a large change and I believe it will be really benefitial
> > > to have some high level design overview in the cover rather than trying to
> > > chase it in respective patches.
> > 
> > Sounds good with me. I can add the call traces above which should
> > explain my thought process a bit more. Hopefully the problem I am
> > trying to solve is evident there.
> 
> I believe I follow where you are heading. I am not sure this is the
> right path but that is a separate discussion. I would focus on whether
> moving cache to the counter makes sense on its own (without that future
> work) at this stage.

If I'm being honest, most of the generic benefits that exist beyond that
work were in the other part of this series that I got rid of to scale
down the scope of this version. But to explicitly name the generic
benefits, it would be unbounded memcg stock caching per-cpu, eliminating
random evictions, (like you mentioned above as well) limiting stocks
to leaf memcgs only, etc.

I think there was a proposal to make the number of memcg stocks per cpu
even lower than it already is, because the author wanted to include
additional fields into the stock that would make 7 no longer fit into
a single cacheline. I feel like we are reaching some limits with that
side as well, so the "unbounded" portion seems to be quite opportune.

But I believe those benefits that we would like to see are made better
by this series, which makes the stocking transparent such that the new
optimizations don't make the existing memcg charging code any more
complex than it is. By abstracting away this mechanism, we can make sure
that memcg just handles the logical charging semantics, and page_counter
handles the implementation-level details of stock management.

Personally I am a big fan of how try_charge_memcg looks after this
series, what do you think? 

> Quite honestly I am still not convinced this move
> is the right thing but I would like to fully understand the mechanics
> first. Having discrepancies among different counters just sounds like a
> potential source of future problems.

I hope that I can present a good argument for why this is not as
concern as it may seem initially.

My first point is that the memory usage counters were always fuzzy, as
specified in the memcg v1 documentation too: 

usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
usage, it's a fuzz value for efficient access.

Secondly, the raw value of the usage is actually always accurate. It is
just the stock portion that overcharge the memory at times, making it
seem like there is a discrepancy. Flushing the memcg stock immediately
brings the counters to their real values (like what happens right now).

Finally, this is a change that is only limited to cgroup v1 users.
This entire series actually has no effect at all on cgroup v2 users,
which I think is a nice perk. Obviously I'm not out here trying to
make cgroup v1 unusable, but I wonder if anyone is still using the
legacy feature.

I hope this wasn't too much of a brain dump on you. Thanks for your
feedback Michal. Please let me know if there is anything I can do to
clarify my intent.

Would you prefer if we continud the discussion here, or if I sent out
a new series with just the cover letter changed? (I don't anticipate
any code changes, based on sashiko review or anything else that I see).

Thanks again. I hope you have a great day!
Joshua
