Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2353B42E4
	for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309531; cv=none; b=NpVO649EHCg8bBBiL30APYDqp+ZnKC5Qg2/YGHcCEfWGrJUGx/hq8QZ7XmouzBDP2OiGn0GTLjNKlqO4c1K+sscu6In1KruGj+1SNDUd2Saaqtxaudg8P5w8lYB8a4xm1vxcDJUrEJs+0yVEwPJFK5oio+sFFr+4Jye39cDHgLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309531; c=relaxed/simple;
	bh=ZUdzXCjL1ne0NmFECQQiQm4vBnjO6qc7tD/5+/0vMVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2VrLCdhF2zCMttg9BbjDLjZ6Ry+ngE+7tu6pZ2X9YzA4Y+5rft6xeqij9HRiP80qIWApL1qsbElXZ5a+dauc39LSyZswrXhk52+4wts8VncTpkZTFOBRYIKDyw8yLQgTRBRSsdvmyFH9TRN+lRw/POPNHSrJqbP4d3sO9AbMvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DCyXc2DL; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DCyXc2DL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782309527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P+krzB/fRPIXJmRo7sPshCRvS8tomogxFOe1laJV1Q4=;
	b=DCyXc2DLiYxBZbHYHiZypoRq6CzXuRtdzU94TSzA6n6GdsTNuCBVE5wLYjrb6rZSufKDPY
	c5wwCLciI1neOVi+KtBNGBdGe+A0lElCFiU7wPfxqJlmrpLjiE6pKNVDfZ50+Ys7SbKU52
	lTq6BWHedR7bvsd/VgxhInujJxid5Ps=
From: Usama Arif <usama.arif@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	yingfu.zhou@shopee.com,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memcg: bail out proactive reclaim when memcg is dying
Date: Wed, 24 Jun 2026 06:58:38 -0700
Message-ID: <20260624135839.2596358-1-usama.arif@linux.dev>
In-Reply-To: <20260623062800.298514-4-jiayuan.chen@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 23 Jun 2026 14:27:56 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Proactive reclaim via memory.reclaim can run for a long time - swap I/O
> or thrashing again dominating the latency - and delays cgroup removal in
> the same way.
> 
> Mitigate this by stopping the reclaim once memcg_is_dying().
> 
> Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>  mm/vmscan.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8190c4abec84..1162b7f76655 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7922,6 +7922,9 @@ int user_proactive_reclaim(char *buf,
>  		if (memcg) {
>  			unsigned int reclaim_options;
>  
> +			if (memcg_is_dying(memcg))
> +				break;
> +

This exits the reclaim loop with nr_reclaimed < nr_to_reclaim, but the
function then returns 0 and memory_reclaim() reports a successful write.
I think you want to return -EAGAIN here?


>  			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
>  					  MEMCG_RECLAIM_PROACTIVE;
>  			reclaimed = try_to_free_mem_cgroup_pages(memcg,
> -- 
> 2.43.0
> 
> 
