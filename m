Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F187541A794
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 13:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787577540; cv=none; b=tmaUVZyYT9IhQnx5ffqmB0DD+WY5auNvV+OH2hc9TWHEAOpq7CyKxxUgxJXr5tne6AMbk9U5V7iVH06NhPF87yOyt3TVvyUWX87l/jyyCgGWbgef+6xr+46CgaNwSNF3rKrd0RVHod2Cg7Z5DUIZJojm2+tSSp/54wRqgNyEnfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787577540; c=relaxed/simple;
	bh=8RHTXuRYUUKOJBcAw84Ji+ZmzZO1dHfvXXjiERNb6fU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUYVFL5WVsF09wKZaeoXuvOUpMMHSA3qBEHeK1zU1w3eDkBrNeCul21LXe2eirrj3y8dff+ds21D3GK5H5JFY956J+VBGr86yFXtr/wUnMf9djoIHMDgFHu15MoZ1EQJP4KrcweGAAOMcZFZDcYyoraf5e+u73FzN0ARbUFQ6Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HYA6NXXn; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HYA6NXXn"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so617524766b.0
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 06:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787577537; x=1788182337; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8RHTXuRYUUKOJBcAw84Ji+ZmzZO1dHfvXXjiERNb6fU=;
        b=HYA6NXXn3PEP73gl9xwOatTV4UNwR8HC3CjDK8MSZLjph6rsc73XvL1E+XYSzBcTHS
         Yrutpl70LJzJJx0PghEGd6IJQBNfRj+bJ/G+EnbKN9kWRR1mAA+mKWe3rPh1UDanYxTu
         ecaMIl9ehCR8ERg1UjQru/RzLHNX01/lMrfWR/Xx4v/UnaZr/RdsGrQGHroQly/aJ/hw
         cBYv0JcTyQbv62/s5ZOBlvHs4oca1S282N4U+AM4BftCtmb00B+3KFxBrvAnGmWCG+85
         eqR50CM74PHXanyzjiuywr8lI/5aOCB3Bqdk3pMFaly+oxbh6jycL0IL/FVgRsvGQgXe
         uyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787577537; x=1788182337;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8RHTXuRYUUKOJBcAw84Ji+ZmzZO1dHfvXXjiERNb6fU=;
        b=Ot0l2AtDjcAgP8CkoFDbIPnpxkRVW0V6QxzLBusc7muRoC4uRQdHEEIHw1m7EE09kg
         wBFVaeJ47MEeb4aRbhpkWkNm8twngKKkaZ/AAK251wDUkUdGaycHkEe++oTBbjouiKpG
         A0pdP+l0dHGAHyc14Fe6ZCpdcBdGTJsGqF7piOdoOf245J0uN/X1CzAjcbqnrwEKrmjf
         ked0OpLcySngTw93tH2IAk9WgIoMNdOhu90zrTmZlXcFiBEul+oAyJE/S7ICjm3hwSJ0
         T/9uLB+in3eeWgDyHRmsyBo5gBpDYLOZMKxg19G+KzZhDQuFR3VP6eSD7jx3IE+iGC+T
         B9uQ==
X-Forwarded-Encrypted: i=1; AHgh+RpbSJ3N2nTG+UD7PKd7f/X8loWrCJku3SF/mzIwfsypxH4gUpS8HB8g8L7IjUzj9rMUF6GEJD/y@vger.kernel.org
X-Gm-Message-State: AFuF++m2FpR2qZcn3Oag+Swl3JgrB4EdQ9WnadiunCy+5XutfCWENzEK
	cl7uoXsFXefX6a6kfqvMY3mWKVMLgH4C2mNAZiT4/9bXq+0DdiDTZn0i5haNQQzwv5g=
X-Gm-Gg: AR+sD12ukKQwo0Cv6HILmAxQPUH0Zk2qWibkkw1ErhPgILjZ5SPRdHbN9UCVA9jy49C
	/rSGmNRyUxmsfCgHXwGWkChLN7cF35ECtWoV3VAyezWuU27SMF/WIQysS/xuZv2OX3mk+ObMb0S
	GzUFNbodJobsWeg28nDGP0zRXkqDzngu6E+h+wvYgHqRuFbxk77K/Dmv5Sj1h+D99caxJPf7Qls
	HCtGR65dreNmMfMH+WolDBrgdKKttTwocEj0Wh/8pCw0v21QbGseg70j95PLPLs/1lbcZ6/Nwat
	4wafwm2VBQE5ELoCK/IPSdGbL6NsRYzkCx8TglswGa0YBKPnxnoeEulZHo7Q31PH+JZU9fMmZCq
	2kiXG5UI1r17SJAJtCqdpooOIrN6+C7CawcDXOULaxoKlfMLifhsmJgjTt41tPJAXHtXb/so4CB
	0ls/LbC3AzKKAOHUvVSXs/pNbBamBJKCCzY/GVM1SifcdIMmXvH1uamTRFE4aO84E=
X-Received: by 2002:a17:907:72c3:b0:c20:2d38:e518 with SMTP id a640c23a62f3a-c249238c382mr2130827666b.2.1787577537181;
        Mon, 24 Aug 2026 06:18:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24dfd91dd4sm20165366b.16.2026.08.24.06.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:18:56 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:18:54 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <aoxEGzZ1eVzIU8xH@localhost.localdomain>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4jd5dcmb4dfal7fx"
Content-Disposition: inline
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>


--4jd5dcmb4dfal7fx
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
MIME-Version: 1.0

Hi Eric.

On Fri, Aug 21, 2026 at 02:56:52PM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> Finally register the per-area usage counters in the cgroupfs. Each CMA
> area creates a memory.cma.<area>.{current,max} pair for reporting and
> limitation for each area.

These areas quite resemble dmem regions.
What is the relation to the previous dmem double-charging [1]?
(Successor, alternative,...)

Thanks,
Michal

--4jd5dcmb4dfal7fx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaoxEuhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ai6WwEAt6IhJ1j5eKMrYIQuXx6H
vcVhIKJYy4uCLIiKXOf6/zMA/jVVm1UxH8BKR0Myu49nuRzoWqbLCU9ie1WLGOPG
nZIA
=+xTm
-----END PGP SIGNATURE-----

--4jd5dcmb4dfal7fx--
