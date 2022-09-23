From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH v1] mm: oom: introduce cpuset oom
Date: Fri, 23 Sep 2022 09:45:06 +0200
Message-ID: <Yy1kAnvowZh4ViP4@dhcp22.suse.cz>
References: <20220921064710.89663-1-ligang.bdlg@bytedance.com>
 <18621b07-256b-7da1-885a-c96dfc8244b6@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663919106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6f+HZS/DDCke26XP72uI0aj2polwGJmTgO/VcYRdyN4=;
        b=c11PTcBSOgXLHWwqQ+O14Z0b4UPZhBejONfGft2EFpfzFF/ME9Z8NK05ejOJBgvTDYj5qh
        unyh7cdLOmGV+gzZQb6orIAz8gj4mabsZIz7V5gsPMeEwc1+RCM407mt48ooiasXkayqko
        T6RRBjDTZ5L8s6G+OuJkFE3jsFYMhrw=
Content-Disposition: inline
In-Reply-To: <18621b07-256b-7da1-885a-c96dfc8244b6-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 22-09-22 12:18:04, David Rientjes wrote:
> On Wed, 21 Sep 2022, Gang Li wrote:
> 
> > cpuset confine processes to processor and memory node subsets.
> > When a process in cpuset triggers oom, it may kill a completely
> > irrelevant process on another numa node, which will not release any
> > memory for this cpuset.
> > 
> > It seems that `CONSTRAINT_CPUSET` is not really doing much these
> > days. Using CONSTRAINT_CPUSET, we can easily achieve node aware oom
> > killing by selecting victim from the cpuset which triggers oom.
> > 
> > Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > Signed-off-by: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Hmm, is this the right approach?
> 
> If a cpuset results in a oom condition, is there a reason why we'd need to 
> find a process from within that cpuset to kill?  I think the idea is to 
> free memory on the oom set of nodes (cpuset.mems) and that can happen by 
> killing a process that is not a member of this cpuset.

I would argue that the current cpuset should be considered first because
chances are that it will already have the biggest memory consumption
from the constrained NUMA nodes. At least that would be the case when
cpusets are used to partition the system into exclusive NUMA domains.

Situation gets more complex with overlapping nodemasks in different
cpusets but I believe our existing semantic sucks already for those
usecases already because we just shoot a random process with an unknown
amount of memory allocated from the constrained nodemask.

This new semantic is not much worse. We could find a real oom victim
under a different cpuset but the current semantic could as well kill a
large memory consumer with a tiny footprint on the target node. With the
cpuset view the potential damage is more targeted in many cases.

> I understand the challenges of creating a NUMA aware oom killer to target 
> memory that is actually resident on an oom node, but this approach doesn't 
> seem right and could actually lead to pathological cases where a small 
> process trying to fork in an otherwise empty cpuset is repeatedly oom 
> killing when we'd actually prefer to kill a single large process.

Yeah, that is possible and something to consider. One way to go about
that is to make the selection from all cpusets with an overlap with the
requested nodemask (probably with a preference to more constrained
ones). In any case let's keep in mind that this is a mere heuristic. We
just need to kill some process, it is not really feasible to aim for the
best selection. We should just try to reduce the harm. Our exisiting
cpuset based OOM is effectivelly random without any clear relation to
cpusets so I would be open to experimenting in this area.
-- 
Michal Hocko
SUSE Labs
