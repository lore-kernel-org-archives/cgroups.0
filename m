Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793606865;
	b=T+GnQXDfShPgG5IRXdLNxX/P8/7lMbTsHLp6aXUKCweK3tUmr6KGaPO+6WCm9d3mHzqT
	 gbSzoSt5z2f71VPIwMLskj4piGdsWRJgJWRq39ApLbuwCHXFNNZtBvt/73CZT36+ex6V4
	 zwbSZcJxeMgKAxG/+9tv+OWXTM/QmJMdzfU39DWnlSB+q8SiDQXxf0sRBah8dD2WU8g22
	 W7B289dXNg/CZolyOhJaffk7+6C22fhXPp6qr6lWDNQnIgVHCDISQ1A746KrQpvSCZrr8
	 FGj1dK0wXgQvAWTnvg/UKkfsKr+nGq5MJ+yxEWMjKoSkDevCt6WFmBo831/tQLnSj2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793606865;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=RmW9W+b2NUCMbTNqn6LeM8cKiTUqHkz3gaeuB+SxxjQ=;
	b=s30hElsIwzXl4KQT8pMoZW6PNADKW4nBdeDpuWoP3YhjWIxQIiao/p0oK/MfhIqeA93o
	 aZW3QvBxcgcTJOn+DXpEXTiIj0i0m4I3/58cSJ5srbnFDmkXbOT3rx1q1oOq8p9B9Oavi
	 DtJionkgKS1ErI1+eRGpjjXeI7mMvEElhUN1Jk4qyqxV026693QWhAYI2lb/kgbdEn7Xl
	 l70iOMm/JDA7j/56EZ2RBmjbaPGNwKBuLh2YqC4AZGD+6HHEGIsXgGOMX+v5/O0EgXegi
	 8Js8yH5T3AFbP7MbJpYqMzGkdvluBr8bZFo019XUdx9uADb+1xVRMwG2IRE5FSGKsFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tnmzTSqr;
	arc=none smtp.remote-ip=95.215.58.46
Received: from mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA837606A333
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 08:07:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA837606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tnmzTSqr
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VFK7vMxbPR50n7fFLwXWLZ6ZPyv6K4TCi+2Re4RLgtA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793606862; v=1; x=1794211662;
 b=tnmzTSqrsxUQkb2Ygb/cunZg4/OUqK6lMcAvJ0bQ7Es69dTB9ZtIaSWepDAbbVg70L7cpC6f
 V1JdH5YEhU0YdyJOo/OdoN6Kk3QzYgnGNo5mWmNFybxDGnbMDNC8TevzmkvMqfTctpYJT0lpmgr
 g9XjIsaSGBn+f1SHLI0M2a+k=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ab74e95e87cc3cd0;
	Mon, 02 Nov 2026 08:07:42 +0000
X-Mizu-Trace-ID: ab74e95e87cc3cd0
X-Migadu-Flow: FLOW_OUT
Message-ID: <a857f808-1988-43bf-9300-86e24a01436b@linux.dev>
Date: Mon, 2 Nov 2026 16:07:33 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/hugetlb: Preserve persistent flags when
 returning folios to the pool
To: Kaitao Cheng <kaitao.cheng@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>, Zi Yan <ziy@nvidia.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Chris Down <chris@chrisdown.name>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
 <20261102024910.31486-3-kaitao.cheng@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261102024910.31486-3-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/2/26 10:49 AM, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
> restoration fails. It clears folio->private and restores only
> HPG_vmemmap_optimized, losing other flags that must survive the rollback.
> 
> Clearing HPG_cma causes a later free to bypass the CMA release path,
> leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
> loses the indication that the locations of poisoned subpages are unknown,
> undermining the checks that prevent freeing or unpoisoning such folios.
> 
> Preserve the existing flags instead of resetting folio->private. Callers
> already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
> returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
> before attempting to free a temporary folio, so a failed vmemmap restore
> does not leave that flag set on a folio returned as surplus.
> 
> Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
> HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
> incomplete transient flag cleanup.
> 
> Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of raw error pages")
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
> Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>   mm/hugetlb.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi
