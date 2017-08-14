From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v5 1/4] mm, oom: refactor the oom_kill_process() function
Date: Mon, 14 Aug 2017 15:00:43 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708141500260.129178@chino.kir.corp.google.com>
References: <20170814183213.12319-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=XZQL66ItogYmagjrsO67YtUTo220QpAHSQvQJcsJeuo=;
        b=cZQTld+aLnS738ILYqcqWg5U8Auu7W28i0JdgkqmbKLwDLq9QhgO0eXL4+C0JDNRs8
         eFwjHqdr8+jtRCMRTq4ki4BH1Bxy4Rsc4VHJFr292gqQGJcvmkA1vNPqu2nXOsraP80L
         397/jsrpFR8ExjGbQANYZePbCW0wrVaCWqTYB9Ty8im7p0t7HuQk9RCP4H3U8A1IgrVi
         4bUOJAJJKavcrlWSBZ22yaL10m6yXfCJ3IOGOrwqx0DMGi58dOYpwV9Icf7YHAS8lnLA
         HppHuJrJu8HPhy37SeUFE834Qg65FzqUF7j2uQqe6rOJaW0zURM9M4lMLsj+NgcF0YT6
         34dw==
In-Reply-To: <20170814183213.12319-1-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 14 Aug 2017, Roman Gushchin wrote:

> The oom_kill_process() function consists of two logical parts:
> the first one is responsible for considering task's children as
> a potential victim and printing the debug information.
> The second half is responsible for sending SIGKILL to all
> tasks sharing the mm struct with the given victim.
> 
> This commit splits the oom_kill_process() function with
> an intention to re-use the the second half: __oom_kill_process().
> 
> The cgroup-aware OOM killer will kill multiple tasks
> belonging to the victim cgroup. We don't need to print
> the debug information for the each task, as well as play
> with task selection (considering task's children),
> so we can't use the existing oom_kill_process().
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
