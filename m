Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49B62D780C
	for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 12:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782305007; cv=none; b=ZqItA8I96AeebZAFKx/6WwhS20YaNrxOmQLBkLsYSjSq5gqSuJqk5r5szkh1d46gcPc+SFGuYpm5SjoozvTQ65xE623VXv89Q+oGboY+UmeXmblJ9nIfTIgCBxIucU0sCTCmFbl8i/6iQ7tI7mg77aoNIWusnSwgIPaqyPnMFrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782305007; c=relaxed/simple;
	bh=1wS2Dp0j8j7U51hcsEcED+6qZEgOqRZvoSwj5zOBI+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qspm4NAlpRQvbSgDEYFYwlzC3gjHEwkMPNFeAPkmLr7/r9wCEqrFrzASgsXyTZ2wK2baWJGB+VofB9zyVJo1GeEeB+WIw8slGy1P6e/TxsOzjyl3C27sliFDSUFCp33I5sGZR+fqmoZSBbJ4ggdjYG/ijAczZSssBZ50JnKKuQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=NdQ49Otm; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="NdQ49Otm"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-69ec2ebec61so622797eaf.3
        for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 05:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782305005; x=1782909805; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3vBqNWysPNQvqkzsE4GQXCpY5+Q5GT/QhxmkZJrUXw8=;
        b=NdQ49OtmMM6pTd932PgSzQLVlQLQia8eFx+1H4eJV+FY5ycGnb4e391PH51FCCO9nH
         tXdBfux67ra5F0bf5duaGfi6R6UDw8/cA5JFdDfuu5mbFvkB+TT+TaVUx95lCYEKBfNt
         yPpioPJ/yNsEWOpZd31galaxrw9F+dlq76DnZIP1WCl21JUVPiG87mzpC0VioHrA18Nc
         /tHqbEPoYT8jGENF/wGUf3RicpBZzGbo3/WZyhHqp8w42gKMqqN9/VCuShmYARsU7G0X
         /KZat0YH00vALmDihnkwflZLb8iPcu1NlJu/G99LUKCH3+VH4TdRtUCLSlojvS1jGlkW
         /Cog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782305005; x=1782909805;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3vBqNWysPNQvqkzsE4GQXCpY5+Q5GT/QhxmkZJrUXw8=;
        b=Bct5u4w0vbB+dEsGIvl5u7uN5CZQ4PolMSg7EPX7GoYRrWOK4ZsHCePCaAtbGKpLQ/
         33zyQJa6PEWkxxXElCrtilB4s2lJ1cko9ssorDmhlRYXNtYB5Ql0MgBnyKlQpHY76iEf
         4oUhK37PTnpg6RvPUrJDpGS907M4dImoaTTaszNW1qwHiRnZxNY8htTIL3HbrfdD9cCW
         VNHqrgXCCY4bt4VMNAgkxTC1Fv9x/od4GBDccYxkj2JyQpAYpFl7JYd1/WFl837cmcE8
         nDpt3Y797lRiQE57pp3GtD5noNsKSybYohOhDo+JhWXqq836V7gHg905IRZ2ODr7+yOP
         d6ww==
X-Forwarded-Encrypted: i=1; AFNElJ/JXBkkzzfpIl4Cp7Ho73wjAG0pH44dh6fmqIEnn80JdJHc2+skoHHrlgr9NvdRxqH7OlkioLbX@vger.kernel.org
X-Gm-Message-State: AOJu0YwCck3yMSXyjlegSZD3pBbTIIqlJvJ1aXOQCad05hdxku7OA37d
	/+GbE5Lgksfd96MTkz8eNc9+t2EldII3LNJUafWy4z7HOlHie+iva/nwGBx0DO26D0I=
X-Gm-Gg: AfdE7clsdmAYV56waiIIMaEukNC5+uql+wPJC+OG4IIjpT1e5E57Lj5+TL+JR9ZBbIA
	OiB+S0IVLHcV/OdX2ERFGYMvSuFSF/pboGQmNUejfGuq+LXuQhsYuKh6iXxW723K9eNYec0k+A8
	dfqQ66867/DH/Erh7I90F8t1x5ETRy5PjtBidq0l0chuNbeLKUKB6ka8RGMySl7/OE5t1cvYGPL
	fmQMJiA2gArEtSASPklazsaaRCWbYs3sm3PvQsiikC43hjH1SflwrGrXcrwQJDrwwk66gEhkoaZ
	PpjljHlORSSNjjQZ3hfe28q4Gru4NnRAAVrDjORVKyyv/iBnLsSImFhlcdV4Tpz/JR7thGjksvz
	fIjNwEnVmPpppu/Bw+pAcCKz9bthDNI5Svwq2yO1xPW9XYf1Vq/cUiSo81RDHLxHSoPy8eHyxCs
	ORSl/WhOPOtfI2HDA6nktuklN1PvNq7uIiTyyPudJLtuzPFrhEbx2nsSHTxwjUcV/0J1d35u0=
X-Received: by 2002:a05:6820:2110:b0:6a1:20d6:ccd9 with SMTP id 006d021491bc7-6a123020da0mr1995384eaf.49.1782305004833;
        Wed, 24 Jun 2026 05:43:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472f0464a6sm10164438fac.15.2026.06.24.05.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 05:43:24 -0700 (PDT)
Message-ID: <34d48fb5-4952-4a48-b92a-f189bc3edd0b@kernel.dk>
Date: Wed, 24 Jun 2026 06:43:22 -0600
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg
 paths
To: yukuai@fygo.io, Yu Kuai <yukuai@kernel.org>, nilay@linux.ibm.com,
 tom.leiming@gmail.com, bvanassche@acm.org, tj@kernel.org,
 josef@toxicpanda.com
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, youngjun.park@lge.com, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1780621988.git.yukuai@fygo.io>
 <1c739fcc-5132-4cb2-bf34-cec94de26509@fygo.io>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1c739fcc-5132-4cb2-bf34-cec94de26509@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/24/26 12:57 AM, yu kuai wrote:
> Friendly ping ...
> 
> This set can still be applied cleanly for block-7.2 branch.

Not sure how you checked that, because patch 3 very much needs some
manual attention to get applied. I have applied it now.

-- 
Jens Axboe

