Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76D4367287
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123719; cv=none; b=sl68Wn02HaF1TEuRojSE/q/XzHFaeqDD6rJnXgYoHU+f0JCY6lzJd/0J2DcWaREl3cIP39CemlYC2iFe7MjmO/WvjHIP2FAdWjXzi4dHITKfg5TIiac/qXmgb+ngoWT7zPQVzBpPFHm1zku4ynIkymZyDaICd4lJbdmLwNR0e2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123719; c=relaxed/simple;
	bh=hpPSDC09vWzUxSkQ+Vo4yy1VGWkDPNbj2tjozaihsTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+jPBrLLQgtl/V6NT8MSGidDpzxxxnoFiTDChdLnHdWWDv8fVmxI1VCYEAH5hv197e79Gf0Yn8v5twX+NHfpEYHDVUasvhLg4e3w50UW0o3rZ8fenZcySO0/c+kpLf89T15JU1IAY+p3sP1uHz2UJd/2z0YTFRfoINFl811vwoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ughP2etH; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ughP2etH"
Date: Fri, 7 Aug 2026 10:28:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786123715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=os/PRrPbacuorvD7qAfSrgmy4CupVw/uh8x9t7DjSaI=;
	b=ughP2etH1jfO2YCuUwJ+EDaLB5Zll21Cf4meMuH3AX4mSCqhajNRmbc1Jajyeb/kfQZWiC
	91mGj+2/jTt0aErwcrvnfYXlbFJC4bC1u/Ka6mNI817P1ddiI/TPHVS5SpH3kdPC6F4niK
	HCfDMnFO+ZHnCSYAHUgaXuM3nrkw5cQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Audra Mitchell <audra@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, david@kernel.org, jocolema@redhat.com, 
	raquini@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anYUNIKwXnTIx0fl@linux.dev>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anX8VgySSw5OR_Sb@fedora>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 07, 2026 at 11:40:06AM -0400, Audra Mitchell wrote:
> On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > > Originally nr_retries was actually nr_oom_retries and we used it to track (and
> > > limit) the number of times we entered the mem_cgroup_oom path and then attempted
> > > a retry. The purpose of nr_retries counter changed with the introduction of
> > > 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> > > charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> > > to retry within the desired nr_retries threshold. Later d977aa939fca
> > > ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> > > nr_retries counter from 5 to 16.
> > > 
> > > As the function has evolved we now have multiple paths that have a goto retry
> > > path and we have lost the original purpose of the nr_retries counter, allowing
> > > us to take a goto retry path an unbounded number of times.
> > > 
> > > Fix the unbounded retries by nesting the code in a loop and decrementing the
> > > nr_retries counter correctly.
> > 
> > Are you trying to fix a theoretical problem spotted by the code review
> > or is there any actual problem that you are trying to fix?
> 
> We have had some customer complaints that performance has slowed to a crawl when
> the cgroup memory limit has come close to the maximum limit. In those cases, we
> have noticed that each process is spending a large amount of time in the direct
> reclaim path acquiring just enough memory for their specific allocation, thus
> by-passing the oom condition yet degrading the system's overall performance.
> In the global case, direct reclaim is bounded by DEF_PRIORITY, however, a cgroup
> will go through the try_charge_memcg path which will call
> try_to_free_mem_cgroup_pages->do_try_to_free_pages each time it does a retry (16
> times). If we bound the loop in try_charge_memcg, the worst case is 16*12 passes
> attempting to reclaim. This patch is meant to address the unbound case, limiting
> the loops to 16 attempts at following the direct reclaim path. An argument could
> be made to reduce nr_retries as well, but given that the nr_retries has been set
> to 16 for sometime, it seemed unlikely such a change would be considered.
> 

Generally we keep the kernel oom-killer very conservative and let the userspace
system-oomd react and trigger the kill (unless there is an obvious bug and/or does
not require to add one more heuristic in the reclaim+oom path).

Anyways was systemd-oomd and psi enabled on the user system?
