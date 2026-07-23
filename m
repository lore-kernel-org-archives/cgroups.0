Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC55F2ECEB9
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 01:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784771984; cv=none; b=IazWjWyUMYt9Jg70gzHlRgAhqByDuXtmwr4dz0pfq0lbV/AFt5epJT14VJ4mmKv4kDYEdEXOVt3abPtVY1DTP3bKa2BLmnLZvx8XL4LAJK9VrvykpOq3Q6BTPqV/ODca4y7PFrF6WrfJ/BbfIf1oiNZRqOd4QVL2dncoi2mt7Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784771984; c=relaxed/simple;
	bh=w64hOozqaIcFFPfK6/6Trc+ayzg8PjRrNpXoQtbMPlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lYABAG4KVgvVuiu1uGon4Rwsavk13xewouUB1rWJJk2un0QpsUokrNKpZNGQgzlKjn5x6R+Ogp5bTBG717ISZlj82aO8Pn6g+m98gF12TmxYcAhwRbfVjux46iO7MqCksRQtcaBRQ0g/LfrwaRgVKvtmgqFIKwmoax0jgWM9Vx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=STNtMUIN; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="STNtMUIN"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92edb12cdf2so7624785a.3
        for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 18:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784771980; x=1785376780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ME39BOUsgETsp9b9ZszwmQSxDI6GW0t/fX+N/500D9c=;
        b=STNtMUIN1RMMToSm9UANZ0sGVmlRnO2lGnBHwhc+lSEiwo2/4sP1FoAnLWc/AKYIvs
         30LpAbhSc4DGKy3e/QM2HhJyBjwu19TbtvSRi4llbfXvLTmc2NlWxqs/F3wZctxxKAYD
         unYv73VEmnpQYAHuZnimYyC5nYtsesknv64PztElHcBvkqrqI/5PL1amUG4IYOKb/JMj
         IWPfWh8GCWIzapD7oxCFpQYbX39xkpiC9YSjETzMua/088hGRP5hfw5jYcRnZ+UY281Z
         eHcWTrd5uj38Zhmh3KNO/9Sqcaju1toH6pXxnneLDTZIwmmVq+T5L8YHEAcYjuJ43bj8
         Ia/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784771980; x=1785376780;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ME39BOUsgETsp9b9ZszwmQSxDI6GW0t/fX+N/500D9c=;
        b=M8Z2eh/KziPluJ066lM4uDLtZolvDbumiSr4zYGIMx0wFDTZGXiHUGuVs6L2HIAi6a
         1g2jrHvDYA4n2tZ4eJ0xP1QmV4J6Wd1es4j/a8Eh2P5sAS39k3P86vQ1QFTpqZK5K4KN
         pZUPARKkSa82jhwedTC2u+RosCsabbP7lKtiyoHsoXotfYfYRaqEfLj+c8JSe93LeCuX
         qdRASLLzQXRBoLWJ1dOJ3qEspE4JZMo9KUef7ZJJtJzT4WuPyoB68xs3o1QsmZd7q4Gp
         87i+Ju4l6s+2vS7VBJjWAQjdrSX7Ui/16iytRuTccgdzxG2W53zgAI99GhMBuEFZryPA
         Zjzw==
X-Forwarded-Encrypted: i=1; AHgh+RpO1DthsPEMhxkjBYI3Emm1h2wY9J64Hhw5m8L4rwowcSqCwZJQefRLayDqFwtDyDVotzIZuy27@vger.kernel.org
X-Gm-Message-State: AOJu0YwrgO6cirs9mXzgj44TEJ+Ji+E/sc9MCdQkitCgwoovfDq18Lxo
	AWmCSHdiMQs9KQLl2oyWATcjH/c04QjhDSO0b9FUKQ1RfxIN/LsOCdjD7QmVwYeHSX4=
X-Gm-Gg: AR+sD12KL50OSa1Uc8F5e8WkXHqviNkA5tTb4iJl6fvRb/PcFOn0JhkBUn9DIq5h7ie
	6yf0jN1eGHGYI0N7SgWUWY7mUuC6Gl5wFAskFSGjLCXY6UUp4/wxGjRHmRZ1J/ddNqjBTFK1FiG
	FaIaWVouHxtk+7XmfEEQ2jkZyx7inSsYR8Gn6SM/8rpf5l/8AbvLv+j2qNXLQGHOE0vM55Cjebe
	nrydPIMEFB5z5oLvqkfO1Ivzw2Pgzaqk+lfx0T3JHcMJW/8cxmAW+8LAxF03yM11P6vtGwJupc0
	BfWwTex7njhOmDbilCRRieyfITGzqNoziQBTMH2+6w69oddr3lGnLJ9p3GDnlDbUgTdLr+wXcGR
	iI97mVJOhjqfPtJYJp4NKGgNfpvwHehwITEHfUOIq5T0VE/LeO9zPAGlXw20g2qazkZaXy/CbLZ
	v7
X-Received: by 2002:a05:620a:440f:b0:915:8f08:5fa7 with SMTP id af79cd13be357-931036d2152mr124807685a.52.1784771980540;
        Wed, 22 Jul 2026 18:59:40 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba9e18aesm34212396d6.25.2026.07.22.18.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 18:59:39 -0700 (PDT)
Date: Wed, 22 Jul 2026 21:59:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 1/2] memcg: move mem_cgroup_swappiness and
 vm_swappiness to mm/swap.h
Message-ID: <amF1ii74RlzKiepO@cmpxchg.org>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-2-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716031729.1064007-2-ridong.chen@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

One small suggestion:

On Thu, Jul 16, 2026 at 11:17:28AM +0800, Ridong wrote:
> @@ -76,6 +77,25 @@ enum swap_cluster_flags {
>  	CLUSTER_FLAG_MAX,
>  };
>  
> +extern int vm_swappiness;
> +
> +static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> +{
> +#ifdef CONFIG_MEMCG_V1
> +	/* Cgroup2 doesn't have per-cgroup swappiness */
> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return READ_ONCE(vm_swappiness);
> +
> +	/* root ? */
> +	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> +		return READ_ONCE(vm_swappiness);
> +
> +	return READ_ONCE(memcg->swappiness);
> +#else
> +	return READ_ONCE(vm_swappiness);
> +#endif

How about:

#ifdef CONFIG_MEMCG_V1
	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
		return memcg->swappiness;
#endif
	return READ_ONCE(vm_swappiness);
