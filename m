Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4940A94C
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 12:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784206459; cv=none; b=LFw+UDq2MHksDU0CEkpQTT1+3fDJXfHcnWtrG+ogvrZkeRyMRZZX3VMf+JeoclLzVmPSXN69rI4NT38xSh5F3YtXni7T+C6HzAuGTM/y9YpP3A/3j/pb4pwl1fHlbJT+N7lTzKy3+mWTVdGNBTVvp7A9xlA/Mp6lKcQAbWtx+N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784206459; c=relaxed/simple;
	bh=VLvepFLbLnMw4+j5aVxMqNrtA5wOAZxiUEu7BvqkcO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CrxWivnl+3bJrPeobRog5pLPSmwJt8yYeKeCw0EWMXBoj2wHe1x+27eITI/WddwVL70dN8Xn1fCqpecasdHnUq9B/6Sidm2mC6ZsbIqPjg0m9XZfYUxRPHz08cTLJ0026aHgDkiAnuTCTup/CZ2afl0OvCxvba+Nl2XCDRRjQSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WAjkLfCe; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WAjkLfCe"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2caed617615so74530125ad.3
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 05:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784206457; x=1784811257; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UlkKCvRMizikKPPQV5+qMzDl1ZZFHbMqGmdaZXVWNSc=;
        b=WAjkLfCeaOrVV/9tbRE1ASOadH3HX1O4PU3ubZhV14xtRWEksUExL/4NDqtgZX2Hwq
         Ur9tPhueAtUkdJ5afPcWFjgIdm1W5qFNbCn0/Nvx0xhvr8eimivvdi+0mfqXfq+WXnro
         V/2LVevZ+216RRVAHzFhXwV7WT5hH2uBFfxVHsfg5uUM0HHCAqIECpK+ESIjH7Ty4O20
         yf1xPAxpglm3yrwbuAetUB17emXAC0BHPXAGHP3GPxV83CDyEkzPfOEvGZ/59QhDAXH7
         m13h+GpiZCA0j7QgDksL5qF6Ql6/D3giD0eCgAO4dl3WPv1Mwd1iWz2ZX/G1DDnxOWNU
         Bu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784206457; x=1784811257;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UlkKCvRMizikKPPQV5+qMzDl1ZZFHbMqGmdaZXVWNSc=;
        b=Mg2sxUdV3CI1lHeYyziX8mgX9ZtuR+rIwWF7oDSdpdQ/D5K+l/BHYaAEOlmLUJlun6
         88nHGDPghCQH3i8VDq2s8Sg4fdVPgluvDmbgCx0bLSgYuD46r0mfQtz1Ky5PyQ5F+E/Y
         gKGYkoBCupxkSqbn46EOCgEjT6PZXY5jVRDWKrcBcrx1/d6+L1Xn5bWvzmEXxtbug1cq
         OB3B1eQVRbp5QJaj6VxRUYRMVXuYdw2jhpsQQUegEAnLjgAZ2Xv4tGzY7wfVd8nz596z
         mOFfQ8PF5axvfzYg/C6/dUDxF3v5PP+mHuSMFbiH3UCVEVPp5Xzg9RpOtqn7g3NAix9t
         X7wA==
X-Forwarded-Encrypted: i=1; AHgh+Rpj30dtdrmw1wCWpq2Df43tL5PZSedSLHQFW7bmd0x95FalfPtIK1kgAp8m4ReuOP16yqZVOsfU@vger.kernel.org
X-Gm-Message-State: AOJu0YwZCcKn/bC6GC/HE5DuC+0NzRcBeX2R6MMtVf3elB0Wde0IMBLu
	ViAtC8C5QQZ3GL2raC5t02WWocA8ByV1iBV1UwKp6nzdSktkTeTy2ciy
