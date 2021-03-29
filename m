From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Tue, 30 Mar 2021 00:13:01 +0800
Message-ID: <CAMZfGtVT85+1_Bu9LBaG6DUsr1kYsepQ-1-K7BDD0Wn3L+BQgg@mail.gmail.com>
References: <20210329144829.1834347-1-schatzberg.dan@gmail.com> <20210329144829.1834347-3-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iwgqrSQ7OtcTD6Kmq+G2j4+SoTiaaT1H8kRq2h2aVwg=;
        b=B9aWLAKZAcMxqzTDYkFoN6eV0fA9YoPBu44LBrfz1T4nCQajwJ1+96uuUowCoffKP7
         MBg0CU2oSAFSCKP0UMxIFoaCf8MgRmHFgZ7w4sCHhaHykw5JmWgJZSohSe4SVtfP8lx3
         2BK6kH92QLkrAsORbl2SG85f70wbzRu95WMoIyW9+Ci/QgcNuz5se6sTzgaWUnAr2v5V
         S913EZLQMV3S20eRdWWJ40lcdNl+T0T96Wl44fH9J7mbgaPeVwj0PmfTEoSyD5a+f6fL
         sVSU06qRWs+2PQvOE/d6zfVul1SWs3lkSBX4GkdKDi1XGP84/Ms+8vrYWqdpPd0NI3zz
         JcRA==
In-Reply-To: <20210329144829.1834347-3-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Yang Shi <shy828301@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, C

