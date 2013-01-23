From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Date: Tue, 22 Jan 2013 17:02:26 -0800
Message-ID: <20130123010226.GF5359@htj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
 <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
 <50FD3123.6090003@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=fj1SgnXa1fq3t0VUcJRjkylj/gUEBGhKdHZFwHNYFDY=;
        b=jeX/yU5sNUXZkWlTqAnzhgDEo7r8Jx539g1C61jhC7xbm+zAKIbGP7GxEXcSx8A6N4
         yHGUMBxc4kWMyXjCuofQA8rhtviFsPTYxZsWjNQmGqtAmuSzSGy+9e+mS/UQXt/AHwKS
         wV64JQivZWpdnCFI5CeU5rO6LL6QQ2AViE/V1XFgLFe45G31ZDDA5+I0TehbUui1OYRV
         UIwTOl+bOP8hY8yOks6ul5vg+py6rdoJArPygBkbPQoJGnxLIVC2b8ySPUUKj4bQNiqZ
         gchRBI02g4u79/lfQyE3LrFzuKCPBCSML7myfnIz7aRrAIvWY2deZKlFDumGqrMmHE09
         mhYA==
Content-Disposition: inline
In-Reply-To: <50FD3123.6090003-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Jan 21, 2013 at 04:14:27PM +0400, Glauber Costa wrote:
> > Android userspace is currently using both cpu and cpuacct, and not
> > co-mounting them.  They are used for fundamentally different uses such
> > that creating a single hierarchy for both of them while maintaining
> > the existing behavior is not possible.
> > 
> > We use the cpu cgroup primarily as a priority container.  A simple
> > view is that each thread is assigned to a foreground cgroup when it is
> > user-visible, and a background cgroup when it is not.  The foreground
> > cgroup is assigned a significantly higher cpu.shares value such that
> > when each group is fully loaded the background group will get 5% and
> > the foreground group will get 95%.
> > 
> > We use the cpuacct cgroup to measure cpu usage per uid, primarily to
> > estimate one cause of battery usage.  Each uid gets a cgroup, and when
> > spawning a task for a new uid we put it in the appropriate cgroup.
> 
> As we are all in a way sons of Linus the Great, the fact that you have
> this usecase should be by itself a reason for us not to deprecate it.
> 
> I still view this, however, as a not common use case. And from the
> scheduler PoV, we still have all the duplicate hierarchy walks. So
> assuming we would carry on all the changes in this patchset, except the
> deprecation, would it be okay for you?
> 
> This way we could take steps to make sure the scheduler codepaths for
> cpuacct are not taking during normal comounted operation, and you could
> still have your setup unchanged.
> 
> Tejun, any words here?

I think the only thing we can do is keeping cpuacct around.  We can
still optimize comounted cpu and cpuacct as the usual case.  That
said, I'd really like to avoid growing new use cases for separate
hierarchies for cpu and cpuacct (well, any controller actually).
Having multiple hierarchies is fundamentally broken in that we can't
say whether a given resource belongs to certain cgroup independently
from the current task, and we're definitnely moving towards unified
hierarchy.

We are not gonna break multiple hierarchies but won't go extra miles
to optimize or enable new features on it, so it would be best to move
away from it.

Maybe we can generate a warning message on separate mounts?

Thanks.

-- 
tejun
