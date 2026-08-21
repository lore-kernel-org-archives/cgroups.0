Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DE23B101D
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 07:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787298348; cv=none; b=fjeVOibjs6FiuFNN6gNxwqzX6k8NQiJENyTnTkg5wKnCy4R4OPvB4TJcjZjZsZrgxLBB1QtTy9ORPKgX74HvRGyzy56Yfqf0YjwrgTiQDrM+CO6vkWSgXH45/2ksusqticVsoQB6NQ/VAY9thoj2ZrcDlzUEfxfLYYXrmH5UK30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787298348; c=relaxed/simple;
	bh=D+PAYHGJr+uDU3QGfOdR0U8jLXpoQnlORIifvPmHZtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Erkh+d/nzBpi87VbN3t5E/ZY3ckUaWHFslac+IWgtIqNy/6NU1sR9JjlVOyqXBPhytp2EOrmCnEVWIfcWnH59COfxA/qB6Q03qg0m9h56n7dr7s6iuNdRtxFZ5cBO09w5y5s0aewmMfLb5tBPfVdyf5tkPl/s3OvAjaxCsVsMp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NpC2i/jW; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NpC2i/jW"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c1712a04ddaso117595866b.2
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 00:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787298340; x=1787903140; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rWco0Zv1E66QrWcdw7k63EetmMugHVxwGwsvEvMFijQ=;
        b=NpC2i/jWUm7NDE1NmX0ptSev7UYtRdLFvixZQkd2+Qre0EGudrRnZUp7gVHqxRUQSr
         JB8HN5+4dsSLrgCsTxZh3LjMtEk9Ak1laR3RzvFOLLLIluYxh/5qu0ISSHFe0yzoBLze
         JMCOOx2tjIv7ngyIvIwlUvxVW9s1rDNVE2cxLOy3X7Demwsxcel813kXqhkDROGfEOY5
         yllQjooY93ZATh4oitURr1B0klvVBkuR8Fd8jst5xysnhidOgvjZHcqZrxyUmwLGolVA
         MOYXl2nm6iUu3Efp9GbDPss6XrQjd2VfxEjy+E1A01vDmrF5WufbPeRIAkX6b560cnZ+
         fepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787298340; x=1787903140;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rWco0Zv1E66QrWcdw7k63EetmMugHVxwGwsvEvMFijQ=;
        b=jHNzLv9Mr9ITBAX+hgpUEDaM40VqQGn6LZRSZGRSFA6oHpj7oSnMPbb760QMJTuMCo
         kIsJF7MyfbpoPXPLzr7D3KWx/RaGEY9gAcgWnWyPYKH/NiKVM5BZuuFWz/ClmRk6zTby
         ml/qarTv0aXh5yjw39/R2h/9iX/V7dOgy134nbp8LW2rGSlH7eqGnpqU6YeglwBtgT1M
         3uuzglzkYt7+mJspdymB8CuLedkVU8lbmHK/3EK3oViNAR/Ti0LuLMAfbi/WaiFCHksC
         BEhMN6JdykSC+9MrlIFr+i/mrtInsDXgWho/5FZRplm9fFTQNQVAp0hqVKaNcZhIbDTa
         KtzA==
X-Forwarded-Encrypted: i=1; AHgh+RqFS+riD7miqjC6YYCdLdfouBcj1QPbVVVD3LMOaxlZ7yLclFdhOUmjHr3Pxi6mpi8kgn0t1aTt@vger.kernel.org
X-Gm-Message-State: AFuF++k7Hmb+mVesnJ6g0sguEhw8tm9TTF9TraCjZufZZpvVYpJxw+/0
	Q5tvSFIjMw9M6wzKEyrfhPYnN3V/GoOyyXduG6S2HyVjh2sQxOIMdLGMey/AVaBRKLA=
