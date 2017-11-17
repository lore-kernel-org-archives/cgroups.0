From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Thu, 16 Nov 2017 20:43:17 -0800
Message-ID: <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com>
References: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=3O0mnxirgw/KLpOpNK87NOnAqyPxWrmZ+ACPYiS72OY=;
        b=GoyPQwzq75WCGLJYrCF3eVpnii7gqAyxca5pPhGugPVThvERBd+Y7peDu9k2L6CPYP
         loFMx5k9IyURfaJh59nl57QJx+e3SJdW+exU+3dzaHot90CKrpCAYyS7bZ8FdYZW/Nvp
         K3e8vKx0CjZC/C1hSIvUp1cRfzEKoxPUWBEHDfm/7YQ1eeEzpaT4/gMJlkcRGcXIEUjA
         CczA9jgu2EP1AimDsASrbLtidKunQr8HtpSYcvZqXw3l0s5g8K4q2IbUnwXrzL9/r1p2
         Q7c0HF3VcFDX+4TvK+Laf5aXpPyNqf8BnvhctWgfVni0Vv38h02JMfk+nWhZm8UhJdtw
         oN2Q==
In-Reply-To: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, khlebnikov@yandex-team.ru, mka@chromium.org, Hugh Dickins <hughd@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Nov 16, 2017 at 7:09 PM, Yafang Shao <laoar.shao@gmail.com> wrote:
> Currently the default tmpfs size is totalram_pages / 2 if mount tmpfs
> without "-o size=XXX".
> When we mount tmpfs in a container(i.e. docker), it is also
> totalram_pages / 2 regardless of the memory limit on this container.
> That may easily cause OOM if tmpfs occupied too much memory when swap is
> off.
> So when we mount tmpfs in a memcg, the default size should be limited by
> the memcg memory.limit.
>

The pages of the tmpfs files are charged to the memcg of allocators
which can be in memcg different from the memcg in which the mount
operation happened. So, tying the size of a tmpfs mount where it was
mounted does not make much sense.

Also mount operation which requires CAP_SYS_ADMIN, is usually
performed by node controller (or job loader) which don't necessarily
run in the memcg of the actual job.

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            |  2 +-
>  mm/shmem.c                 | 20 +++++++++++++++++++-
>  3 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69966c4..79c6709 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -265,6 +265,7 @@ struct mem_cgroup {
>         /* WARNING: nodeinfo must be the last member here */
>  };
>
> +extern struct mutex memcg_limit_mutex;
>  extern struct mem_cgroup *root_mem_cgroup;
>
>  static inline bool mem_cgroup_disabled(void)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 661f046..ad32f3c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2464,7 +2464,7 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
>  }
>  #endif
>
> -static DEFINE_MUTEX(memcg_limit_mutex);
> +DEFINE_MUTEX(memcg_limit_mutex);

This mutex is only needed for updating the limit.

>
>  static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>                                    unsigned long limit)
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 07a1d22..1c320dd 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -35,6 +35,7 @@
>  #include <linux/uio.h>
>  #include <linux/khugepaged.h>
>  #include <linux/hugetlb.h>
> +#include <linux/memcontrol.h>
>
>  #include <asm/tlbflush.h> /* for arch/microblaze update_mmu_cache() */
>
> @@ -108,7 +109,24 @@ struct shmem_falloc {
>  #ifdef CONFIG_TMPFS
>  static unsigned long shmem_default_max_blocks(void)
>  {
> -       return totalram_pages / 2;
> +       unsigned long size;
> +
> +#ifdef CONFIG_MEMCG
> +       struct mem_cgroup *memcg = mem_cgroup_from_task(current);
> +
> +       if (memcg == NULL || memcg == root_mem_cgroup)
> +               size = totalram_pages / 2;
> +       else {
> +               mutex_lock(&memcg_limit_mutex);
> +               size = memcg->memory.limit > totalram_pages ?
> +                                totalram_pages / 2 : memcg->memory.limit / 2;
> +               mutex_unlock(&memcg_limit_mutex);
> +       }
> +#else
> +       size = totalram_pages / 2;
> +#endif
> +
> +       return size;
>  }
>
>  static unsigned long shmem_default_max_inodes(void)
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
