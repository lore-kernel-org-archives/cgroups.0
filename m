Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED293CF1F2
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 08:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511069; cv=none; b=RikSNixVJoi8fVW041zzw5E3wgrof1jJ4Rc01/xowL00XEHOHHOXLkHIxfuCf3I41FU8/ZmLRFse2wM2Fcd0hxd+yLoWNIV7YnEGa3tTnAqFfnkmHQXOGC2+N9FftjqQ1EtZxpcMRTET6Vmrfv1mznmUXdtnMSUNHhtetEMcXAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511069; c=relaxed/simple;
	bh=JNVo3mCPeHl6ES3fr1l9fzdDZhXVPKNXb/7te67rFJA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrevOrPQY2yQrsXgnmZKCYl1AOXiF04Es6P0euf5k9nmZ9V65LlIWaBxTPA3WPkI2Zh2l/wNN3B3w5/vypBxLpQWeLxziXvDALMn/cAQp8mwC4aGSbw5P6yOsHiXK0icOXAUljxNjcxZnvOKFk4DsF+dynEKtHx9eg3WMrLZVpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=It9jDnEV; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="It9jDnEV"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so9913345e9.3
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 01:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788511066; x=1789115866; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3s1LbH3i67Aex+XO8TqzHfYjkZ2LQ+Zdti2dOun8vp0=;
        b=It9jDnEVCbZVR9s5JO3WJcHTmGDv4Qvre+NAB3GUZs1d8/27QCs3gM890sAJAfRu0X
         QXW71DDQXO+Bm5q5BjpqOjxDgpRwnGLANq5vYPrpr5vu06y7qevH/bd+7zME9iSg2SyQ
         O9XxjOIXzdz9zr0wVl1a4UG3RPYhyIurxSFVdnb/VYMOOPXHI2vbrFupWEyr4BOoTrWk
         9yTZ5jvfCIzY002hPglb8hNKqvIW9iB+TZez5fD8kTaPwEF/k+pftgp6MvufxC546o12
         RaXRMaiJSljwTsHyFmgEWatoGmCnDkVh+cjv7zxYkAG/xQL2srka43NFz0RhyAGDTxmv
         ycYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788511066; x=1789115866;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3s1LbH3i67Aex+XO8TqzHfYjkZ2LQ+Zdti2dOun8vp0=;
        b=YFQboAzqySOgVdGYzITHCyHU932C9pxy4xkAtPbAUcAg/seUSntJfNmlix7MvCFWwP
         NOi8dnki3W1/hLDuqJznh1Os1SgD2UV3Tdlg6jBiA/5/UyN5KY0toqcsAcCpausrEvL5
         s2pJ7OM/OPxXFwbO6jvBQ1raabb1kcq+bucfi3itBKTbbgougtHuSqtgwg8yUt+/jD4Q
         0fGsE9woroCYug8P1wmseNazD+qnlg4PgwXEKDnHCVtKWZk3wQBi/p+pUD2phkJL27Of
         hMVKjg9i5P0vqy38RWMXOz2KbZyi56GKM/gF4rrnDac8/YFFmZ4AZJcqV3RzC2yQSgo0
         eo3g==
X-Forwarded-Encrypted: i=1; AKwUvBwrrc0iLxE2+UVV3d4aQ/5f4EHIjPqNW0Hgxsj7PMVWKGsXRshzIc4qe1/m+i6o/DqBcNt/r4r5@vger.kernel.org
X-Gm-Message-State: AFuF++lBNvv+crY0f7IuXwy96r3Hd5NVojVmZWezgZ0I9SPJEsFh9LF3
	b1LIYUOnfjCKBaPxYM6v+nMcCIsI5xZwlBDsOPANqyd9BiIpgzsMxSHo
X-Gm-Gg: AYBFou3EkGLsWz4vq/ic85FCJGdB9nwn/V6xgwx0SRR4s7S8tIfjcqh6iYOyc9873/W
	x6UIujMP5Zh819yi7+sdNkA1BgX7ce4/TG2gOm4BqFtrKg9c3xe/wTDTwKh//UNvKVC/OIqHhcm
	p4p+u6782xrcIMQ9WwKQ95WnDl/fE855fg6cbEPgflczBaw64LwcdIkvV7C+2JSCHvsBGxPm2mn
	diNzHVhuKS6SPiDX9mLn3oG3IJpjpG/KfXatdz/DDPHk0K3OiT2rHQCqQv0jcQvEVL0YpcMka1e
	me8IPQjMTTBnCD9uUaayb3ZGYZZi/IuBFZiSsBkDDhzBRpKVFcfPuveRS4bd+c6635+rEiNKCpc
	1SySjBCEos8Gw4dsbagJ3b5tn+tNlwIl4Cpph5nIswPrMs2WGfLh+gq4fWPxeqf0aNJLNVH7EPA
	ceg8+swah2Tjq1Kvgln/YSAs+L7LtwsgX2xamKcGMx7ZaToNt9sOZxf6G/Kei8VZnjdJhuQlVXm
	fsQSAVm20JXRQi+Wps8U3WkNA==
