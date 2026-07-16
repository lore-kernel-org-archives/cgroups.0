Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224D73CC31F
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784204395; cv=none; b=maBa9vmoFsRs3YGOHMvvHp6bwGUrXqCnDWJv3OyVq+SB3rNFVy0e/ZuCtmPQnPYT/opcWOWrjhWpp/C0vJalUZMyj1We0hCipNBPD0cYk4vy0g0U4xu9hzX2R0/zbcd6xCi9Gtql4IBQHaHS6ByaTHmCblykS9E7VFc+PFFvvUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784204395; c=relaxed/simple;
	bh=PlzjWzgDDt6tc68NVLye65j+dlo1TtiJV4HmRQ9VJao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yr58uNplbO+yxwCKmjw46EDRQx8htBUBNIRzgJRz3oRuUrhjj1oKT8oiB1n9ZA4ngF13fbEY2lURmIX7Cu7B5t4YpcY3gN9aRu0/uv02kN9vvkPCdZ2FUjCT9q34TxESp3NSYpTGTeLUtXZ/Z1zdJMIkJ82d0ikCmklgfXyxrZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fmxbrowx; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fmxbrowx"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8485ef63b68so6089145b3a.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 05:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784204388; x=1784809188; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NNVBy8u+XjMaZM3z2LpdEO0iw/XOyiSV5aem9nLfAFg=;
        b=Fmxbrowx2/fDb/VorBk4l4aoN61eN4Fqzn/DN3EMn3VhtVhD2SQtsMCfp5AXNOcG8B
         +npZhUJdT8/Y6M7JBuirILsehyEAne3RcJH8dGnng8gfUF4nQrA+iAqjYBYA9uk3/FA1
         wkIfkb43iXKnp5nlQYOfaNxwI2shfw/LASOPLqXSnno3bUwE+1aqFrXhLgpm6tEHZKm8
         uCChY/06s4zX7gQ7PTbNsjQL2BYpnXjbuvBDFZE9OqJ3g2GypmzJ+oxk1PT5tIveNsJK
         dhwf6x5oPtgzPMdVsOtGYTzUs+x55JqwKs8dSTZRUXoCjykgwsilH/EIImlt8X8Q0Mu8
         1frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784204388; x=1784809188;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NNVBy8u+XjMaZM3z2LpdEO0iw/XOyiSV5aem9nLfAFg=;
        b=TuLjqeQYVCxvMu47ooK2lJ8A3GTp/ytXT8Vck1D0jbNXMjKqE7fmNW3t8YfCI2GmSv
         0+g6D7i/jq486gJrc8oM4isZrXzHHzR2Li55mhLVHqfVsmmtgOOquMQs5/inmUEZvndH
         UghzJrWmYpHTUw/bl6XswSFURM4OamaTycNYGdBS4q1ziT2zcEximgriekiw6C1guSqc
         GX6wN1QGe3c/aY3riB56OT08KMXzmn3OY8oPLjlZ/7eIcF7z0WI3tSY34WcTXRx/Dw+e
         qamvLiSeHTeQrT4LwIJAhIB9sFINmJT/gSpoNg9GA8xmYjWlzvhEBNREThzv1IFidov5
         NN6w==
X-Forwarded-Encrypted: i=1; AHgh+RpwQ6BvuREFtv7qlYKUPWhp4K4MproTUGXQDLNCoFBRjrakio4ezBGTe3nKuoOhFaaRjyRDp3Q2@vger.kernel.org
X-Gm-Message-State: AOJu0YyxvpFkkNu6tBPh33X5H2z2yPT/VJRv4PDbqYnsb6PX6r4RRezi
	6+j+KcHxwxvlZbDeRsSxazu1F0IKEArxWgGljWpO3uF/GHWrY/jSZ+bg
X-Gm-Gg: AfdE7cl/4aAAdTts8NZihXqOeeYS75lmnLF6rZg2unypWzGsg99QGBjPpryO8w0IWHF
	qesu13116ah6pPLlGrS3D5aA6WHn3iQIDEAdw3BnccIJU6oFj60PePDvNxmvRRDrZZWws8C0NlN
	QI4CJ5+Wp75t3q0LxLuWctZpOoMT/KDhgniQTp0Msynq1m6I5NYAbXcCrh07D24WRUZ+SduiytN
	xuD8uVYO7QqzaAkuUJUpENvtQFhpvTM9CJFthRq14zhKesdofjpy+FtWUCagR60bkZNeOXevk1z
	6akxquVK2q60pAXkSfZ6Fswql9MCNVYPt4EpAqgiUDW+lkFdvHebXmbx8yLpc4ryJ7EUyKheRo+
	BMiFPVz2cO/NBB+m974p4GhBn3VAknp345YdvbxPMW03A1FUiQ+Lwe1ITeA4HIr/I9RIRpXoyDM
	jt4RPll8eZGK7IVJoHuQqB
X-Received: by 2002:a05:6a21:e97:b0:3c0:9c18:d5a7 with SMTP id adf61e73a8af0-3c3572937c3mr13731565637.68.1784204387596;
        Thu, 16 Jul 2026 05:19:47 -0700 (PDT)
Received: from [192.168.0.23] ([210.10.76.89])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eb8578sm1834476a12.3.2026.07.16.05.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 05:19:47 -0700 (PDT)
Message-ID: <676f4205-edef-4d2d-a7b1-8878d466bb7e@gmail.com>
Date: Thu, 16 Jul 2026 20:19:43 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-cgroup: show io.stat numbers for discard-only cgroups
To: Tao Cui <cui.tao@linux.dev>, axboe@kernel.dk
Cc: tj@kernel.org, josef@toxicpanda.com, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
References: <20260714063302.1153238-1-cui.tao@linux.dev>
Content-Language: en-US
From: Tang Yizhou <tangyeechou@gmail.com>
In-Reply-To: <20260714063302.1153238-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 14/7/26 2:33 pm, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> blkcg_print_one_stat() gates the rbytes/wbytes/rios/wios/dbytes/dios
> output on
> 
>     if (rbytes || wbytes || rios || wios)
> 
> which omits the discard counters.  A cgroup that has issued only discards
> (zero read and write counters) therefore prints an empty stat line and its
> dbytes/dios are never surfaced, even though they are accounted correctly.
> 
> The guard predates the addition of discard stats and was never updated;
> include dbytes/dios so discard-only cgroups are reported.
> 
> Fixes: 636620b66d5d ("blkcg: Track DISCARD statistics and output them in cgroup io.stat")
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  block/blk-cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index a778aa9d2bb9..b324701cb05d 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1154,7 +1154,7 @@ static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)
>  		dios = bis->cur.ios[BLKG_IOSTAT_DISCARD];
>  	} while (u64_stats_fetch_retry(&bis->sync, seq));
>  
> -	if (rbytes || wbytes || rios || wios) {
> +	if (rbytes || wbytes || rios || wios || dbytes || dios) {
>  		seq_printf(s, "rbytes=%llu wbytes=%llu rios=%llu wios=%llu dbytes=%llu dios=%llu",
>  			rbytes, wbytes, rios, wios,
>  			dbytes, dios);

Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>

-- 
Best Regards,
Yi

