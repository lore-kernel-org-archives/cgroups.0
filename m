Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAFB385D9B
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 11:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287541; cv=none; b=gByUIKVxrYjdO0ZFFmlTx9w/bg/43xD/ND6E9Tf5CyqeoIdpdKcxxF0fu1QnpQiflOICk8NHy8h+2Q8iO4SeDq/eR/736VPHO0CDFkyhfoSwGQhgQ6rML0zed2WEic3jnHAH/8DXnagIu+8xXWiSnjaVvFMcNEjW4XstTQboJSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287541; c=relaxed/simple;
	bh=b13YWFUSi2ABCS9GNvKmbC8JRTyS6lZ2xmdiWv/pWXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhYDSxb9C6AerKEiIKnP6L06Z81IriqQDZy0d4Ba/ooKFoGQs/7GBvggIjUZ1Et1Y/9z2axB0E2pHyKNqK2V5Tb3Ro/X27jUAwfNsyFcUYjf/2wID53QuP4BytCKvTIa+Tibl1zz/gicKd9EPeEphZ8jQXk8BACpT56HFvlpUrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIOcj4Ss; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIOcj4Ss"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ccf2360620so38204625ad.3
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 04:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784287540; x=1784892340; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pVuierYlugSu0sUY+XJcj2RzObrDWMBeCLTVAQKDCbA=;
        b=mIOcj4SsowtR8l7Sy2SghhLQEv4P+821zCh2DDE6VFx1nwQYpFmP8/OvLFU+yeiHWn
         bADl6Eh03bVk6mBZupCOBp/GAT/jXyazu5PZq3Kyr05GmKkCzLlp9GVBHDPJlciYJSEW
         M3ZwY3m8oeWosIdOWu7oQIanUXPb64BJU7rSEJmH8l/R1EWaO8xGWR7IzXpvDNRv7qbR
         nBrkQsoOXpbXC8wB7xkq9eYmuhUKrXrXKuDBJfPas+CCUVRTFpBBJ+tO7TNn51cIrzRe
         LfOF4kAZT5Qe+BqKreQ72qH5+s6XJtajTRwTCQhwaet6BY06Qxav6Pgf12qEda3sIyax
         9FnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784287540; x=1784892340;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pVuierYlugSu0sUY+XJcj2RzObrDWMBeCLTVAQKDCbA=;
        b=i6no51nh9dVSUBpJTTG1n+hbWQLH/p2xpZPNhwm+z/lXBAZJww+WrIavlsqnAbAdn/
         X75TsxqbpNkcwQMTRIDIyiKN15prYX5gIBdtPXwuDHwhRGszyVuebs/Xp4ePaDn1QmZA
         fUXkq209anyLoR6VmIh/Pep9/aiG70OJP5tIaRpcaNhh4uJZjZviOHu2oyjCivv7AzM8
         w34quFALte6XWvO+CbTjJ2xcPhSdE6Rz16JG0/wa+hqXIcbugR/PHOupgtvEV31w2Dia
         LpKpkIOp5c51ErrLAcjHtCnwuIcszX3SuU1HdgIzjT3KWH99c0XdeKZrwp63s7GD+hkZ
         Ahog==
X-Forwarded-Encrypted: i=1; AHgh+Roehh/UIC5EJojcNH0zL3YtJ6ye20JPaMZgia0dSXRD0aVoaqBJGnfpd5cdWgAkwRGv70rIBFtU@vger.kernel.org
X-Gm-Message-State: AOJu0YxvER7cYGFyGC+znNY3Am8oylnWhVPUZY4c+n5btA76KOSVdxpe
	xUdvrUkCod4nV39kpjXF9fMAMeBZy5vaDfZ3EA3tiPwKh18eEfbbI+Lg
X-Gm-Gg: AfdE7cnziMgEzohxD7/4eg/TqMjX/6GPTMIsB0EAHrm37zJX8xGSL6zfQ0efv8ao289
	90o2Dbrx37hl8G7SUu//d04irKGPwKtyklSLyY/F1JvGPfxOsB64XiSNkhzd24Er2nxa1j/CL6f
	EtGKWYLW1Ejq4XQ8Te/q53DPas1QfeSDtn5x7OhBpoW/LNF3ywdTH0im4QEwwbCX2wpmTO0+SdA
	HCA+OlN2PzMNq0lLN1AjAq/yPykhZ1Mp2C7gVh6BmIrGIsh2wTT77cvbbo28ytlyl3xPTHiYSlx
	eLKSGi/AJOUs9a1nRxEB0LU36OYPOWfZFc4xLCQ6UuT4WiHPHGDGf4OXl8m5vYdeXMAL3e+nlUb
	LPWR6RGWxhQBYPNnL58/W6ilFQKkJRChTksi092N/GOOoUo/UTKVlfq/oi45xr/rXYod41S4OWm
	T+VaU9BhtijkSa1zlFW/tzE48pqrLtTPrrNTqnRjycG4TyvGaG43Drjp3ecjVQkMdoyxi3zvfYN
	A==
X-Received: by 2002:a17:903:1b2e:b0:2ca:281:27f9 with SMTP id d9443c01a7336-2cf349978f5mr22647765ad.27.1784287539501;
        Fri, 17 Jul 2026 04:25:39 -0700 (PDT)
Received: from ?IPV6:2400:79e0:1203:64b0:6cf3:a642:5711:319? ([2400:79e0:1203:64b0:6cf3:a642:5711:319])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344d80e6sm8978785ad.29.2026.07.17.04.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 04:25:38 -0700 (PDT)
Message-ID: <3a711d12-5184-45b0-a4d5-2d02a17d8b3b@gmail.com>
Date: Fri, 17 Jul 2026 19:25:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-throttle: remove dead field last_check_time from
 throtl_grp
To: Tao Cui <cui.tao@linux.dev>, axboe@kernel.dk, linux-block@vger.kernel.org
Cc: tj@kernel.org, josef@toxicpanda.com, yukuai3@huawei.com,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
References: <20260717054855.2018578-1-cui.tao@linux.dev>
Content-Language: en-US
From: Tang Yizhou <tangyeechou@gmail.com>
In-Reply-To: <20260717054855.2018578-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/7/26 1:48 pm, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> The last_check_time field in throtl_grp was used by the
> CONFIG_BLK_DEV_THROTTLING_LOW mechanism (in throtl_upgrade_check() and
> the downgrade logic) to timestamp the last upgrade/downgrade check.
> 
> Commit bf20ab538c81 ("blk-throttle: remove CONFIG_BLK_DEV_THROTTLING_LOW")
> removed all five of its uses in blk-throttle.c and the surrounding LOW
> fields (latency_target, last_finish_time, checked_last_finish_time,
> avg_idletime, idletime_threshold, bio_cnt, bad_bio_cnt,
> bio_cnt_reset_time), but missed the field definition itself.
> 
> It has been a dead field since then: zero references in blk-throttle.c
> and the whole tree.  Remove it.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  block/blk-throttle.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> index 9d7a42c039a1..1b5775771e07 100644
> --- a/block/blk-throttle.h
> +++ b/block/blk-throttle.h
> @@ -120,8 +120,6 @@ struct throtl_grp {
>  	int64_t bytes_disp[2];
>  	int io_disp[2];
>  
> -	unsigned long last_check_time;
> -
>  	/* When did we start a new slice */
>  	unsigned long slice_start[2];
>  	unsigned long slice_end[2];

Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>

-- 
Best Regards,
Yi

