Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0C54C2269
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 20:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789589088; cv=none; b=PJQWPqQaFxf0zhK3XN6p04YmpQA4aTE7NZ0GLnyDUSZc3Woe1U0nbgSV0Rl8h7HNBy/2WvRnl7d45JtpTYORjeh6Wg0flU62E6XpR5phARwIe2yqnmhyVjX29RymzJECS9vrxnIhVyZc7RaggVbnT9BnFZM5My4Lo7iFM/JmZDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789589088; c=relaxed/simple;
	bh=ihZ35iU0VI/7mp+EmY0VgHI5ZWg7b+/5sEh2IzhBvNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlPfSjrQ09Eecvl6You8boCi6nkbRWPj5wq0NrnNeSpbYGsDL+TxiGjoaOP0aiBJopvV11p8tIC5drOhgEYxCUMsu+UrLx9qjRhdEA+9vqeJcUms+8woCWjNIpaKh3PKfaPwEb+Ofu1EpphtOI+dNS2VzI9P03oax76zpRSLJjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=AniVZPYl; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="AniVZPYl"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-91059280d58so347126d6.1
        for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 13:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789589079; x=1790193879; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LYBE6fjhCC90VNWvARTLSCkVoVvNv7gfJ6w8/9LQtiY=;
        b=AniVZPYlfP+Vq/g9a5qel0llK4FnJ/QoYiF5jhEig1PN1JchyCwapQJV8gaaAjeuto
         Q0xCSqjxYCoi7+doIYvHs1rn/zCZRkZAZjN3aNfH+S11nud0kC0ejile9YlGQy9UGu9j
         BpQroyO8mzr/0BPHIgUFhQoa63i7CcZOg4C2iaNBmhyyIfCEsuVO8ljGDqctz2dNbPsw
         OqYxg6+FQ+VxnHvWWZm9J0fE/fzMMFxPx3qozKzETT4R8xnJspFbAAixThGpPh/r/jGu
         C3b9OMMmVs3q7SqxN8DkYMbWoi5vF3surSSa7tH3qRBm2vASQL7X1M4q6WexUkkx1weN
         qX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789589079; x=1790193879;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LYBE6fjhCC90VNWvARTLSCkVoVvNv7gfJ6w8/9LQtiY=;
        b=cvxH4bZDyzP0tyVtOB0+moddmjLzVgEGKJaOYdtpmRQrKfZaeX68E6Zaaelg+W1M2i
         m/020dcXAvZpznYgCOQvYSVT5mf8mCLmbfjiQ44PgSwCK67z9cW5WRr2/hHzFJy+DC9E
         gHeNJn48QoBmvdUl5W6mEff8jaa6mnlhEo/N1LRBeXmmm2Opg0Wwmy5hg42SahldAmVv
         Z+fye2h/lMOZvwITNUyf4Se7Sdhrmsyc7u21Aob5HoR8tkZvqHb1gBJl16rwmz2nbjnb
         2KSIFdtrsrd9veduxk+tpz7UvLK8FE+xieUE3SBosG/2yAxp2lwcvShdfYRyq3eZvT7Y
         +0+w==
X-Forwarded-Encrypted: i=1; AKwUvBwaqmjN9yiALH+FplCg/r08tieBmwGRVOzlLrDjNM+OVys/wGS+0K+EigxRqoAhe3X00jF82MBr@vger.kernel.org
X-Gm-Message-State: AFuF++n+0LpHu5Mdfpp779L6nor4n7vNN5J3B+cRW15WjV/cVUGcBDHT
	S/lkrT6B4QHunIgC9m0kgO++sMIsfOH+m02t72+V0hY0oT1gvPjUbvySmJ6tvUUxsTg=
X-Gm-Gg: AYBFou0JcSExgJ/vVsBE0iX28ikLibfzrQxRHIo2Gdn2dFp5pjeeMZNtAQV0izG5km9
	xZdI/pKBLHA3p6xq7yqrItbSDXzo/tkUwxlC+fj7KRWn5UjQKzQIJshg43y3bN28sTK+SPMDW8t
	NabYSZ0Vk2B0eZVblwFc9m9UHWdXpsKdLKEVveM7Zx/FehILq1w/TWkF62tWoxAQE52JDhcZqtz
	5lyZuejNjyMMFyOK2cmicEACgpWgyV0gclaHqL5mZDlYCCFJDqovPTMaQwrW9HXtnwulSbU1z7t
	GAnseZpI5LUeIwXEKf8oCJnSyipEIAJUvCZc8Kq866O5jNSSPefWuA7F9eJ8EN9IAXI2arRx5TP
	rNWZ5WeDVBVKo5d7xHfQ/77pHDCz4D2RgZK2iV4HQHYVKoCDrM/k1adT/95RhAyASgRBmI95reY
	/KKc5neIhdOTdF0mxXYKQ9cAJR4NPcIhhgC+nGuCE9n2/8U6RuniyL932T7b4ehqSac2SF/Q==
X-Received: by 2002:a05:6214:404:b0:8fd:d5a7:f970 with SMTP id 6a1803df08f44-9123d754226mr75992146d6.11.1789589079282;
        Wed, 16 Sep 2026 13:04:39 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:1f35:22b6:fe30:2a34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123be946f0sm33219756d6.27.2026.09.16.13.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 13:04:38 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:04:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	yosry@kernel.org, joshua.hahnjy@gmail.com, taejoon.song@lge.com,
	her0gyugyu@gmail.com, lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with
 per-cgroup selection
Message-ID: <20260916200434.GA5784@cmpxchg.org>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916183437.2946306-1-youngjun.park@lge.com>

On Thu, Sep 17, 2026 at 03:34:33AM +0900, Youngjun Park wrote:
> Per-cgroup swap in debugfs
> ==========================
> 
> Patches 3 and 4 let a memory cgroup choose its tiers through debugfs.
> 
>   # swapon -p 100 /dev/nvme0n1p2
>   # swapon -p 50 /dev/sdb2
>   # cat /sys/kernel/debug/swap/tiers
>   Idx   Prio
>   0     100
>   1     50
>   # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers
> 
> Bit i of the mask is tier i, so /batch swaps only to sdb2. A tier keeps
> its index for its lifetime, so the mask keeps selecting the same tier
> across swapon and swapoff.

Can the cgroup be given a priority limit? That would have pretty
obvious inheritance semantics:

root
`- batch (memory.swap.prio.max = 20)
   `- task (memory.swap.prio.max = max)
   `- logs (memory.swap.prio.max = 10)
`- interactive (memory.swap.prio.max = max)
   `- task (memory.swap.prio.max)
