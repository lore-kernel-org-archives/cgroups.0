Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795681847;
	b=A1D9j7Zxq9sbhfdZXOAk2IxqOs8sSbK8Tlcds9fm64LhvArDJONh3aNguH6QSeXYXgum
	 Otv1EbauaIbBHv7hfasOiB+dFLOWY9XsifwMjjcTvJylQpbGK9JX+pa0w8MVCkBvFxYqd
	 fdDVcbVQFlgz9rF1nsCVI5YU5OJISr+EoFkfUOCfx0e0mUd0ITepsu0+gUTyhb7eqc9R9
	 Nd+digmL8sCG9HCNOm8mS9YgpuxYRYt5O331JPd6EYtD9tc20Ds3ulWt6WAP4hS3Wmx91
	 TUipbeO7ZOOh8hudLgumsrxQo/PyrM75yVjQcQnC7H1mqB7dWN2orfoZGtOIcbNmpMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795681847;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=FyyIgAo1e3KK4/AdbdpOK9l3019Yj2VAw+xdIQTmPhE=;
	b=0nB6DeJ3dbOoaFIvcmqd+b40aSj6U7sq5b+x+h6w0OHS6O+sakzvT5EepGEMvrmM9qkO
	 qXGjBnWSY9ORoDZqXtqupeOpG8l6chIHWOmTM2lu5/XdPYWIdhvUDCeP/BVWhz0tF23js
	 HNaTTvuNnJ6oJiqY1AsRU0u89XgYCAAwHXVYG21GfelEOVEZqNR0xwo4izjS7F5Xz+aGh
	 KAlPkArhi+OPf9X3d/CuKJF1JYcp+XOAmUPf+smUtF/5twynO7bDwglQlkwOZlTJvzGzm
	 FH4Aglwa+2jsIBlX8hqLIOibkCBYcV+YZ7pSHSmzhKJIDb2dDGrYW4jyw+OKb+1BlQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="eCg/fjps";
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F79606A321
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 08:30:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43F79606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=eCg/fjps
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso36129285e9.0
        for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 00:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795681845; x=1796286645; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FyyIgAo1e3KK4/AdbdpOK9l3019Yj2VAw+xdIQTmPhE=;
        b=eCg/fjpswoW70jdAY+mfyk+zh8A7sPtwN0ZOj8XcsYLfY+IxN4rBvfAZo9jTNIV4yZ
         huKQSVldcKpLTjcvTpaEWhW6eYIR50k6YD72+/5ObME9AznGZVEzvoBsnXkrVaJPSLni
         lL2L6HInflOQoLQaYcb5QKVNWEqDcJ0hbeRYjhMjRajEg1SidC2tG2rn9PBzBZGNIY5r
         6vIobqG0eHeYJ8rWh59B5yxLh48EecZeZ+1rDwojXF5y07/F8vhZnh3YOFOvefR99QNr
         lfwo/rFhAH019qI9tydDvcnnbqT6JqLmm00sBYhgsldbCxjW5CYrx6Ah3BaRm4NTptol
         52tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795681845; x=1796286645;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FyyIgAo1e3KK4/AdbdpOK9l3019Yj2VAw+xdIQTmPhE=;
        b=uTkKoj93cPUksTrbXD92KQ6mDfbME9RwDY141ha/OHgJIKEnIaZDJ5X6YtjD/o3isp
         8o2cPCiZ+rlTIzcBo1b+YeHVlVd//bfhCD0YGxe6TAE7zhaOKkv1loLmwnBJCioeBwc9
         BF2cWDJuK+NXeaJWylTkNNCCGKBqzw3pJ5SYSW8H9dkHA52Jt1+dK9GmZI6F0sSlmMum
         EOyWBshNSO3d1zEuCbnBRfswU3siSAn2gPVAo+UMdk5dM1s9GW/SUpqP+UK4FOjU6mA4
         MAGt34Tcl3/fWAiACFz1WqMeKr0ps4C0L17R8IUyJE2Y9G0wIuiwSj82+A16NFVDMLBl
         zJ3w==
X-Forwarded-Encrypted: i=1; AL+hErGow0WcG360fD6/wX4e708SiixImjf5IOcye0podbGCr5IKF7uX0oz48Qj8oyOUIIt6Aw9UZIkT@vger.kernel.org
X-Gm-Message-State: APuU4Z9GmVOV9RrGNnRCcCY5e5YM8Xmakzab/fn/mU1/5lT8FspiCuCq
	Rz5S8nWGnlAny+0MbyF4XqA1lyfgH1WmLNgKSrqvNP76GtNZt2sZjxgyfzl/O8rhEE8=
X-Gm-Gg: AZFdTZe5CUsyiB9qIrgAoOl8e+6q8RjDciGp/yQiPbaVXHmHO8zAyTs7bEm4HSRxx2h
	6R1RAxHGmHIsGQqroBvTQs6R31NAhdp5oIg1T4dexIyR0lG58NH2I0cAIsUkI634yNvqA7fjMcc
	ITW5xA1tgd2eUTit86S+LFsn2zC0/XmBjnc/QbjrYGhFRndm24VWeqCe+JLKMKqMMKwzkHFZnM8
	BtXtQJAZVWVvylErtHG2Vs4DQQNkFz7ozwK13cbZHZaFNTQJ0WZEak6p2LURp/CSomQQfYlg2ao
	PPdwM0OF4JC0RN3hAxRWR4fJeIPq8Ln56/dg7WGzFHZ6Q/B1M/F7XCErad5ZYg2Smq47Wg4ZeKN
	BdHWQIx/YyI8zTeOtJfC9QL+WVNiwe33MWSJn+7rLhdilduOZg2q53Ru3UXQDudckLx7itwxglb
	CwBSUW5azD3nrusuxfgQ88sqyNpyVsxGpjX+NblvMuiu/shPCKCSs4YW1bvaPvSeo0+3DeQyTJ8
	GIVh4ZABhXkHIvKYdwImWDwk3hVzX7yC5kZoqx/NT/ngJi3RPolMve+aR5Jdi7EQvXPMUpWk+fQ
	oyMIrD7ghMzLagvPjn15T2/1jyOxANA//pq6UUA6
