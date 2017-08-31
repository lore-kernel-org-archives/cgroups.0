From: Roman Gushchin <guro@fb.com>
Subject: Re: [v6 2/4] mm, oom: cgroup-aware OOM killer
Date: Thu, 31 Aug 2017 14:34:23 +0100
Message-ID: <20170831133423.GA30125@castle.DHCP.thefacebook.com>
References: <20170823165201.24086-3-guro@fb.com>
 <20170824114706.GG5943@dhcp22.suse.cz>
 <20170824122846.GA15916@castle.DHCP.thefacebook.com>
 <20170824125811.GK5943@dhcp22.suse.cz>
 <20170824135842.GA21167@castle.DHCP.thefacebook.com>
 <20170824141336.GP5943@dhcp22.suse.cz>
 <20170824145801.GA23457@castle.DHCP.thefacebook.com>
 <20170825081402.GG25498@dhcp22.suse.cz>
 <20170830112240.GA4751@castle.dhcp.TheFacebook.com>
 <alpine.DEB.2.10.1708301349130.79465@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=NgVoWEzqIy9ckUcLG3GvQCsSKmmRDrkreArmImEoLFM=;
 b=Bb2xtJ+zDdj8+2Xj275Q4s5QUFNMX8HYlHSWzIp/9hqQgDDJZPxzO7pHVvpNoUkkruyS
 GW41k4lAmLwwPVgT/4fwwswV99sZdoVzjCdSWvtWmEJjVQRnoWhiNtYXM3G+esgInFkN
 g3vNn8YGA2bxJk3qS274jU3W/fk/f/R0594= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NgVoWEzqIy9ckUcLG3GvQCsSKmmRDrkreArmImEoLFM=;
 b=LdN0WpgHMxzP+AFWhcR45p1foDgQ3f6JJv+x/NeylwmMgZSmt53QncNcXTojH7432qk8prvzoebinOa7H31vOp+YrO9+N9rkD2B9HYgWH3mi9Pgc0S9Q24cj5O9dqB6DvISjrm14dwOj1lpNCsHfWB0LspzqatqSodnMGMCDoj4=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1708301349130.79465@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Aug 30, 2017 at 01:56:22PM -0700, David Rientjes wrote:
> On Wed, 30 Aug 2017, Roman Gushchin wrote:
> 
> > I've spent some time to implement such a version.
> > 
> > It really became shorter and more existing code were reused,
> > howewer I've met a couple of serious issues:
> > 
> > 1) Simple summing of per-task oom_score doesn't make sense.
> >    First, we calculate oom_score per-task, while should sum per-process values,
> >    or, better, per-mm struct. We can take only threa-group leader's score
> >    into account, but it's also not 100% accurate.
> >    And, again, we have a question what to do with per-task oom_score_adj,
> >    if we don't task the task's oom_score into account.
> > 
> >    Using memcg stats still looks to me as a more accurate and consistent
> >    way of estimating memcg memory footprint.
> > 
> 
> The patchset is introducing a new methodology for selecting oom victims so 
> you can define how cgroups are compared vs other cgroups with your own 
> "badness" calculation.  I think your implementation based heavily on anon 
> and unevictable lrus and unreclaimable slab is fine and you can describe 
> that detail in the documentation (along with the caveat that it is only 
> calculated for nodes in the allocation's mempolicy).  With 
> memory.oom_priority, the user has full ability to change that selection.  
> Process selection heuristics have changed over time themselves, it's not 
> something that must be backwards compatibile and trying to sum the usage 
> from each of the cgroup's mm_struct's and respect oom_score_adj is 
> unnecessarily complex.

I agree.

So, it looks to me that we're close to an acceptable version,
and the only remaining question is the default behavior
(when oom_group is not set).

Michal suggests to ignore non-oom_group memcgs, and compare tasks with
memcgs with oom_group set. This makes the whole thing completely opt-in,
but then we probably need another knob (or value) to select between
"select memcg, kill biggest task" and "select memcg, kill all tasks".
Also, as the whole thing is based on comparison between processes and
memcgs, we probably need oom_priority for processes.
I'm not necessary against this options, but I do worry about the complexity
of resulting interface.

In my implementation we always select a victim memcg first (or a task
in root memcg), and then kill the biggest task inside.
It actually changes the victim selection policy. By doing this
we achieve per-memcg fairness, which makes sense in a containerized
environment.
I believe it's acceptable, but I can also add a cgroup v2 mount option
to completely revert to the per-process OOM killer for those users, who
for some reasons depend on the existing victim selection policy.

Any thoughts/objections?

Thanks!

Roman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
