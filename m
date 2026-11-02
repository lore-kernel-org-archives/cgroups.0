Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793639030;
	b=RsZXFDuA/cJyHHvEfS/GZ4oywXTCRJ7v1MjLgHxwm4Bv5QgqE0zOLuANYAcdY/zJwvrk
	 m3hGVNynn4OBkm7vgB8wh95G4JnucW8Twe2IxHjE+Frt+xZptpLMJTPdc9K3a91SYT2Uo
	 ODrdTwwz5swtkYsjdBJ6bM9pzhZkgbvUKIEk1UmtVGFtuHJ8RALzjKkYriCd65Nsunuvc
	 +DdSublHDqGQBbnrp0ZYN38Qoj0urKyGEbMxoH7ZTRF70/hDp/Goi5bXg0tT7wrYJxsbq
	 qTGfcrMHIehcT9RDSKPhGXk73h3e3y2zDqPjMnk7bMoMj6Ax8p40XX72x2IPQWQKTUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793639030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=zKVeSOmmrsl8lwum3t0s5Z+f2k9HnKnqrEKpVB5PY4I=;
	b=rp/8p7UWYodCeB0Y7fZYpVrgojTvcj0C5nCJ/GzeG3NGee221Wk4FZc39U6TnIrevxov
	 dtRMlL2M1k4R1Xo5DDQcXo7gB/z9WNsTBPdhKaGVVBOpr2NuRalfpUemHHeO2WKcxglFV
	 g7C2PT1r97HlSV2u3Z4+qnZdL9GwKXDL/GKDvEjcOmaxzfPbh2C97k2+HxIUcI0k+T08c
	 ZZYHbZEg/t8T9s2ig5OxRX0XvEqyJWfZfb0bGBTCMCaTYjW1O5178+UZrMwvnA/Hgjho3
	 /oLbL/VT006Zw3Y20L1t7pw5/Lu4fWquaEM5T3RvO8Qz1V3mC5RLnz8Z1RobHBIuwwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AgxdDCcD;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269316070D8B
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 17:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 269316070D8B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AgxdDCcD
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e10a70540so1828029f8f.1
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 09:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793639028; x=1794243828; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zKVeSOmmrsl8lwum3t0s5Z+f2k9HnKnqrEKpVB5PY4I=;
        b=AgxdDCcDNmY4Iu0DCPZh/nv6kr32Jy+0IEcG/Elc5D9A0gW3cvNTwNjSTLh159ENVx
         DmL/JX9N1LDAgfCrrah6bk6m9ra/nLMjl1y5QMAt4wOL1McEMAgD+zB3v59DmT+CjB45
         xVr1Mlu0dShbqUOZcgW33+hi8/w9LhjlBon3N4HTjLShGggKrJNJ9tyqL+mFL9l+QHYE
         2Bk1xblkkV/Uz8WhNkoqFGXYL3hFB0N0GRXUSQ8aCh2q6GKqrZuK8pGFw9iLCJ1eqoOs
         vzNrvivpDtYQAKQEY4kIOCSoa6xD1tGGeSNz5Hz8Q4Y94c/vsA5hxJU1xau5vlaIsvby
         BQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793639028; x=1794243828;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zKVeSOmmrsl8lwum3t0s5Z+f2k9HnKnqrEKpVB5PY4I=;
        b=NkV8R7AX08VrN5eKG1GtAe6ep6gUG2420o7ggc4coryqL7HmzAP/sF7V5/26CO5n/0
         m19K3ZdrdxeAguMrihkbHGPbdWcvs9vTvt1XjQV35MdAuTUkTHp/hJ901oPQ771SeKxd
         RFqZsUWh0wnqe4Iu5CCopsgm5LBVKVe9CQb/tvebvP1rXJTVEGVmEopzwFI0XPW99oAF
         Xm2aDPPYY6wcTDQ0ZD9/Nc8SjkPYoq7OKV8/31Z4PrlwB0yb9IGgJsSYaMvMcmx+Vt/7
         VC3B2o9qkgZbv/ERpJSzFQZIjutDx4qIDkPDECzM6h7qqM/31rT2ZHCVdA3xnECCHH7e
         3KPQ==
X-Forwarded-Encrypted: i=1; AKwUvByOO2Mxy9Ew0iDPqRMBnY4Nv3lkRFLQ8rh2MRyHXvZgsIgbfa2y4WQ3XpLHzax5Yaow13YYcAJq@vger.kernel.org
X-Gm-Message-State: APuU4Z+e0VoejH2bVwKMQeD5W54Hk5/3iv85ZWglEDtqUGS2ioBOmTa4
	9l5NadB0uocmwvUmdzPQpUQvySEg9FshbLwguZTYtPNHdOF2XOLjHL18BHAewn9Peco=
X-Gm-Gg: AYBFou17ZJFM+jZr2855Ye2lcZ8m50Ta8IBT6rHVw3+Y5U9uo5BAMiKAFnGLgRe0P+E
	VqevHnI9EWyr78sfaVYU2cS7FbeKRW4BcXq2PuBZK7MdBftCuVidAhw3l/00Rm6YR7sCl79O9PJ
	DsIGJs675RBGFigEviVrin/eqlZsdLG3utzjI6uPDpgRt+voXAbh3K2ne3vOn6dQVQ8QCh7UYQa
	zWT6td+zuJ6Jd2bqcIh7Z5v/AGvMmBQ05UrUkGk6poqLWWCVXNlj0vlnL0NBewGwoJLh7v4/OuU
	qdyycCPrxapcNUGKTaO9/qNNaZLMuSm9ryoBuebNhMOwqpgVYLpIId/Tk7l7WgYF6IQZixiv+BU
	/Z6aSaHl6WMbLWktR5HlkypCvqh+3bR1qykS90ExoI3E0BIvLLhInvXH5SvrIJQhDKG62WarNtE
	8mDwWqDTqqykv/HPRtB6t7QEC4/phUw4BMZ15W+ijs2yIAoL2FExQMAV7OqawTrIdrq8W/si0T6
	kX37AhKtM+23v03gs+kJ/9U4Apa9/TviA5iJll4QBur/FooBF8+yDNJ+5ZL6BBrGTIcs6HQPwut
	ZqRrdya6NO87TKCinLZteWpPRILWpaJjHOxsD98=
