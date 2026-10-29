Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793304134;
	b=XeuVxEQejgANjMXPoca9fn/a/RGaW0QfELfTwl95vOCH6PKY1qrWtJM2+C8kBxxQAmQQ
	 IBhMdUDsZewH7UOasrVDTqzMWNSRelY1losc99qLsP0QZM/nZVpi6vOhrsZHjXvZ7Cf4w
	 1vFq2A6Gj6J7AgkYOtqtwcFPSQTZIJGl2bPQ0C8HZ73qi+4rt6rOmSeDlYFuq9tV0seok
	 kA/xmSZKOoMEakLN0595DoW07QSaWd6UmF7XdOUzA7FrAYhZDZzszwVmWEED5a1IfptD0
	 hDCUfpBt+9mHeIZ/TWcSsT/F19+jtwo8B+AvHjoAthv1CAjxGYqA2GVFgBHfZRk6gZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793304134;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x7QbBREQ+MMItXZrHv3jRMCCfzMElbblNplhpdNrQEw=;
	b=icolj4vdtDeSZwmV61LiyfXAXSO7UCJeYJSf81aTxpmxG/AKYdjqAZ/3/HLDfoZ5jGje
	 SXen2R24Lfu6osJWe4rH4aef7I60jdFUBLW38mcZhuqsDG4zF53udofcPjY2zL/YEYIjg
	 SlKiEM4Gjf4DBZsRHynMZMlvDidGI1hiVo5Wj0s4T8MPKLWkKA385AVqfjVlHdZy6LiQ4
	 5T6DtsRU0IrhDwXAefsA7njQm5f2vO53MwZKreaXoBkvT6+/5lkskrevSTUXswqSaw8gh
	 QefTgAFA6IkB6ZNplGO3zM+ikAJ7UnslcVscDU3jpmMJh7nJO4ppiMNmNBNlQlLtixQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q5loa8XA;
	arc=none smtp.remote-ip=91.218.175.220
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B78606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 20:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1B78606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q5loa8XA
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ndNJf7YwM/TOx7eJIWnPNAnZdeI6PTLMRtwC3Ga2kgc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793304130; v=1; x=1793908930;
 b=Q5loa8XAo3SJYK9aXRqiC9AaOub0uSUNasOOf5Fk77P8FRZkyiWW3kokWuICTEHIkWD24L+x
 YFaM5X5LwEyUAgP3dzzTjQqcCiJlTyukXXUfqRKRADGEbPHkuTk91WEJbkfZMlAprkyuuUUwtv7
 MbqgLkS3ECYZzCx2Dy+snrf4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1426dea9613e2433;
	Thu, 29 Oct 2026 20:02:10 +0000
X-Mizu-Trace-ID: 1426dea9613e2433
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 13:02:08 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, yosry@kernel.org, 
	joannelkoong@gmail.com
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
Message-ID: <auOlmxtQ5-EZTj62@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <auKSeCFvsWzP-XYy@linux.dev>
 <auKYs_ucslI-tdar@linux.dev>
 <auKcNvAizn-B92xB@google.com>
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
In-Reply-To: <auKcNvAizn-B92xB@google.com>

On Thu, Oct 29, 2026 at 01:35:18AM +0000, Kuniyuki Iwashima wrote:
> On Wed, 28 Oct 2026 17:52:32 -0700, Shakeel Butt wrote:
[...]
> > > 
> > > For the 4th patch, I would prefer we first try to move the network sockets
> > > from memcg to objcg path.
> 
> sk_forward_alloc is already batched per page, and I think
> migrating to objcg would just add an indirect layer and some
> costs for css_tryget() / css_put(), and still inlining
> __consume_stock() or batching in memcg_stock would be crucial.
> 

We are over time moving kernel objects holding direct reference to memcg to the
objcg infra and the reason is such objects can become source of zombie memcgs.
There is no urgency for the network sockets but eventually it will happen. We
will see if indirection is really measurable at that time.
