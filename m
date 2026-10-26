Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793021149;
	b=R+peUrup8AOUvLNxHMOoAKPdsnMRTY/DtJzWmun5E7n1YYvqcFbW96f4CZfKcEgG7oR2
	 SK84RV626d1fDTkBXjuSkISChfjsEg7JX5dqQV6FnrYdrgPree2tkyF4Wts3i1zupwVBe
	 V/aFCbTWA33D/FQdXCel/589TDrbB/Rw9nZxWrvz+t1P+kfJ4E9E8yAm3mG7ot9JZl1OD
	 kZqJ/f1Kcl0s09VRMYqDwx/Xww2msJCXNFyhWCBhMjfIclqJHB0BEEQ/cHSEldBOpwAj9
	 C8ydZlHd6ITQa/9muOCiT90KFyPRKhX+fIKm7zgGzkQO0WUhdIbPlYVbbXaYc0B3R/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793021149;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=JTZ/P1YmJ6IZNJ6lk8Cg6Zigprwxb6S7rjKWG93e8pw=;
	b=umJ+0AmdjWcfioS14KXtcF8vZknoULpIT0wxWy2n5a203KSAGqqA08B9OqGiQPxTkINz
	 Tbe3VJmYgIu4lo/yafT6u7IRbxSZ1N6MNqz5SE/h/VZB4+vKyl2WQKiehicER4uvSPkBj
	 zkC3huZElOulGnmM4Ngzw2CACCmOFdTgxV6ZfefplqRy0S1xZn01oj2/VDRqkoz3fagg+
	 Oaf/OFUn6hYYVaatbdLX5AO5YheIgfT4M4TbbT3Ffh7bYI9S8jBASQ4E5hq0RIVt3eErQ
	 E7VBPb15btAp0KZJuCmlwWRKdZBTLJFcmXb/JOnMJmEBXV7pSYqLwvYgm7o+SXgWTpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=TeC2FOPt;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1A360A2603
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 13:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A1A360A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=TeC2FOPt
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso16789195e9.0
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 06:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793021147; x=1793625947; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JTZ/P1YmJ6IZNJ6lk8Cg6Zigprwxb6S7rjKWG93e8pw=;
        b=TeC2FOPteMhC84ln1XNPf2/uDi0Y1HNEWRFnSOT7TjP9dCtOt9flZwVcpmIH7osh2S
         f4kq+T7b62JMHP9bVv58rt7+W8RN6vJjr4iPpVcodn4j+Xk1X5eBtPopddvTzpYIsxMK
         3FNdwQjuoyg7XvmkqvAeADWLNLzjC0zbNgoNVN0+cfAwltOyftmC81rBukPkIweUTb4+
         G58Jwu1rTaOAWIIl5paP0+PKvr6+i4oCqNSjkpI2Q+g1OyB8CE1k4Lfg2zM+K7BeIy/2
         RRWUX450SDMx7t3w1AddmhUBy0E/491GGDHDYHDoW5vOcuWcMDODhYjAqqZKC0e5unWk
         G7HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793021147; x=1793625947;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JTZ/P1YmJ6IZNJ6lk8Cg6Zigprwxb6S7rjKWG93e8pw=;
        b=GQ0eX7TAQ4DYp1GR/4RRmPg5B+3NzG3DygmIA4fOnmR1W2+aw1RNKAULImnkqlZFss
         NojbOm8k+QYPBgOND+pVp5PI/Dv8We3jJ1kw5yMXr3oi/oBNeGyr0wfh0uoaUY0Wpz2x
         Ir6/O8CIEu3D2zJ6RKi8R6q3Gy4qhjsB9AHoH13l61wDalIN88MkGw0WTq9E7DDBr+jt
         B1nWDS/PuIPgoZK7vKjEtC24qFqM3ryj7IoV3fM5qGUx5Tzx/AY/4syYugQAn9In9qaC
         uhV06yw4YjHV4/HPFxFLilpC2KL3R7v+0jtWbp0Dej2273HE1T2mqM9ELEuXICjAr2Hh
         jKmg==
