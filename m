Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFD2448BBE
	for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 21:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785275875; cv=none; b=qP/l76d4bo2pRZptbxUwSbUFmSAMvTKn8z53M+HeVqmGXRmyV2BEm0Z9DDz/88PbTPL+W3n/gz3XNBqanQmpwRNJOy64Bbv2roxnE0aT74kIq+dvK1goO6+uQlGlLQHXUWtbZSi+K+o76FANgSk71NEng4fQFViDhqORXCjfh6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785275875; c=relaxed/simple;
	bh=nOUoc94DzlfDyphYzuR1x6IJHoQGvh3JVcVlGwM/AV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anUrW3mt4zVE2VTzCjlWuwRCVglcSOUT0vMqbP6uFnz8BO13fiz/eUZAxB11bo48tg7uC5NT6wJL7LTJ1Nf5m1h8Bvhd52yuWmb9mgZcGhrMs8GTf1pwEtRj2VYv4J4I8X4T+V/6BugZZU5T3ooA3D3rUvPrug+wdPdawZbX7hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZPVRQLU4; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZPVRQLU4"
Date: Tue, 28 Jul 2026 14:57:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785275867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf3Bnkx46W9gMZvdRYmVghSOeclZTGz/xxcx9HYGmF0=;
	b=ZPVRQLU46Zs8g4/juBipXjOm8G8+oEFx+Hz3pC+IdPNGyI5azPRp+fkX+PB8bq1FIN5T2n
	a/r8idt2v53wm7MDwKmiXSP7tBvlgu9ttPHuo/WNEBsTyz+ZG1hS8rJ50q53fnkTPf3Qpc
	LgyX2IAl/G6hm3g3QcacFD4QW9QiWfc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Nhat Pham <nphamcs@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amkjTk7Jc1q4ubxj@linux.dev>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
 <amhZ645Nhj856JfO@tiehlicka>
 <amjeUV3dAn7KPQgK@linux.dev>
 <amkBvRSJm5rgiV5Q@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amkBvRSJm5rgiV5Q@tiehlicka>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 28, 2026 at 09:23:41PM +0200, Michal Hocko wrote:
> On Tue 28-07-26 09:55:21, Shakeel Butt wrote:
> > On Tue, Jul 28, 2026 at 09:27:39AM +0200, Michal Hocko wrote:
> > > On Mon 27-07-26 13:48:58, Shakeel Butt wrote:
> > > > On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> > > > > On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > > > > > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > > 
> > > > > > TBH I am not entirely happy about this approach. It effectivelly reverts
> > > > > > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > > > > > It just makes it lockless. Assumption that a dying task will do so
> > > > > > quickly and with bounded resources has turned wrong on several
> > > > > > occasions.
> > > > > 
> > > > > That's why I kept it as RFC :)
> > > > > 
> > > > > > 
> > > > > > On the other hand I do undestand the contention issues and I can imagine
> > > > > > that the existing solution doesn't really work well for huge thread
> > > > > > groups that all end up lining up on the oom_lock just to learn there is
> > > > > > nothing really killable anymore because they are the oom victim...
> > > > > > 
> > > > > > Would it be just safer to bail out only for oom victim threads. This
> > > > > > would narrow down potential runaways for oom victims which should be
> > > > > > more limited than any killed/exiting task. It would also give the oom
> > > > > > killer/reaper chance to work. WDYT?
> > > > > 
> > > > > I will give the following patch a try with the reproducer I have. I am still
> > > > > improving the reproducer as I am still not able to recreate multi hour slowdown
> > > > > yet. I will report back once I have some results. 
> > > > > 
> > > > 
> > > > I have some results with the reproducer I (AI) wrote.
> > > > 
> > > > Setup: 20k threads, each with its robust_list head on its own page in a
> > > > large anon region pushed into a zswap pool (writeback off, so it's
> > > > unreclaimable and pins the memcg at the limit). On the OOM-group-kill
> > > > every thread faults that page in futex_cleanup() -> do_swap_page() ->
> > > > swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
> > > > in a loop so the oom_reaper can't reap the pool -- matching the host,
> > > > where the reaper was blocked and the memcg never fell below the limit.
> > > > 
> > > > I tested on next-20260726 as baseline and then tested your suggestion over it.
> > > > For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
> > > > drain the 20k threads in a VM (hours on the host, where each invocation
> > > > was a dump_header over netconsole). With the patch the dying tasks stop
> > > > entering out_of_memory and the storm is gone.
> > > > 
> > > > With the following suggestion, the threads of dying tasks stop entering
> > > > out_of_memory but the exit time doubled as each thread has to decompress the
> > > > page from zswap.
> > > > 
> > > > 	if (tsk_is_oom_victim(current))
> > > > 		goto force;
> > > > 
> > > > I also tested by replacing goto force with goto nomem and the exit time halved
> > > > i.e. ~20 seconds. Looking deeper it seems like each thread is still going
> > > > through the reclaim loops.
> > > > 
> > > > Just for testing purpose I moved this check along with goto nomem just before
> > > > the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
> > > > below 1 second. I think what we need is to detect early that the cgroup is
> > > > unreclaimable and the threads of exiting/reaped process should just return with
> > > > enomem.
> > > 
> > > Do you mean, something like this?
> > > --- 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 6dc4888a90f3..66f1eebf8c22 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2648,6 +2648,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > >  	if (!gfpflags_allow_blocking(gfp_mask))
> > >  		goto nomem;
> > >  
> > > +	/*
> > > +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> > > +	 * help but it might fail on mmap_lock contention. If the victim is a
> > > +	 * large thread group then all exiting threads might compete on oom_lock
> > > +	 * just to learn that there is nothing really killable anymore. Bail
> > > +	 * out early and fail the charge to expedite their exit. They are
> > > +	 * considered fully reclaimed by the oom reaper and they shouldn't contribute
> > > +	 * further charges.
> > > +	 */
> > > +	if (tsk_is_oom_victim(current) && mm_flags_test(current->signal->oom_mm))
> > 
> > I simply had tsk_is_oom_victim(current) check here. 
> 
> I was hoping for a more specific treatment. 
> 
> > I assume you want
> > MMF_OOM_REAP_QUEUED in the mm_flags_test() above. Do you want me to test with
> > this additional mm_flags_test() as well?
> 
> Sorry I meant MMF_OOM_SKIP there.

Here are the results with the reproducer I have. Ran the test 5 times and
showing avg and std below:

Baseline (next-20260726)			36.47 ± 0.78 s
early nomem (tsk_is_oom_victim + MMF_OOM_SKIP)	20.83 ± 4.19 s
early nomem (tsk_is_oom_victim)			 0.59 ± 0.22 s

Since MMF_OOM_SKIP is set after multiple retries by the oom_reaper the result in
between baseline and simple tsk_is_oom_victim check makes sense.

I think we can proceed with the early nomem (tsk_is_oom_victim + MMF_OOM_SKIP)
change as it is more conservative unless you have concerns. Overall I want to
deploy this in prod sooner to see if this specific issues is resolved or we
catch something else.
