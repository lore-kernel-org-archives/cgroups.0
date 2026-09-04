Received: from mta0.migadu.com (out-160.mta0.migadu.com [91.218.175.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D4E377AB2
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 22:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788562052; cv=none; b=PaD1TtGzo8hrYnFHl6Lfg8FsGp2j9fr6Z5HBr/dSXJpNu4e2mIU/uzHHVrdgbrSmDQAEPnmlYpv7PM1SbsuPGAlUa6BHnlePxbCgYl0C5YQi0O1oc06AfmzjTpqhVslW6Sxaao8WcPItT3yAaIG7R2RTGz3x1HA6vG1QWqOw7yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788562052; c=relaxed/simple;
	bh=a9LWtZEwa63QJ3Ja33Gs2KV3YWbCdmNNXpX1BLghxQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bl8uEUQeJq9/WrsmuK9E+id+BiWq8LwWx7a2lfcEtV/lcLTMUCXlHFkJrTQDtEH3b/ZX1UJVa9xjBCxKIuIsfKUVgRPJhDKRMOI1MJzhpIxCqIGshIJCRYxSSo5qNOV/KVoFTNkSbfM86eKwhxku7J7nmgwj824S3jxqTQwj6K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uvmke9U0; arc=none smtp.client-ip=91.218.175.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uvmke9U0"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=a9LWtZEwa63QJ3Ja33Gs2KV3YWbCdmNNXpX1BLghxQk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788562047; v=1; x=1789166847;
 b=uvmke9U0SECNi9AL1bXd/PYSoouG969CYCJqT+hKYaz5DTcBTMUrdHVOX81GM3+WfuNPXjfy
 Awh8hWU7jaLEQvJoSGruF6ZiVD5Vb6SvRlskOo/TUheP9q9aCMzVTzNs3ieOmT8i0ydlDrSR2JZ
 pTkfi8F6ygVbUSEZlGd4WLjU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1e87ab9cb44541fb;
	Fri, 04 Sep 2026 22:47:27 +0000
X-Mizu-Trace-ID: 1e87ab9cb44541fb
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 15:47:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 3/7] mm/page_counter: introduce per-page_counter stock
Message-ID: <aptJ5qQfjMB-24WB@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-4-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260831163752.2193337-4-joshua.hahnjy@gmail.com>

On Mon, Aug 31, 2026 at 09:37:47AM -0700, Joshua Hahn wrote:
> In order to avoid expensive hierarchy walks on every memcg charge and
> limit check, memcontrol uses per-cpu stocks (memcg_stock_pcp) to cache
> pre-charged pages and introduce a fast path to try_charge_memcg.
> 
> However, there are a few quirks with the current implementation that
> can be improved upon.
> 
> First, each memcg_stock_pcp can only cache the charges of 7 memcgs
> (NR_MEMCG_STOCK). When an 8th memcg wants to cache its charge on a CPU,
> a victim memcg is chosen among the 7 cached memcgs and is evicted,
> losing all cached charges.
> 
> Second, stock draining is per-CPU rather than per-memcg. That is,
> when a memcg is under pressure and must retrieve all cached charges,
> it iterates through every CPU and drains the stock charges of all
> present memcgs. This means that one under-pressure memcg evicts the
> caches of all co-cpu-resident memcg stock caches.
> 
> Finally, stock is tightly coupled with memcg, so adding new
> page_counters to memcg is an unscalable operation where only one counter
> gets to use the fastpath.
> 
> We can address all of these concerns by pushing stock caches down to the
> page_counter level, and making each counter responsible for its own
> charge.
> 
> Introduce struct page_counter_stock along with its allocation, free, and
> per-CPU drain helpers.
> 
> No functional change intended.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/linux/page_counter.h | 16 +++++++
>  mm/page_counter.c            | 90 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 106 insertions(+)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 89a083f16fbf7..c1fe331f34e7e 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -5,8 +5,11 @@
>  #include <linux/atomic.h>
>  #include <linux/cache.h>
>  #include <linux/limits.h>
> +#include <linux/workqueue_types.h>
>  #include <asm/page.h>
>  
> +struct page_counter_stock;
> +
>  struct page_counter {
>  	/*
>  	 * Make sure 'usage' does not share cacheline with any other field in
> @@ -41,6 +44,13 @@ struct page_counter {
>  	unsigned long high;
>  	unsigned long max;
>  	struct page_counter *parent;
> +	struct page_counter_stock __percpu *stock;

On gcc 14.2.1, I get

In file included from mm/page_counter.c:8:
./include/linux/page_counter.h:47:44: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or ‘__attribute__’ before ‘*’ token
   47 |         struct page_counter_stock __percpu *stock;
      |                                            ^

I think you need an appropriate header in this file.
