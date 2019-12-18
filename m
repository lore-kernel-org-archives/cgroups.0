From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: vmscan: memcg: Add global shrink priority
Date: Wed, 18 Dec 2019 14:09:52 +0000
Message-ID: <20191218140952.GA255739@chrisdown.name>
References: <1576662179-16861-1-git-send-email-teawaterz@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dxjsGjatY6ZbcTCcZP76IfB6Z3ogOgfOc4zopQ9KHZw=;
        b=PNyhx+AOrNKPg3eDV8ybExNCbharLbfTnb/QPJsivs4Drc+dFrkWLrZiSpJzm/dOol
         5cwzbkNc0l3rz6AIjkIRe7L/lvDQUdnn4yZCYUv6VZJkKbn7U9Nyh7g83AWJylEcGA3W
         d4ZLDHApZ7hFNqnvcOOIs2oZSjbuNQKWIlnAw=
Content-Disposition: inline
In-Reply-To: <1576662179-16861-1-git-send-email-teawaterz@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Hui Zhu <teawaterz@linux.alibaba.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, guro@fb.com, shakeelb@google.com, yang.shi@linux.alibaba.com, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Hi Hui,

In general cgroup v1 is in maintenance mode -- that is, excepting specific 
bugfixes, we don't plan to add new features.

Hui Zhu writes:
>Currently, memcg has some config to limit memory usage and config
>the shrink behavior.
>In the memory-constrained environment, put different priority tasks
>into different cgroups with different memory limits to protect the
>performance of the high priority tasks.  Because the global memory
>shrink will affect the performance of all tasks.  The memory limit
>cgroup can make shrink happen inside the cgroup.  Then it can decrease
>the memory shrink of the high priority task to protect its performance.
>
>But the memory footprint of the task is not static.  It will change as
>the working pressure changes.  And the version changes will affect it too.
>Then set the appropriate memory limit to decrease the global memory shrink
>is a difficult job and lead to wasted memory or performance loss sometimes.
>
>This commit adds global shrink priority to memcg to try to handle this
>problem.

I have significant concerns with exposing scan priority to userspace. This is 
an incredibly difficult metric for users to reason about since it's a reclaim 
implementation feature and would add to an already confusing and fragmented API 
in v1.

Have you considered using memory protection (memory.low, memory.min) for this 
instead? It sounds like it can achieve the results you want, in that it allows 
you to direct and prioritise reclaim in a way that allows for ballparking (ie. 
it is compatible with applications with variable memory footprints).

Thanks,

Chris
