Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792549590;
	b=qzrffq4aUZVoJmN8D4RuQxt3WeUaC/TzpoPiFjve6H+03W6LfTtNbWLsyOaDEPPzgr1h
	 JIQ4k4TNOgx20EN65iY4mb4WBHipuIGmIO34KJSSO6zQDR3ptOVqWDYNnmePDhRVM1NLv
	 GZ3V7OmfJcUhCfVqZPrulq3AUZiQ4DgCAMVZry/6e8P600Kc9l6VslFXlEbGgdJ2H/7XW
	 SUkr4/t7wMaDgNAbYldsIOx6m2Mu0PyA7bPsClEsrg1a+ovT55c5vmbewuPiTHA+d9Ct0
	 LHwsGl0hdWePmtPqgndZ7+OZCGFcBEl8QWTPBecLJPE+lveKKJyRHDYIhBfLEz6oc1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792549590;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=qDdiu7ls9XDQIfTHarLgal/BKccCKhlDZU1D6BhXGx0=;
	b=I+wbLD9jtwmcBKFSrY9b3dPVaef8NFVWRrqbtQtDIhiY4NyF9b+P6Y9ovmXohpH02zkb
	 l9e25K+WcV1ikA6qoYN0/2rRHm0rSLDtG0Qx//GZP9LpNadUG4GaT/hJk/+a4QtCixcbX
	 3mr+O1SjQoIUR+Gwqztzpn8ymsXgXhywn9fbjAhxbvGFscKWL8ZBaNV8vgrBm6phwmY/2
	 1qtwOvoV47EvS5Z2IEZAEw52P1Br6CQeUF+AsLoz9W4cFQy38LQqJ+Qlz8JsqX+GXlbpY
	 YB/vsVdraSBCfwcKq4K/6XQHWoI1XeAgk2VilasM8SBb33Val4exS1IR4CnaSdC9pUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=WhaA0OJl;
	arc=none smtp.remote-ip=209.85.160.172
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E6A606A31D
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 02:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47E6A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=WhaA0OJl
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5365f9a04c5so4482601cf.1
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 19:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792549588; x=1793154388; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qDdiu7ls9XDQIfTHarLgal/BKccCKhlDZU1D6BhXGx0=;
        b=WhaA0OJl7jf8AS6CHRCl5npa46++WEicQwXYsexkMoPKqw9Q3h4kSIjeveOEPtOeQI
         jaYgiB0cl3NQJHu/keZ32MrBc98D8b4oLfT8Y6wNaiAe4UfWBuAToFWagfEGaxnddfEo
         qu5q7/qP6mmcY2TvC5vR+ByQUN9v7Rda4N5bBRjJHQTmuEfcxPtz6L8zqEu6y1AIChe3
         p3OgT+oiD7wRnr+UKJR08zq5slkVNPdFqXF3v//bXbAqokrcTz20l3opU0VcKVFOcRX5
         nUz0Ccc8hFuW6zQCBOz6lXNCEZGINN9h7Xrab7SHL4+NEFGXvv9ohf9eKYSs8mgT7FRw
         PUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792549588; x=1793154388;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qDdiu7ls9XDQIfTHarLgal/BKccCKhlDZU1D6BhXGx0=;
        b=iPHWVAg6mVZAJE+YCAA3MXzv4m2o3t95L64AtfkljpxyUh6P5sKr/xrUEDHlUCMhr+
         MEjAwcGJqCik/AHjTfkTeudQJX5NIApFlN50a4guVE8izmCWvEeiYRYzYwf4pvO4HeBG
         AZWs7Ra5TGU3VNCFGOAiwxD68kFyRp2mnoEU8g+m5KeFP0UdoHPliTpdX5VngbNvGDa6
         xo7KM1QXDCQf2Kw12PDTt2gV70g/SeYPk799Gu/dTCbipD0xjoNDiece5qp9JpUUhUMX
         n3oelZ+qqKz88wn+hflPkwgsYlfYiuOn1pFPkeQzDB0RAplYAxXRILSDxzXghxtztyDu
         tKoA==
X-Forwarded-Encrypted: i=1; AKwUvBx0svcSVPvcEVjAf3h1EZQ3KnB0xaCWIJiJXjDIpv+MAlEIyLkXwzVrELqjhaqcAgNbwPfP0HzC@vger.kernel.org
X-Gm-Message-State: AFq9FYJgxbzmQTVZB4KStvw6w/UeuPtCRH7iQtIHLTnbghKBfiYWCYRW
	FxuuEHv04h+x1J326b176DaMJNMjg69RsKYD32/UXnL9WgfsPEW156FVNlCLkLWBMXg=
X-Gm-Gg: AYBFou3xVCo8nUQ4+1fFDH8mkX8c5KPnd9sla/YJfp1H3tUdlw5I3QGnXhWRcPsFt3p
	id86tRZjwRFhrTgyJdWbHbtaZBIQ23Sjvg2MB56pysI2lQNb5SVHKRdbj7TgaJVOgcpRXz2SadH
	aMK+wwLANOrerdRnsG/NS3q72+/K4hQgIjWrB6Tet8AxGlEBZu7RGrPwSi1LOzqHacvDtZGmy2G
	CSMCXZzcWqMp/Q91C/oDbyQJbIPDi0Dman00NMnsbY0ds98wtm/kbr9oS4o+zuDcpQZE0A/Hc1u
	pIGXUpSrRhgIGLEIaAq4X2T7bTUp0T1cfaddJqDUvmfkha1AaHhjI2Zo4PqL6kDaFW+GfllNLjP
	UWBPxKZcCxo562KgMbmGhsEPybvJiWdf01GgO0wVFKI73xgOFy5fck3Uofjqj+72Piqal87ek5R
	6RVG4Jjl2qn1YbXLXzvVEaHiTtaJGdBEnEDycZ9i5t95EbJLFQAmkL+/wvS0Yy8gNi8YKXmRKZv
	VwDKpxh1NpJtTPbDMpz5iUYRcQV3tTaKR5pPPZnF4KgQ2COoqsiA756WFjZleutM0KTAU24Dbyb
	qCp+LgAJcXUdrDszTPgyM++ax1g=
X-Received: by 2002:a05:622a:1248:b0:535:a5f8:a5c2 with SMTP id d75a77b69052e-5369b8a4bc2mr10226291cf.66.1792549588210;
        Tue, 20 Oct 2026 19:26:28 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c42b17sm13170296d6.40.2026.10.20.19.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:26:27 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v3 bpf-next 2/5] sched: use static_branch_likely()
 for the NUMA balancing tick check
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
 eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
 juri.lelli@redhat.com, vincent.guittot@linaro.org, 
 akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, 
 roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, 
 tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, bpf@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261019064157.29885-3-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
 <20261019064157.29885-3-laoar.shao@gmail.com>
Date: Tue, 20 Oct 2026 22:26:09 -0400
Message-Id: <179254956989.1919196.954997201143423051.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-19 14:41 +0800, Yafang Shao wrote:
> task_tick_fair() checks sched_numa_balancing on every tick. The
> static_branch_unlikely() annotation reserves the nop for the disabled case,
> so the default configuration (NUMA_BALANCING_DEFAULT_ENABLED=y) pays a
> taken jump per tick. Flip the polarity to static_branch_likely() so that
> the fast path matches the default.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

same with this one, this is useful separate of your series, please
submit separately.

Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>
