Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694876;
	b=I1FshZ8i4eO9zTYtVHN3ga5li00XRifAnUn7HpKDDQAyNmcbZTSGCXjOI3rvCAhuWv1w
	 SJ4SbHqz86/kd1gUb8xcphLnAV9Kyb8HnfCGNl8TIERdz/5Hk9RNQ6yiJV3J6bpZoEIQo
	 nuZ3ZMX+c1/Hblli5p8NuFGvKUL0/vxSewiInke/aoU5KknXizN3qdo+VshhYo2scrF+y
	 NsqUJt3BPvm0jSY2gAp6rdOh+7tog0xK9rQ4u5nB+vpu20PTsE+A/QXEkxQW0oJTq7+D2
	 IbsQ3xNeS6jf3ktfTwBWeb7y209MmzHGfu/8J41KSFYIZJdMaYTh3uibisL/d7SDKGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=o94uNRQqzrylUu01kiRSHaUQ5l5ZXHsTJxuqTtmUWsA=;
	b=pRjUYNQFZfpf2dhq+XLSoEthj4+5IWu0Ix6FLRFTTdFnF+sbJm7nQOShsFmqX5pdxKqV
	 YSaGjHqYzCgaAraCp+DWaVHbHZfGNWABQLPW2phPXIM4kKFwsqLziM/QZufQdQlhCkDPm
	 5HbfDsUmGnJZfDMGGhLb1mC3IGpPt0ne/nhuNTtu2aKa7ZRLQHXMsyU+l3J6ah+ORHg2G
	 1m1XSnvmcq0FcKFh3udX5vviaF0H08jYKjEfobs6n+U2OGH/zA0J00xULmc0BdwID/jEg
	 zy7Jkhrd9flyvgwOL26A6U915MbNqy1QAS5ufnYyt4yRaOxelBlC0jXNU43E9BOu3gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=TLVy7iFt;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3845F606B6E1
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3845F606B6E1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=TLVy7iFt
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso2354800f8f.2
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 00:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793694874; x=1794299674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o94uNRQqzrylUu01kiRSHaUQ5l5ZXHsTJxuqTtmUWsA=;
        b=TLVy7iFtFV1eosB1viqZ7kViXpvbRMjgrFtWB9Imq6n76wjr8s3iRUHWE8hgHwH7Gr
         0KInipeNWTR08EjSERF8pBe1LkUAMlskiz3X0+LPzZHWD1VodvaOFpXD/XS36dPppxjU
         EdiIuVK+VO4HJkL8KSHmDuftog2QHWddAXkE3Ed+Il3YJmrHhKr/mAO8DsoyZJlUakNL
         4rxY/hQtmPfk36jSWuthX2k94iG9CN/Mho5dKMpxFLKqaIuEZzHldAH5jH+2JYLyUFMt
         lmeeuZpbICNNFyG19S+eF5BPU+e+q0kgrq+2pfK3WorZgLrO1HemIDKFRt/Js6Ibxqlr
         T3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793694874; x=1794299674;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o94uNRQqzrylUu01kiRSHaUQ5l5ZXHsTJxuqTtmUWsA=;
        b=24TbwBJeN1h3XWeRIo7+JEstBB9W2xkpMZ8+I7v9X6nhmY/5rJHc6WUEb6REBxcF65
         HWRVX83m8/YaaB+QpxSjK9WwaSEutr1iwG+N/cznnHV9HS2J22aBRalkA1EcA+n1gRvO
         AQr5wQahDyRb10DguqT43e3164G9s1SNbhMyZNNTXM4q9UbjuKpb8f///U4yoHuPhv9X
         NeTQuri/sutSCrfTyH4XnNfGMbF1DaVNaHxlxPhwYTZAe0rw7IrPfb45NRqMwv1rl/YX
         k5mWatovDwKOziWCVwPzabYPYVl6XRQu/YktMDWxZcu51G1PlDhwdc6Mg0kY71UTVbgU
         +mGA==
