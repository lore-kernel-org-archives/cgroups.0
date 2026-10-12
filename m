Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7F43EDE6C
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 11:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791803301; cv=none; b=q1oOBu+sxqGhVNqHaERTgESAkzlO3Zghm5N4G2bMKDhwJWjBwEr0vl+uI5NC54kfksbJl+yEYkjl9r02TZCrHqgQ1dDIya8s2aBrhC2qVV8JKSfOLgz5uUnQkYesuJ8pOLwZ528LoOecibSzPYl/xT7So/LbYeDqsgAlLDyyhQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791803301; c=relaxed/simple;
	bh=GSrdr7mS12mhAPcQhPWfCq5PW4kV/MXU8Gl0USYX69k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irntmSxrvSprYTxC0HI0EgO2f+202lB0qIqsomZkVlt17hnyvzI9trqLrMsuSXq3a6gsbq6TNGDghLLBXUX/BXNXmNSRE8Yn3iwHkGHiOS4xO7Hc9jT6VY0LUut2bwWTV836wwQM/LOD1Zpgmz5bsO+mvVa/xZB1gaeXksWhLTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s6+84idP; arc=none smtp.client-ip=91.218.175.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s6+84idP"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GSrdr7mS12mhAPcQhPWfCq5PW4kV/MXU8Gl0USYX69k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791803296; v=1; x=1792408096;
 b=s6+84idPgY/Ya5g/Yba+NB5TW+mTwe7u66sYYprc0iHt6luMdY5ewIdGH3CZwILrKK2qzH/Q
 Qmr6SyOBaFMvQiEb7NFyITg99qXoPH1mkyQUbmjCCLgk+aSbCmsi+U7hXdzU9qFMGTJYRsKOiOo
 INBAi6YloKFqesZs1VMZD5xc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0d2ca05d90e48ec5;
	Mon, 12 Oct 2026 11:08:16 +0000
X-Mizu-Trace-ID: 0d2ca05d90e48ec5
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 04:08:11 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Mingyu He <mingyu.he@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
Message-ID: <asy_L2s1TNcN7bOK@linux.dev>
References: <20260911032905.63683-1-mingyu.he@shopee.com>
 <aqRXqcynCx88D2QK@linux.dev>
 <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>

On Mon, Oct 12, 2026 at 04:17:46PM +0800, Mingyu He wrote:
> Hi Shakeel,
> 
>   This came from a reproducible workload with a custom in-kernel consumer,

Please share your custom in-kernel consumer. Let's not make changes in the
kernel for things which are not in upstreame kernel.

[...]
> 
>   Regarding the BPF interface, the implementation in the tree I found is:
> 
>   __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>   {
>           mem_cgroup_flush_stats(memcg);

Let's make this force flush.

