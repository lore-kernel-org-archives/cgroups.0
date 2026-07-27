Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957DA35674C
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 08:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785140212; cv=none; b=ayd5+2JoKTNa5P/zxrZ2ndjX3e5nBgL8LFV/BH8AWequ2SyLAtCH/BkAgUASWfkAn/mLte/v2ig5xa+qc8WGrCmWcIZdln0Pc7MB5mzKUAuBjMtamuJQFfGqQU/N2m9HhHcUOobq+bcDYhp5mezZvW2ZUyBolk9da6B0NZOdYG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785140212; c=relaxed/simple;
	bh=R8g/L6B33xMR2Lh/73FUrIpMISh3O1GDWuYaktK8AIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CnRswFe7/8sD91JeiOxOQhpDTRqCzK82t04x3KdqDNziv/jYkVenhWGXEwODcJTNU10tN7gSMRVT8AOjiOg7kuOVwp37iWQ0x/C93mI1Cywnj5L56RgWI0l8F0dxnSXN9rXuLUJdsmsN2XeJwpHIgGmV/H0p8BC4U72/muYg49k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C2Gw3McV; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C2Gw3McV"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49548e01d02so11916835e9.0
        for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 01:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785140209; x=1785745009; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xyS0tG8v2Hcb4VXfsGP6gPVBE+5XXuuxqiihsyJcIEM=;
        b=C2Gw3McVNt3CpfZsVAIXBdVin+uJznMxRtwH+iLu9Cyam/vb0qjQlu9H1/bDATarXC
         7BNUfxAfhNJWx/e78VSutBMSXqUCE3AZpBsslFnUIuwXBd6JpsyTYNK0HPUN7V2Tn0kP
         VLF5BoTWLKcVLeIEPi38LymCjbKXdQq6yydc1aVn35T034KqRUIthySFS1uDmtCjYejP
         IHyFEzk6VvFpS+OsbtaUrpxVZoG+Z5qQXJEq7nBAqq5HMS8I2qljcPgvlUdas1XFOZvG
         ck7ippGvlnqaniV4RIczKnaoO3JmMZqNiGucgpFqk6NioVX/Dq64zS+ZWyle5WVYZ+C7
         jdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785140209; x=1785745009;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyS0tG8v2Hcb4VXfsGP6gPVBE+5XXuuxqiihsyJcIEM=;
        b=H5dYUuMXwNJWysXOKFEZOEgFFt3Iq0bKTMbRvUmT+uRmw3z5CKFl5sPkh9cplwFZPJ
         7wK/D4iiIzhkedQ7k+ku17XqmhOfkK8KiQl1YM5lbdSn2zX3WPkPAuU+XK09z1OfvQGC
         H10lFUsolNq5wikpaqkeaJAQFLLVLvK6/Uj+vdvjmIUseaSk2KIDCEdAdCio3ruO0nWQ
         uVabsfJvABFjQ8sxgj01GUzJxHGhf8yyrynWoxyEOnuDKywTixcHEQhRQGboe5DPlU6h
         8HrkoUxbcZMm8IAb9AQ/bghMBFIZdZbU70A1/iVt04o4Y9B1jlQRC5II87PpEqtmMKMb
         ymYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rob0eustnYjD2hkrEXLjqqTbt8cSgAaifCXqnfJ3K3xV6OD4M8gMd0XZGSp7bCF7aZXg8KUGtYE@vger.kernel.org
X-Gm-Message-State: AOJu0YwGcTj9Jf40t2AUZfYwJe12A3TVBwJYzLP37p/ZzPFqL84EGEIC
	SWS0XsOxqMu82BuXpTt3fBuGzvCG3KEY7/MV2NQOAo2wCP7HE3uhpU1tgfAv5+KzKKI=
X-Gm-Gg: AR+sD10t+HcqMscrb77XtUxjgMFiSCsGN+C3uy+ytHMnA5FA0kmaQDE50y6QmYxyfP8
	cKc4WikyFMLM3iCsQjjByUbd8iOsrg3cVkSMejG5HysX96cwJmQR6/jHcraf4Jjs6uzB/zttee2
	c/hS9bqcpnknljRxHr4ygl5L01N+V/qqMHXSU5Fvxla/Ai72HNWghrxzjPv6XaB6Kq0VMItLDyB
	TpGBsDYjhn0OHydRwh1EIjoBlhID9YeqL4sgoOQOpnqW9+85DPPkkOIikhiJWutLnp3t5HmyQ6K
	THLzpXli5RDr6dhh1yrpBZDnZHfH8OyRgDkW2A/tGF5+3KO2ty5jsrztHfT4toQKRyw6QsaQDjS
	VbNxIj9JSZyqKYF3rN0vNF0+MVvbjkb0GdEmEK2kOtgf52qFgCTQuJAORwjTlZ86TCMlLObq9J1
	Vm3Fvj3Wozpg==
X-Received: by 2002:a05:600c:1f8f:b0:493:bacb:1341 with SMTP id 5b1f17b1804b1-496b5710e30mr91785715e9.4.1785140208888;
        Mon, 27 Jul 2026 01:16:48 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b52eec24sm196028765e9.3.2026.07.27.01.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 01:16:48 -0700 (PDT)
Date: Mon, 27 Jul 2026 10:16:47 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Message-ID: <amcT75pLmA0hRUm1@tiehlicka>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724021805.1234583-1-guopeng.zhang@linux.dev>

On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> kernfs serializes file operations only per open file, so separate open
> files can update the same memory.high or memory.max file concurrently.
> Both handlers store the new limit before synchronous reclaim, but
> continue to use the writer's local target in the reclaim loop. If another
> writer raises or removes the limit, the first writer can continue
> reclaiming toward a stale target.
> 
> For memory.max, this can leave the writer looping indefinitely once
> reclaim retries are exhausted. The OOM path sees sufficient margin under
> the current limit and returns true without killing, while the writer
> still compares usage against its stale target and records another OOM
> event.

The current behavior is deliberate as described in b6e6edcfa4056.
What is an actual problem you are trying to fix?
-- 
Michal Hocko
SUSE Labs
