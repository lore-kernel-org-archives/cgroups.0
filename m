Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792520015;
	b=CF2FwsQAmVO0QcFwznkkpNVKl7QNTmac8H5leGDJfGxpFPQgFtMV1e2limvlMSxRSGy4
	 fJ+7LFVZfXtun3bSSyKwljb629gmRftQQWRVvSlp3wD9pw/0dP6VfGfM2hHX2Q5XCxrUV
	 NflhkbPou5ZWRZephgIPhdrWIKp3g5DGa05pTa3ZVfKh+Eem5QQET09Siw9Kbfip0I4AD
	 qpZTU21gwZWVqfIE8HzE/RXwV5LUjNu1XBna1SVmqRqlmSRlAgTsdCGzdAy9WM0TGfnwv
	 ikxna+O3Yu4lmvYpgiG5XAPcIFfrddM7FvlUT5IvQEOM7V2/vjY9aOv+mBroUNEcKSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792520015;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OvgrH+6ZI3PmOmzd8t/UFo/rFzWXLLMI1rZ7t41rPsI=;
	b=rm/KBPWvZkpcuQ2vbsEjmyOZbBp7yUq5khU8n8EWbua9SRf7Jqw2lGiw2DgKoxIK2LAx
	 sXW75qfC7bpLAUpQdwULVGeW/Gx9sUmUqJzs7iy/4D9ACAthaNq+njnS8S3o9atshTkuP
	 RddB75qJrd5dT+pCN3D3bmWQOFEDUVW5PODkTFcyA1YZM0ey70U4E6SO2N2efwW4Snbb2
	 etmi7oSzdysPhA07BkvyEG6Op9vHRV6GNg70muAR9UEBCSUTtC2fAyF/bEU4i/vi9Z9Ds
	 UwhPYmtP3X0oFh8+2ayPIyuPERyzAxrg7uJnk+wug8XZIcRCtg8UlQsh4vg+MrkHAyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="CMpw07/1";
	arc=none smtp.remote-ip=91.218.175.210
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425B1606A31C
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 18:13:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 425B1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CMpw07/1
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4vHXAYHH5hEm7cUcKU4ec1l2m6WXSXPscNO/va3EpP8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792520009; v=1; x=1793124809;
 b=CMpw07/1podgMC2L5t4ik81Y/a8gR1uhzmVANrSaEX1AsyCWMdTWhLQeLWShazHYIdXC2iOb
 IAuqdF8jtibg1khDUKIeWlDvsFGXhl/6P+Wlwhguydl0fT9kmV6i3bZnBrHIdlFjdWTJ5W3EBzp
 pIE31al9KVcnufM4iDTHAY6U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3b0c82d051bbe280;
	Tue, 20 Oct 2026 18:13:29 +0000
X-Mizu-Trace-ID: 3b0c82d051bbe280
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 11:13:27 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css
 reference
Message-ID: <ateuS_d6hRKFFeZW@linux.dev>
References: <20261020165627.1599959-1-joshua.hahnjy@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020165627.1599959-1-joshua.hahnjy@gmail.com>

On Tue, Oct 20, 2026 at 09:56:26AM -0700, Joshua Hahn wrote:
> struct memcg_stock_pcp hold references to cgroups that it tracks to make
> sure that the memcg never gets freed with unaccounted charges still
> living in the stock. The cached stock can be cleared either via
> drain_stock() or consume_stock(), which drop the reference if the
> stock goes to 0, and then clears the pointer from the stock.
> 
> If that was the last reference, the memcg is freed after an RCU grace
> period, but this can happen while the pointer still points to the
> to-be-freed memcg. Then a reader that enters its read-side critical
> section after the grace period has started is not waited for, and then
> can dereference it after the memcg gets freed.

These are per-cpu fields and are accessed within local_lock. How can there be a
reader where a cpu is still between css_put and WRITE_ONCE and within
local_lock?

> 
> In practice, this is very rare and I have not been able to reproduce
> the issue in my own testing.
> 
> Switch the order of the reference drop and the publishing so that
> we first publish the NULL pointer, then drop the reference.
> 
> This is based on a report from Sashiko, who found this pre-existing
> issue in my page_counter_stock series [1].
> 
> [1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
> 
> Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e7d7db5718f9a..a05d9a8baa1b6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  			stock_pages -= nr_pages;
>  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
>  			if (!stock_pages) {
> -				css_put(&memcg->css);
>  				WRITE_ONCE(stock->cached[i], NULL);
> +				css_put(&memcg->css);

This css_put can not be the last reference for the memcg from this path as the
caller of consume_stock() (above the stack) should be holding a reference to the
memcg.

>  			}
>  			ret = true;
>  		}
> @@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
>  		WRITE_ONCE(stock->nr_pages[i], 0);
>  	}
>  
> -	css_put(&old->css);
>  	WRITE_ONCE(stock->cached[i], NULL);
> +	css_put(&old->css);

Here this can be last reference but I don't see any concurrent readers of stock.

