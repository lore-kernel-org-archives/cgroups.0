From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 16:44:20 +0200
Message-ID: <20220728144420.GA27407@blackbody.suse.cz>
References: <20220728005815.1715522-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659019461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DUx+MWMoJx3rj7YLGpNF515BhD3DfyJeCTB/nJKgRCk=;
        b=MHJHRYEZfylLqaLT6NoEWTI/QBRAymRiDK0CUqh5mdBBeYtTx6qCLSiiiJlKDbXH2CtuML
        ELg0DUMKWzPeLpTK+ErUV7mFx6fxMZpMc7rnXtt9XGWtBGIt5ltP3AO/QF24jIC/h4u+UH
        iAHGylfhM2L1Jq106PrL+B58hQ2xPus=
Content-Disposition: inline
In-Reply-To: <20220728005815.1715522-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Wed, Jul 27, 2022 at 08:58:14PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> It was found that any change to the current cpuset hierarchy may reset
> the cpus_allowed list of the tasks in the affected cpusets to the
> default cpuset value even if those tasks have cpus affinity explicitly
> set by the users before.

I'm surprised this went so long unnoticed / unreported.

Could it be users relied on that implicit affinity reset?

> That is especially easy to trigger under a cgroup v2 environment where
> writing "+cpuset" to the root cgroup's cgroup.subtree_control file
> will reset the cpus affinity of all the processes in the system.

This should apply only to tasks that were extracted out of the root
cgroup, no? (OK, those are all processes practically.)

(Even without your second patch, the scope should be limited because of
src_cset==dst_cset check in cgroup_migrate_prepare_dst().)

> That is especially problematic in a nohz_full environment where the
> tasks running in the nohz_full CPUs usually have their cpus affinity
> explicitly set and will behave incorrectly if cpus affinity changes.

One could also argue that for such processes, cgroup hierarchy should be
first configured and only then they start and set own affinity.

> Fix this problem by adding a flag in the task structure to indicate that
> a task has their cpus affinity explicitly set before and make cpuset
> code not to change their cpus_allowed list unless the user chosen cpu
> list is no longer a subset of the cpus_allowed list of the cpuset itself.

I'm uneasy with the occasional revert of this flag, i.e. the task who
set their affinity would sometimes have it overwritten and sometimes
not (which might have been relied on, especially with writes into
cpuset.cpus).
(But I have no better answer than the counter-argument above since
there's no easier way to detect the implicit migrations.)

Also, is there similar effect with memory binding?

Thanks,
Michal
