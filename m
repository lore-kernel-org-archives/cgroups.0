From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 7/7] psi: cgroup support
Date: Wed, 9 May 2018 13:07:36 +0200
Message-ID: <20180509110736.GR12217@hirez.programming.kicks-ass.net>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-8-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xX5O3OJZMsmfN6VJxR/1SPgfO3nJlLBQq4GICQvYF7I=; b=cY7HYNS14WHbD63ePBp1l9FBX
        UwTMlxoT5i7a1UDI32kfCzAwx4rZ9RPcihJuxCgcx+AM8JEW1dH/rgv8dNFIn1JbaD9WgNhxAqhfx
        uDUYNZKmIZFKUy6F3EbshoNm/QXK5aJZI4nzaatWiz0zKrKJdjY/VorkJqcPIpZTi1aSOzXd8xSFa
        V4gsbbzHMnjIah7F4z0RaXhk8pfJfV+Z55ShB4fnwxab9Np/4tzYTMY8BKDnmn9DVFYEbUSf6VZkt
        VYXdGTn9wsyYyUFrR0XKLs5jclmoI4lMawtjzDfw5eJ+ATzMtSvQftQPRBm0pzIFZDwNiPfrOnJTI
      
Content-Disposition: inline
In-Reply-To: <20180507210135.1823-8-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, May 07, 2018 at 05:01:35PM -0400, Johannes Weiner wrote:
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -260,6 +260,18 @@ void psi_task_change(struct task_struct *task, u64 now, int clear, int set)
>  	task->psi_flags |= set;
>  
>  	psi_group_update(&psi_system, cpu, now, clear, set);
> +
> +#ifdef CONFIG_CGROUPS
> +       cgroup = task->cgroups->dfl_cgrp;
> +       while (cgroup && (parent = cgroup_parent(cgroup))) {
> +               struct psi_group *group;
> +
> +               group = cgroup_psi(cgroup);
> +               psi_group_update(group, cpu, now, clear, set);
> +
> +               cgroup = parent;
> +       }
> +#endif
>  }

TJ fixed needing that for stats at some point, why can't you do the
same?