X-Received: by 2002:a05:6000:71b:b0:48e:68d5:81b1 with SMTP id ffacd0b85a97d-48e6e4fcfbbmr22771632f8f.48.1793639028313;
        Mon, 02 Nov 2026 09:03:48 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b7270asm21084674f8f.11.2026.11.02.09.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 09:03:48 -0800 (PST)
Date: Mon, 2 Nov 2026 18:03:46 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
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
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <aujCcqKKyio7oZ0x@tiehlicka>
References: <aui3TJqadHUv-4RW@tiehlicka>
 <20261102163014.237806-1-joshua.hahnjy@gmail.com>
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
In-Reply-To: <20261102163014.237806-1-joshua.hahnjy@gmail.com>

On Mon 02-11-26 08:30:14, Joshua Hahn wrote:
> On Mon, 2 Nov 2026 17:16:12 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > > > > > We get an added benefit of simplifying try_charge_memcg(), which now
> > > > > > > has all the stock management handled transparently within the
> > > > > > > page_counter layer.
> > > > > > 
> > > > > > This is quite a large change and I believe it will be really benefitial
> > > > > > to have some high level design overview in the cover rather than trying to
> > > > > > chase it in respective patches.
> > > > > 
> > > > > Sounds good with me. I can add the call traces above which should
> > > > > explain my thought process a bit more. Hopefully the problem I am
> > > > > trying to solve is evident there.
> > > > 
> > > > I believe I follow where you are heading. I am not sure this is the
> > > > right path but that is a separate discussion. I would focus on whether
> > > > moving cache to the counter makes sense on its own (without that future
> > > > work) at this stage.
> > > 
> > > If I'm being honest, most of the generic benefits that exist beyond that
> > > work were in the other part of this series that I got rid of to scale
> > > down the scope of this version. But to explicitly name the generic
> > > benefits, it would be unbounded memcg stock caching per-cpu, eliminating
> > > random evictions, (like you mentioned above as well) limiting stocks
> > > to leaf memcgs only, etc.
> > 
> > limiting cache to leaf memcgs makes a lot of sense and addresses a big
> > concern I had. How exactly does this work?
> 
> It's not a big change, actually. This was the implementation from the
> origianl RFC of the series:
> 
> https://lore.kernel.org/all/20260410210742.550489-8-joshua.hahnjy@gmail.com/
> 
> The idea is that you treat a cgroup as a leaf until it becomes a parent,
> at which point you drain the stock. Stock can land on the parent due
> to hierarchy walks, but I can also write another part to this that
> prevents stock from getting cached when a cgroup has children.

OK, makes sense.

> > > I think there was a proposal to make the number of memcg stocks per cpu
> > > even lower than it already is, because the author wanted to include
> > > additional fields into the stock that would make 7 no longer fit into
> > > a single cacheline. I feel like we are reaching some limits with that
> > > side as well, so the "unbounded" portion seems to be quite opportune.
> > > 
> > > But I believe those benefits that we would like to see are made better
> > > by this series, which makes the stocking transparent such that the new
> > > optimizations don't make the existing memcg charging code any more
> > > complex than it is. By abstracting away this mechanism, we can make sure
> > > that memcg just handles the logical charging semantics, and page_counter
> > > handles the implementation-level details of stock management.
> > 
> > Yes, these are all good arguments. Especially when clarified that this
> > leaf only feature. I have to say I was struggling to see how caching on
> > all levels of the hierarchy would work in practice.
> 
> Sounds good. If it makes sense to you then, I can fold in the
> leaf-only caching into this series to maintain more parity with the
> existing code. How does that sound? 

good

> > > Personally I am a big fan of how try_charge_memcg looks after this
> > > series, what do you think? 
> > > 
> > > > Quite honestly I am still not convinced this move
> > > > is the right thing but I would like to fully understand the mechanics
> > > > first. Having discrepancies among different counters just sounds like a
> > > > potential source of future problems.
> > > 
> > > I hope that I can present a good argument for why this is not as
> > > concern as it may seem initially.
> > > 
> > > My first point is that the memory usage counters were always fuzzy, as
> > > specified in the memcg v1 documentation too: 
> > > 
> > > usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
> > > usage, it's a fuzz value for efficient access.
> > > 
> > > Secondly, the raw value of the usage is actually always accurate. It is
> > > just the stock portion that overcharge the memory at times, making it
> > > seem like there is a discrepancy. Flushing the memcg stock immediately
> > > bring the counters to their real values (like what happens right now).
> > > 
> > > Finally, this is a change that is only limited to cgroup v1 users.
> > 
> > Right but is there any actual point in adding caching for memsw charges
> > now? If you have a way to opt-in to caching then you can simply disabled
> > that for memsw counter altogether. Fewer problems to deal with, explain
> > etc...
> 
> I think the problem actually still exists, unfortunately. In fact I
> think the issue becomes bigger if you remove stocking for memsw.

Yes, you are right. We do actually cache memsw through the charging path
which charges both mem and memsw with the batch. 
-- 
Michal Hocko
SUSE Labs
