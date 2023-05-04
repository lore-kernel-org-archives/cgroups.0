From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 2/6] sched/cpuset: Bring back cpuset_mutex
Date: Thu, 4 May 2023 08:18:42 +0200
Message-ID: <20230504061842.GC1734100@hirez.programming.kicks-ass.net>
References: <20230503072228.115707-1-juri.lelli@redhat.com>
 <20230503072228.115707-3-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DfqWiyDRGB40eGYe2jGNPAj11jBf4uHEb5kd/1AH73Y=; b=jh1G+T4BkA9Hqha86rr270atlB
        5VwBCL/FYuqlZsXl0tN57xUIihlHNN0hXZdhYF5obHg6NpfSugsRblLNfQpxC9YVbxj6uIRzHsddp
        KTBcXsnS9sPUo1O2QKsEvkTK3lGpdlNDQ0mSvgXDxXeFdghOK40WtYgfhXV79NTqsA3nUnp0I969U
        CMC3kIZOlR0BJRQO/CAEg9xEanUSQQ8Wk+Q0NR0s4hMKnb6KBoE+w9bEonYDEwg7IrhgW7OV4pfsL
        p5QLXOChTN+p5HhuP/ExTFbYwLe4NO5TcFy+X+sWCWDmc2UetTwys0ulbOrEaa4exgcA1Ce8chbzI
        h/w1z1vg==;
Content-Disposition: inline
In-Reply-To: <20230503072228.115707-3-juri.lelli@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Qais Yousef <qyousef@layalina.io>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>

On Wed, May 03, 2023 at 09:22:24AM +0200, Juri Lelli wrote:

>  /*
> - * There are two global locks guarding cpuset structures - cpuset_rwsem and
> + * There are two global locks guarding cpuset structures - cpuset_mutex and
>   * callback_lock. We also require taking task_lock() when dereferencing a
>   * task's cpuset pointer. See "The task_lock() exception", at the end of this
> - * comment.  The cpuset code uses only cpuset_rwsem write lock.  Other
> - * kernel subsystems can use cpuset_read_lock()/cpuset_read_unlock() to
> - * prevent change to cpuset structures.
> + * comment.  The cpuset code uses only cpuset_mutex. Other kernel subsystems
> + * can use cpuset_lock()/cpuset_unlock() to prevent change to cpuset
> + * structures.
>   *
>   * A task must hold both locks to modify cpusets.  If a task holds
> - * cpuset_rwsem, it blocks others wanting that rwsem, ensuring that it
> - * is the only task able to also acquire callback_lock and be able to
> - * modify cpusets.  It can perform various checks on the cpuset structure
> - * first, knowing nothing will change.  It can also allocate memory while
> - * just holding cpuset_rwsem.  While it is performing these checks, various
> - * callback routines can briefly acquire callback_lock to query cpusets.
> - * Once it is ready to make the changes, it takes callback_lock, blocking
> - * everyone else.
> + * cpuset_mutex, it blocks others, ensuring that it is the only task able to
> + * also acquire callback_lock and be able to modify cpusets.  It can perform
> + * various checks on the cpuset structure first, knowing nothing will change.
> + * It can also allocate memory while just holding cpuset_mutex.  While it is
> + * performing these checks, various callback routines can briefly acquire
> + * callback_lock to query cpusets.  Once it is ready to make the changes, it
> + * takes callback_lock, blocking everyone else.
>   *
>   * Calls to the kernel memory allocator can not be made while holding
>   * callback_lock, as that would risk double tripping on callback_lock
> @@ -403,16 +402,16 @@ static struct cpuset top_cpuset = {
>   * guidelines for accessing subsystem state in kernel/cgroup.c
>   */
>  
> -DEFINE_STATIC_PERCPU_RWSEM(cpuset_rwsem);
> +static DEFINE_MUTEX(cpuset_mutex);

Perhaps extend the comment to state you explicitly want a mutex for PI
etc.. ?