X-Gm-Gg: AR+sD117hgbgkP+/1StKbQJkvJh6ohGmabIeKGi5ZpfAstHWp2c1j4UL3pvJsGs8CUy
	9cx3pIeRh6ea1tBf7Uo9+/tnLUvGtnUIHdYiAe84FaX4OZLgdhlXjDlwzxIKv6GcQ5s45oHaS5M
	ZPwY66WDbcQalXwMzqo7WO5pb3h57SfzLsTzEtqR/AKATMUfzKBuoBGKGPwHh/f8KSQyG+MxcTv
	WhNwTu3azYY9JQx3HjL5oqfM1E8ndm6TZFesctRmd1BJYVvSN8+gKPXYuzQyI0+3UAGUqwt5uN9
	ikzTFkERwyt7kDA0hE2X4MUVzdEYDpZLKsMFfzXHd6SA7TFnl+Yr2V5kDrU4fpjWyRSOBxdvk1i
	5lvUtQLVquRoNiji3LLYkQQVUZt23Ngg7hmNphIOESwKADtqrTvGOzoqgnmuGsXZpeIKK6Z95sZ
	klhBSG+sqrvlaTc8G8vg3dhrAnVnI+Z0w4O+zXDF10tLnVas2xLI8UaEuSms3Q1nmZGQmghgH7m
	5VHJp4AE7HJ
X-Received: by 2002:a17:907:3c83:b0:c20:899:b8bc with SMTP id a640c23a62f3a-c246a4d116cmr488381166b.6.1787298340554;
        Fri, 21 Aug 2026 00:45:40 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2458b09448sm360492066b.17.2026.08.21.00.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 00:45:40 -0700 (PDT)
Date: Fri, 21 Aug 2026 09:45:38 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aogCIs5-MCpo9loo@tiehlicka>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
 <aoanalsTiGmL69LN@tiehlicka>
 <aoclMssJAyYw2aCn@linux.dev>
 <aodLEmCg76oRHY2j@tiehlicka>
 <aodk640QxaSa0gVK@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aodk640QxaSa0gVK@linux.dev>

On Thu 20-08-26 13:50:32, Shakeel Butt wrote:
> On Thu, Aug 20, 2026 at 08:44:34PM +0200, Michal Hocko wrote:
> > On Thu 20-08-26 09:06:29, Shakeel Butt wrote:
> > > On Thu, Aug 20, 2026 at 09:06:18AM +0200, Michal Hocko wrote:
> > > > On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> > > > > @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > > >  			empty_slot = i;
> > > > >  		if (memcg == READ_ONCE(stock->cached[i])) {
> > > > >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > > > > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > > > > +				memcg_uncharge(memcg,
> > > > > +					       stock_pages - MEMCG_STOCK_LOW);
> > > > > +				stock_pages = MEMCG_STOCK_LOW;
> > > > 
> > > > I would find it easier to read to keep the update in sync with
> > > > memcg_uncharge, i.e.
> > > > 				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)
> > > 
> > > Sorry I am not sure I understand your suggestion. The WRITE_ONCE() is throwing
> > > me off.
> > 
> > Sorry, brainfarth on my end. I meant to say that stock_pages should be
> > updated by the uncharged decrement rather than capping it at MEMCG_STOCK_LOW.
> > So in fact I meant this
> > 				stock_pages = stock_pages - MEMCG_STOCK_LOW;
> > but then shortcuted it to a nonsense.
> 
> To fully understand your suggestion, let me walkthrough the code:
> 
> Let's suppose stock_pages = 65
> 
> 	// Original code does
> 	memcg_uncharge(memcg, stock_pages-MEMCG_STOCK_LOW); // uncharge 33 pages
> 	stock_pages = MEMCG_STOCK_LOW;			    // stock 32 pages
> 
> -----
> 	// You want instead
> 	memcg_uncharge(memcg, MEMCG_STOCK_LOW); 	// uncharge 32 pages
> 	stock_pages = stock_pages-MEMCG_STOCK_LOW	// stock 33 pages
> 	
> 
> Am I understanding you correctly?

Nope you are right, I was clearly not thinking straight.
Sorry about the noise.

-- 
Michal Hocko
SUSE Labs
