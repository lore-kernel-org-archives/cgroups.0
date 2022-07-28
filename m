From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 07:23:07 -1000
Message-ID: <YuLF+xXaCzwWi2BR@slm.duckdns.org>
References: <20220728005815.1715522-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=N+EDZeN9hOjgggv+GakuBGOt5cAU+R6TAmQfKefuGy4=;
        b=Emg3DdK7LSA+NPGtwUNvKOne+VsyeeyNXbQvyE/VGpLz3/txaN1mHFE01gAsuDkCbB
         2K7lXPS/nzQZA2KQw6vB/AgSjSFuh5/PtFjUpNz/VSASorhlSmLD2FS3h2HbfMkcTDG2
         fxBFMM8xJyVClKV9xW3aMewFxSDcY7TeKGj4/W3nEqhO62yY+c9uMYLUim1v3S2aZWn2
         iguQ331j5j8wWHjY9b26yu1dsHepHq14knp9Lp2mh3CssireX5EasKZP+fh+IoToiO9d
         uOOzEZXLpe1nmRc16BoqGuojFL+81jyLgTuwt2FYlVdkxONSwxluMiO3xqYUjVk9MEFQ
         +7pQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220728005815.1715522-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jul 27, 2022 at 08:58:14PM -0400, Waiman Long wrote:
> It was found that any change to the current cpuset hierarchy may reset
> the cpus_allowed list of the tasks in the affected cpusets to the
> default cpuset value even if those tasks have cpus affinity explicitly
> set by the users before. That is especially easy to trigger under a
> cgroup v2 environment where writing "+cpuset" to the root cgroup's
> cgroup.subtree_control file will reset the cpus affinity of all the
> processes in the system.
> 
> That is especially problematic in a nohz_full environment where the
> tasks running in the nohz_full CPUs usually have their cpus affinity
> explicitly set and will behave incorrectly if cpus affinity changes.
> 
> Fix this problem by adding a flag in the task structure to indicate that
> a task has their cpus affinity explicitly set before and make cpuset
> code not to change their cpus_allowed list unless the user chosen cpu
> list is no longer a subset of the cpus_allowed list of the cpuset itself.
> 
> With that change in place, it was verified that tasks that have its
> cpus affinity explicitly set will not be affected by changes made to
> the v2 cgroup.subtree_control files.

I think the underlying cause here is cpuset overwriting the cpumask the user
configured but that's a longer discussion.

> +/*
> + * Don't change the cpus_allowed list if cpus affinity has been explicitly
> + * set before unless the current cpu list is not a subset of the new cpu list.
> + */
> +static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
> +				       const struct cpumask *new_mask)
> +{
> +	if (p->cpus_affinity_set && cpumask_subset(p->cpus_ptr, new_mask))
> +		return 0;
> +
> +	p->cpus_affinity_set = 0;
> +	return set_cpus_allowed_ptr(p, new_mask);
> +}

I wonder whether the more predictable behavior would be always not resetting
the cpumask if it's a subset of the new_mask. Also, shouldn't this check
p->cpus_mask instead of p->cpus_ptr?

Thanks.

-- 
tejun
