Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617C634041B
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 17:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999819; cv=none; b=pv6ZWvKC1QDq3w01RqvSLgiTXKPmCpN12URy4vjO1StXc/aH7UxYqQuKNQ6CZxsIZSq3MT+joBiI3MIz1HWyQS81ew7MKtkM2c0oV++bMiWKMLVtpRPLOmX4uMZmXEqwB6KAPE2QsOtA+WbbhMtQyqH1c5msSYYUGBqzy/n+YYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999819; c=relaxed/simple;
	bh=q5POMpCCLN/ewLuDa3kIQXsVdH+S/vIBvv/bj14RqT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2JU+S0VLc7DstFTH02xHRCCyGSZJMknBCdJ0B6LIcEOMeZiIBwQvbMo28sWWw7ZlB6M+vd3lYpboLChVsFzdDKe6E64hQlBN0x99rmhyuDtUOJPVKRb4Mpj0Er/RD6QEwCZL7g/Jzkp9Lxu2B2OYrigjFhhFP/Oca4hkaw5Eyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZfXRQfHQ; arc=none smtp.client-ip=91.218.175.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZfXRQfHQ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=q5POMpCCLN/ewLuDa3kIQXsVdH+S/vIBvv/bj14RqT8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791999814; v=1; x=1792604614;
 b=ZfXRQfHQzp04Jmef1UvxTF9HZV7RBFkJ2QRBGU9jU0rMZ1bQvydkJLKzksVjNV2JkYkrPJG4
 QETks8hRgWzhIVl6Osy/jlQUeL7JZRi7cESf8c9/zqx3OulfxnLXwWkFt9MpI4g7J43l/tx63Uc
 /uFq+fFOGm+TtXapaaKyEZS4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id eff8696d1074c0e2;
	Wed, 14 Oct 2026 17:43:34 +0000
X-Mizu-Trace-ID: eff8696d1074c0e2
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 10:43:33 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 5/5] memcg: simplify high limit handling after a
 charge
Message-ID: <as-sE3hZqFA_Wb5B@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-6-shakeel.butt@linux.dev>
 <as9rj8KoF1oKO8rE@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as9rj8KoF1oKO8rE@tiehlicka>

On Wed, Oct 14, 2026 at 01:46:23PM +0200, Michal Hocko wrote:
> On Sat 10-10-26 14:09:57, Shakeel Butt wrote:
> [...]
> > -	/* Interrupts, kernel threads, and remote chargers stop here. */
> > -	if (use_worker)
> > +	/*
> > +	 * Use a worker for interrupts, kernel threads, and tasks whose mm
> > +	 * does not match the charged hierarchy.
> > +	 */
> > +	if (use_high_work) {
> > +		if (!iter)
> > +			return;
> > +		if (allow_spinning)
> > +			schedule_work(&iter->high_work);
> > +		else
> > +			irq_work_queue(&iter->high_irq_work);
> >  		return;
> > +	}
> > +
> > +	if (iter) {
> 
> Would it be much simpler to bail out on iter==NULL (i.e. nothing over
> high limit) right after the loop?
> 

I want this patch to not change any behavior. If we return here when iter is
NULL, we will skip a potential call to __mem_cgroup_handle_over_high() when
current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH. Though I agree that is
very subtle and most probably unexpected. If we decide to remove it, we should
do it in a separate patch. Actually I am working on a followup series where I
plan to remove the sync enforcement of memory.high and put high enforcement on
the code paths which can potentially do a lot of allocation within a single
kernel entry.

> > +		/*
> > +		 * Count the full batch so reclaim work and delay penalties scale
> > +		 * with the pages charged by this task.
> > +		 */
> > +		current->memcg_nr_pages_over_high += nr_pages;
> > +		set_notify_resume(current);
> > +	}
> >  
> >  	/*
> > -	 * Reclaim is set up above to be called from the userland
> > -	 * return path. But also attempt synchronous reclaim to avoid
> > -	 * excessive overrun while the task is still inside the
> > -	 * kernel. If this is successful, the return path will see it
> > -	 * when it rechecks the overage and simply bail out.
> > +	 * Earlier charges may have left high overage pending even if this charge
> > +	 * found no new overage. Handle it now if this charge can block, to limit
> > +	 * overrun while the task remains in the kernel.
> >  	 */
> >  	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> >  	    !(current->flags & PF_MEMALLOC) &&
> > -- 
> > 2.53.0-Meta
> 
> -- 
> Michal Hocko
> SUSE Labs
