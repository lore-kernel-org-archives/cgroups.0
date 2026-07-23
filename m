Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE8846D0AD
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805489; cv=none; b=vBTV3tLekscT4m3Y6qCtFBuMFFwLGfg7JRjRMII/emS/yazYcJSNeDRjdbev52XCmytdH84dIjzBxGkbm5q/rRleNRmcX0ID4mSPgiRDoLDPOSyJ5BENyfmPIIe+1qLugxKeajNrIW0TXDbylcOuGrBjVBfu0q2rghVRwhyqxXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805489; c=relaxed/simple;
	bh=+Wkaj4UHoena/1Gfc+0sVRsK85mXOaIe+VRpgEhw/+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CkeSmxSK8GcfpPayt/tif7ERVJJbZBNsor6qFvmiqgg3dRQZ33NOMLB3L+DUo1FzPDrSpGZEmLP+qyl6YMROJdOaS2pZl4hGN0adZr1ltt1AE4CIfT0UPd1tTRxHB4SPeQM0Q6U1pa7pcTNmIe1CC8VqC8yuzE8GlP3oSxqd1fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJwRFtML; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJwRFtML"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-384930ca5e2so488707a91.3
        for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 04:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784805482; x=1785410282; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5p4lXkdpnCsbltYcC1FVF7UTY1mmokYIoR5useAxszA=;
        b=VJwRFtMLFtwwxQvdU515qnSw5GDF0xRHaRZPqHLtiYAZ1kKs/fHtLanrE0mejSMCYv
         fYUmo8IFfMyi0DfmjI31y6BBGF8LGZiOAzYbA/Pg21l+JliazaifAzZ+zOgrDeEbDc+9
         duGCgehvS4kJYIUSazDIv3/rw+dDGe17xPpdLXMbsCXTOWiooaM4NydPrUHDSOrJh6rk
         gdbEbjGzuFugh1qisFhpyK3byWqJyuLWEdInGNquqey3jKjseaL1lTCIO3e15wF8sfi1
         QHeuMZyp1/EDh2C78FZO0SqC6AuWcsMKqEP7jgII3qxGmaQuF1S0G0RZnIteAxcsKOte
         R1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784805482; x=1785410282;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5p4lXkdpnCsbltYcC1FVF7UTY1mmokYIoR5useAxszA=;
        b=igj6P78qynYHzqEBoGG2g+2iX7tEFtzChLOOIp5vrPcJ5ecAAG2XGMKMM6D/o7jS/B
         +XdimnxTZd5GGmEUcaNGhQziCZoxebiRXvUBq0DgvtS32SsL7riPGaRon/qdjxu2YCMi
         JIvPtKdYUB6fhtiegM6k7HycT/eysoC1bV0BIfZgT7G94NNrHPhUuVZ1t/smGu8AdkW6
         qQmXtaa7d4AsSC3exkMW+Lf1ubo3EU1x0ajc9YwoK+g27vS56RDV3oy1ZD7jDBsa6NAT
         XctxoUahDTxcj0yUZKW/OVHVbAoG3bgLNvYoIGivzkQklE72GmZscOJ0bnZ/TdxDNbKh
         swfg==
X-Forwarded-Encrypted: i=1; AHgh+RriGEMkxauL68NYNIUjXL8cJs10eYGTvuOyQodBo7222mBJYGryJ0f1NHwI8VRDgvfBxcso8l0P@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq9OuWywwLGeiazI2ByBp0aRc7UEy7LqjKgC/9kEeTSKlSTGkw
	5J0yzUhND0zHXT3e3H61ieWqUU0Mgjw0GEpAcs45ngG5ZcA/tA4qRz3y
X-Gm-Gg: AR+sD10zX1IslqQWysrZjlvtliCrUqSut9dP9PiHFC1tlC59OHjoOKfSzyvKfbwuAcA
	Frwfbs2GGkzMl87PavWwxEjtA0aM1sMdLjrFVkgdSDPEL0AiXAqJsaJPfWjQQq3l6z5HJtOoTvy
	RmQDxIRky9/tqQFe4RR3BmiebEY6MIIt3/vAy/Fotrh6DhaIARV2yqij9vqvjaOuH1lUn4Dy+LT
	9WFBEpWzXf6Uu1ZTSYp8TUqQimtOZIoc2M/HT+RvqwNEsTj9w4xuT8/mQRUOEuRoCjDj2j1FY12
	ato7Mu3j8XIG0KCbipO0Ws3AavtRnRvXjD76NjinR0zg0kh8qbZvW0UnWM7gnXUfRxWRTqTVtF3
	x4XUmWuLSjQi77b7Grh/NhJgDR9TGBEnzo3wHIezuTiVSX/28HFp7i2PKOJRjMI6ooPvIp2GPs8
	WBdPLXKDMDTgyUu5/tk3SIOG4x
X-Received: by 2002:a17:90b:1d48:b0:387:e0db:3d8e with SMTP id 98e67ed59e1d1-38ec665050cmr2866538a91.41.1784805481916;
        Thu, 23 Jul 2026 04:18:01 -0700 (PDT)
Received: from [10.22.68.205] ([118.201.124.118])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38ea5966676sm1591924a91.2.2026.07.23.04.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 04:18:01 -0700 (PDT)
Message-ID: <51865f65-7b75-40a8-b7ba-7029065f5840@gmail.com>
Date: Thu, 23 Jul 2026 19:17:57 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-cgroup: remove unused blk_queue_for_each_rl stub
To: Tao Cui <cui.tao@linux.dev>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, tj@kernel.org, yukuai@kernel.org,
 yangxiuwei@kylinos.cn, cuitao@kylinos.cn
References: <20260717102049.2080768-1-cui.tao@linux.dev>
Content-Language: en-US
From: Tang Yizhou <tangyeechou@gmail.com>
In-Reply-To: <20260717102049.2080768-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 17/7/26 6:20 pm, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> blk_queue_for_each_rl() was added by commit a051661ca6d1 ("blkcg:
> implement per-blkg request allocation") to iterate over the root request
> list and per-blkg request lists for the legacy (non-blk-mq) request
> allocation path.  The request_list code, including q->root_rl from
> struct request_queue, was later removed in 2018 by commit db6d99523560
> ("block: remove request_list code").
> 
> The macro definition left behind in the !CONFIG_BLK_CGROUP fallback
> branch of the private block/blk-cgroup.h header now references the
> removed q->root_rl field, and has no callers in-tree (it would fail to
> compile if expanded, so it cannot have any out-of-tree users either).
> 
> Remove the dead stub.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  block/blk-cgroup.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 615390f751aa..6a309d2d3db5 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -500,9 +500,6 @@ static inline void blkg_put(struct blkcg_gq *blkg) { }
>  static inline void blk_cgroup_bio_start(struct bio *bio) { }
>  static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
>  
> -#define blk_queue_for_each_rl(rl, q)	\
> -	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
> -
>  #endif	/* CONFIG_BLK_CGROUP */
>  
>  #endif /* _BLK_CGROUP_PRIVATE_H */

Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>

-- 
Best Regards,
Yi

