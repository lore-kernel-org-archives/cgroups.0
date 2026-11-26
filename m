Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706828;
	b=SEjON0nlVWUhCNx3dqvam4HABlXtvAU+20E022ri2GkA4AHzBCyCUgLJbcs2v3Qcn/W3
	 kkUUTZU6jQ8rYwnYTsIqOl8RlhV+eNQtj+Ncwo/FIu8QF05DItcFgGAAtZbsNCYoH2vaU
	 tEl69/5vFvJaYF3q3U5R8TAjqwOgkQCwGNPaQl8BasZVkZ9DwynUmSEcc1moiOT5lXt2B
	 ITYyrdIWFP5qCJBvJWr5HSAgYeF9F/XfPRkbyLf7gvbYJz1tF3Ppa0XXUGQcKGxMsSJEE
	 XOVnlGtm5f/tGPv2Gb5HZDoSQ85yTHuqaUxbBs4KyEB1Zlc1HOhv1DB8aSRb1w5KT/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706828;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yuJqy0NseoGTjiNdlXcAFKErbfQ+Md0iYPLbsmzKFlE=;
	b=y9rqSQSwgHl/qGJRr9VeGJSZ/dzPi6OIFafsnPLv53Yjl+f3P+bydju31oS6N80NoBIP
	 EZU1tP+9DQD9NJED/fohbKE2HCRTKUUglA7wluerTdI3gOppAND4Pa9DyNlih2ydY9lgA
	 eZtx1IBeCxT+CYJptO+EHYTInqKv2r0AQ507iuut8I0r7VINKnM62ihHgsyUAUpznfJ9Y
	 6W4DqghsWdCWK5BITNJG6CNeeGAzDZLc16EQpZDo0e4RSVs8+3XN8PSHf2JjDrjC8HX/I
	 mxJ3zg/P7qF3bt4DC+69Yfp/BeifCp1buhfLuNUNSdcReOeTiQcAj9Fgsj/hme14IAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F4BGsX4w;
	arc=none smtp.remote-ip=91.218.175.20
Received: from mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD493606A321
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 15:27:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD493606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F4BGsX4w
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KbVedbyeDFEeAK/XvGiJ+Oc2ogwQltzRQPHWkSa26XU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795706825; v=1; x=1796311625;
 b=F4BGsX4wltLX19n0RQ8e8Lt6Xa7f1+aUnz+D6fm9t8CzdvEHQAYwU+IaId0QNmsBQAtY6/2P
 u0mi9Zje/Mxd2bT8bJP8x4XrSBVRCtPhYixoPR9WsY19bI+h7mhdfQbTumZkt06dDUk+TSDh4Ge
 Y9/YgJmw2wdECDMDiCLOEwX0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a9864cef7e22ac7f;
	Thu, 26 Nov 2026 15:27:05 +0000
X-Mizu-Trace-ID: a9864cef7e22ac7f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 26 Nov 2026 07:26:59 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memcontrol: expose anon and file reclaim statistics
 in memory.stat
Message-ID: <20261126152615.GC738059@shakeel.butt@linux.dev>
References: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
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
In-Reply-To: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>

On Tue, Nov 24, 2026 at 03:51:27PM +0800, Xueyuan Chen wrote:
> The aggregate reclaim counters in memory.stat do not show how reclaim
> is split between the anonymous and file LRUs of a cgroup.
> 
> Expose the existing per-memcg scan and steal counters by LRU type so
> userspace can measure reclaim balance and efficiency when evaluating
> reclaim policy. Report the same counters per node in memory.numa_stat.
> Both files report the counters in base pages.
> 
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
