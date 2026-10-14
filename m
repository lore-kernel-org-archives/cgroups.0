Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580953E6DE7
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006611; cv=none; b=QGe7y9uaNcYvhpeIOfnVe9dSV0g2AANO+USRAhDAePSr0xmOuqo7pLaP6iDvwJwdgdAfE/b3ACK4csZfla6ihTj7634jtsqBtyE1xY5a5P0SA4mKtYvsPsRsGWVp7bGLB6tfltLF9bGNkDLteIfmepIQJe6LWLkEnFDuWX/9v3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006611; c=relaxed/simple;
	bh=083C/YHtNGmiDsCLg6a7weM6tlLUgKGnnJOHmEI8Abo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UC1n27nrni9xl76ABGjMEk9hmRbeK5b62Fha/ifH8RqqZKO/APOmPP0JfO6iMzStcYOZ3I7RnAO5iVltIcGjcMx/iUNn8G7ZulyFSQlXIjd9ovXMknEqraz+i101D13oPTl6vN8kQQPMh1y+t9tIZU89cTBC/445RqTw4GiIGfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O0FuYSjL; arc=none smtp.client-ip=95.215.58.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O0FuYSjL"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=083C/YHtNGmiDsCLg6a7weM6tlLUgKGnnJOHmEI8Abo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792006605; v=1; x=1792611405;
 b=O0FuYSjLj/WmJsRWZxJpXbDZ3KrpA8OMFnQe/yrP2TTG/fGzZpG72vj3ZucIPIjzmSM6mVoW
 tzt5z4Z92SmkqdQl0Afm1cdzifmeKaUcde1pYP05WbjLxIClEQzwZ6HugLC9tteQ/JCThlB7zNr
 O8uFTml4zFu7OBv0AS5HQQKc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5208ad6ed7251eda;
	Wed, 14 Oct 2026 19:36:45 +0000
X-Mizu-Trace-ID: 5208ad6ed7251eda
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 12:36:39 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as_ZNUcBwNHnF_jU@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
 <as97Nzob4XuzO9Ss@linux.dev>
 <as-08j9_1C2F_N8s@tiehlicka>
 <as_AxtUlV8K2fkNu@linux.dev>
 <as_XvRZzV6vR9dCo@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as_XvRZzV6vR9dCo@tiehlicka>

On Wed, Oct 14, 2026 at 09:27:57PM +0200, Michal Hocko wrote:
> On Wed 14-10-26 10:55:21, Shakeel Butt wrote:
> > On Wed, Oct 14, 2026 at 06:59:30PM +0200, Michal Hocko wrote:
> > > On Wed 14-10-26 09:06:00, Shakeel Butt wrote:
> > > > On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> > > > > On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > > > > > Kernel threads and remote chargers use high_work when memory.high is
> > > > > > exceeded. Their allocations during reclaim can also charge memory,
> > > > > > for example when zswap stores a page.
> > > > > > 
> > > > > > Without a check, the high_work worker can queue itself from its own
> > > > > > reclaim. The pending bit is cleared before high_work runs, so each run
> > > > > > can queue another run.
> > > > > 
> > > > > What does that mean really? Does this delays the actual run?
> > > > 
> > > > It will not delay the actual charge request. This mainly means that we keep
> > > > enqueing the high reclaim work even from high reclaim context and can
> > > > potentially keep wasting CPU if high reclaim is not very successful.
> > > 
> > > Hmm, so is there any practical problem if we do that? What exactly do you
> > > mean by "keep wasting CPU"?
> > 
> > More specifically if high_work kworker keeps enqueing high_work, most probably
> > the memcg does not have reclaimable memory and keep retrying it wastes CPU.
> 
> Yes but this is not specific to PF_MEMALLOC context, or do I miss
> something?

Yes you are right and you didn't miss anything.

>  
> > > > > > Skip memory.high enforcement for charges from task context with
> > > > > > PF_MEMALLOC set when they would use high_work. This covers kernel
> > > > > > threads and remote charges. The memory is still charged. Interrupt
> > > > > > charges keep their current path.
> > > > > > 
> > > > > > In a VM with incompressible zswap data, the worker queued itself 163 times
> > > > > > without this check.
> > > > > > 
> > > > > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > > 
> > > > > The patch itself looks OK. I am wondering whether we can unify the check
> > > > > with the existing one which forces the allocation through in main
> > > > > charging path.
> > > > 
> > > > The force charge (and ENOMEM) paths bypass the memory.high enforcement
> > > > altogether.
> > > 
> > > Exactly. Isn't that exactl what we want to achieve here as well?
> > > 
> > > > Only successful charges (done_restock label) goes through
> > > > memory.high enforcement. So, even if we move this check in try_charge_memcg, it
> > > > will still be a separate check before calling high enforcement function. I think
> > > > this check is very high_work specific and better to be in the high enforcement
> > > > function.
> > > 
> > > I meant something like the following
> > 
> > Oh ok this makes sense. Do you want to send a patch or should I add this in this
> > series replacing the 4th patch?
> 
> Feel free to take it. I haven't even tried to compile this. Just wanted
> to show what I have in mind.

Cool, I will resend the updated series after the merge window.

