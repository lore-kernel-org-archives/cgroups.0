From: Roman Gushchin <guro@fb.com>
Subject: Re: [v9 3/5] mm, oom: cgroup-aware OOM killer
Date: Tue, 3 Oct 2017 15:38:08 +0100
Message-ID: <20171003143808.GA531@castle.DHCP.thefacebook.com>
References: <20170927130936.8601-1-guro@fb.com>
 <20170927130936.8601-4-guro@fb.com>
 <20171003114848.gstdawonla2gmfio@dhcp22.suse.cz>
 <20171003123721.GA27919@castle.dhcp.TheFacebook.com>
 <20171003133623.hoskmd3fsh4t2phf@dhcp22.suse.cz>
 <20171003140841.GA29624@castle.DHCP.thefacebook.com>
 <20171003142246.xactdt7xddqdhvtu@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=zAtP7vKabVKP1HfXRu/xeh/sCWO1+yCNdykvTlLvOBE=;
 b=PZIYzw8/0+SfTjwn7eMyncCx5gk3fqLCoy095CIWc6z305D9Y5z0OR8MfCrIMsA3ntLq
 okEk8ZQFt12TxZQiGGu8DV9I+OYh+GsncsoNW/GeM3ZcibiWy+PNxHSKiKwwajOSK999
 rATZrmMmUHyo1wXKquthlghoQgJfRMEkRKo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zAtP7vKabVKP1HfXRu/xeh/sCWO1+yCNdykvTlLvOBE=;
 b=OXAcAtkTrnDX8b4ShQScVDbAcWP6w1mJI/Q+kQu3124rjZLKOa3cuEHIipZ/zVBeYw7gqA2dIHL3JUz8F+B/RLM6LGjslB1zANkL2GRKnr2ps7dbaRJJ20+RqjVImv2dskJpRkuuZEzROugzyHrfbvF24k0EXm7BwcPXhgdLvAo=
Content-Disposition: inline
In-Reply-To: <20171003142246.xactdt7xddqdhvtu@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 04:22:46PM +0200, Michal Hocko wrote:
> On Tue 03-10-17 15:08:41, Roman Gushchin wrote:
> > On Tue, Oct 03, 2017 at 03:36:23PM +0200, Michal Hocko wrote:
> [...]
> > > I guess we want to inherit the value on the memcg creation but I agree
> > > that enforcing parent setting is weird. I will think about it some more
> > > but I agree that it is saner to only enforce per memcg value.
> > 
> > I'm not against, but we should come up with a good explanation, why we're
> > inheriting it; or not inherit.
> 
> Inheriting sounds like a less surprising behavior. Once you opt in for
> oom_group you can expect that descendants are going to assume the same
> unless they explicitly state otherwise.
> 
> [...]
> > > > > > @@ -962,6 +968,48 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
> > > > > >  	__oom_kill_process(victim);
> > > > > >  }
> > > > > >  
> > > > > > +static int oom_kill_memcg_member(struct task_struct *task, void *unused)
> > > > > > +{
> > > > > > +	if (!tsk_is_oom_victim(task)) {
> > > > > 
> > > > > How can this happen?
> > > > 
> > > > We do start with killing the largest process, and then iterate over all tasks
> > > > in the cgroup. So, this check is required to avoid killing tasks which are
> > > > already in the termination process.
> > > 
> > > Do you mean we have tsk_is_oom_victim && MMF_OOM_SKIP == T?
> > 
> > No, just tsk_is_oom_victim. We're are killing the biggest task, and then _all_
> > tasks. This is a way to skip the biggest task, and do not kill it again.
> 
> OK, I have missed that part. Why are we doing that actually? Why don't
> we simply do 
> 	/* If oom_group flag is set, kill all belonging tasks */
> 	if (mem_cgroup_oom_group(oc->chosen_memcg))
> 		mem_cgroup_scan_tasks(oc->chosen_memcg, oom_kill_memcg_member,
> 				      NULL);
> 
> we are going to kill all the tasks anyway.

Well, the idea behind was that killing the biggest process give us better
chances to get out of global memory shortage and guarantee forward progress.
I can drop it, if it considered to be excessive.
