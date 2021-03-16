From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Tue, 16 Mar 2021 08:50:16 -0700
Message-ID: <CALvZod7sk52OYwxP=VRhS0q4xZ57UuSdL6Mi4Y956xDq3pTatQ@mail.gmail.com>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com> <20210316153655.500806-3-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WwakdtxuHaTN5z0HCiQ4MNVrrN9llL1dGHrwS+1rEFI=;
        b=Y8vlN3SI/ykxQTjQbv4kH+9CK9WxCxroUfhO5YAG/Q06fEfhC7gmihPG0b2gkbg7p2
         BJcipNhPpwfAYZQawmSVw4SuDq9HgHqrnJ72QN6YzAPc/iS45ymhVnlsheWAmhIcRFFC
         5n043KRfcygMCCaESFPz/xle+ga7BJvXFjAgDJ2KE3+DwTFKrqQGRARQHbIWQizdgYAx
         yjC00EWkXA7CGN93CjqVoC9HMMj3XE/OgUEkwHEjGGzbImbrc7x5KngmL6YhRLcDwLnF
         rOlY48nIfjjcwEFdjlIDwqnZrPTEBtobD5wnEMK+86kKf6TRdXu36PZTzykBdCGIV382
         K6bQ==
In-Reply-To: <20210316153655.500806-3-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>

On Tue, Mar 16, 2021 at 8:37 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
>
> memalloc_use_memcg() worked for kernel allocations but was silently
> ignored for user pages.

set_active_memcg()

>
> This patch establishes a precedence order for who gets charged:
>
> 1. If there is a memcg associated with the page already, that memcg is
>    charged. This happens during swapin.
>
> 2. If an explicit mm is passed, mm->memcg is charged. This happens
>    during page faults, which can be triggered in remote VMs (eg gup).
>
> 3. Otherwise consult the current process context. If it has configured
>    a current->active_memcg, use that. Otherwise, current->mm->memcg.

It's a bit more sophisticated than current->active_memcg. It has been
extended to work in interrupt context as well.

>
> Previously, if a NULL mm was passed to mem_cgroup_try_charge (case 3) it

mem_cgroup_charge()

> would always charge the root cgroup. Now it looks up the current
> active_memcg first (falling back to charging the root cgroup if not
> set).
>
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> ---
>  mm/filemap.c    |  2 +-
>  mm/memcontrol.c | 14 +++++++++++---
>  mm/shmem.c      |  4 ++--
>  3 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 43700480d897..5135f330f05c 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -843,7 +843,7 @@ noinline int __add_to_page_cache_locked(struct page *page,
>         page->index = offset;
>
>         if (!huge) {
> -               error = mem_cgroup_charge(page, current->mm, gfp);
> +               error = mem_cgroup_charge(page, NULL, gfp);
>                 if (error)
>                         goto error;
>                 charged = true;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e064ac0d850a..9a1b23ed3412 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6690,7 +6690,8 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>   * @gfp_mask: reclaim mode
>   *
>   * Try to charge @page to the memcg that @mm belongs to, reclaiming
> - * pages according to @gfp_mask if necessary.
> + * pages according to @gfp_mask if necessary. if @mm is NULL, try to
> + * charge to the active memcg.
>   *
>   * Returns 0 on success. Otherwise, an error code is returned.
>   */
> @@ -6726,8 +6727,15 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
>                 rcu_read_unlock();
>         }
>
> -       if (!memcg)
> -               memcg = get_mem_cgroup_from_mm(mm);
> +       if (!memcg) {
> +               if (!mm) {
> +                       memcg = get_mem_cgroup_from_current();
> +                       if (!memcg)
> +                               memcg = get_mem_cgroup_from_mm(current->mm);
> +               } else {
> +                       memcg = get_mem_cgroup_from_mm(mm);
> +               }
> +       }

You will need to rebase to the latest mm tree. This code has changed.
