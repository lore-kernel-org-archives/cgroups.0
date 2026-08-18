Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E64537E5E1
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 14:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787063394; cv=none; b=ZOFmipNED/wVEWJ3tBNub0FZ4vAugZMLIxU39NcQI872xELATynh3fb5K8v4yC8B7iYaGnH8yGfVeVaiZI67QDsOU4Mij1Evn8DFMT/KCUoUm6xEAKSWRptUi54ow4m3t/O6LtAwKcrm18qDCvTSgrI49Axlyg7z3pGlTxpd1Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787063394; c=relaxed/simple;
	bh=Nhk/TpmrrdzGGpQVRKKiJc+WJRrpAIFK2udf3IVnMPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u63EWIwEFtSy5lWl6QEIwdxb0Jbacbc76O6Aflb7Rjlwyr6LJp5oHfg3R4DSSYUKEvsy+35ZYAH6KN9B8uTjxL5RUZkz3mIfJQue7hi6l2wweDIEfFIAG5ldT0q7KW4z6yzEYTdwJ4zE/PAUp9Cvq9kEsntV7q8a86shF0u/cSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Zbcb8Rq+; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zbcb8Rq+"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49558ce01afso36460365e9.1
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 07:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787063391; x=1787668191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d7NrMCatC8ufvSDl+4wuR3/sLG8+OS++07jlkcNtqeY=;
        b=Zbcb8Rq+4Hltyos/V26v3GwnBdRZbr9Dttbks+fyhAlP9n4uyzDslbCjtl/T1E3URW
         fQQ538gJHvFNzmb+XStyUe1XnTPW/x7xT1HZfZpQvHfx9Pd55YPt1NPZQr4JBW6QQ8ux
         TqzDwlSCYuuD0+xts0hcqYDLyzNaAHeacr72En9AXkTwQpg6GCwOy0ZHnSPLHQnN7IDV
         UxUD5TAF9GQfMcktV/C01527kaxRb+MWiHuTUGQxqyMrutBKNzHW02BIW/ByPvnof7kI
         cqZiFcPM571dBqnCqmeZ9obyXF1cFWs3uZ/T4G5ZAfb8Y5rupF1lQwNj3FRm4H3MAr7r
         SuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787063391; x=1787668191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d7NrMCatC8ufvSDl+4wuR3/sLG8+OS++07jlkcNtqeY=;
        b=Qbymb1DWvUURhXCbcG5pLwvaZcZZiaug5Lxf/bfPOP1zipobOEhKkz6gn6G74uC8zp
         mhr5uqKUzAOzaZQRCKPgK4Iedo3KrKm2vcq5c4tIJ2QxmIt/7ZxLpTR8MRlNDk6dRQnE
         zx+tC0EQHJBoO9NRTjhjDgQl0CVB9YBh6hKggbHMlgdYmqybuGHi9SAuALBMeyD78hGO
         rznInUFHIIg2M0EUotDj9sTiYDnHjqAdUahdDQXo6o4qcnVei4vizpxBu/F9Fj+q8DhQ
         dhqPuWWAs7XJZQKOgPD0gf0s6VsHnrq1o2rcjMoNjO6ZBQxxov7VK9z3HGYNdbOj9Hsk
         aVBw==
X-Forwarded-Encrypted: i=1; AHgh+Rptj5R1luLsqYcWR/zyXFgmF8bRYLzYwWFFnyztRRepbrE7AG6meQlx1ofc0LZB68wSrPR1sbyA@vger.kernel.org
X-Gm-Message-State: AOJu0YzZt0DWi0FZV8N0HziGz8Vl2g6wkK1+XepURZRRGHxAPtf7Nkfx
	qj9VGVK8C0qOrGe2Icg27PacPpGf1Flp4veVZJThvto92la2HNci1/8gTK1WfIxcP3g=