X-Received: by 2002:a05:600c:6219:b0:4a1:d087:f6ab with SMTP id 5b1f17b1804b1-4bb8880badfmr388991925e9.18.1795681845543;
        Thu, 26 Nov 2026 00:30:45 -0800 (PST)
Received: from localhost (109-81-21-11.rct.o2.cz. [109.81.21.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bba3d3679bsm61507665e9.2.2026.11.26.00.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 00:30:44 -0800 (PST)
Date: Thu, 26 Nov 2026 09:30:43 +0100
From: Michal Hocko <mhocko@suse.com>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memcontrol: expose anon and file reclaim statistics
 in memory.stat
Message-ID: <awfuM7vj5Vyb6Fjb@tiehlicka>
References: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
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
In-Reply-To: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>

On Tue 24-11-26 15:51:27, Xueyuan Chen wrote:
> The aggregate reclaim counters in memory.stat do not show how reclaim
> is split between the anonymous and file LRUs of a cgroup.
> 
> Expose the existing per-memcg scan and steal counters by LRU type so
> userspace can measure reclaim balance and efficiency when evaluating
> reclaim policy. Report the same counters per node in memory.numa_stat.
> Both files report the counters in base pages.

We have found these stats quite useful when debugging issues at the
global level many times. So I think this is a useful addition to memcg
stats as well. Especially when we already collect the data so this is
purely a change to show the already available information.

> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  Documentation/admin-guide/cgroup-v2.rst | 20 ++++++++++++++++++--
>  mm/memcontrol.c                         |  8 ++++++++
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 9e3c67b02ae2..eeeaf635754c 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1726,6 +1726,22 @@ The following nested keys are defined.
>  	  pgsteal_proactive (npn)
>  		Amount of reclaimed pages proactively
>  
> +	  pgscan_anon
> +		Number of base pages scanned for reclaim from the anonymous
> +		LRU. With the multi-gen LRU, counts pages isolated for reclaim.
> +
> +	  pgscan_file
> +		Number of base pages scanned for reclaim from the file LRU.
> +		With the multi-gen LRU, counts pages isolated for reclaim.
> +
> +	  pgsteal_anon
> +		Number of base pages reclaimed from the anonymous LRU,
> +		including pages demoted to another node.
> +
> +	  pgsteal_file
> +		Number of base pages reclaimed from the file LRU,
> +		including pages demoted to another node.
> +
>  	  pgfault (npn)
>  		Total number of page faults incurred
>  
> @@ -1829,11 +1845,11 @@ The following nested keys are defined.
>  	application performance by combining this information with the
>  	application's CPU allocation.
>  
> -	All memory amounts are in bytes.
> +	All memory amounts are in bytes. Reclaim counters are in base pages.
>  
>  	The output format of memory.numa_stat is::
>  
> -	  type N0=<bytes in node 0> N1=<bytes in node 1> ...
> +	  type N0=<value for node 0> N1=<value for node 1> ...
>  
>  	The entries are ordered to be human readable, and new entries
>  	can show up in the middle. Don't rely on items remaining in a
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1ebc9330aeae..ac12ff69a633 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1647,10 +1647,14 @@ static const struct memory_stat memory_stats[] = {
>  	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
>  	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
>  	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
> +	{ "pgsteal_anon",		PGSTEAL_ANON		},
> +	{ "pgsteal_file",		PGSTEAL_FILE		},
>  	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
>  	{ "pgscan_direct",		PGSCAN_DIRECT		},
>  	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
>  	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
> +	{ "pgscan_anon",		PGSCAN_ANON		},
> +	{ "pgscan_file",		PGSCAN_FILE		},
>  	{ "pgrefill",			PGREFILL		},
>  #ifdef CONFIG_NUMA_BALANCING
>  	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
> @@ -1699,10 +1703,14 @@ static int memcg_page_state_output_unit(int item)
>  	case PGSTEAL_DIRECT:
>  	case PGSTEAL_KHUGEPAGED:
>  	case PGSTEAL_PROACTIVE:
> +	case PGSTEAL_ANON:
> +	case PGSTEAL_FILE:
>  	case PGSCAN_KSWAPD:
>  	case PGSCAN_DIRECT:
>  	case PGSCAN_KHUGEPAGED:
>  	case PGSCAN_PROACTIVE:
> +	case PGSCAN_ANON:
> +	case PGSCAN_FILE:
>  	case PGREFILL:
>  #ifdef CONFIG_NUMA_BALANCING
>  	case PGPROMOTE_SUCCESS:
> 
> ---
> base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307
> 
> --  
> Best regards,
> Xueyuan
> 

-- 
Michal Hocko
SUSE Labs
