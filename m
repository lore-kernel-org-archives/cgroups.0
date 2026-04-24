Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684AD3093DD;
	Fri, 24 Apr 2026 05:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777008051; cv=none; b=m6iLXsUoDxG00b3smAnPvVjyXS6sIhWM0O8xTs3ijgjP8Cy5NxOZOhgqYs4UaLkRCEA1CGkuZO06IlMyI0cu7NIgbqX2fogatUvVWhWV1JmPGHf+IMxK2hBf/XOnnH1m4TCAIvJHQTEfj4HwrE1YL2W8ANWnU4agIBmlvzes45U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777008051; c=relaxed/simple;
	bh=yzSFr76VywT6mzIWHv1uIbUW5oarBczpza1ZqXVPhNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Paoarn5zS6hQeMGlNzLjlj0AzDm+3C6FRiG4WUxvpnvzdwSh9EWdSD+3iq4kc7EQCpKYCWraiyZeem30e8ZoxWVct2NufZ3zxmlJjRPIqkAyFr6b6/VCVdH7Mejmqd0HD62Mu3LUhEvKsifaO4yOmwRNhpBeY/QDJAqn+moCoM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DErWeeVw; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DErWeeVw"
Message-ID: <84e67f8e-7cb7-4710-bc46-055a2bb9d0ca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777008038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yzSFr76VywT6mzIWHv1uIbUW5oarBczpza1ZqXVPhNQ=;
	b=DErWeeVwVrnD0TSpf7Ktcrk/EQp2CqM95/ld7OLjvYvCxmZizMlH0nFpDSmgQ8+FMSLC3s
	GEDweT2SNYfK0MQzHu13h9CFRBxKdnq3ACWpjgnXUhv/9gygK4TdUbIwQpXooivd4WqXUr
	eSYdusT7dBqItD1zY/6/XWLHkDYcE48=
Date: Fri, 24 Apr 2026 13:20:27 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 5/8] selftests/cgroup: replace hardcoded page size
 values in test_zswap
To: Li Wang <li.wang@linux.dev>, akpm@linux-foundation.org, tj@kernel.org,
 longman@redhat.com, roman.gushchin@linux.dev, hannes@cmpxchg.org,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 mkoutny@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-6-li.wang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260424040059.12940-6-li.wang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 4/24/26 12:00 PM, Li Wang wrote:
> test_zswap uses hardcoded values of 4095 and 4096 throughout as page
> stride and page size, which are only correct on systems with a 4K page
> size. On architectures with larger pages (e.g., 64K on arm64 or ppc64),
> these constants cause memory to be touched at sub-page granularity,
> leading to inefficient access patterns and incorrect page count
> calculations, which can cause test failures.
>
> Replace all hardcoded 4095 and 4096 values with a global pagesize
> variable initialized from sysconf(_SC_PAGESIZE) at startup, and remove
> the redundant local sysconf() calls scattered across individual
> functions. No functional change on 4K page size systems.
>
> Signed-off-by: Li Wang <li.wang@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutný <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Yosry Ahmed <yosry@kernel.org>


Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>

