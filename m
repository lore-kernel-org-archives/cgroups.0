Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794959855;
	b=XP4LGyqI4H9Sm86JmuGHDzX/8rykGUNMvYgmyMNFXg9cRsna62kHXZURNDjO9uqAuTbx
	 HA4uYhfqPtfA4MRBxgHwxjzTTT1L7jze0Cn/SyDsKvTHh8fmALVDtdjklWUqNyUoduSWw
	 zDzPCReozaMppr2DsnzTASaC/AfUdL8pjRzNs/HaVkKHUUKTL1zcEGAtsobpEcb/5JktG
	 2SeW5JNogQcOoYNU19gDYnn/fxRaig7zvOIqk+Oo2KrT3r1JiGTEgn0dOb2hJLSefYOPh
	 UW+TLG390RAH8Cpm5ZSm7ebStf7qNkFYTQWz3yCM9MWuMcDKMXJdD1hBL1jzdymYRKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794959855;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=q3OTBwL+TyzHGc36tg10hWnQr6i2w3v45IA4aHIlkR8=;
	b=OMehO47Zyk6y94k5rO+Pa4HLloj/iWcgjP7IjNWxF/e0NqQOxrzamRSt6dKj/RhGKBdH
	 qYsUBOHwjTn+D31rUhcZEDCDRVH8lPma3GRhAZM3vXpHWdjfj04vfftGPWOJRhzNB7G0l
	 iyr+GspVsmI97zD0JklwTRNCa2XW0Ts7X1COgoamtoyC5JEWWvM++bc/MWGp0x0Cx0jtH
	 R00CcE+VeImGKqyv9rPOplitgf7V8DPpkirZHSAAASC/kKo/8/b4hEfnJPL/HOWymeI2Z
	 N6lS4i+WnD7sAwQPA6x+3azcUNFvHlNzw34qek7u4T7g0f4lC6Vg13Xxillzy+F1/Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u7zqySAa;
	arc=none smtp.remote-ip=209.85.161.50
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2020606A332
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 23:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2020606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u7zqySAa
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-71ac798b8bbso270840eaf.1
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 15:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794959853; x=1795564653; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q3OTBwL+TyzHGc36tg10hWnQr6i2w3v45IA4aHIlkR8=;
        b=u7zqySAaeYlhQpUqV32/X9eVu1RKlum8oNRsvTE0fE9E/aFMffn73Sjoe6uqQ+UtF6
         kFw4KN7mtWw7vryJ8J2BaTVqAinedz5zMu6sBZJux61Y73pSxtRTi2UVibzBDM07DXut
         zQDVi8UZ8hNSRxTub8QfrDLw6lhXILUFeJl9c/rooB1T1Z32GdUzCVlWmA9B6GzU+WLH
         FCe5awUUR1fFU7u/bKBu+Zb0rfEqOR0Hg5KrzgwNbQ58CP4ZiBGle/c+Itb7dkxBoGEE
         tWX1+5H46LnaqccEfkZ5MRv9NaFp9blwOAN8sSC7xlw+fTHzL491r8VuA47VelVm7Mvb
         KYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794959853; x=1795564653;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=q3OTBwL+TyzHGc36tg10hWnQr6i2w3v45IA4aHIlkR8=;
        b=Fvz5R7GzrWKIocwNaotQNH8qK5kWSpTWx8LtTOqeYyV0lkoUsfse+dY5kpK6Kvc+qz
         otaTC3uUGM4YOOwwXGBwNqtzsykC3NYSwJYeNrttj3tAXudU0aSLDs0FS9AXsOX7gdQW
         N4jl/pmoFEQkFshpcBkEI4l3jTBf1a9qLHu53jVWH9A0gTs81eCgZkJqdPywss4Tt9A+
         3i6nQngw/RZ7rocZ81z0xdUdvT703HeRQkx5IIuigc3ZsKNTiDD5xfXjgqkPcEphrdNB
         Mdl1f4iPGcfliWVHtMHBhLUHuV7/6A1eKuJGIu8ypVOeMNbVBDJY4PN/tYZRk56yYgYm
         Ta/w==
X-Forwarded-Encrypted: i=1; AL+hErEuW3afhm2hYlFSguz1/lvO3wsiJKS6nvEq2dG0Ipv7jl2r/0i7RFBi4CjLCpSnT85FGkOHg0EQ@vger.kernel.org
X-Gm-Message-State: APuU4Z9ug2cEZqtfhIKk4k+a8WyJfZ1db2cyur22AJCXfnaJ1GTSKXAf
	xIg/WbCvUg3VZnyYtAskMNeP1umbOt8rq/fv+v7L+MG1ha7ay4KsjJoy
