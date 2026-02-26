Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6123B223DC9
	for <cgroups@vger.kernel.org>; Thu, 26 Feb 2026 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772113159; cv=none; b=jCFzGxs5bNL9m9YZqlvzfGD/Io3ayHTkeGp+DShyaWWyU+oZeo2wYJdlTo8e1W6z0c2+9zZv0T4wp4wcleLF68mLgcgHVzmp7+SAT1zRhphiNA3poFPLUFVH9C1w24qgaf8mzCE1JYq8nEa+N8tmRO/BK1R0GZ62WJly8Z69an4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772113159; c=relaxed/simple;
	bh=jR5uv885HDHBxmpRoseRMzHbHsp7+BQHhZndtKyuCCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSXfIDeQDejWuiIdmSUeJHpRXlKRrginvdrydKbGvMfzQK6KeeAcACMNSBTQnxp1SvcKinyYJz7P6xcqrRF+3P4A8+PDff19sJyF4U6PuRaU1eAVu/ujXvw0R7T3QYCc5mEi3fJz0akjtlG7ZWNUhj8sR3AsG+vVnlDpc/oIT4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LAijfW77; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LAijfW77"
Date: Thu, 26 Feb 2026 05:39:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772113146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86+mXi9L/gLCLWNcu/Z+GG/qwyq3WnOhFFQzn1lQbCg=;
	b=LAijfW77YpuG22Udq9aazERjZ8rTXISFn3fH5kBDmQyvSHGoPNpQ+xcI7gfApl3um0jHeE
	xM6Gn1o1IeCYWqFgomAd8+WnhYKXcBO25ybeGr87DGNuujH5q0F77ZPmn1rMQ3Z4eBIaxZ
	QImFVIzvMNhaGFpSh9Vmf3kWUBxbJjo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hao Li <hao.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	vbabka@suse.cz, harry.yoo@oracle.com, muchun.song@linux.dev, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock
 path
Message-ID: <aaBM0fN8fqER7Avf@linux.dev>
References: <20260226115145.62903-1-hao.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226115145.62903-1-hao.li@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 26, 2026 at 07:51:37PM +0800, Hao Li wrote:
> In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
> use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
> than nr_bytes.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Li <hao.li@linux.dev>

Thanks for the fix.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
