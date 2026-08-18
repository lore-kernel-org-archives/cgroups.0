Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8550E3403E8
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 07:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787037602; cv=none; b=iRDnEkp7xtvKxNxZtq81xjmpdNNl0kEKYUs5ljCLTWUDwuyALNTFoVsc+7D3zmIar4WHxWhbwZ/mCA9C1osompbBfVtogfEILQrMeVn/mf7v7Ox1tFrOALz4myHH0Ua034xJvNCcDQjQYvEV66o8GtEIB/rlTv4Xlv8nMrLc+6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787037602; c=relaxed/simple;
	bh=M/D4ZJ7WZLQYSekWO63cM3Lx+FOmlTfFl015biR0nTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dPhI6ZT8UC+e5LLaFqiuG+LJCVk3F+Nl5FhlNhsN5n68tPtHJ0NvC+/YvQyiUUSfuG/3BDoUMtpuWQWWbiMqzXWWphQfTmxpeRhEZFurUWdUHnxLboP55/yuAKtPAZ47se3pr+HaioOkDAwa56VKbnz3L5QtgOTUW2Pxnrd921Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gVyxWssW; arc=none smtp.client-ip=91.218.175.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gVyxWssW"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=M/D4ZJ7WZLQYSekWO63cM3Lx+FOmlTfFl015biR0nTE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787037598; v=1; x=1787642398;
 b=gVyxWssW2tUgE+5I2qwAFXVpIK785BzvElJuid0IFb5mWvdwD/BiEJ3b2zkyNgLIGrQhOmKQ
 zHwcQJ0ya9Vkz1WWSGrzNpxmjkmIK/X/UhaeGCIBGVRkoXIJa2wUKq6CGHdIHRGOBx0qT8zB0xS
 mP/F5joOZWy4eauTJ7f9RlPw=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id e113e2322ca57fa1;
	Tue, 18 Aug 2026 07:19:57 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 15:19:54 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 10/15] mm/mglru: make folio lru referenced times
 count a generic API
Message-ID: <aoQHmlpoyMG_pJVE@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-10-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-10-4d8dad39dad6@tencent.com>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
...snip...
> diff --git a/mm/migrate.c b/mm/migrate.c
> index c737d0682fa4..806f1e913a38 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -786,8 +786,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  		folio_set_active(newfolio);
>  	} else if (folio_test_clear_unevictable(folio))
>  		folio_set_unevictable(newfolio);
> -	if (folio_test_workingset(folio))
> -		folio_set_workingset(newfolio);
>  	if (folio_test_checked(folio))
>  		folio_set_checked(newfolio);

Change in this place sneaks into this patch?

>  	/*
> 
> -- 
> 2.55.0
> 
> 