On Mon, Mar 29, 2021 at 10:49 PM Dan Schatzberg
<schatzberg.dan@gmail.com> wrote:
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
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> ---
>  mm/filemap.c    |  2 +-
>  mm/memcontrol.c | 72 ++++++++++++++++++++++++++++---------------------
>  mm/shmem.c      |  4 +--
>  3 files changed, 44 insertions(+), 34 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index eeeb8e2cc36a..63fd980e863a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -872,7 +872,7 @@ noinline int __add_to_page_cache_locked(struct page *=
page,
>         page->index =3D offset;
>
>         if (!huge) {
> -               error =3D mem_cgroup_charge(page, current->mm, gfp);
> +               error =3D mem_cgroup_charge(page, NULL, gfp);
>                 if (error)
>                         goto error;
>                 charged =3D true;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 668d1d7c2645..adc618814fd2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -884,13 +884,38 @@ struct mem_cgroup *mem_cgroup_from_task(struct task=
_struct *p)
>  }
>  EXPORT_SYMBOL(mem_cgroup_from_task);
>
> +static __always_inline struct mem_cgroup *active_memcg(void)
> +{
> +       if (in_interrupt())
> +               return this_cpu_read(int_active_memcg);
> +       else
> +               return current->active_memcg;
> +}
> +
> +static __always_inline struct mem_cgroup *get_active_memcg(void)
> +{
> +       struct mem_cgroup *memcg;
> +
> +       rcu_read_lock();
> +       memcg =3D active_memcg();
> +       /* remote memcg must hold a ref. */
> +       if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
> +               memcg =3D root_mem_cgroup;
> +       rcu_read_unlock();
> +
> +       return memcg;
> +}

This function is already removed since the patchset below.

  Use obj_cgroup APIs to charge kmem pages
  https://lore.kernel.org/patchwork/cover/1399132/

I also suggest not reintroducing get_active_memcg.
There is only one user of it, just inline it into
get_mem_cgroup_from_mm(). Actually we don=E2=80=99t
need get_active_memcg() either.

> +
>  /**
>   * get_mem_cgroup_from_mm: Obtain a reference on given mm_struct's memcg=
.
>   * @mm: mm from which memcg should be extracted. It can be NULL.
>   *
> - * Obtain a reference on mm->memcg and returns it if successful. Otherwi=
se
> - * root_mem_cgroup is returned. However if mem_cgroup is disabled, NULL =
is
> - * returned.
> + * Obtain a reference on mm->memcg and returns it if successful. If mm
> + * is NULL, then the memcg is chosen as follows:
> + * 1) The active memcg, if set.
> + * 2) current->mm->memcg, if available
> + * 3) root memcg
> + * If mem_cgroup is disabled, NULL is returned.
>   */
>  struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
>  {
> @@ -899,13 +924,19 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm=
_struct *mm)
>         if (mem_cgroup_disabled())
>                 return NULL;
>
> +       /*
> +        * Page cache insertions can happen without an
> +        * actual mm context, e.g. during disk probing
> +        * on boot, loopback IO, acct() writes etc.
> +        */
> +       if (unlikely(!mm)) {
> +               if (unlikely(active_memcg()))
> +                       return get_active_memcg();

Since remote memcg must hold a reference, we do not
need to do something like get_active_memcg() does.
Just use css_get to obtain a ref, it is simpler. Just
Like below.

+       if (unlikely(!mm)) {
+               memcg =3D active_memcg();
+               if (unlikely(memcg)) {
+                       /* remote memcg must hold a ref. */
+                       css_get(memcg);
+                       return memcg;
+               }

Thanks.

> +               mm =3D current->mm;
> +       }
> +
>         rcu_read_lock();
>         do {
> -               /*
> -                * Page cache insertions can happen withou an
> -                * actual mm context, e.g. during disk probing
> -                * on boot, loopback IO, acct() writes etc.
> -                */
>                 if (unlikely(!mm))
>                         memcg =3D root_mem_cgroup;
>                 else {
> @@ -919,28 +950,6 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_=
struct *mm)
>  }
>  EXPORT_SYMBOL(get_mem_cgroup_from_mm);
>
> -static __always_inline struct mem_cgroup *active_memcg(void)
> -{
> -       if (in_interrupt())
> -               return this_cpu_read(int_active_memcg);
> -       else
> -               return current->active_memcg;
> -}
> -
> -static __always_inline struct mem_cgroup *get_active_memcg(void)
> -{
> -       struct mem_cgroup *memcg;
> -
> -       rcu_read_lock();
> -       memcg =3D active_memcg();
> -       /* remote memcg must hold a ref. */
> -       if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
> -               memcg =3D root_mem_cgroup;
> -       rcu_read_unlock();
> -
> -       return memcg;
> -}
> -
>  static __always_inline bool memcg_kmem_bypass(void)
>  {
>         /* Allow remote memcg charging from any context. */
> @@ -6549,7 +6558,8 @@ static int __mem_cgroup_charge(struct page *page, s=
truct mem_cgroup *memcg,
>   * @gfp_mask: reclaim mode
>   *
>   * Try to charge @page to the memcg that @mm belongs to, reclaiming
> - * pages according to @gfp_mask if necessary.
> + * pages according to @gfp_mask if necessary. if @mm is NULL, try to
> + * charge to the active memcg.
>   *
>   * Do not use this for pages allocated for swapin.
>   *
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 78ab81a62b29..7c09276125d5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1694,7 +1694,7 @@ static int shmem_swapin_page(struct inode *inode, p=
goff_t index,
>  {
>         struct address_space *mapping =3D inode->i_mapping;
>         struct shmem_inode_info *info =3D SHMEM_I(inode);
> -       struct mm_struct *charge_mm =3D vma ? vma->vm_mm : current->mm;
> +       struct mm_struct *charge_mm =3D vma ? vma->vm_mm : NULL;
>         struct page *page;
>         swp_entry_t swap;
>         int error;
> @@ -1815,7 +1815,7 @@ static int shmem_getpage_gfp(struct inode *inode, p=
goff_t index,
>         }
>
>         sbinfo =3D SHMEM_SB(inode->i_sb);
> -       charge_mm =3D vma ? vma->vm_mm : current->mm;
> +       charge_mm =3D vma ? vma->vm_mm : NULL;
>
>         page =3D pagecache_get_page(mapping, index,
>                                         FGP_ENTRY | FGP_HEAD | FGP_LOCK, =
0);
> --
> 2.30.2
>