X-Gm-Gg: AR+sD12BYXhw9tW5jvc4z7NwhiBhl6r+6yBft1nHqOue8RmIsQoz9kD8VeXww9QFgAX
	JfmKnTw+cJqDAp+WPgcma1/ZgRDivAjpj78ZkDr6Lz0BdLpnqIGiD86hITpQNBs9kxKHxEA4YB8
	Eg0wMl+1TsYK6qCJTXTDmig7taUZIUZie+TRGl5xKDn4/Cy7yxyg0F8o3JWHxMzP5WrMfQofSJA
	EePe2lALhMTXmJSJVLPVqSj9V4O5vNmSx4THpQ/Q09qCT8VODcvwstCD+wK4qQ152vrTpVsffUZ
	y3LrWIUp6YH+HiICywiyo/s5AMHofraq+Vnq6V3ftfNVuGu9SE1U9jIHgg/cLMUeNJ+3gfukg9N
	3n41VDLKytHuyvh6LQdsA/wlKRxI8rqGSpM6SvEuZVi3amlyJ7SHlKuMvMqq3mdpkFW09rXyFNj
	lCxqMar80NR5eMhoKFoE3E16zz6s2SSLKhvaohr9ON7iWM2VG6x/y0kLPE5Xarjvm9XH3Nwj+fo
	A==
X-Received: by 2002:a05:600c:c171:b0:499:7f38:d77 with SMTP id 5b1f17b1804b1-4999fb2e1dbmr169268255e9.6.1787063391240;
        Tue, 18 Aug 2026 07:29:51 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d0876b8sm189990045e9.8.2026.08.18.07.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 07:29:50 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:29:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, joshua.hahnjy@gmail.com, willy@infradead.org,
	shakeel.butt@linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev, zhuhui@kylinos.cn,
	audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH v2] mm: memcg: release the css reference when a stock
 slot empties
Message-ID: <aoRsXafoUYxFccQr@tiehlicka>
References: <20260818130135.154315-1-husong@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818130135.154315-1-husong@kylinos.cn>

On Tue 18-08-26 21:01:35, Song Hu wrote:
> consume_stock() can drive a stock slot's nr_pages to zero while its
> cached[] pointer stays set, so the slot keeps pinning the css
> reference that refill_stock() took.  The offlining drain only
> flushes slots with cached pages, so the reference is never released
> unless the slot happens to be displaced by an unrelated charge or
> by CPU hotplug, and the memcg lingers in the dying state - up to
> NR_MEMCG_STOCK (7) of them per CPU under container churn.
> 
> Keeping the slot populated past the last page only saves a
> css_get()/css_put() pair on the next charge of the same memcg, and
> costs more than that: the offlining drain has to know about empty
> slots, and refill_stock() cannot reuse them either, so a charge
> under a different memcg evicts a live batch through the drain_idx
> rotation instead.
> 
> Drop the reference in consume_stock() when the slot empties.
> Empty slots stop existing, so is_memcg_drain_needed() and the drain
> path stay as they are, and refill_stock() reuses emptied slots
> directly.  The cost is one refcount pair per emptied slot, at most
> once per MEMCG_CHARGE_BATCH pages.
> 
> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> 
> Changes since v1: drop the reference at consume time instead of flushing
> empty slots from the offlining drain, as discussed with Michal Hocko and
> Joshua Hahn (full-stock drain cost, refill reuse).
> 
> v1: https://lore.kernel.org/all/20260817025917.66233-1-husong@kylinos.cn/
> 
>  mm/memcontrol.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..1271d390b617 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2140,7 +2140,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  
>  		stock_pages = READ_ONCE(stock->nr_pages[i]);
>  		if (stock_pages >= nr_pages) {
> -			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
> +			stock_pages -= nr_pages;
> +			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> +			if (!stock_pages) {
> +				css_put(&memcg->css);
> +				WRITE_ONCE(stock->cached[i], NULL);
> +			}
>  			ret = true;
>  		}
>  		break;
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs
