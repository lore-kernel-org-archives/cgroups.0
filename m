Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794501830;
	b=fHI1d0rNq230dlYoasEdCWSurSWpV+j4X08lfdt0ZTTZmloniwjIVuRBXEZtYtBoL7sA
	 sKE8vxykteKKZyKuFu8xCZT52NlRjMj//tlAfGmi9ZQyFugv+gd/FUzInWVaoHjRFAbRH
	 ooZJEUHH5z11TJzZkRpEYpdwHjVjTVUAN9jVTD1igbbIdfar+5JH4Uvto3O9GTejCLeWM
	 NttOoyc6Jo7ki/PyywjSm+uj2dUce0PDJ6FBla+335W6b6Af06qPgC31BqtFXTU3xEB1K
	 OiyjALfUItdogsfSwob9aurOfGJdwIRFlv9325yCWCyCfWgkRmQos872PX32Qm9wZLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794501830;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=OT3KyYwDV0pkmmBWZVaURf9TIcCa5HYu6d3239mcr10=;
	b=SQ/p04pCOV8dangQD30gsHSvMSg09jB4BYPWUcqT9s8UUzBTarrU1pXB92Fk9wu3DK9e
	 rIgSSQ1K374fWmuOsftCOv3c8g+qjevYoz9HaWQFJP9hk329/mbs9Zqq4C/jw16see940
	 f1xTnAxIN1gEwex1KlUVisGkrDI4JrOo5jyK42r5MLPLVoNm/D1uOKSVKKsOuIo16/K4k
	 quenxrhi5P0DuMYOm5434zuJvHK6DBL3EF6ADnZLXcxGGmk6007xsHKI8k1M4JfpGPsoS
	 bOuq1ckyeFTVYqIpVouZZBvgRxsyXebqJUWgyt8bcbyo4Q3u+0g2aaYG382zR5mJ6NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=ZYKSRf2s;
	arc=none smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77A4606A31C
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 16:43:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E77A4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=ZYKSRf2s
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b0d126f631so861947b3.2
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 08:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794501829; x=1795106629; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OT3KyYwDV0pkmmBWZVaURf9TIcCa5HYu6d3239mcr10=;
        b=ZYKSRf2svXhh7Fs6IxWfASNqCCKN1Fh2T2OQdkQ1P2Asuy9BXkLmFuZ7zz2CO0bARl
         sgFtUwK74sE/flVX/PlY8hys2NW1vs1tDzf/gVRoK15hgWsyOW/nZxWV62esAymWrThS
         t1oWBUIXbEimEz5mTxaTMqTYj4j6CbwXGGZoPzw2bI2IYmHQBldi+VlEShgQvfRWlFUw
         1vprQFGpsHFerd5Kp/ARO614AJjuVYlzc0Mw1U85lFKqJYAUSHJLnaGceai1BzwZFYRi
         yKr5ZKUI6gOhngS97L+ZJQe16WvKpcvYD25klc11aWfKf47QFgnKpuq6q4d2AD9eZjuB
         BgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501829; x=1795106629;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OT3KyYwDV0pkmmBWZVaURf9TIcCa5HYu6d3239mcr10=;
        b=d5A8KdFkcXyZn+/mWM3w5Z7cKyKxA0ojzZMMIjHAVAcHtZP9iTxALw7PSiSCOpeteq
         8LPPsEAb9r04ljXtpcURsmkGyhYX0w6CRWxvuO8DgyzMCy+BXpF30veBPBzJxRaO39K4
         OuokKee5ex7kJo34NFvn3/C+36xf5HwFMKPW2LDK8qTfQqIH7PCsJaZkDmFU68sxcZEw
         Ayh8Mde/zdVmvY5l5JzjBxYvNHXHMCv5CZskoxhi0SjUJLGG7Hv2UmVbhg3+Jh9igvsa
         1F5EgrxOLK4ZGt8aOFbNaB4yANRGXSN1hmrrvbAill3vCx/FdAlGU1kNfWgL0Pl4bnZi
         t3Sw==