X-Forwarded-Encrypted: i=1; AKwUvBwZc4+H8ddOpdYVVQ5Up5+0qF9sp5ewnmLN2RLkr6Mk/1y4ktZmUR8FLAT+VRF8jVx4MVhiiyaG@vger.kernel.org
X-Gm-Message-State: AFq9FYLt/6paKqsfkZAE/Ps+aJmmrFkD1QJ6f8gWSMa2e3JwoakcIvSp
	Aw0MNEumuM5R4raSWjYLJi4Kx4RKWf+0a8mx6cLxRpJcGWguv0y72Ye3PQknSbCGb+Q=
X-Gm-Gg: AYBFou3C8x0awiy/IJxJpDeCU47B+vldZ2fgAM0pAhFBL2TXgEL942Se3aXo/tf52cv
	Bj5bA4GixO97W9tqS0E3fIytaa0bx1p49GOOrLMLuC06oEckztYn42+qaBaWSfCEuPMAQ++8dCb
	fp9wiIIcy7JtWeFtMrFmnijc0c+Qe2BEXIFymoLk3zrHh7WS8MuNZabVfIip77RMgG25uG+01KY
	300l+P4IoltbgSenJCR7ifKsTR/QjsmeiWb6e3lzjWoLadGBSyQUJsQBwAdxAvK2SkzbwdDZmKD
	WvJ3ZEo8bylNNBnRodF7ZQYMn+b6pYUpk+qOmNO8+9F7y4HR7tIcRMYdfShQkGtEqTpmh0qU94H
	HwAZVt5arl627Q5lhUaq2Hpr3BxlwpQd0o2W9yJqGcCU1sk2GtWhG68hXSTjtfPDcpoHdUSZsXB
	Qi2cDLgWfIJLG6hEs/FaSBzXjpuGJd52CaeUIi9bM7f26xonCeTMZlrz7RHujP2FFU+CAvTEtuv
	6Ro0JvYHigSpOMTTRcW7EiQ7zdaAvoPf720/1vssOHUeKqYNqJ0f3WqvcrFbaeu5hrinw==
X-Received: by 2002:a05:600c:a306:b0:4a4:fc8c:cfd9 with SMTP id 5b1f17b1804b1-4a4fc8cd1edmr72049405e9.25.1793021147467;
        Mon, 26 Oct 2026 06:25:47 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a30e11bsm232464125e9.1.2026.10.26.06.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 06:25:47 -0700 (PDT)
Date: Mon, 26 Oct 2026 14:25:44 +0100
From: Michal Hocko <mhocko@suse.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	akpm@linux-foundation.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
Message-ID: <at9U2HvyUP-iYOCt@tiehlicka>
References: <20261023222313.3979455-1-tjmercier@google.com>
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
In-Reply-To: <20261023222313.3979455-1-tjmercier@google.com>

On Fri 23-10-26 15:23:13, T.J. Mercier wrote:
[...]
> ---
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b..84f4a8fd4d16 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *work)
>  	struct mem_cgroup *memcg;
>  
>  	memcg = container_of(work, struct mem_cgroup, high_work);
> +	if (!css_tryget_online(&memcg->css))
> +		return;
>  	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> +	css_put(&memcg->css);
>  }

OK.
  
>  static void high_irq_work_func(struct irq_work *work)
> @@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  
>  	page_counter_set_min(&memcg->memory, 0);
>  	page_counter_set_low(&memcg->memory, 0);
> +	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> +	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
>  
>  	zswap_memcg_offline_cleanup(memcg);

Should we simply disable_work_sync when the memcg is going to be
released instead (mem_cgroup_css_released)? That should both prevent
the run reclaim_high during the memcg shut down and and also avoid
plaing with limits to work around.

-- 
Michal Hocko
SUSE Labs