X-Gm-Gg: AYBFou39blUcPbhxvphX0eF7KqK0jHyUNj7/xNMFnv2F3BBwlhTWD2x0dPGwchKTUKo
	q3pjDTRTCjMBuILdg1rjDG+zJxKQ/ixLhbnzhu+M881WA6GsDGzIWWYhEut9n1aid19/1GnqNy5
	xxh8vXnklh3TCgAqYx11tF8HhVa3i1duUqqhc7lSVXcjFXzP6bIM3jP1pVg5dyDHik7cb928x0Q
	a9MehakRIIIRIWi2WMD5EuT1L7iLEeBRrs246AsauHjzrbKZPRBiiJ2O0B+bqQMNaqCUjP0TVpH
	ljka0VOGW78b0qLynIeIRQa5frPwIrrL+9W1WVCZXAlfC9JMHcRGoUp0s7p+F1mm8jyNs3x8Nnm
	DLlmZECaZw12QEhidAqTy1ZucW2lBcqLzkzVQcHTKcj87fqj621PZ8bXMtUi04Q0SUHwFyTrpeR
	XJq36KKtgbSfT1n2mWKG76R0cxyLwuPQfJNLXH3r0aYs+rJ5zM/05VR+tI9mLWpT9l/TbnyGUoH
	EOryAmY6nGLjBpJ3GQD9yj2Srs14BwYZ52PftqlL5qL2aJsOplaVQajKNmHnBG2+RnVSMunyCv3
	bpPyyOnDEP3PB+zmA/QXgYmjQ8lE2pnYYEhIoENlCxc6rdghhw2beQVFj9JR
X-Received: by 2002:a05:6820:1c8c:b0:71a:e1a9:4b74 with SMTP id 006d021491bc7-71b1859452cmr762291eaf.72.1794959853612;
        Tue, 17 Nov 2026 15:57:33 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71b1945800asm648215eaf.5.2026.11.17.15.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 15:57:33 -0800 (PST)
Date: Tue, 17 Nov 2026 15:57:31 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Down <chris@chrisdown.name>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcg: fix zero throttle delay on 32-bit kernels
Message-ID: <avznwfoMxq9s2NwC@devbig011.atn3.facebook.com>
Mail-Followup-To: Hui Zhu <hui.zhu@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Down <chris@chrisdown.name>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
References: <cover.1794902513.git.zhuhui@kylinos.cn>
 <6931674296b98139f5e02821d66ad1855eba36c9.1794902513.git.zhuhui@kylinos.cn>
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
In-Reply-To: <6931674296b98139f5e02821d66ad1855eba36c9.1794902513.git.zhuhui@kylinos.cn>

On Tue, Nov 17, 2026 at 04:04:20PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>

Hello, thanks for the patch.

> calculate_high_delay() stores max_overage * max_overage * HZ, computed as
> u64, into an unsigned long before shifting it right by 34 bits in total.
> On 32-bit kernels the store truncates the value first, so the shift always
> yields zero. Tasks over memory.high or memory.swap.high are then never
> throttled, and the reclaim retry loop in __mem_cgroup_handle_over_high()
> is skipped as well.
> 
> Keep the intermediate in u64 so the shifts see the full width, and clamp
> to MEMCG_MAX_HIGH_DELAY_JIFFIES before narrowing to the unsigned long
> return value: a truncated result would escape the caller's own min().
> Nothing changes on 64-bit kernels, where clamping each term is equivalent
> to clamping their sum, which the caller already does.
> 
> Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")

Is this the right fixes tag? That one doesn't introduce the division by
MEMCG_CHARGE_BATCH.

> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/memcontrol.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d16..1ba42724ed1e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2576,7 +2576,7 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
>  static unsigned long calculate_high_delay(unsigned int nr_pages,
>  					  u64 max_overage)
>  {
> -	unsigned long penalty_jiffies;
> +	u64 penalty_jiffies;
>  
>  	if (!max_overage)
>  		return 0;
> @@ -2601,7 +2601,13 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
>  	 * MEMCG_CHARGE_BATCH pages is nominal, so work out how much smaller or
>  	 * larger the current charge patch is than that.
>  	 */
> -	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
> +	penalty_jiffies = penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
> +
> +	/*
> +	 * Clamp before narrowing to unsigned long: a truncated return value
> +	 * would escape the caller's min() and look like a small delay.
> +	 */


I think this is a bit verbose for what is happening here.
Why not:

return min_t(u64, penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH,
	     MEMCG_MAX_HIGH_DELAY_JIFFIES);

Or just dropping the comment block seems fine. I think folks should be
familiar enough with values wrapping around.

Thanks, have a great day!
Joshua

> +	return min_t(u64, penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
