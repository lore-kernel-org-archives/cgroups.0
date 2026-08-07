Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6186C36F42A
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 19:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786129849; cv=none; b=I/pxnJ/tTcBpYBn+yA8O4HjMBYDo5SIdMqZYwNRzXJaqWK2w6oNaIeCAxwbKyCpmDBXDgGxNJbtxnbJxJfChAKhVu85Ea+HHs61W4iSqDL77ypWkyJd/mIf/coJe+EzbN0lX8kG0soeWXdZy5wLAVzcLV6cUUx5hcJVJRCKA7X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786129849; c=relaxed/simple;
	bh=jD430PnnWtLmYF5+CXSBXbQ2kOWcg7BN0V8I8xANai0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgIqDSj2u6ZGscy2a+yYaRBwL80v4g2+sX71TMGCPThrnkEDEhCwdikMC0Qnl/UyCY4TjGS3ewGdTlqKnsuNWF2NYvlHk4tk4T+/wObjHmzk6/c8c53uDydSh9uAk/3SZ2Y7Z2r5g1l2tpCUZFxiZrbsU3C7g48URC3VLD9HQy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lub/0oAM; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lub/0oAM"
Date: Fri, 7 Aug 2026 12:10:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786129844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PCEptNRU1/sT4EeCLaaq6ras0jXi+prulPBFZsJWzg8=;
	b=lub/0oAMZ/BfA/OhRan10l0mip92hxY0WzguPVfbO1Cdn7f7keLyKEEB5V1n9D33SLhKlC
	mdhx3EDFS736L4fM6ijybNLHtLOubSwUc5/1laOYT8p9QX2Bzs7Zr9K3P8PGx3pp3yX4od
	RvFOscDgbmV+WQ3PgWzqn44CV+KE0Wk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Audra Mitchell <audra@redhat.com>, david@kernel.org, 
	jocolema@redhat.com, raquini@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anYr6UIi1nevGJkA@linux.dev>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
 <anYoLs1B0MwUNR2n@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYoLs1B0MwUNR2n@tiehlicka>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 07, 2026 at 08:47:10PM +0200, Michal Hocko wrote:
> On Fri 07-08-26 11:40:06, Audra Mitchell wrote:
> > On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > > > Originally nr_retries was actually nr_oom_retries and we used it to track (and
> > > > limit) the number of times we entered the mem_cgroup_oom path and then attempted
> > > > a retry. The purpose of nr_retries counter changed with the introduction of
> > > > 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> > > > charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> > > > to retry within the desired nr_retries threshold. Later d977aa939fca
> > > > ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> > > > nr_retries counter from 5 to 16.
> > > > 
> > > > As the function has evolved we now have multiple paths that have a goto retry
> > > > path and we have lost the original purpose of the nr_retries counter, allowing
> > > > us to take a goto retry path an unbounded number of times.
> > > > 
> > > > Fix the unbounded retries by nesting the code in a loop and decrementing the
> > > > nr_retries counter correctly.
> > > 
> > > Are you trying to fix a theoretical problem spotted by the code review
> > > or is there any actual problem that you are trying to fix?
> > 
> > We have had some customer complaints that performance has slowed to a crawl when
> > the cgroup memory limit has come close to the maximum limit. In those cases, we
> > have noticed that each process is spending a large amount of time in the direct
> > reclaim path acquiring just enough memory for their specific allocation, thus
> > by-passing the oom condition yet degrading the system's overall performance.
> 
> Yes, this is entirely possible scenario.
> 
> > In the global case, direct reclaim is bounded by DEF_PRIORITY,
> 
> Well, both global and memcg reclaim share the reclaim logic. Both of
> them try to exercise all reclaim priorities (i.e. check whole eligible
> LRU lists) and they fall back to OOM killer only if there is no other
> option left. For the global case should_reclaim_retry is the gate keeper
> around direct reclaim retries while for the memcg we have more or less
> fixed number of retries.
> 
> > however, a cgroup
> > will go through the try_charge_memcg path which will call
> > try_to_free_mem_cgroup_pages->do_try_to_free_pages each time it does a retry (16
> > times).
> 
> > If we bound the loop in try_charge_memcg, the worst case is 16*12 passes
> > attempting to reclaim. This patch is meant to address the unbound case, limiting
> > the loops to 16 attempts at following the direct reclaim path. An argument could
> > be made to reduce nr_retries as well, but given that the nr_retries has been set
> > to 16 for sometime, it seemed unlikely such a change would be considered.
> 
> As Shakeel said in other reply, this is a deliberate implementation
> decision. The OOM killer is the very last resort and we are giving
> chance to userspace to handle close to OOM situation much more
> gracefully and also workload aware. Keep in mind that what might be seen
> as a slow progress for one workload might be acceptable for others where
> OOM killer could mean a lot of work being lost.
> 
> From what you are describing above those users might be hitting reclaim trashing.
> I.e. last small portion of a reclaimable memory is bounced back and
> forth for the workload to make tiny but steady forward progress. While
> OOM killer might help to stop the suffering and restart the workload
> sooner I would generally recommend revisiting limits set for the
> particular workload.

+1 to this. Beside memory.pressure, we also have refault and reclaim metrics
in memory.stat which can further help in debugging if the workload is thrashing
due to workingset larger than the limits.

> Especially if restarting it might lead to the same
> state sooner or later. Watching PSI metric would be a good start to see
> how the workload behaves wrt memory stalling. User space oom handlers
> might be a proper measure as well but that will always be safeguard
> rather than a solution.
> -- 
> Michal Hocko
> SUSE Labs
