From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Thu, 3 Jun 2021 09:53:16 -0700
Message-ID: <CALvZod5=-Q_xFP3-8hUe4dzJ5_U+omi2R7Leen2s_sqn2+5VbA@mail.gmail.com>
References: <20210603145707.4031641-1-schatzberg.dan@gmail.com> <20210603145707.4031641-3-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t0rBINIjyYVjiWlKA6CZdf8Cu1m85/b95NW0HipMWEw=;
        b=RT6DDw3hX0Vd0D9y8P1+wlBANWRsJKcOTL5XNuqjuoqdcO+eVWb3h5lPuPBdWbpXRP
         qS7RpEK9U4hewHkB9ReHFH0CpGE6xxnLud53HxAhqun48esVrJ2Tsyp+XW2wrFLkrwHK
         lH/KFiL4LHRVHxBi+EJaxQ1OcbONA/XKS1BDaSuddZH/u57dzNoDmqyVp/ACKK8Zo9xA
         GYN86bl7bcGB1HAkjN9u3Li/fE5sVQbAL/zx25EkFYVTSn2KJIenbUvhjj/7OSdYsqOj
         aF8pnMaxmokmARnSb/3P9IcKdc1ySVi+6IVr0FK6l431NPIU5pv9T8uTmzgRjZmKVxX7
         SuIg==
In-Reply-To: <20210603145707.4031641-3-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>, Muchun Song <songmuchun@bytedance.com>
Cc: Jens Axboe <axboe@kernel.dk>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>

On Thu, Jun 3, 2021 at 7:57 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
>
> set_active_memcg() worked for kernel allocations but was silently
> ignored for user pages.
>
> This patch establishes a precedence order for who gets charged:
>
> 1. If there is a memcg associated with the page already, that memcg is
>    charged. This happens during swapin.
>
> 2. If an explicit mm is passed, mm->memcg is charged. This happens
>    during page faults, which can be triggered in remote VMs (eg gup).
>
> 3. Otherwise consult the current process context. If there is an
>    active_memcg, use that. Otherwise, current->mm->memcg.
>
> Previously, if a NULL mm was passed to mem_cgroup_charge (case 3) it
> would always charge the root cgroup. Now it looks up the active_memcg
> first (falling back to charging the root cgroup if not set).
>
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Chris Down <chris@chrisdown.name>
> Acked-by: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Can you please rebase over the latest mm tree? Specifically over
Muchun's patch "mm: memcontrol: bail out early when !mm in
get_mem_cgroup_from_mm".
