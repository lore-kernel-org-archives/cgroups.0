Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DDD486628
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 15:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786722574; cv=none; b=H2hIWL6GrJSrdlppzgcL07T3QFksAYvVuzJRLFQhwBy34l2oyy6DD2aX0Dnmp28Xtb+9vGla15BeanukZYaoVywuRK5vCN1BODvrbYclMRQgLT46iDUnuLCbQVYg3DA8wUHJa7fBFrbbA+VzWoJssZKSQO8qsZtwOFxTGFKaBGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786722574; c=relaxed/simple;
	bh=swIn0hqUyRR4ib+o78/MJobw5W+Q8v/m4iW+5oHhqnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0n58VCinUHepNGh75WdOjRrPVhhpiSUftx4NLeaabgSJAMlGYsjR5amZ8U8HqLjGWIgMEjVuzI6xPyheQMUJNqSM1OxBgokAsTAARmoyzySVOhCFfAoqaHRQ/aD8jG8nAj7dabHwQlvN5EuhT2K7TMxOXQtFxzPJlI7fpqNuvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 15 Aug 2026 00:49:20 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.121 with ESMTP; 15 Aug 2026 00:49:20 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 15 Aug 2026 00:49:20 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, chengming.zhou@linux.dev,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com,
	corbet@lwn.net, kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap
 backends
Message-ID: <an85AJ8auvXQ3+nk@yjaykim-PowerEdge-T330>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
 <20260806184254.3790858-3-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806184254.3790858-3-nphamcs@gmail.com>

On Thu, Aug 06, 2026 at 11:42:45AM -0700, Nhat Pham wrote:
 

> @@ -537,7 +562,12 @@ swap_cluster_populate(struct swap_info_struct *si,
>  	 * Only cluster isolation from the allocator does table allocation.
>  	 * Swap allocator uses percpu clusters and holds the local lock.
>  	 */
> -	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +#ifdef CONFIG_VSWAP
> +	if (swap_is_vswap(si))
> +		lockdep_assert_held(&this_cpu_ptr(&percpu_vswap_cluster)->lock);
> +#endif
> +	if (!swap_is_vswap(si))
Hello Nhat

Does vswap actually come in at populate time?
For free clusters (dynamic ci), 
isn't the cluster freed immediately rather than going through this path?

If it is right, then just validation seems good enough. (assure vswap does not come in)

Thanks
Youngjun
