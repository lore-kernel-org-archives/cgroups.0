From: Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH v2] sched: cpuset: Don't rebuild sched domains on
 suspend-resume
Date: Tue, 31 Jan 2023 19:22:23 +0000
Message-ID: <20230131192223.jf3aydhafpmjg5z4@airbuntu>
References: <20230120194822.962958-1-qyousef@layalina.io>
 <c4c2dec6-a72b-d675-fb42-be40e384ea2c@redhat.com>
 <20230125163546.pspvigh4groiwjy7@airbuntu>
 <45e0f8ea-d229-1ae7-5c12-7f0a64c6767a@redhat.com>
 <20230130130038.2qx3pkzut6ypqdub@airbuntu>
 <253ced33-c3a8-269f-90cc-b69e66b10370@redhat.com>
 <20230130194826.rxwk4ryvpyxemflm@airbuntu>
 <17537d7f-8734-2186-b27c-f39f3110ffe5@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7lck5IFZUPbrV5J6AbtBCAeWGEX6izFIQH+15LEmKRA=;
        b=3mi0GsH7c6haeXzLoSNBUXCZpDEVsQNhDfqH8x3AWvsrX9uuhJm4c0ocd3YSjSi1qY
         FmqiRBSw3s5FCYEfm3TX/DZ98X+onxYyAhmSUynBbDSVzmuq9zFZhAKyD+86vWKPpl8t
         YBDVE1Wu0NVQZmiUBz46yaPPGoN/Wb6jl+U0rvzVDnQj8CwyJNh1sEyxx8oGjHEtqNZT
         JlO7ugaGhSBoAISDe7Qz7d6DVDr6dJf/+mBiGKZBsbyVbNJ3KVq22VNzbXRyctHCdRcT
         QyGHs+M5KLdcKhbrvXNftSIzNQIwMzDP5FZzZvRv55ygaB0vxuJ6IPE1V2cdilE0qixV
         ZTZg==
Content-Disposition: inline
In-Reply-To: <17537d7f-8734-2186-b27c-f39f3110ffe5@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, Dietmar Eggemann <dietmar.eggemann@arm.com>, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>

On 01/30/23 14:57, Waiman Long wrote:
> On 1/30/23 14:48, Qais Yousef wrote:
> > On 01/30/23 11:29, Waiman Long wrote:
> > > On 1/30/23 08:00, Qais Yousef wrote:
> > > 
> > >          just skip the call here if the condition is right? Like
> > > 
> > >                  /* rebuild sched domains if cpus_allowed has changed */
> > >                  if (cpus_updated || (force_rebuild && !cpuhp_tasks_frozen)) {
> > >                          force_rebuild = false;
> > >                          rebuild_sched_domains();
> > >                  }
> > > 
> > >          Still, we will need to confirm that cpuhp_tasks_frozen will be cleared
> > >          outside of the suspend/resume cycle.
> > > 
> > >      I think it's fine to use this variable from the cpuhp callback context only.
> > >      Which I think this cpuset workfn is considered an extension of.
> > > 
> > >      But you're right, I can't use cpuhp_tasks_frozen directly in
> > >      rebuild_root_domains() as I did in v1 because it doesn't get cleared after
> > >      calling the last _cpu_up().
> > > 
> > > That is what I suspect. So we can't use that cpuhp_tasks_frozen variable here
> > > in cpuset.
> > > 
> > >       force_rebuild will only be set after the last cpu
> > >      is brought online though - so this should happen once at the end.
> > > 
> > > Perhaps you can add another tracking variable for detecting if suspend/resume
> > > is in progress.
> > I think cpuhp_tasks_frozen is meant for that. All users who cared so far
> > belonged to the cpuhp callback. I think reading it from cpuset_hotplug_workfn()
> > is fine too as this function will only run as a consequence of the cpuhp
> > callback AFAICS. cpuset_cpu_active() takes care of not forcing a rebuild of
> > sched_domains until the last cpu becomes active - so the part of it being done
> > once at the end at resume is handled too.
> 
> Well we will have to add code to clear cpuhp_tasks_frozen at the end of
> resume then. We don't want to affect other callers unless we are sure that
> it won't affect them.

Actually I think since the cpuset_hotplug_workfn() is called later, there's
a chance to race with another cpuhp operation just after resume.

Anyway. I think we don't have to use this flag. But we'd have to better distill
the reasons of why we force_rebuild.

Your 2 new users are tripping me so far - do they handle errors where the shape
of cpuset changes? If yes, then we must take dl accounting update into
consideration for these errors.

Juri, I'd still would appreciate a confirmation from you that I'm not
understanding things completely wrong.

> 
> > 
> > It's just rebuild_sched_domains() will always assume it needs to clear and
> > rebuild deadline accounting - which is not true for suspend/resume case. But
> > now looking at other users of rebuild_sched_domains(), others might be getting
> > the hit too. For example rebuild_sched_domains_locked() is called on
> > update_relax_domain_level() which AFAIU should not impact dl accounting.
> > 
> > FWIW, I did capture a worst case scenario of 21ms because of
> > rebuild_root_domains().
> > 
> > /me thinks rebuild_root_domains() is a misleading name too as it just fixes
> > dl accounting but not rebuild the rd itself.
> > 
> > What makes sense to me now is to pass whether dl accounting requires updating
> > to rebuild_sched_domains() as an arg so that the caller can decide whether the
> > reason can affect dl accounting.
> > 
> > Or maybe pull rebuild_root_domains() out of the chain and let the caller call
> > it directly. And probably rename it to update_do_rd_accounting() or something.
> > 
> > I'll continue to dig more..
> 
> Looking forward to see that.

Another thought I had is maybe worth trying to optimize the rebuild root domain
process. Interestingly in my system there are no dl tasks but

	rebuilds_sched_domains()
	  cpuset_for_each_descendant_pre()
	    update_tasks_root_domain()
	      css_task_iter_next()
	        dl_add_task_root_domain()

seems to be going through every task in the hierarchy anyway which would
explain the slow down. We can have special variants to iterate through
hierarchies that ever seen a dl task attached to them and a special variant to
iterate through dl tasks only in a css - but I'm not sure if I'm brave enough
to go down this rabbit hole :D


Cheers

--
Qais Yousef
