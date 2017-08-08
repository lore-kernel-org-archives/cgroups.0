From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v4 4/4] mm, oom, docs: describe the cgroup-aware OOM killer
Date: Tue, 8 Aug 2017 16:24:32 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708081615110.54505@chino.kir.corp.google.com>
References: <20170726132718.14806-1-guro@fb.com> <20170726132718.14806-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=MvugsoIuS7SQaN6qv2ZajZEY8FHTg34ntA70CQdT2gA=;
        b=vyT0H155HLPqjxK9YiYvjAdWxQMVaFKixIH/8UpFErAMBr5hQZv4yFY55MZRDPh8H1
         C1hzYTQDQDoutPqcoKoEad6a54iQ1Rs3yBpEMYDHBWGWNapT8bvGOhnaAbkncYi/m5lT
         qAH9BY0zmssjNvh3Xxx6bInM1MbBPMxxlFUaUSqhks7UDqok4/voTfg3gXqmgGyLOyUJ
         7hCiczV26aRevWB/wCBh/XQ5ocnT+i1+JZYJWX2HRTQ3NXA22ima1+Zt/SF6zm81AbjY
         TnzfexZfK5XZBJFY8NA/pcA5TGE+FYVAXqT05+aqELDaQaICUoB9Luxy99lZje2ZtUNh
         PTBw==
In-Reply-To: <20170726132718.14806-5-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 26 Jul 2017, Roman Gushchin wrote:

> +Cgroup-aware OOM Killer
> +~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Cgroup v2 memory controller implements a cgroup-aware OOM killer.
> +It means that it treats memory cgroups as first class OOM entities.
> +
> +Under OOM conditions the memory controller tries to make the best
> +choise of a victim, hierarchically looking for the largest memory
> +consumer. By default, it will look for the biggest task in the
> +biggest leaf cgroup.
> +
> +Be default, all cgroups have oom_priority 0, and OOM killer will
> +chose the largest cgroup recursively on each level. For non-root
> +cgroups it's possible to change the oom_priority, and it will cause
> +the OOM killer to look athe the priority value first, and compare
> +sizes only of cgroups with equal priority.
> +
> +But a user can change this behavior by enabling the per-cgroup
> +oom_kill_all_tasks option. If set, it causes the OOM killer treat
> +the whole cgroup as an indivisible memory consumer. In case if it's
> +selected as on OOM victim, all belonging tasks will be killed.
> +
> +Tasks in the root cgroup are treated as independent memory consumers,
> +and are compared with other memory consumers (e.g. leaf cgroups).
> +The root cgroup doesn't support the oom_kill_all_tasks feature.
> +
> +This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
> +the memory controller considers only cgroups belonging to the sub-tree
> +of the OOM'ing cgroup.
> +
>  IO
>  --

Thanks very much for following through with this.

As described in http://marc.info/?l=linux-kernel&m=149980660611610 this is 
very similar to what we do for priority based oom killing.

I'm wondering your comments on extending it one step further, however: 
include process priority as part of the selection rather than simply memcg 
priority.

memory.oom_priority will dictate which memcg the kill will originate from, 
but processes have no ability to specify that they should actually be 
killed as opposed to a leaf memcg.  I'm not sure how important this is for 
your usecase, but we have found it useful to be able to specify process 
priority as part of the decisionmaking.

At each level of consideration, we simply kill a process with lower 
/proc/pid/oom_priority if there are no memcgs with a lower 
memory.oom_priority.  This allows us to define the exact process that will 
be oom killed, absent oom_kill_all_tasks, and not require that the process 
be attached to leaf memcg.  Most notably these are processes that are best 
effort: stats collection, logging, etc.

Do you think it would be helpful to introduce per-process oom priority as 
well?
