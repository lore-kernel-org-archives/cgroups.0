Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0173EEAC2
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 16:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786983409; cv=none; b=WZOF3Bc7l1RAYu4UswbJVYWEmDS0731YymzruCFx7KlzsKWCHnODoD29ACHXiBgeFz4yESUdHG2lYEHbVgoCE2M5yOhnm1EyS9scVRkHCXqxKICRIH+i9qJRmR9NfqJd6ij/Ht4ftWKvGRgIb1+iZvc2lj851MSohGZTMIqCzUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786983409; c=relaxed/simple;
	bh=i6bQMq/DC00QCcuw75mN4wCsOIuCzDBMfmplOIXgDzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HYYdV/0+RYW8iJmjouRlEYPrQY/XcnlGjyHabO89pjs2QN+4UNDmC5E6eUsyytmeKTabANU5rprypmzMsyDAsMPzc54oOKEwzxiVk7yia8P1/KOgzLO6hJ69v3HcyRSj3RZH4qdmsNh59lpu+8tUjzQqLramsDjTP7JjFW2fkJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S3wbMJnR; arc=none smtp.client-ip=91.218.175.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S3wbMJnR"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=i6bQMq/DC00QCcuw75mN4wCsOIuCzDBMfmplOIXgDzk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786983406; v=1; x=1787588206;
 b=S3wbMJnRGCslnNbTCuupNF4iThPC3hCIaT4dcz/TttxVbErzmNazm2zKWEgOcC3McYiMrCvA
 U9xYIHbx8ezn2IRl6XF7tAGQaiBsFpSXE+ACepnFo/JuyJkQJ4G+VaPEundGlELAk0d5J2/Kw1p
 u3wxtnaY/9ZPeiwA68nSEcWI=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:d::)
	by smtp.migadu.com with ESMTPS id 2099e86e7d174f0f;
	Mon, 17 Aug 2026 16:16:46 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 09:16:40 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoMzchLCCz5hiFHp@linux.dev>
References: <20260817042652.74136-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817042652.74136-1-cui.tao@linux.dev>

On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> memparse() consumes no characters on an empty input and leaves the
> end pointer at the terminating NUL.  The only validation in
> page_counter_memparse() checks for trailing characters, so an empty
> input slips through and the limit becomes 0.
> 
> All limit write callbacks of the memory controller strstrip() the
> input before calling this helper, so a script that writes an unset
> variable hits this path:
> 
>   LIMIT=
>   echo "$LIMIT" > $CG/memory.max
>   echo $?
>   0
>   cat $CG/memory.max
>   0
> 
> Nothing reports the mistake: the limit is now 0 and the OOM killer
> goes after every task in the cgroup.  The same happens for
> memory.min, memory.low, memory.high, memory.swap.high,
> memory.swap.max and memory.zswap.max, where 0 silently removes the
> protection or disables swap and zswap.
> 
> Reject the input when no characters were consumed, which is the one
> case the trailing-character check cannot catch.
> 
> Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  mm/page_counter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 661e0f2a5127..d14db705b04f 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
>  	}
>  
>  	bytes = memparse(buf, &end);
> -	if (*end != '\0')
> +	if (*end != '\0' || end == buf)
>  		return -EINVAL;

I wonder if someone started depending on this behavior. In that case it is
better to return error instead of silently ignore, so we will hear complains
loudly. This looks good to me.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


>  
>  	*nr_pages = min(bytes / PAGE_SIZE, (u64)PAGE_COUNTER_MAX);
> -- 
> 2.43.0
> 