X-Forwarded-Encrypted: i=1; AL+hErGOSvJqt8AIaa69o+Ty1GsIhR06zT0Mx2FFry/L4smU8Nf1ETTrXbIrtzEGdNkRSgvhGMR8KJFd@vger.kernel.org
X-Gm-Message-State: APuU4Z9jJiGYOq3OJ5CbQ4kKtIzG8rO0eNG0//3ZLnL0coaz/MMNcBjR
	X140+kDn75vYLl1AT2hTNjdiF7SEWR0kW8kN6i+4Qk7nCgbhb5wYKieqJwPmCUraWT4=
X-Gm-Gg: AYBFou2oOKBAO18EsYb/+gwJLSw+ET+qS651MSIoVXXpz7X3i4AXJiiMdnimgqEMg7j
	8wvA9XzXuC57YSjHZUaAb0HxeENcqR3NvR7ceuLfEcZAkfPX2vL4Pa3S5IjyrX1ZzvminWp6SVd
	9DKP4ZJfFAFH2q4Lo5Tkagh1rbifxTdX3tlMb44Sgs3iSfGaTsapm4XfpgODT0zORccHYZIoEQb
	TVk6a6WQuyChen3EWF5o0ho7QRoPedB/YU0keWIQmCE+pov5p4xKLHXqply5KsC/pWO7bCXPv5D
	UjIEtcHAptMFaPD5w4e4zalbkbu41Oxr0NMgiuGfV2mEpx05raX/n/s6OCxRfoXgbqjyuB/TIJ+
	yLqlxuuGmZKneQdCIMRPMktb44iLytUuz8GuZYU9L4pEf5bJbS0EqyhkIkv3kX/rlHpavju70Wj
	0O1Cxf0C0azmrIhT+bomw4xEf22lsY4QlN1ywGOw0rHsVFX8xOg7gl7+KTBEbKgYQgMtnjV+xdx
	C2qX1V3r2m6s9+H4J38vAZYhhGtfLkT6YeAqe8XPabo4Pn/S769mZ6q8PnMvnj800s45Gpf9B2i
	+ccMy/E9nMNzg2zspLxgZutnKsP92bsMSaA/jrFUZNsnDARjBA==
X-Received: by 2002:a05:690c:e1d3:20b0:8b3:4f53:91c4 with SMTP id 00721157ae682-8b4aa326b49mr620977b3.29.1794501828827;
        Thu, 12 Nov 2026 08:43:48 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3933fb45fsm73764697b3.25.2026.11.12.08.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:43:48 -0800 (PST)
Date: Thu, 12 Nov 2026 11:43:47 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, shakeel.butt@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org,
	david@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 1/4] mm: zswap: fix shrinker count for the root memcg
Message-ID: <avXsw9ZJHOkFG4Ll@cmpxchg.org>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
 <20261110015321.611093-2-joannelkoong@gmail.com>
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
In-Reply-To: <20261110015321.611093-2-joannelkoong@gmail.com>

On Mon, Nov 09, 2026 at 05:53:18PM -0800, Joanne Koong wrote:
> zswap_shrinker_count() scales the number of freeable entries on a
> memcg's zswap LRU by the memcg's compression ratio. That compression
> ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
> stats.
> 
> However, for the root memcg, the zswap entries owned by the root memcg
> itself are never accounted for in the stats (obj_cgroup_charge_zswap()
> skips the root objcg, and before the root memcg had an objcg, its
> entries weren't charged at all). The stats only reflect the entries
> owned by the root memcg's descendants. When the root memcg's descendants
> have no zswap entries (eg when the whole workload runs in the root
> cgroup), the shrinker reports nothing to reclaim for the root memcg, and
> its zswap entries are never written back by the shrinker. When its
> descendants do have entries, the root memcg's entries are scaled by the
> descendants' compression ratio instead of a ratio that includes them.
> 
> Fix this by using the zswap pool-wide counters for the root memcg
> instead. The zswap pool-wide counters cover every zswap entry, including
> those owned by the root memcg.
> 
> This also gets rid of having to flush the root memcg's stats, which
> flushes every cgroup in the system.
> 
> In a VM running a reclaim-heavy workload in the root cgroup with the
> zswap shrinker enabled, the shrinker wrote back no pages before this
> change (zswpwb stayed at 0) and 1016 pages with it.
> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Reviewed-by: SJ Park <sj@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
