Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC234361DA5
	for <cgroups@vger.kernel.org>; Thu, 22 Jan 2026 21:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769116356; cv=none; b=jcdN9+ePuxIR7n0PCm1mYBF3uXLBHWgN3z3tq/dVWO3/ruaEG5V5wH/9VXnLZ2DYQ8HP7osTeQqt0tr03WwPGD97TI0crDccmnEmEFbLKU6XVof8cbmMQasUlUfq7+IcN2FevO4W7o0aotI7ruc90WmxeSghLsvHhLeypQF/WnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769116356; c=relaxed/simple;
	bh=uF79UUOVu2VSWSWvxPNG4ohwvihAPUyWESs0mW4lkiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sx7hHMjT7uLOMvqNY6pEipB5yG5U591Kyz8ZW2D7jgccyQeA7cR8wPtZyLPQb97/riR8mZdWey3UVbfSnFcGDU8gbhSPecqkL6jVN15J6w8pvsM46wXwVoNYuNIaY6HigJY/rJLac5TAz/3BdjNzvvWMbXSHxJn5uqXcYz0c5s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cxBUblBF; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cxBUblBF"
Date: Thu, 22 Jan 2026 13:12:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769116347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kYfdqvT319RBpVhEW8fYIHSKc/aCjfRP65K3l5ZbsKg=;
	b=cxBUblBFrRAcJdIrrBvrIM5okSmViN9tTDjm3kNwm7aSn8F/wSRIPfTKe4rFBn2RX/d7ri
	OSWCnaCrtzQjThsFELOlHHpm8wTMiT1MlEzBGf9x8PG1iDdmuTaCn99BxKvrMnNIsW7SiT
	4ySESML89TrncBDHVusXxo5XuMd0kRA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	inwardvessel@gmail.com
Subject: Re: [PATCH v3] mm: optimize stat output for 11% sys time reduce
Message-ID: <aXKRIOpDrZG37_wz@linux.dev>
References: <20260110042249.31960-1-jianyuew@nvidia.com>
 <20260122114242.72139-1-wujianyue000@gmail.com>
 <20260122091351.0cc1afd5d419fafa1d98b32f@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122091351.0cc1afd5d419fafa1d98b32f@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 22, 2026 at 09:13:51AM -0800, Andrew Morton wrote:
> On Thu, 22 Jan 2026 19:42:42 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:
> 
> > Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> > printf parsing in memcg stats output.
> > 
> > Key changes:
> > - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> > - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
> > - Update __memory_events_show(), swap_events_show(),
> >   memory_stat_format(), memory_numa_stat_show(), and related helpers
> > - Introduce local variables to improve readability and reduce line length
> > 
> > Performance:
> > - 1M reads of memory.stat+memory.numa_stat
> > - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> > - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
> 
> So the tl;dr here is "vfprintf() is slow". 
> 
> It's quite a large change, although not a complex one.
> 
> Do we need to change so much?  Would some subset of these changes
> provide most of the benefit?
> 
> It does rather uglify things so there's a risk that helpful people will
> send "cleanups" which switch back to using *printf*.  Explanatory code
> comments would help prevent that but we'd need a lot of them.
> 
> I dunno, what do people think?  Does the benefit justify the change?

It does come with significant benefit but there is no urgency and we can
definitely decrease the ugliness. JP told me he has some ideas to
improve this.

Andrew, let's skip this patch for the upcoming merge window and you can
drop it from mm-tree if it is a burden.

