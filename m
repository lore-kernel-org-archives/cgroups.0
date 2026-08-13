Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDF13939A2
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609518; cv=none; b=loVrNY0kHcr96XCFJTrhmPLiElfK2b6tqq96VVg++QTSUx0dLm5krS9EcFD1Aeu9mgtHSKEYikT4LV/vMzzuI7IgJhPtasQBiu/bqu9hVz2KbC0Mq/zxHSAJqrSJu1jbERUbW1n3b+q4X8BBfhhXMYGxPQimUgwMcbtOpzQ1rA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609518; c=relaxed/simple;
	bh=NjALtO9A7T2OuE96iL5pbuUkc0VJxBZyarnLTDCj2XI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLBV0nVStiwstjqc3SUZy8GFBbnv/s+MgSDYnXMod93EW6INAJfq7s0S+Q7UxcRsJMVU+xqQwcBvng5Hs5boEQCaDXPkh9I0EIrLMN4wI3FyegoZiz/SNhbt+SiPIYC5B9/wHMNY5eGIGb5ZrKXJHML53rj6Tdi06SC+Hj79a5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XxkwCtvK; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XxkwCtvK"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47362928f65so1486313f8f.2
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609515; x=1787214315; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+1Sq1nuPok8oUtWOy6Z4ORV4YbR/KwkOamX8x9tcNTI=;
        b=XxkwCtvKsbkmasNb2kWQeH7qQd36jfxFsTiPN49GbDPXMnaGYt+nZhyi5im9RKEfOA
         WWYCQFLilM54mXy0NyRDlSlwD5nTMcK+bspcHDMTgbu8W7wX+3vUqldAXWgJuVhYcL2y
         qbR0HcVFErEvwpnET6EoEJVuE6jrm+REZeAt6A1FcJD+/ZkOl0OlFnprm1lOaW8cBC/D
         fGGIxCzuX6UwUkIAPADjZTHlFadZHsN4Xmqv6QbDbsIp9Y3L0uzWcPSXDRPiKQtreZmJ
         mGpwHkiP1m2hlYJHplBxkd+ReGQ+51Lr1+kGh4qQkLnohfXmswwoasGakjTAcOVBRZLM
         P/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609515; x=1787214315;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+1Sq1nuPok8oUtWOy6Z4ORV4YbR/KwkOamX8x9tcNTI=;
        b=hxlteV2qwV1RzePTje1aRb093gO3qDMuQG5rGXP3gJi+oCFnhC//Ctlk2XzKjfUi7S
         VqbSjj5XxOd8zXzSxT/2H/7SjkwR+dYna+YRFds+9kP7il7VBM5efhs7Fe5pGwqDA05v
         XGukVLEq7U76WlyFg/gGQYaV2UwlpY8/w7JgEQsANWbtELDI9zLZ/kQE22X9bV0MUlSa
         JAnMnPTD9E+WYfEsw8bS47H85AZIX3vtjw2mottbQq5Mfp0dVMkTQdsOYOQ2DdSHSn/w
         FwL+l6qvG01lR+FRd8fQ2Rz3BZskhjARSTQHuVhZnnYLp+Zw6elcavtC06Rjam062db/
         A5IA==
X-Forwarded-Encrypted: i=1; AHgh+RrataAFbI+pdVfo2jsytWi2xXK1PnyTx6I84EQmpPsHPadrT6l+ofoBpr+iskQxfg7DGsAz4DH+@vger.kernel.org
X-Gm-Message-State: AOJu0YyWLtPVKQ/hg5g0kwfADVXME0qLElofGliheI3vbT/lCaHC0fEn
	ot3hSC8lb34I0yn3Udf3k9anWcgL/v84V4FDN00K37OE1QZrErVzFrMz7j37orMh/jk=
X-Gm-Gg: AR+sD11x3ZgF66b+Sk/S9+Very3e0RVDpPTCi9cCYvvGHH4HwazKMOhIKlNYnTaHm6+
	tJt0Lf0orB/ZuO2S7FT24iKF7JJW+7la5HXE2ezPbs17qXSLo+MCRYQ6PBcUFhOSsrnvdM7FHsn
	83OwC//aWeKVQL9ZXDo+UvjhxyK+I6VgPNpjwln/e3FWcnmrFNtLRVQ5JUCxrj/R4oNIgnH1eZg
	bSfYh4nS3CEJivcm8GWpk8Qpsf0XqmuNjcCi+rAOjAJyc4AThIEIPRJVvuGfpaOkNvILK9qfi0A
	W9MoxcDOg4xvfi95Pa0ll1cFiOPr75UIWIDrDEwKEoH9hTqic5+U2RN5aKk2Zdw2q0OxoHZfHot
	pefpkPr+bgqHq+8QHRgzxPj0LCeyLtXE7RB0Wes1aOHSnWxR1u42tRuAy/USALLZWDwNtmRbzTR
	goZaAj0b/b+ZcnfR7Bi0SrqFrWvjohy3fojvvio4nduWKi2cn/Qtld2WqYuWq4gt54ZVT0t8cax
	se96wZ2Ww==
X-Received: by 2002:a05:6000:260a:b0:481:57f7:6015 with SMTP id ffacd0b85a97d-48159cbe165mr6521901f8f.6.1786609515628;
        Thu, 13 Aug 2026 01:25:15 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af191sm4534225f8f.19.2026.08.13.01.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:25:15 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:25:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] memcg: remove the soft limit reclaim tracepoints
Message-ID: <an1_amxUpeVU_ARo@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-5-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-5-shakeel.butt@linux.dev>

On Tue 11-08-26 13:31:58, Shakeel Butt wrote:
> mm_vmscan_memcg_softlimit_reclaim_begin and
> mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
> mem_cgroup_shrink_node(), which is gone, so they can never fire again.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/trace/events/vmscan.h | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index b4bf7b8def1f..8a872990b4be 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -214,13 +214,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_be
>  
>  	TP_ARGS(gfp_flags, order, memcg)
>  );
> -
> -DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
> -
> -	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
> -
> -	TP_ARGS(gfp_flags, order, memcg)
> -);
>  #endif /* CONFIG_MEMCG */
>  
>  DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
> @@ -260,13 +253,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
>  
>  	TP_ARGS(nr_reclaimed, memcg)
>  );
> -
> -DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
> -
> -	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
> -
> -	TP_ARGS(nr_reclaimed, memcg)
> -);
>  #endif /* CONFIG_MEMCG */
>  
>  TRACE_EVENT(mm_shrink_slab_start,
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
