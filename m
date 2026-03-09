Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4023A4525
	for <cgroups@vger.kernel.org>; Mon,  9 Mar 2026 11:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773056027; cv=none; b=cL2IQim/NaSY1rn7kOtj7CnkZNaHlbSeVyBO4FmPXx77SgXPZr6UFbShuPQ8DJhkEvGovBZrwiRbT0P8mo6cfTbOz4ZlZhRonB7MW9x/O/jqEdQW0Xom/eIRX1VThIJW+pqNQiAodQjyfyeuaUvyqv1WKuUa69AWSpx15d93n+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773056027; c=relaxed/simple;
	bh=nS3f1JtKIMyiKxBtGadIYcCv1KC3QXEBR1e7+NU7NKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hXVJwNo/u2bG9ErBHzQ+kS/a+UibRpWOmVRmqQGHCegI0OhCqRqjSZZKBqCaBUc7WRxjQzCYRE6+g9jrqkDD3BI5sm44T+KA0Q1yJkTX8vJVadKD0sfPwNbHOPcWEZpFlie2W0+vfgPgh/NhdzC9ocvE1Y1+69gdq2FEr0//gJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FUReVhKm; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FUReVhKm"
Message-ID: <b26f48f1-c311-463c-be17-7384ca27c7c8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773056023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZdc7LG7ZYkmcqRXQcEuwYKpiDy0yyiOVu0PO+EX6Pg=;
	b=FUReVhKmfpOpc9YHORo2h3+9SXjqXPHjJFQO5zvtyq3Z39iHLE1TxI9ctFAfiqbmPOZdDa
	w4CBNH+BqrCNTjtV84dpKUkGVjULP+mnrp4CfpKSFgpkSqJ7kBibOCJbCQj7PyG9FE/W+n
	IxASUlf+CmUZ/JhmFo3RnnJt0FcrFbI=
Date: Mon, 9 Mar 2026 14:33:33 +0300
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fix: mm: memcontrol: convert objcg to be per-memcg
 per-node type
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com>
 <20260309112939.31937-1-qi.zheng@linux.dev>
Content-Language: en-GB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260309112939.31937-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 09/03/2026 14:29, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
> from being called agagin in __mem_cgroup_free().
> 
> Reported-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  mm/memcontrol.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 992a3f5caa62b..ad32639ea5959 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4140,8 +4140,14 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	for_each_node(nid) {
>  		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>  
> -		if (pn && pn->orig_objcg)
> +		if (pn && pn->orig_objcg) {
>  			obj_cgroup_put(pn->orig_objcg);
> +			/*
> +			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
> +			 * from being called agagin in __mem_cgroup_free().

nit: s/agagin/again/

Apart from the nit.

Acked-by: Usama Arif <usama.arif@linux.dev>

> +			 */
> +			pn->orig_objcg = NULL;
> +		}
>  	}
>  	free_shrinker_info(memcg);
>  offline_kmem:

