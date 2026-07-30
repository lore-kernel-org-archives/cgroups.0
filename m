Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8148145BE3
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 04:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785386240; cv=none; b=OKYtjcb+AoXBAZb5C1jIwVSZb1YHyCFT6ZZ78AaKQsnqNVfu+yFleoZ+3dyE3cgByo0BlIi72mPsmqU/k7TGQVoWL7v2RSDwi6udD3EKqktUejqWCY97koOZTn9T1NuD9megyJMcPI2ZZEiUPECX6CEsvCPTSW1UOGy8fs2jrAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785386240; c=relaxed/simple;
	bh=5FHUxzGMdV1pqnOsg8NMCY1ZWtE0VK9dJf8LxF7ro/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1xbUJV4Sx3ApjlhuFOdCwTsqqR43RTr7VOSduKjRV1hWCjTT1Qryk9ff7Mtl88IydL/yBLPOX0JPaN5i7cPjHvs0s5Cb2JEP3H+0iLm8YpSCRm/zz1BNaXIFHN+cyclPC1LEwSLPWp9FA61Xc9bAM5+5Vxrc4ch+osMxTd9TJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aLag2t32; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aLag2t32"
Date: Wed, 29 Jul 2026 21:37:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785386234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jt+GOWxdRbvsR3onEzesDNIgXdjOGzHQPiH/YZFcDak=;
	b=aLag2t32vo0HfGP+4yMkIaDPGDwCBapLHur4aYP5Nt1ZKrQjTIqeEcs8OQeP5zD+rYiZL5
	daMZ14jAhD8xRyrlmKNkle9b7uCgKjSB0rEktoDzU8GFT7zv+T7WQUEu3b0xZ0ymfU3Zy2
	prKvb0ifiK/Vg7kjbGCDrxeVufDzBcY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Rik van Riel <riel@surriel.com>, Nhat Pham <nphamcs@gmail.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: bypass the reclaim and oom killer for dying tasks
 once oom_reaper is done
Message-ID: <amrUQZDNNJMdl_aP@linux.dev>
References: <20260729024612.3369005-1-shakeel.butt@linux.dev>
 <20260729181349.fd41f1a09ec19c9cfb0c412f@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729181349.fd41f1a09ec19c9cfb0c412f@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 29, 2026 at 06:13:49PM -0700, Andrew Morton wrote:
> On Tue, 28 Jul 2026 19:46:12 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > At Meta, we are seeing instances where an OOM killed job is stuck in the
> > exit path for several hours. In one particular case, the job was stuck
> > for more than 8 hours and I had to manually remove the memory.max limits
> > to allow the process to exit.
> 
> Not seeing the problem here - that sounds like normal kernel behavior ;)
> 
> > Reproduced with 20k threads, each parking a robust futex head on
> > its own zswapped page, OOM-group-killed while a sibling holds mmap_lock
> > for write so the reaper gives up and sets MMF_OOM_SKIP. Tested on
> > next-20260728 and baseline show ~90 seconds exit time while with the
> > patch the exit time reduced to ~3 seconds.
> 
> Very positive.
> 
> But it doesn't sound like you're fully confident that the problem is
> fully solved?

Yes as I am not able to reproduce multi hour stall, so I might be missing
something else. The patch at least fixes the issue which I am able to reproduce.

> 
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2653,6 +2653,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	if (!gfpflags_allow_blocking(gfp_mask))
> >  		goto nomem;
> >  
> > +	/*
> > +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> > +	 * help but it might fail on mmap_lock contention. If the victim is a
> > +	 * large thread group then all exiting threads might compete on oom_lock
> > +	 * just to learn that there is nothing really killable anymore. Bail
> > +	 * out early and fail the charge to expedite their exit. They are
> > +	 * considered fully reclaimed by the oom reaper and they shouldn't
> > +	 * contribute further charges.
> > +	 */
> > +	if (tsk_is_oom_victim(current) &&
> > +	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
> > +		goto nomem;
> > +
> >  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> >  	raised_max_event = true;
> 
> Should we backport this?

I don't have any strong opinion. I wanted to deploy this patch in Meta fleet to
get some exposure. Maybe backporting will give more exposure to it.
