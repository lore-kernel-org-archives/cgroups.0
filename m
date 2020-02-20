From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/3] mm: Charge active memcg when no mm is set
Date: Thu, 20 Feb 2020 10:14:45 -0800
Message-ID: <CALvZod5bDQvYHTMCHoWbhiEbcBs4KATv=QLdjjivJ33kb6ZY+w@mail.gmail.com>
References: <cover.1582216294.git.schatzberg.dan@gmail.com> <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uUKdgkaufxLmLYOt3TduZTiePIKaOkl8sejxXEeQJug=;
        b=uEXDpSnvxNGx/1g8in8h2Lps6UF2cwI0Ci30lm3NqVXZaApTkzuDK+720dgSH9vb6k
         KPzL7duyHh9m0BqEDV45tazOognY/d0scMRdl2OcG1JPE/lSbuZQK0NgSRFEE6JZ1ocE
         bqLEMcVwBuFDRo16e9ImN9DFgGBbY4Rh3WKWen7Cz5Tan7f1NIIGTAN0UdCsrXlhKb2x
         xp82sXN5MddaQ9Fo3jlxRRZOvEG5C3dmzkLPX1is1Moe0S017U8Ajd4vA0J68kr+ivdJ
         DDHGyxImOHKFItW4eCZUYeAX2LdHOyh93fukcpNbkzLACAa56EL81Jnugc/MS1xxyks7
         aVSg==
In-Reply-To: <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Feb 20, 2020 at 8:52 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> memalloc_use_memcg() worked for kernel allocations but was silently
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
> 3. Otherwise consult the current process context. If it has configured
>    a current->active_memcg, use that.

What if css_tryget_online(current->active_memcg) in
get_mem_cgroup_from_current() fails? Do we want to change this to
css_tryget() and even if that fails should we fallback to
root_mem_cgroup or current->mm->memcg?

> Otherwise, current->mm->memcg.
>
> Previously, if a NULL mm was passed to mem_cgroup_try_charge (case 3) it
> would always charge the root cgroup. Now it looks up the current
> active_memcg first (falling back to charging the root cgroup if not
> set).
>
> Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  mm/memcontrol.c | 11 ++++++++---
>  mm/shmem.c      |  2 +-
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6f6dc8712e39..b174aff4f069 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6317,7 +6317,8 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>   * @compound: charge the page as compound or small page
>   *
>   * Try to charge @page to the memcg that @mm belongs to, reclaiming
> - * pages according to @gfp_mask if necessary.
> + * pages according to @gfp_mask if necessary. If @mm is NULL, try to
> + * charge to the active memcg.
>   *
>   * Returns 0 on success, with *@memcgp pointing to the charged memcg.
>   * Otherwise, an error code is returned.
> @@ -6361,8 +6362,12 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
>                 }
>         }
>
> -       if (!memcg)
> -               memcg = get_mem_cgroup_from_mm(mm);
> +       if (!memcg) {
> +               if (!mm)
> +                       memcg = get_mem_cgroup_from_current();
> +               else
> +                       memcg = get_mem_cgroup_from_mm(mm);
> +       }
>
>         ret = try_charge(memcg, gfp_mask, nr_pages);
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index c8f7540ef048..7c7f5acf89d6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1766,7 +1766,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
>         }
>
>         sbinfo = SHMEM_SB(inode->i_sb);
> -       charge_mm = vma ? vma->vm_mm : current->mm;
> +       charge_mm = vma ? vma->vm_mm : NULL;
>
>         page = find_lock_entry(mapping, index);
>         if (xa_is_value(page)) {
> --
> 2.17.1
>
