Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255C426EA0
	for <cgroups@vger.kernel.org>; Fri,  6 Feb 2026 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770401641; cv=none; b=TVsfr3YSjQnQWvEv/JthHKbl4MaESfA3krk+ui9dy2DUI/CXCYRIodZrISdsQqFCQzz2B6GOiv9OAQABB2y3e69tAcRMYRrBGr9+dz5toFo9Yt13SbAv73QtxON50U8PoMdZDxJt6+CcmVwRmNKcnINT1qzI2S29WR0qhlmng7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770401641; c=relaxed/simple;
	bh=31l9a/J3ky9SSmLpO5OPKYpJeNyF1GgMD+f+x/7HQnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avqFizB7MJETj40JYeCdgDUXPdkrVNKBKFT/m8lj5Kz4L0q0D1507seOxanjGQGXK7S4YBixLdUMf1q4Yc/NQMzOQU/etr7ONKA9IwO+OoZ+CDibLPh7n3rXpAaojq6SArC5bZMG8MI30r96OE/l1yW3txVs3eW6B0REO2/JM9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ldwtKf+R; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ldwtKf+R"
Date: Fri, 6 Feb 2026 10:13:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770401629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g5Gy1VnuwP3PRcgfNvx+OUQirue6Tb+SWeRbQ4+gTFk=;
	b=ldwtKf+RlhBjVz8gW9tXGFBeH8QYbZvKLVfPvUO6+wkMhQ3QSSDUOVoaWpNn9b16Vm4Nba
	tDIeGZvul77SFT9Ck2OrTXNC5bTf8CaDletMpTENThSVk65UomdZufhBvGqEwoAm1L7G8Y
	IIaCLRscj0sRvFK1lyfkq8eFQ1ceYvw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/cgroup: add test for zswap
 incompressible pages
Message-ID: <aYYvNq0CibG_ABEG@linux.dev>
References: <20260206072220.144008-1-jiayuan.chen@linux.dev>
 <20260206072220.144008-3-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206072220.144008-3-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 06, 2026 at 03:22:16PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Add test_zswap_incompressible() to verify that the zswap_incomp memcg
> stat correctly tracks incompressible pages.
> 
> The test allocates memory filled with random data from /dev/urandom,
> which cannot be effectively compressed by zswap. When this data is
> swapped out to zswap, it should be stored as-is and tracked by the
> zswap_incomp counter.
> 
> The test verifies that:
> 1. Pages are swapped out to zswap (zswpout increases)
> 2. Incompressible pages are tracked (zswap_incomp increases)
> 
> test:
> dd if=/dev/zero of=/swapfile bs=1M count=2048
> chmod 600 /swapfile
> mkswap /swapfile
> swapon /swapfile
> echo Y > /sys/module/zswap/parameters/enabled
> 
> ./test_zswap
>  TAP version 13
>  1..8
>  ok 1 test_zswap_usage
>  ok 2 test_swapin_nozswap
>  ok 3 test_zswapin
>  ok 4 test_zswap_writeback_enabled
>  ok 5 test_zswap_writeback_disabled
>  ok 6 test_no_kmem_bypass
>  ok 7 test_no_invasive_cgroup_shrink
>  ok 8 test_zswap_incompressible
>  Totals: pass:8 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
