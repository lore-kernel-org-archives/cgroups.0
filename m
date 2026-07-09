Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611E01A5B9D
	for <cgroups@vger.kernel.org>; Thu,  9 Jul 2026 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609276; cv=none; b=XwbyfF+m63N9/w/ETKJpze1F+uAAkOAcyvfAwa9Hd4n7qPbjv7s6c99dp5GWCfCQv357yo6/ahukIDMNkNvYJeDcfFXrkZ7JeOJaz6nY1IyFp1v+YehYsO2XIWRYs8Uu2qJa5dSsgFq5NCjBrgag+L2zEfThawxNEJSurmuH18g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609276; c=relaxed/simple;
	bh=Lr+5ewuwnuRI0XQJvhazEBz3R+huyj5xuWkRpvr4yT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgrwUGezVrb0oEK43ieHfTf/MHEqQQPG3jZSD222pJoXsDhUTVV2kcby/hYT+WZoL8UAEbfisnLdySi6kt6zCPjUBAD8wBxdrNFtp5fzgIY9AcIW2/D0mbdJOpaJ8LUf2vJfuESav7Qe+ultvAfm/xTxmaizUPXR8B0gqn+17eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=UgC0LK9s; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="UgC0LK9s"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8efec2c28f8so14458396d6.2
        for <cgroups@vger.kernel.org>; Thu, 09 Jul 2026 08:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783609272; x=1784214072; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lCoCDKvKWAelS8ArabvJ3verPItQS1mXV1mG6RVch54=;
        b=UgC0LK9sg3qH03Cw+jLytqCbxtNtUM3AsGZw7yx56l6seCUZ708yx3ZBm5j1NGOBfb
         8EblrIUBcajU+jzC8t+fSLglTkfY2jy35M15CsYrfiO6wVJKnvtaskTNBhE6FvZnB1uB
         OmdD01uWbr0kzLHnjukh29iEk8wBJxP6X+zwYCMahoAAD3KyCjaq0DR8yR8acrck+WTl
         WHLVA86/6/3QvdXM6w219+vFP58/SHUps+iRO2bXYm4PHjCUdVpr80lot5Kjo3geZWde
         6QncQEXj7a9z7QwzQA0rw+4UIPSFC686he6sW768yNc9Uco3C5N8zqzXOF9fbPyeXFoD
         c3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609272; x=1784214072;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lCoCDKvKWAelS8ArabvJ3verPItQS1mXV1mG6RVch54=;
        b=U6y1BaIlAuHV0cQnW7N53XNtVunMeGIOz5xbAZrwWub6D6R1I3cxdirLKh5Rk0GUYw
         JtbBvaelsrbMxC+CwSFTKKzyFzAuQm1q5HkteaLn3gl3Wu5RcXYonSpUK34oFwIar1p6
         Zc1189ZpDp9dbwU8/csA/bXfDQNOrgPdWnsV1MQw5HhPKvd+GHOQ+17mXDOyw+gEWtom
         b2X2zrXvw5UyM4WoU0KTHI0uc7mJnxreSleoflAmHMN+l4emGRhNRPqW80fqNDq/dIjj
         qXjQWsSJJmFupPkP+P0suk26bsKJh45ghYAx2ffhwd23x8iSv20jKcuV+DVynu7lX3Hx
         XgPQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr6vFDTcjHoJnH01rpYFVfQAJLr170Dicm7rGGXqKCK8ti21VZEURa5oo8j6V1/eKxo7lmFPIQ7@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6/GTxROjq1mTzyJOIIe9IpOWIgjYp3FdpDAmUxhol456XIIym
	0OJhy7IRWH7IEXwpNteXypvBrqmgrxUx22r1iGgAxyA3ZpG3dWmAKqML3vupAfWdK1A=
X-Gm-Gg: AfdE7clHfgJm74CGSj5Puy0SBaH0yqRsKbAdKmx62ESiunZNdT27stZpwQkomfdmTpS
	wRDcS5Ov7s5u9GbQgzNS+vZdtOCv5eIGyQYJEPcbqMb81W/132bxPeTqNNXQeXeQYF5EWMtYB0y
	MCaiovY8BV7sl/4o/Qd3uisnJ+TmX1pVAxjWR4qL3GZ1F+/iyCn+1eaHUXVZ0ub9JAln9boczc7
	UQuxKxrD/Pnv93O8jP+J4o8arBTAiLMlEF7zRru0tc1qgVwo0ifHWP9nHz0+Gc1IxM2Z8zwmR4y
	NL38SrxwXjCuku9yinOdwhvAlQVKl0sKgCZkZfVQolgXHdo9B0ZZBdARQ0xRz7tehatf9d36gub
	pX1ibu+jorzamb/iD/dyDFv/Sc+esPQ9qj+ZrbLNpINBb6X+0hJfNUy5Slxbl04B2CGGMUFHHZm
	IX3iTGUD+T+WU=
X-Received: by 2002:a05:6214:1305:b0:8e9:f62b:8fa2 with SMTP id 6a1803df08f44-8fec342e855mr93084796d6.55.1783609265440;
        Thu, 09 Jul 2026 08:01:05 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd81f4bbdsm18994596d6.36.2026.07.09.08.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:01:04 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:01:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Barry Song <baohua@kernel.org>, Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [RFC PATCH v2 2/3] mm: distinguish large folio swap allocation
 failures
Message-ID: <ak-3r4i2qdejYzSP@cmpxchg.org>
References: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
 <20260709145124.764807-3-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709145124.764807-3-xueyuan.chen21@gmail.com>

On Thu, Jul 09, 2026 at 10:51:23PM +0800, Xueyuan Chen wrote:
> @@ -5550,10 +5558,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>  
>  	if (mem_cgroup_disabled() || do_memsw_account())
>  		return nr_swap_pages;
> -	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
> -		nr_swap_pages = min_t(long, nr_swap_pages,
> -				      READ_ONCE(memcg->swap.max) -
> -				      page_counter_read(&memcg->swap));
> +	nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));

This hunk is unrelated to this patch. Don't mix refactor work with new
functionality. Make the previous patch a pure refactor job (where you
add page_counter_margin() and use it here ^), like I had proposed.
