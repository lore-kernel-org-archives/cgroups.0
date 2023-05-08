From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 0/6] sched/deadline: cpuset: Rework DEADLINE bandwidth
 restoration
Date: Mon, 8 May 2023 13:24:16 -1000
Message-ID: <ZFmEoBoX15FIpyW1@slm.duckdns.org>
References: <20230508075854.17215-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683588259; x=1686180259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xWUewLtyjjleyCE27N0mgy++XbZ3xZJBSp9FQArDlQU=;
        b=cMgyvKzfMRZ5F6dobb+hxpXJmFiFNPdymS/AneW1qDN9sWCmT/PL8mluUI+VSw0I7L
         yLOTKnHDqulRpFgPTlbgJ068wRQv3ph93VqvAylgj0TBV9hjoWcIyVwstwcQo6JoKuBf
         GfmMQ9iDoviqnYAGxX0P1lj/KwdXQcJk+6KOxAIbdfgXgu9sNn0HBGqbnRIvJ30Wm0fG
         gDB/Txt23JlWHtP7he4FGgXwIz+m1WwbgFCcKj6sXoBdsA9RU8kz5nsushGnw8lEzrBQ
         JDOGRmm5Sj7o913tB4WBuCs3EcWn7K50tzAM96peisZmCKkOYcTUdyN0crppKzcxCPco
         89bA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230508075854.17215-1-juri.lelli@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Qais Yousef <qyousef@layalina.io>, Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agor>

On Mon, May 08, 2023 at 09:58:48AM +0200, Juri Lelli wrote:
> Qais reported [1] that iterating over all tasks when rebuilding root
> domains for finding out which ones are DEADLINE and need their bandwidth
> correctly restored on such root domains can be a costly operation (10+
> ms delays on suspend-resume). He proposed we skip rebuilding root
> domains for certain operations, but that approach seemed arch specific
> and possibly prone to errors, as paths that ultimately trigger a rebuild
> might be quite convoluted (thanks Qais for spending time on this!).
> 
> This is v3 of an alternative approach (v2 at [4]) to fix the problem.
> 
>  01/06 - Rename functions deadline with DEADLINE accounting (cleanup
>          suggested by Qais) - no functional change
>  02/06 - Bring back cpuset_mutex (so that we have write access to cpusets
>          from scheduler operations - and we also fix some problems
>          associated to percpu_cpuset_rwsem)
>  03/06 - Keep track of the number of DEADLINE tasks belonging to each cpuset
>  04/06 - Use this information to only perform the costly iteration if
>          DEADLINE tasks are actually present in the cpuset for which a
>          corresponding root domain is being rebuilt
>  05/06 - Create DL BW alloc, free & check overflow interface for bulk
>          bandwidth allocation/removal - no functional change 
>  06/06 - Fix bandwidth allocation handling for cgroup operation
>          involving multiple tasks
> 
> With respect to the v2 posting [4]
> 
>  1 - rebase on top of Linus' tree as of today (ac9a78681b92)
>  2 - add the 'why' to 5/6 changelog - Peter
>  3 - explicitly say that we need to keep cpuset_mutex a mutex for PI on
>      2/6 - Peter
> 
> This set is also available from
> 
> https://github.com/jlelli/linux.git deadline/rework-cpusets

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
