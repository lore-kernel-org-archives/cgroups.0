Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAFC4B1284
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788444027; cv=none; b=on5ladJUV0QVXJ1uLmG014+EZNGsD92V1rPeE9wNS+U8ZOSPjqvMPKqqMt3VPUtxz4TyNd66z/J863RBRCDPO++yFev78hVyFKWyIksGIcLpwC2bvnA+yd/Ia8XRnLlkp1tseaJ76YGmknkU4hYCfA6v0q0l4u219Wq/7sRXXWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788444027; c=relaxed/simple;
	bh=FjtcxQDS3soBj9IDfIhk0j1GKjqT9WRyMUwdeko7VUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zbd8YX1OS73mGyRCm4jDsR/aRQ1Al7QkdWHkmZbeBWKCocJgRJZ7uBV8P4T+tqYA1CVeLjWcE2s3/M548V/EjT71pD4AazQ+UlmMGfz4BUUWECW1akURfvZyidNwRov0fBMZT/miYpNYXy8VtzyOMJcOCMQSO7uRjcfNyHNAfAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=i+mWn83B; arc=none smtp.client-ip=209.85.128.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="i+mWn83B"
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-86162c086f8so15445017b3.1
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 07:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788444010; x=1789048810; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q6ffg0EsM9Oq53XXehfd0nBgBXlCf1MLMwzSPDpkFdE=;
        b=i+mWn83BU/HWsqbUv4DI1g+BtYxIXy+uxw3xAtuZjBjuoZwUUymRn3K0ArjuuQFeJF
         Z4ybYB56Kku2XDJf3WUTzkjpl2G8TtBOdNxTpZkLA5WenBaLBiXKzC3+jHSuRgqL4uQI
         XoFxkmSgAQtl+m2NmxGUDYnBr2dnOamGtId2sYNBSlRuDLgmLsUdUz9nOOqmKa33GMab
         t4VTDSPEYQ1Ulz7LAg/qYprc/Q1ZW0DEhit6VpOj7/FwX0ldz9frFCfOVn8TL2M48det
         2IXiTUxZbiSCQB/VrUPjr7ikgFycdKsN50YCduVVb3cnwmTgXDcQyQCSXJa4+va5vXUi
         x4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788444010; x=1789048810;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q6ffg0EsM9Oq53XXehfd0nBgBXlCf1MLMwzSPDpkFdE=;
        b=Ot6oIZVFjcRiwSYPssxR+Dd8LxX3LgqA4I5ZG3b+uS8v6EuDFPTDClDINFhk/wOSCc
         /m8NWy1wYd3Y3iyvU2D5q6yPLkifTBG4J9Qn8cabrLdfBmnNdqSVAtR3GRDVmqOlid1u
         NrVPmODFjGeo7V6df+T6rWdhlC8Lp9Z6gLMk4Gw7iSEmW2kJ9HoDfQANFDdhc/QE9Ptr
         W3sxcwVx15wSRdKQci70PqTPRCbu6gMOdROIrbDfzzNOhLWHyffeJLdeV3x2O6GpwoTJ
         H2rDs4Z/vhhiTKiaSxeR5aVUkY27UuhiOUpUFJucnXyBbdIAuuvOhyhjEnMI+P3zwFIA
         SqWQ==
X-Forwarded-Encrypted: i=1; AKwUvBxbP7Ul8XEiiPhAJHGrPWDtWwi1k/wm/ym7D5jXSPPWnZRP4E7EG5TdO/C7d0OjI3Mavt12JM/x@vger.kernel.org
X-Gm-Message-State: AFuF++lOv8liaC4ewz2xiOvD86ogmeerbN8Iqfxv3HmmdYqij+sI0mrO
	maFtRZ+aPOM5y2LsqKhF47sU1wSzcUUcrDO3I9HlVTElvvkpfJW+NTZK6BbF/ba5V6g=
X-Gm-Gg: AYBFou1N8dVRHOjHVH15PUpGjrVSghAbMNITCXpjAF3lvPdfpQJyVE6XQBZh4BvHb6c
	7u30HGMW+qn6XQdlxmoAY4sykYLrkmMJ/jKVjlRfntLl8Q7PZ+M9VAaIcRCbT+j/htuUPR7H2pP
	t+ErlnR+tdD6zEbKWhDLAR0hW35QN8f2AappHmsedP0mkdnQHGxhm9mTvLnH/QH6ZVW3cvI3GF3
	bti2y6zigLCXqD/7EDAO+lF8pmFhbCUL+eA8QaSiMx9/rfbAAzTlXgN4dr7zmHMXHOlT5lC4EPa
	H5tCq0xFweIOILmQf+j0Ghf5w4cid+bMof8YmDUG+NjsLW396TzHJn0/UAhzb7m6QaYK4QeN7Cb
	zSAT72/QT5IcdN6PsxaDqc/L6xoRv/V/q36DnGwgkAALS33OXmK+OoqABQ+cAibx4ZHpI3KQmnD
	hmz1XiJT8u3g+K8vwwh3GkTmau+pxgMSEgEwA+CyK+0gCdvzdBRIMvALKrDVUX
X-Received: by 2002:a05:690c:a84:b0:7f0:38f7:6ca6 with SMTP id 00721157ae682-86e6d7905ccmr34387887b3.5.1788444009533;
        Thu, 03 Sep 2026 07:00:09 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c12d92d9esm40198227b3.22.2026.09.03.07.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:00:08 -0700 (PDT)
Date: Thu, 3 Sep 2026 10:00:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
Message-ID: <20260903140003.GR3004@cmpxchg.org>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
 <20260903031952.1120321-2-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903031952.1120321-2-ridong.chen@linux.dev>

On Thu, Sep 03, 2026 at 11:19:51AM +0800, Ridong Chen wrote:
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

Looks correct to me. But a few nits on readability, since this code
already is quite painfully complicated.

Please don't do math in the declaration block.

`unclaimed` made a bit more sense when it held *this group's* final
share of the unclaimed protection. As an intermediate, it's *the
parent's* unclaimed protection.

Put together, it should look something like this:

		unsigned long parent_unclaimed, parent_unprotected, unprotected;

		parent_unclaimed = parent_effective - siblings_protected;
		parent_unprotected = parent_usage - siblings_protected;
		unprotected = usage - protected;

		/* overflow comment */
		unprotected = min(usage - protected, parent_unprotected);
		ep += mul_u64_u64_div_u64(parent_unclaimed, unprotected, parent_unprotected);

With that,

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