X-Gm-Gg: AfdE7cnf6dxxQVCdkxGH/hh7sFPK9bDFdVF8ZUatMh7gjSZIg6OTpVLiwyYIpX7exJw
	zkmLsPhmrb7HlCJOuXOsUdGTFuCikS++D4djknHydaz07ToUTrjWqKbMjSeLC1MRtEHbUMSQzrG
	D993xC5p1q7c96qAIYSkg/2S2c8771iS8jkBMFqDsGJ1iiLQF9EDTHNVpCG4JeCtR62j/PNhRpq
	karNb46cFUi2oIQfIuSxaF683esqJ27+RskI0MssFh35GJlpf7ixGxnuwFAcdbWyMDrh9RZ/6a1
	/7TVB7PZ8VMTG4wZmdCubbLNM30C+KKNGZjs+kVlghfDLIRbhQDKhKW2MpopZvj2lja+w8eqmNa
	ML171fQhQGw4H5kJVWGXQvamrr1sMSyK3ToNsPweknV2L3DOzgObBCq/G6xgU7OwqoZRCFgGsBg
	I6/L0j0EZhHFqWHcjjJIFL2hHlVfq2/K7SX6hCtlT7ttCgc4r6lFGZxvLnxawKtHaBeufSdeQjL
	Zi7
X-Received: by 2002:a17:902:fdab:b0:2ca:329:3da1 with SMTP id d9443c01a7336-2cf03ca9c33mr65942925ad.16.1784206457145;
        Thu, 16 Jul 2026 05:54:17 -0700 (PDT)
Received: from ?IPV6:2400:79e0:1203:64b0:e174:fd48:2cf7:d01e? ([2400:79e0:1203:64b0:e174:fd48:2cf7:d01e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf1012fe86sm19726645ad.26.2026.07.16.05.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 05:54:16 -0700 (PDT)
Message-ID: <ed8b92b3-18d8-43d4-b204-8ae82d0f5e38@gmail.com>
Date: Thu, 16 Jul 2026 20:54:13 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-cgroup: avoid 32-bit overflow in root io.stat byte
 accounting
To: Tao Cui <cui.tao@linux.dev>, axboe@kernel.dk
Cc: tj@kernel.org, josef@toxicpanda.com, boris@bur.io,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
References: <20260714063118.1153083-1-cui.tao@linux.dev>
Content-Language: en-US
From: Tang Yizhou <tangyeechou@gmail.com>
In-Reply-To: <20260714063118.1153083-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/7/26 2:31 pm, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> blkcg_fill_root_iostats() converts per-CPU sector counts to bytes with
> 
>     tmp.bytes[BLKG_IOSTAT_READ] += cpu_dkstats->sectors[STAT_READ] << 9;
> 
> but disk_stats.sectors is `unsigned long`, and the shift is carried out in
> that type before the result is promoted to the u64 accumulator.  On 32-bit
> kernels (unsigned long is 32 bits) this wraps, so once a per-CPU counter
> reaches 2**23 sectors (~4 GiB) the computed byte count is wrong, corrupting
> the root cgroup's io.stat.
> 
> Every other sector->byte conversion in the tree casts to a wide type first
> ((loff_t)sectors << SECTOR_SHIFT in bdev.c, (u64)max_sectors << SECTOR_SHIFT
> in blk-settings.c); do the same here.
> 
> Fixes: ef45fe470e1e5 ("blk-cgroup: show global disk stats in root cgroup io.stat")
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  block/blk-cgroup.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index d2a1f5903f24..a778aa9d2bb9 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1112,11 +1112,11 @@ static void blkcg_fill_root_iostats(void)
>  				cpu_dkstats->ios[STAT_DISCARD];
>  			// convert sectors to bytes
>  			tmp.bytes[BLKG_IOSTAT_READ] +=
> -				cpu_dkstats->sectors[STAT_READ] << 9;
> +				(u64)cpu_dkstats->sectors[STAT_READ] << SECTOR_SHIFT;
>  			tmp.bytes[BLKG_IOSTAT_WRITE] +=
> -				cpu_dkstats->sectors[STAT_WRITE] << 9;
> +				(u64)cpu_dkstats->sectors[STAT_WRITE] << SECTOR_SHIFT;
>  			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
> -				cpu_dkstats->sectors[STAT_DISCARD] << 9;
> +				(u64)cpu_dkstats->sectors[STAT_DISCARD] << SECTOR_SHIFT;
>  		}
>  
>  		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);

Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>

-- 
Best Regards,
Yi

