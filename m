Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983D0339371
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 23:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578379; cv=none; b=JhXszuIwi35ZSpQF5p54ZsIe9ipLncrVft6gUpbUxk3L/vCXPFagyTnp2J+HXCIT/05Uyb82vyRcQCFfNWQyKhlsNvVggJ0CWQRq8ifWAW95hX7hgUFzbdC8RF0PKWSnUUClrckqG4MtwTH0y4PQhdjrFrODXQ0cqz05wVI3coY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578379; c=relaxed/simple;
	bh=Suug6ZlLMRpt7AO3wExksttzRhjDowxSc/U7ICXnYsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCfT+raGkLMnzwy/8Q5ePJscyn/kOWdzrl3Sq1/0GoR3CP0sYBksH/3eEWnl2N270YEdFJZzC6vNKFNx41xxlHnRKv+yzVCAB3WpNev31UIG7P0gYzh99oG2C6e7JRKCGYFy6KFjdGuctFojs7pjHHdqUiwo3NTni9opZNNAX6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pjReRsjU; arc=none smtp.client-ip=91.218.175.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pjReRsjU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Suug6ZlLMRpt7AO3wExksttzRhjDowxSc/U7ICXnYsU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786578375; v=1; x=1787183175;
 b=pjReRsjUK7CyUIS/VWoH+vfERRzp+sncklUeXxXGg039MQaOLBKWvmxHiWiIB9PpQk7B6M7o
 rUFReJpRTI1SB1NQnLvEAQTtd9cNR4zi3cXXj5vMCA5K96QLQc5l+UiL37kw+K544UKsO0vaCGW
 rlJereWzZsS0ManoIwk1Vya8=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:a::)
	by smtp.migadu.com with ESMTPS id cf2368f0b44ab78b;
	Wed, 12 Aug 2026 23:46:15 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 12 Aug 2026 16:46:09 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cui.tao@linux.dev, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 1/2] memcg: acquire peaks_lock when reading memory.peak
Message-ID: <an0Fp5HVk4xVtrSk@linux.dev>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807090000.1532495-2-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807090000.1532495-2-ridong.chen@linux.dev>

On Fri, Aug 07, 2026 at 04:59:59PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Sashiko reported that a reader can transiently observe a lower peak
> within a race window [1]. peak_show() returns
> max(local_watermark, ofp->value), but peak_write() updates those two
> under peaks_lock while the reader takes no lock. The interleaving is:
> 
>   writer (reset on fd A)                 reader (fd B)
>   ----------------------                 -------------
>   usage = page_counter_read(pc)
>   WRITE_ONCE(local_watermark, usage)
>   // watermark lowered to usage
>                                          lw  = READ_ONCE(local_watermark)
>                                          // sees the lowered usage
>                                          val = READ_ONCE(ofp->value)
>                                          // B's value not updated yet
>                                          return max(lw, val)
>                                          // both low -> low peak
>   WRITE_ONCE(peer_ctx->value, usage)
>   // B updated, but too late
> 
> Fix it by acquiring peaks_lock when reading the peak, so the reader sees
> a consistent snapshot of local_watermark and the per-fd values. The same
> race applies to memory.swap.peak, which shares peaks_lock and the
> peak_write() path, so take the lock there as well.
> 
> [1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
