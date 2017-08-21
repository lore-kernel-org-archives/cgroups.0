From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v5 2/4] mm, oom: cgroup-aware OOM killer
Date: Mon, 21 Aug 2017 10:46:56 +0100
Message-ID: <20170821094656.GA13899@castle.dhcp.TheFacebook.com>
References: <20170814183213.12319-1-guro@fb.com>
 <20170814183213.12319-3-guro@fb.com>
 <alpine.DEB.2.10.1708141532300.63207@chino.kir.corp.google.com>
 <20170815121558.GA15892@castle.dhcp.TheFacebook.com>
 <alpine.DEB.2.10.1708151435290.104516@chino.kir.corp.google.com>
 <20170816154325.GB29131@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.10.1708201741330.117182@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=mz6JPRcP5oV4XrqGeE2Z32bH17NNW6jJhp7fWbp4rV8=;
 b=Up6casz6pcA9G5T7zcrikffZu486NTWG9KPeKYTKgLXPpPUgH6ILrpg3v/62ccezBv0s
 3zjVxQWvpkZm9WLm79dK2aKUjEeXndqZyP4QTlJsOKadhPWDsEkkSK/KbTkk7qUJaXRw
 ZsX3jYoA0vfQv+ZRfz6G85Xx28pS6gVU2ik= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mz6JPRcP5oV4XrqGeE2Z32bH17NNW6jJhp7fWbp4rV8=;
 b=Y65Ykide4JYcu3pS2oFEAaxNVViGxQHtDO+lsuI2ZV23DvaYhiuuM0eru/qkAa+f5QpZlMB+ODwVVvfbS3coeTtxBwS785i8buLWJtmg+UIGMrPjC5EmlwW/0Zupp/wBOZ0x2imfWW5ibXGVHwX+E4SIxKo8rRzuDkmiCZTiZ7E=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1708201741330.117182-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Aug 20, 2017 at 05:50:27PM -0700, David Rientjes wrote:
> On Wed, 16 Aug 2017, Roman Gushchin wrote:
> 
> > It's natural to expect that inside a container there are their own sshd,
> > "activity manager" or some other stuff, which can play with oom_score_adj.
> > If it can override the upper cgroup-level settings, the whole delegation model
> > is broken.
> > 
> 
> I don't think any delegation model related to core cgroups or memory 
> cgroup is broken, I think it's based on how memory.oom_kill_all_tasks is 
> defined.  It could very well behave as memory.oom_kill_all_eligible_tasks 
> when enacted upon.
> 
> > You can think about the oom_kill_all_tasks like the panic_on_oom,
> > but on a cgroup level. It should _guarantee_, that in case of oom
> > the whole cgroup will be destroyed completely, and will not remain
> > in a non-consistent state.
> > 
> 
> Only CAP_SYS_ADMIN has this ability to set /proc/pid/oom_score_adj to

CAP_SYS_RESOURCE

> OOM_SCORE_ADJ_MIN, so it preserves the ability to change that setting, if 
> needed, when it sets memory.oom_kill_all_tasks.  If a user gains 
> permissions to change memory.oom_kill_all_tasks, I disagree it should 
> override the CAP_SYS_ADMIN setting of /proc/pid/oom_score_adj.
> 
> I would prefer not to exclude oom disabled processes to their own sibling 
> cgroups because they would require their own reservation with cgroup v2 
> and it makes the single hierarchy model much more difficult to arrange 
> alongside cpusets, for example.
> 
> > The model you're describing is based on a trust given to these oom-unkillable
> > processes on system level. But we can't really trust some unknown processes
> > inside a cgroup that they will be able to do some useful work and finish
> > in a reasonable time; especially in case of a global memory shortage.
> 
> Yes, we prefer to panic instead of sshd, for example, being oom killed.
> We trust that sshd, as well as our own activity manager and security 
> daemons are trusted to do useful work and that we never want the kernel to 
> do this.  I'm not sure why you are describing processes that CAP_SYS_ADMIN 
> has set to be oom disabled as unknown processes.
> 
> I'd be interested in hearing the opinions of others related to a per-memcg 
> knob being allowed to override the setting of the sysadmin.

Sure, me too.

Thanks!
