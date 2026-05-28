Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF783E8688
	for <cgroups@vger.kernel.org>; Thu, 28 May 2026 13:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779974720; cv=none; b=e7TnK7MIHGW8DWxtf1fTvLFhOqEWjgcCMFptSDALj4l/MDPXAdFde78JW+I5Y9yH0GDqt6NtNWhCNpM5cVcAC9LGTFVQaOZufAnINejB2j8eIKpXIW5Z67WUCh3O75Nuk8Eh6i9YjLqTFka9qC1gVNUHKTsgCy7i1TnzoHhe97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779974720; c=relaxed/simple;
	bh=RhDb/aNKMcsSQE3bA2/50m6XCLP5QV/togbf+h/lDlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eGFGfdnrSTSCPomjzp1QaOY9YaVwGWWh8V6EuwoP5mvuvuTr1N2npAqNzcsHyqRbV+rQgbJYfD6QXH4FyLigRP9Kzxvd0Ur0Jcl2KvVYGyTnhMoAdg4+3RkxXMZFPLVUzJ/UzOWQODwioi03apK5E1cEoAOsNjp5KDNEpkFPM6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YEvhW7kY; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YEvhW7kY"
Message-ID: <1eb96ce9-6959-403a-980c-c3bbd5843bbf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779974716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YxcsNZRecDEaQahSiT11cWudtxXnG0dORG1khJbfvIw=;
	b=YEvhW7kYNXlm9pb0Nco0953goxoB6e2HwGldUUyQg0h4AiIlLCtrtHHxY4j3AVrbcVvkJd
	7SFNPBQ4KBvQR080l/wF3xGV3MqI6+ouBvUM6L7PsZminoYSLEtGXCdRL7erGMsSznoYqi
	3kgIoNNi/FUaCW8CRstXYBtAhtdDVc8=
Date: Thu, 28 May 2026 14:25:10 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 1/9] mm: list_lru: fix set_shrinker_bit() call during
 race with cgroup deletion
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-2-hannes@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260527204757.2544958-2-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 27/05/2026 21:45, Johannes Weiner wrote:
> When list_lru_add() races with cgroup deletion, the shrinker bit is set
> on the wrong group and lost. This can cause a shrinker run to miss the
> cgroup that actually has the object.
> 
> When the passed in memcg is dead, the function finds the first non-dead
> parent from the passed in memcg and adds the object there; but the
> shrinker bit is set on the memcg that was passed in.
> 
> This bug is as old as the shrinker bitmap itself.
> 
> Fix it by returning the "effective" memcg from the locking function, and
> have the caller use that.
> 
> Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
> Reported-by: Usama Arif <usama.arif@linux.dev>
> Reported-by: Sashiko
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/list_lru.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>

