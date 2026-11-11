Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794355521;
	b=tG4lfU2CZEosENJjc/BN1Yy7Dl72aq/nRjMVly7jKxtPK/YzeZkkcLC6lhCkzDEYxsjj
	 IEVvNC6gKwuWl2O1IbHdGEoIgsTS6j55u4NEz1Y5b3DMOVTu/dxCP8/IIfzufpjqo0I7x
	 a9WbVTz4z2/baGf2aXlNibM96C+4bZX8XQ2QzeiTeu7mS2pD1aCYEJWBs1oa3YZEHK+TE
	 zSeRkX3POxSwMsxgTo9fe9kbT3fyYekfr4CqwPW1Mq+gsZZQbfdjxH2CGPPl5UZM424vi
	 ngnV8FqFndmXRR9Wn6kSgzQ+KHSCx6p/wy4hgTxbp4ww8r6Zsy3o0lsqeZYcWiw+x3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794355521;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lXPGOnD2xoKZFTFfUqDx4bSUVEQWrQ7xV1CJ8oeKg+8=;
	b=fy0aggoqg1WJJXBd0Pl52JgSQYX7EiaGQMa+ZNSmWwpuqSehkD7dRNfPgMpUVYnt7hIq
	 QxPcQP86Wit3DfhZku/D1kfxAE7I18B0F6Vw2e3O9cdcFWMINVj/CViPwNU5xuP1JN6tb
	 VINPIDRh+PDGh44y1pdNBQs0iNDOXeWVHKIBTuqyQh+b6YEeBOC+SeQ842R01UyBcd4NM
	 53ZGdfUR3NIHWFr51MIK+WKI7UYQ4r+x7euK0SggishM8Wh+a4Y2m0t2RrXhGP9PP1nGc
	 VwgR+jGyOabhQIROf4sWiaYVLTGXNUE2/3BEJE3Sk9KfCYve5e7W4wimmjGwPVtOgaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ctOH3hn0;
	arc=none smtp.remote-ip=95.215.58.155
Received: from mta1.migadu.com (out-155.mta1.migadu.com [95.215.58.155])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AE9606A31C
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 00:05:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62AE9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ctOH3hn0
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lxTQMWQoOBuUMzQsVGk0y2VzRKADUwBbP6Tg7Ined9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794355518; v=1; x=1794960318;
 b=ctOH3hn0PUbQLLpTbGcEA4wf9tdSFP6RIfOn0jurA7nMbS+cK+K0q1rriYMpzp4JRkVNmbB4
 jtay3mH6UZPP1Rwd30+tN/SOVBzlvdlmFDVoiSFADLF/2swukYOleRAPemwaD/bysqvxpcj7xAJ
 Igi9SVRZA1aOHX/ta5Xur8x0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fcc7bf95561a02ce;
	Wed, 11 Nov 2026 00:05:16 +0000
X-Mizu-Trace-ID: fcc7bf95561a02ce
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 16:05:14 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Noah Feldt <noah@feldt.systems>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] mm/memcg: list_del corruption on memcg LRU on
 7.2.11 despite bf4ade7dbd76 (single NUMA node machines)
Message-ID: <avOxF0yKfZ0Wv1gb@linux.dev>
References: <20261110132853.71228-1-noah@feldt.systems>
 <avOsiy7kGWpehKJn@linux.dev>
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
In-Reply-To: <avOsiy7kGWpehKJn@linux.dev>

On Tue, Nov 10, 2026 at 03:46:07PM -0800, Shakeel Butt wrote:
> Hi Noah, thanks for the report. Can you please first test without MGLRU and see
> if you are still seeing crashes?
> 

Never mind, I think I have a reproducer and the fix. I will post it soon.
