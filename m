From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH v3 2/3] mm: Charge active memcg when no mm is set
Date: Thu, 20 Feb 2020 13:35:52 -0500
Message-ID: <20200220183552.GA2181061@chrisdown.name>
References: <cover.1582216294.git.schatzberg.dan@gmail.com>
 <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ui1GYJ+3TKdhDhER6hX80GC8ogMrESlUENKJdsvmiJw=;
        b=fmztncXTcGHJiFgzRFjgjLEip0FvqqT27efzmzqFHV75pB/K83qJ3D1hNW4E70dXeZ
         CJFi4rvcQHriQibThmglNljM7AMJM2WmKPyRjHJZtP1+ft4kHUBatB/TJEuTN6xxhTiN
         E6+kHjefonE2x7TQtlE6uRTgWbAoPRwp5TtqE=
Content-Disposition: inline
In-Reply-To: <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Yang Shi <yang.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

Dan Schatzberg writes:
>memalloc_use_memcg() worked for kernel allocations but was silently
>ignored for user pages.
>
>This patch establishes a precedence order for who gets charged:
>
>1. If there is a memcg associated with the page already, that memcg is
>   charged. This happens during swapin.
>
>2. If an explicit mm is passed, mm->memcg is charged. This happens
>   during page faults, which can be triggered in remote VMs (eg gup).
>
>3. Otherwise consult the current process context. If it has configured
>   a current->active_memcg, use that. Otherwise, current->mm->memcg.
>
>Previously, if a NULL mm was passed to mem_cgroup_try_charge (case 3) it
>would always charge the root cgroup. Now it looks up the current
>active_memcg first (falling back to charging the root cgroup if not
>set).
>
>Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
>Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>Acked-by: Tejun Heo <tj@kernel.org>

Acked-by: Chris Down <chris@chrisdown.name>

Thanks! The clarification the v2 thread for this made things clear to me.
