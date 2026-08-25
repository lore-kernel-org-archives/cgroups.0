Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40323431E3
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 16:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674497; cv=none; b=XHXRPR1aPMLupQ6Cisr3FUoFZpKWM+CLKgBq7OHbwB9rC13aYT3lA90wx0erN1TgrfaABQWD2E10U4hH+ECv6L+6FTb+HwtY4MClOsqAOsOWzwR4Nai5CzRoQ0taocI5Ju7DJN81PtlY7PAeMCW1nFkEj3k6fOt969+Ot0k0PMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674497; c=relaxed/simple;
	bh=GpM8ASnSFiVcBDFxVqOdzWow5DVgYn8Bxd3d9ZX5sAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXK/Jf8bOtLQkHyG510xVPL0CxGFqLp/tOW3FR/TYq+XQVZ7xAnQo0nsfZugfNJPKbcCRNUsrZtXSF7wDq3U3TIM++a2p5xB094FXdyExdZix0i8bjPHgg2dnSx9otbq/0nFY+AxYw1qyDsxFBi7T6rQ0EfXLeakYn77bKw3V+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RwySpcLH; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RwySpcLH"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-90cabe38a61so18536666d6.1
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 09:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787674493; x=1788279293; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1YlH5b9PYM7jA11GCLyb7iWudl/SVZb5yXn2BHQRSG4=;
        b=RwySpcLHfZZCAwSTCy/RmCtTQ8pS873vZtDMg8qDQL+FeD1o6ybd2ssWOdFp+QMFaE
         /lB5nkQAxrxQDNVWuJ9GIE0Ny+XEi9dIjY5TGEwvjBJ/nkeN/INo0S4IH5momiJb0VQt
         i2KVQQItZRIEVm0DdGaxvrMXO9Ede37qfkJgExpi/4e81qR3Ebr+I/Zu/CBCOwc8ZxSo
         lcd6ZJHfNlx9y2FDFWr0IC9BQiLu+CTXHq8SubSFj7NKoL+K1AdzChwPwmfJBTqpw8NJ
         oFR4W5ecwWjG8mjg8VTUgv9UjIYt7VFO2cIG2JNJeTGVH30XY208o1mUNWtNBZaUyYTf
         yTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787674493; x=1788279293;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1YlH5b9PYM7jA11GCLyb7iWudl/SVZb5yXn2BHQRSG4=;
        b=rOxLbQ4BsRax6GoW52bd/Yu5k4eS6IrY4XSnpyMAUj1Hf5GOatFFktlplUow4XwTw7
         ZtOQQD5u2lq6obu7Ex2h0alJJb1NhqHHY1gYRsx7crJXni6dxYY4uXHniKJhSFOuOlOJ
         kY4G/eMvVfNg1HBsacvKrBFH5iK6uSvHU8Extou982ZsboaJPR+Y80xlI6cVoL2rW91V
         wkklH3Uth69XpF/0eB4VNueGDoZ9Hy5HgyZGKNPzsqqi2iqQipkGfj2e5bhN9fkGQqYr
         h6I63KPpyxjsMUrd4BLwiqvjBkRqCZmOKx5bZuNwS5N4FdEOtWsAVcCudTfwdLQ2Tkmi
         BKNw==
X-Forwarded-Encrypted: i=1; AHgh+RqE4JvekDtj7ZzXPAvfx89SDRVsW5/GM3Z55RvjQE6EYnK7X3i14WV8+xbbo8S6dDJ+TJo1ZJNy@vger.kernel.org
X-Gm-Message-State: AFuF++mODxJyukw8eqhIdhz4b/PapBP8BFbMTZ/msZrX7Bf9nRpjXROA
	Uin5ozx8NKsg71uGIBsktUdj02gAVTftP2M3R4cLgEzfdiu7Vfy7YN+ZeSHAKVNzwgA=
X-Gm-Gg: AR+sD11SrvDYc2H/Ici0c2a5CWmMTfzPAY7Pjxhkl0qcvLtQDmo825Fh7rEJOyj/MRm
	SJBUI1WL28gAN1rs+69B05QVgWZ0Mua8YGq9qKh3E4OI5QKHKh8JoyyLXrOpBQtCYFmTGBGwVoM
	+ddzTYehZHCiasSSINPzbyKsWKF+ZgJiNisj9Lxfp5JgEJyhZ5WeD8k5wgp1kIdB0RdjkcsIEmF
	4YYVCh6doT4v6jnlyoQnOnT9kpGxZ89S73iQ6dGJS6fK67cjVKqIUWqAD6C5VTraOkr3PloajmC
	Z5f480GqBOkxWdiSSjcO8m+5ep1d2PtrQ8awRm+FBJox6wwaS45xxY3XAhG2ZuU3FpMIeTYGB7/
	LnH1106LBQf/NOBaCTUqh0JPks23gf2vzjvzRXlzZXS+cKYX3YmfpHxCxFztBFfsfqXbjoAEIIQ
	th6Y0LGWzDU3OvssRnkZIk6vvZuqAWs9DYhWbFhtSORRiuzU4t8jM46Rk1Fi7bQZeiX7vIpKDKA
	N8farUzkEgRtWrPyBcPmqCOjcPtPxb3vpPMKQaMj7nJPzsikgwnur8=
X-Received: by 2002:a05:6214:3114:b0:8de:25f7:98bc with SMTP id 6a1803df08f44-90c8fa2ace7mr324838386d6.22.1787674493270;
        Tue, 25 Aug 2026 09:14:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc63c68acsm2381676d6.10.2026.08.25.09.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 09:14:52 -0700 (PDT)
Date: Tue, 25 Aug 2026 12:14:50 -0400
From: Gregory Price <gourry@gourry.net>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: remove unused memcg parameter in
 calculate_high_delay()
Message-ID: <ao2_aYpnxsmux8p2@gourry-fedora-PF4VCD3F>
References: <20260825120153.1405-1-hongfu.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825120153.1405-1-hongfu.li@linux.dev>

On Tue, Aug 25, 2026 at 08:01:53PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The memcg argument of calculate_high_delay() is never referenced in
> its function body. The delay calculation only depends on nr_pages
> and max_overage, and both callers have already obtained max_overage
> from the same memcg.
> 
> Drop this unused parameter and update the two call sites inside
> __mem_cgroup_handle_over_high().
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