X-Received: by 2002:a05:600c:5303:b0:49c:fa21:1c85 with SMTP id 5b1f17b1804b1-49cfa211d81mr22763385e9.26.1788511065589;
        Fri, 04 Sep 2026 01:37:45 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d4938sm137112065e9.2.2026.09.04.01.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 01:37:45 -0700 (PDT)
Date: Fri, 4 Sep 2026 09:37:43 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Muchun
 Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Chris Down <chris@chrisdown.name>, Tejun Heo
 <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, cgroups@vger.kernel.org (open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
 linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER
 (MEMCG)), linux-kernel@vger.kernel.org, Ridong Chen
 <chenridong@xiaomi.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
Message-ID: <20260904093743.23cde26b@pumpkin>
In-Reply-To: <20260903031952.1120321-2-ridong.chen@linux.dev>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
	<20260903031952.1120321-2-ridong.chen@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  3 Sep 2026 11:19:51 +0800
Ridong Chen <ridong.chen@linux.dev> wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
> 
> effective_protection() scales a parent's protection by a ratio of page
> counts, e.g. for recursive protection:
> 
> 	(parent_effective - siblings_protected) * (usage - protected)
> 		/ (parent_usage - siblings_protected)
> 
> The multiply is done at unsigned long width before dividing. On systems
> with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
> protection value and silently breaking memory.min/low enforcement.
> 
> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
> usage and parent_usage are not read atomically (a child is charged
> before its parent), usage - protected can briefly exceed the divisor,
> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
> the ratio stays <= 1.
> 
> Reported by the sashiko review tool [1].
> 
> [1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1
> 
> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/page_counter.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 661e0f2a5127..e8bd512069c5 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -8,6 +8,7 @@
>  #include <linux/page_counter.h>
>  #include <linux/atomic.h>
>  #include <linux/kernel.h>
> +#include <linux/math64.h>
>  #include <linux/string.h>
>  #include <linux/sched.h>
>  #include <linux/bug.h>
> @@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
>  	 * otherwise get a smaller chunk than what they claimed.
>  	 */
>  	if (siblings_protected > parent_effective)
> -		return protected * parent_effective / siblings_protected;
> +		return mul_u64_u64_div_u64(protected, parent_effective,
> +					   siblings_protected);

On 32bit it is only necessary to use a 64bit intermediary.
mul_u64_u64_div_u64() will drop back to the (probably faster) 64 by 64
divide (and then maybe to a 64 by 32 one).
But there is a lot of extra code before that happens.

>  
>  	/*
>  	 * Ok, utilized protection of all children is within what the
> @@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
>  	if (parent_effective > siblings_protected &&
>  	    parent_usage > siblings_protected &&
>  	    usage > protected) {
> -		unsigned long unclaimed;
> +		unsigned long unclaimed = parent_effective - siblings_protected;
> +		unsigned long unprotected = usage - protected;
> +		unsigned long parent_unprotected = parent_usage - siblings_protected;
>  
> -		unclaimed = parent_effective - siblings_protected;
> -		unclaimed *= usage - protected;
> -		unclaimed /= parent_usage - siblings_protected;
> +		/*
> +		 * The usages aren't read atomically, so a child can transiently
> +		 * appear to use more than its parent, making the ratio exceed 1
> +		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
> +		 */
> +		unprotected = min(unprotected, parent_unprotected);
>  
> -		ep += unclaimed;
> +		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);

If the ratio is forced to 1 there is no point doing the scaling.
So maybe:
		if (likely(parent_unprotected > unprotected))
			unclaimed = mul_u64_u64_div_u64(unclaimed, unprotected,
							parent_unprotected);
		ep += unclaimed;
OTOH if the min() generates a cmov rather than a conditional branch
then you don't get a statically mispredicted branch in the normal case
(which is very likely with the empty 'else' branch).

David

>  	}
>  
>  	return ep;

