From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [PATCH 0/6] sched/deadline: cpuset: Rework DEADLINE bandwidth
 restoration
Date: Tue, 4 Apr 2023 21:09:09 +0100
Message-ID: <20230404200909.krwq36nx36ktm2sh@airbuntu>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1680638951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iHa2YuwGHdarAAiMk1og5R7L6o7idQvUnJX2z9eCeX4=;
        b=suhopf6Duc7KaYoyMZ4+D6ZLGbwrP5YpWGxvE6qzST17brhCVvVgvh0BhBnIeK89jy
         Azqz+miC0BBFkvUmhVnUOA0Q8m6QtHVrqsAlgwZQII75k0bHcHAPFQN2evjlRLmIqofl
         eUI96Bo8z5GlOkNLhKLLtA4W40vQ4tCDvno2MaGTbm7Rk6RXfTTjk6PWbzd0WUqgV8Nz
         5DTa/xhKTSCkXbrh9CsXi7qc5nJI59qwfYPE+oj5O/uTU/BpVZLxdLa5KAjl4WBtqxGV
         kf1eJF6FwXSywiLqrG68dKYSdbyBjyv2ZNMBhyhjJXIgvS6pifZ55Ae/AmVOxGbhQhfP
         s/wA==
Content-Disposition: inline
In-Reply-To: <20230329125558.255239-1-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AyHOaXKfS9Lw@public.gmane.org>

On 03/29/23 14:55, Juri Lelli wrote:
> Qais reported [1] that iterating over all tasks when rebuilding root
> domains for finding out which ones are DEADLINE and need their bandwidth
> correctly restored on such root domains can be a costly operation (10+
> ms delays on suspend-resume). He proposed we skip rebuilding root
> domains for certain operations, but that approach seemed arch specific
> and possibly prone to errors, as paths that ultimately trigger a rebuild
> might be quite convoluted (thanks Qais for spending time on this!).
> 
> To fix the problem
> 
>  01/06 - Rename functions deadline with DEADLINE accounting (cleanup
>          suggested by Qais) - no functional change
>  02/06 - Bring back cpuset_mutex (so that we have write access to cpusets
>          from scheduler operations - and we also fix some problems
>          associated to percpu_cpuset_rwsem)
>  03/06 - Keep track of the number of DEADLINE tasks belonging to each cpuset
>  04/06 - Create DL BW alloc, free & check overflow interface for bulk
>          bandwidth allocation/removal - no functional change 
>  05/06 - Fix bandwidth allocation handling for cgroup operation
>          involving multiple tasks
>  06/06 - Use this information to only perform the costly iteration if
>          DEADLINE tasks are actually present in the cpuset for which a
>          corresponding root domain is being rebuilt
> 
> With respect to the RFC posting [2]
> 
>  1 - rename DEADLINE bandwidth accounting functions - Qais
>  2 - call inc/dec_dl_tasks_cs from switched_{to,from}_dl - Qais
>  3 - fix DEADLINE bandwidth allocation with multiple tasks - Waiman,
>      contributed by Dietmar
> 
> This set is also available from
> 
> https://github.com/jlelli/linux.git deadline/rework-cpusets

Thanks a lot Juri!

I picked up the updated series and applied them to a 5.10 kernel and tested the
issue is fixed. Replied with my reviewed-and-tested-bys to some of the patches
already.

I haven't looked much at Dietmar's patches and while they were part of the
test, but there are no dl tasks on the system so I felt hesitant to say
I tested that part.


Cheers
