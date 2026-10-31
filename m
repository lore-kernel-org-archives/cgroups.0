Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793407610;
	b=1Mbw0zoj1WYO8TNSn13bK1T8eCrUFsxh+nSEoPAlEDKXy8Kd7FBH/FDiddZJPuYUZ1RI
	 yxGDPQKGryH1D7AariiVNNRcEaN4R2bkeFEO7K0wQEO/aNsBCDmmwms4qFe7rcXz54e7j
	 CdZvPDQt3jqq5hYje/PClc0TlB9z6ibnTCHB0y26nIqlpNdS4a5d8ZRHFxSXLNrvcTMSe
	 rcIfYIcCIqtvnodOA9lwBEjnPlOB8MLVE4fuRrPWFcZf07E3vFhlHPwo7wzjy358Zc+vO
	 5P3LaBFOcojiS4dZEcjbORly9AVKgLBG1jaV6gBfIUZHyqt2cDatr2aAl73NP3U/G6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793407610;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=H7Ifc7p7cHcO1C78lzF+gI6I9rOcTVWv5sLtNAQ1MO0=;
	b=XwpE/nAaZGvI5g0RJs6UbVxYouwExNcJjyhgn0HWSNLFAoA8Kwn9yEXb/qVerZvHYO+w
	 1+/ZYAmLBKAxbbv0ha/dOYU78Dx7U+zlI/+lptqAIDO059ek9LXWi4fdwQ/grina9gOWB
	 aufJGGBv2nsahAzr7ZkPH6DOXxJeQpihCDqqSreBCVG9vUu9nR4rdFpaxq+ntlJNaYUOf
	 kKkWkBmSxypEMVrlMPeKFRi1fPQ0FGTzVhXwpLE4nna/Ghhc6yv021keWzMsPK5rJNbIH
	 Xja37/4lgfhCb17SYPSAPnA9OFn3BW0i+9jqU96OKG0yCZefOQiPoYNiGU3eH4Xg9rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=StOVEISL;
	arc=none smtp.remote-ip=95.215.58.31
Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87488606A31C
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 00:46:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87488606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=StOVEISL
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=z26c2PyZ8pF8QGqqT2YXQEk7jdeK6dxDZwh05tv1Xdw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407607; v=1; x=1794012407;
 b=StOVEISLs7OTCFFflGvKw3SGY3u0LB+qtHOZoYHM907Qe2I2bliBtIMwaVx+X9XV9oDdZhX6
 bLwv6fhv4B1GGNxmjaxcHbXmWHIqDa5viGyTJEQjrRnrO5qvYvuTCDBPgdIRpYdqow2OdTTLZpP
 UT8a7Gr/3H22m/GTp4QsGiEY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 619347082113727e;
	Sat, 31 Oct 2026 00:46:47 +0000
X-Mizu-Trace-ID: 619347082113727e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 2/5] memcg: force charges from reclaim before trying
 the limits
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030205418.341214-3-shakeel.butt@linux.dev>
Date: Sat, 31 Oct 2026 08:46:31 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tejun Heo <tj@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <7CE7A687-C45B-4F99-8F58-88633E052D85@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-3-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 31, 2026, at 04:54, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> Reclaim can charge memory, for example when zswap stores a page.
> try_charge_memcg() forces these PF_MEMALLOC charges, but only after
> they fail at a limit. A charge that fits still has memory.high
> enforced. That can make a task in direct reclaim do more reclaim and
> sleep longer later, and kswapd records overage that it never handles.
> 
> It is also a problem for the next patches, which make kernel threads
> queue high_work. The worker charges memory from its own reclaim, so it
> can queue itself again. With those patches but not this one, the worker
> queued itself in 118 of 284 runs in a VM test with incompressible zswap
> data.
> 
> Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
> memory.high, as they can already go over memory.max. Drop the
> PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.
> 
> Other effects:
> - As before, the check reads current, so it also catches interrupts on
>  a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
>  themselves for swap over network, so the check can't be limited to
>  task context.
> - These charges no longer charge a batch or refill the per-cpu stock.
> - MEMCG_MAX still goes to the first cgroup that the charge puts over
>  its limit. On cgroup v1, memory.failcnt no longer counts them.
> - high_work can still run again and again when there is nothing left
>  to reclaim. This only stops reclaim from queuing more reclaim.
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