X-Forwarded-Encrypted: i=1; AKwUvBxQ1jZcezoaQXcKlz0N6sDAROUhb0Rzn6vdfX60yYhuZGlWWlB+Y1w1FpX3EzCZQXiUoNFycbT8@vger.kernel.org
X-Gm-Message-State: APuU4Z/ah4oVbDun9RBETIHoh3cLUmiJM8fY+xrBhvyyfBcHgBpQ/dYj
	kNjBYy3ta2rBJz3NggOnJcHrDg+NYruOK+HOZJjjKBhrfMTMlNeuoebtGwOCTev8WYad0sM7+qY
	xZ2CR4cg=
X-Gm-Gg: AYBFou1SY/q5w9Ao0hStcZNMVeaO17KYUR+UfBo2l9QpO62DbCTa8EVE7fiVcdnmA1e
	j66g+cSL3Wn2OolnDt31aDOJkOZlJzkOC8qyRU2FId/cqSp2v0bnb/NiOJOTUMI92lcke+TBzmM
	9XmGvF03AMRWL5sXlOyIVyq5pWgw2UiTVl/mcpWEyCbXo3tT1iTMKpiCAJ1ky1JeG4P/MnjC+4S
	usq+2xPHNBmDwdKl4EPVr2JJIOaGYPkdPpsJchQFUUDTQVWGvpvGqtO79D1nuVo8+a2r8EGx3kJ
	jTTfzqbXRyZSh9co/mG/iI0HOh0WHQ/0HAsKp/gzm6CLyWaqjk9w9t7hUE9wkuaf5ABVUq6/bGq
	J/8+AWZ/We1Ief9LDp55/FApNqoZFjaa4mJchJ42Hp/8Grf20wTImzUMe1U7lytF+Kagga6v34X
	lT9zWIdtI+UK9VaLomDqTi8jc7IG9z2GM6uVnLGC7Zjb7zDVfXo+pw0J+1CQsIoghwTu6vnCmRD
	B9UPsGgeXe0/5FCrtH1WZ4EDgSWgKno5U2lq7l6VNcRFM9SL1XF4wU/94cxdJ3eA0FkOmcJXZ74
	ac9wt/at0mWD3vYSYxZmGHabnpMlIMJps0745xk=
X-Received: by 2002:a05:6000:2892:b0:48d:eb44:650c with SMTP id ffacd0b85a97d-48e6e309f40mr28006453f8f.40.1793694874669;
        Tue, 03 Nov 2026 00:34:34 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a7d1sm23718452f8f.38.2026.11.03.00.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:34:34 -0800 (PST)
Date: Tue, 3 Nov 2026 09:34:33 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] memcg: force charges from reclaim before trying
 the limits
Message-ID: <aumcmb9iBpovh97u@tiehlicka>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-3-shakeel.butt@linux.dev>
 <auhN7v127jwy-q-W@tiehlicka>
 <auli2Zlf1F0tyi4X@linux.dev>
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
In-Reply-To: <auli2Zlf1F0tyi4X@linux.dev>

On Mon 02-11-26 20:34:40, Shakeel Butt wrote:
> On Mon, Nov 02, 2026 at 09:46:38AM +0100, Michal Hocko wrote:
[...]
> > @@ -2789,6 +2779,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	if (do_memsw_account())
> >  		page_counter_charge(&memcg->memsw, nr_pages);
> >  
> > +	/*
> > +	 * If the allocation has to be enforced, don't forget to raise
> > +	 * a MEMCG_MAX event.
> > +	 */
> > +	for (mem_over_limit = memcg; mem_over_limit;
> > +	     mem_over_limit = parent_mem_cgroup(mem_over_limit))
> > +		if (!mem_cgroup_margin(mem_over_limit))
> 
> Second, !mem_cgroup_margin() is true at usage == max, so a charge that fits
> exactly raises an event (unlike today).

True

> 
> > +			__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> 
> Third, we definitely need a break here otherwise every ancestor at its limit gets
> an event which does not happen today.

This is a separate thing but shouldn't we actually raise the event on
all levels that are over?

> I want to keep my current version.

OK, fair enough. My intention was to have those two parts closer
together but this is not something I would insist.

Acked-by: Michal Hocko <mhocko@sus.com>
Thanks!

-- 
Michal Hocko
SUSE Labs
