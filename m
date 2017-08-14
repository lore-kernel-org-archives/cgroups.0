From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v4 2/4] mm, oom: cgroup-aware OOM killer
Date: Mon, 14 Aug 2017 13:03:49 +0100
Message-ID: <20170814120349.GA24393@castle.DHCP.thefacebook.com>
References: <20170726132718.14806-1-guro@fb.com>
 <20170726132718.14806-3-guro@fb.com>
 <20170801145435.GN15774@dhcp22.suse.cz>
 <20170801152548.GA29502@castle.dhcp.TheFacebook.com>
 <alpine.DEB.2.10.1708081559001.54505@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Jd8RaR7pCJua3FdphOExLlnJ6eaZL+PlUzfATjfb+1E=;
 b=LqbXHWIFo9Z8s0sz/Vo4FBNX0rG1drJWRRz/skZIk4SJCm7CSulMruJY9gksPf0UCbrU
 PulvRqcYnq1oom2rMTbvGRJCJbmAxz7ZG1NJQy8NZkvqbRNk3TQArJEEVXr9xcLZBdHA
 yy4ASn9pj0RmKW35cuSuHrJENxjxg0+wGRM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Jd8RaR7pCJua3FdphOExLlnJ6eaZL+PlUzfATjfb+1E=;
 b=GZkw+eHLxcSRvQlG/MnC0ND6LAvpDu/xkbU2aq4yHWcY619LfP9u5AME8IbFXMa69xqgIq3UBq5QyzgFdx20tS1V+PcxwKsaDb+YXsMW0H+Fq+5pkL4Dv7/fSjmgTAGQaXRK+k9yXgNUSaMvq73v24apQP77Bm9KRiHc/bQHMVE=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1708081559001.54505-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 08, 2017 at 04:06:38PM -0700, David Rientjes wrote:
> On Tue, 1 Aug 2017, Roman Gushchin wrote:
> 
> > > To the rest of the patch. I have to say I do not quite like how it is
> > > implemented. I was hoping for something much simpler which would hook
> > > into oom_evaluate_task. If a task belongs to a memcg with kill-all flag
> > > then we would update the cumulative memcg badness (more specifically the
> > > badness of the topmost parent with kill-all flag). Memcg will then
> > > compete with existing self contained tasks (oom_badness will have to
> > > tell whether points belong to a task or a memcg to allow the caller to
> > > deal with it). But it shouldn't be much more complex than that.
> > 
> > I'm not sure, it will be any simpler. Basically I'm doing the same:
> > the difference is that you want to iterate over tasks and for each
> > task traverse the memcg tree, update per-cgroup oom score and find
> > the corresponding memcg(s) with the kill-all flag. I'm doing the opposite:
> > traverse the cgroup tree, and for each leaf cgroup iterate over processes.
> > 
> > Also, please note, that even without the kill-all flag the decision is made
> > on per-cgroup level (except tasks in the root cgroup).
> > 
> 
> I think your implementation is preferred and is actually quite simple to 
> follow, and I would encourage you to follow through with it.  It has a 
> similar implementation to what we have done for years to kill a process 
> from a leaf memcg.

Hi David!

Thank you for the support.

> 
> I did notice that oom_kill_memcg_victim() calls directly into 
> __oom_kill_process(), however, so we lack the traditional oom killer 
> output that shows memcg usage and potential tasklist.  I think we should 
> still be dumping this information to the kernel log so that we can see a 
> breakdown of charged memory.

I think the existing output is too verbose for the case, when we kill
a cgroup with many processes inside. But I absolutely agree, that we need
some debug output, I'll add it in v5.

Thanks!
