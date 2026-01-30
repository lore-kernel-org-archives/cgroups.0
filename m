Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007D2DDA9;
	Fri, 30 Jan 2026 05:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769752033; cv=none; b=gIKOc5SLJv6UNkBfA05sNA0VnV4nPVWHy16VaY56Bb/nGUTX/kJp9q6tYqKptE1lg0iytEpbW6/uV5VCXVyEEg8+rbPcxJOArhoI7O/jm0wUWLR27ZXTejBEEH6tijKw9zhcsIqelwOzaZ0JqHpNGxsm3bINXF5mXUOCgKe+/uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769752033; c=relaxed/simple;
	bh=awPp0FjH9ERIyGnhqtmOy/OpGwF5NWUfk7BBuldl+0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9gElMLn3h/naRfWNGw5SkMXn16qf3v70128ZxB78oTVZi+tK2iU6U348/iPKLE3yMQoNRLCD4TdrY9GQeg3VG5372SH65dlY+L/kkBCy1axeShxondPf3CRQc6R6lDCsjSH1/shL4R3Ymta/3gRoSr1rJKZNmqPPa5BoTssiTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WMI9hY1q; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WMI9hY1q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769752023; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=77Nrg4O5LoXp8ea1NF3SV8uU8VwqaIAVT4aaN0oPDq8=;
	b=WMI9hY1qCP4M3Jf/mN1vNukwdcL2LGZBKpFvu5r99pUH/W7dAYIwYl16Q46XeaBIcdm7hhMjDjL398gxVNOrLAx25Aai60A3qF2HzTmv7zWx69LNt0lj5xS8WlUacCcmoWyHAd/bh6dEAEcMGq4EHHCNO8bkDZ05tyVQxFP2WOQ=
Received: from 30.74.144.133(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wy9eGt5_1769752021 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Jan 2026 13:47:01 +0800
Message-ID: <98256ecd-2b1f-42e9-9569-445909a1d223@linux.alibaba.com>
Date: Fri, 30 Jan 2026 13:47:00 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>,
 Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260130042925.2797946-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/30/26 12:29 PM, Shakeel Butt wrote:
> In META's fleet, we observed high-level cgroups showing zero file memcg
> stats while their descendants had non-zero values. Investigation using
> drgn revealed that these parent cgroups actually had negative file stats,
> aggregated from their children.
> 
> This issue became more frequent after deploying thp-always more widely,
> pointing to a correlation with THP file collapsing. The root cause is
> that collapse_file() assumes old folios and the new THP belong to the
> same node and memcg. When this assumption breaks, stats become skewed.
> The bug affects not just memcg stats but also per-numa stats, and not
> just NR_FILE_PAGES but also NR_SHMEM.
> 
> The assumption breaks in scenarios such as:
> 
> 1. Small folios allocated on one node while the THP gets allocated on a
>     different node.
> 
> 2. A package downloader running in one cgroup populates the page cache,
>     while a job in a different cgroup executes the downloaded binary.
> 
> 3. A file shared between processes in different cgroups, where one
>     process faults in the pages and khugepaged (or madvise(COLLAPSE))
>     collapses them on behalf of the other.
> 
> Fix the accounting by explicitly incrementing stats for the new THP and
> decrementing stats for the old folios being replaced.
> 
> Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Thanks for the fix. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
