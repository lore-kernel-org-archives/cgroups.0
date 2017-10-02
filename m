From: Roman Gushchin <guro@fb.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 2 Oct 2017 13:47:12 +0100
Message-ID: <20171002124712.GA17638@castle.DHCP.thefacebook.com>
References: <20170926121300.GB23139@castle.dhcp.TheFacebook.com>
 <20170926133040.uupv3ibkt3jtbotf@dhcp22.suse.cz>
 <20170926172610.GA26694@cmpxchg.org>
 <CAAAKZws88uF2dVrXwRV0V6AH5X68rWy7AfJxTxYjpuiyiNJFWA@mail.gmail.com>
 <20170927074319.o3k26kja43rfqmvb@dhcp22.suse.cz>
 <CAAAKZws2CFExeg6A9AzrGjiHnFHU1h2xdk6J5Jw2kqxy=V+_YQ@mail.gmail.com>
 <20170927162300.GA5623@castle.DHCP.thefacebook.com>
 <CAAAKZwtApj-FgRc2V77nEb3BUd97Rwhgf-b-k0zhf1u+Y4fqxA@mail.gmail.com>
 <CALvZod7iaOEeGmDJA0cZvJWpuzc-hMRn3PG2cfzcMniJtAjKqA@mail.gmail.com>
 <20171002122434.llbaarb6yw3o3mx3@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=GrhcxVQiQinWYPTGlii5TKUZhxs6OyWiBqajeNvZx3g=;
 b=kT0O/nRRdF574NOi6jF15I+xKGtTeJHopn/IPlyKsvoQBtyAuYxoAAgEEQvki5g/QXuS
 VUwKzDH63CfK0+JF59MWnRmfHeWjGwhP4g4PI8BTotAv8qqyhwDo6nWTxgyDTKNUOcWg
 h4dw8Bcc6B7iiivWd5Vd5ettAQBhpbV4wiE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GrhcxVQiQinWYPTGlii5TKUZhxs6OyWiBqajeNvZx3g=;
 b=GwYkI/40fAWeCksZK9j15fbaj2kHBcVsZ/r1NsaDA1cZqjvlzpzRXEoh5lbIiialO1HUxAZBjU8RoQ5zHd2i1IOikAd/BWdEXirgUlPgkUmZst0DYjXUHCzkMnA78yBtWfmxDMmmHSsrRGnJG9gspPG8i5x24JyUYiOlvRBoTNo=
Content-Disposition: inline
In-Reply-To: <20171002122434.llbaarb6yw3o3mx3@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Tim Hockin <thockin@hockin.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Oct 02, 2017 at 02:24:34PM +0200, Michal Hocko wrote:
> On Sun 01-10-17 16:29:48, Shakeel Butt wrote:
> > >
> > > Going back to Michal's example, say the user configured the following:
> > >
> > >        root
> > >       /    \
> > >      A      D
> > >     / \
> > >    B   C
> > >
> > > A global OOM event happens and we find this:
> > > - A > D
> > > - B, C, D are oomgroups
> > >
> > > What the user is telling us is that B, C, and D are compound memory
> > > consumers. They cannot be divided into their task parts from a memory
> > > point of view.
> > >
> > > However, the user doesn't say the same for A: the A subtree summarizes
> > > and controls aggregate consumption of B and C, but without groupoom
> > > set on A, the user says that A is in fact divisible into independent
> > > memory consumers B and C.
> > >
> > > If we don't have to kill all of A, but we'd have to kill all of D,
> > > does it make sense to compare the two?
> > >
> > 
> > I think Tim has given very clear explanation why comparing A & D makes
> > perfect sense. However I think the above example, a single user system
> > where a user has designed and created the whole hierarchy and then
> > attaches different jobs/applications to different nodes in this
> > hierarchy, is also a valid scenario.
> 
> Yes and nobody is disputing that, really. I guess the main disconnect
> here is that different people want to have more detailed control over
> the victim selection while the patchset tries to handle the most
> simplistic scenario when a no userspace control over the selection is
> required. And I would claim that this will be a last majority of setups
> and we should address it first.
> 
> A more fine grained control needs some more thinking to come up with a
> sensible and long term sustainable API. Just look back and see at the
> oom_score_adj story and how it ended up unusable in the end (well apart
> from never/always kill corner cases). Let's not repeat that again now.
> 
> I strongly believe that we can come up with something - be it priority
> based, BFP based or module based selection. But let's start simple with
> the most basic scenario first with a most sensible semantic implemented.

Totally agree.

> I believe the latest version (v9) looks sensible from the semantic point
> of view and we should focus on making it into a mergeable shape.

The only thing is that after some additional thinking I don't think anymore
that implicit propagation of oom_group is a good idea.

Let me explain: assume we have memcg A with memory.max and memory.oom_group
set, and nested memcg A/B with memory.max set. Let's imagine we have an OOM
event if A/B. What is an expected system behavior?
We have OOM scoped to A/B, and any action should be also scoped to A/B.
We really shouldn't touch processes which are not belonging to A/B.
That means we should either kill the biggest process in A/B, either all
processes in A/B. It's natural to make A/B/memory.oom_group responsible
for this decision. It's strange to make the depend on A/memory.oom_group, IMO.
It really makes no sense, and makes oom_group knob really hard to describe.

Also, after some off-list discussion, we've realized that memory.oom_knob
should be delegatable. The workload should have control over it to express
dependency between processes.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
