From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH] memcg, kmem: mark cancel_charge() inline
Date: Fri, 22 Oct 2021 15:22:57 +0800
Message-ID: <CAMZfGtUL7_EfE4L-j0LxhqmpAX4ed94+1tuQYn6y4D1MBv0FDw@mail.gmail.com>
References: <20211022070542.679839-1-arnd@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I1vQaOge6Eq30iCGGtZzSSi/EQTEwgL0ohNIjHQi/KM=;
        b=uuv/tbejcRUmXHleRBldEGi/B8O1kL8uWt2IdylNW0f2jJK06tE3pdZp0cpmNvkwVC
         kqX0xP4gNIFA7x4hAdgmR5rmPmd7l4Cz3aR9LSqPxw5b4wZd3xJrhY8hjJLg5PIL60d6
         VY/xp17n3XgfIHdpbNch2nQ0W4rS3KvDK+UJXhmTNg1ImhZOv1b4W36tyIkFYGIJb6qd
         MEYUD7/Nlmfc8ojqzQcELshvhKkOQz4qQCiQK3ozfd3XaMngCCAfbDC1dDyCUVoUKiWF
         3+Y4SwVMNediRvwJD/8uzvVUFe9Mo8yON8fYU14LYUWogIr4xdYza8vMqTYn6+xBo4Ca
         Jmmg==
In-Reply-To: <20211022070542.679839-1-arnd@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Roman Gushchin <guro@fb.com>, Arnd Bergmann <arnd@arndb.de>, Shakeel Butt <shakeelb@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Waiman Long <longman@redhat.com>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Fri, Oct 22, 2021 at 3:05 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> cancel_charge() is no longer called for CONFIG_MEMCG_KMEM on NOMMU
> targets, which causes a compiletime warning:
>
> mm/memcontrol.c:2774:13: error: unused function 'cancel_charge' [-Werror,-Wunused-function]
>
> Remove the now-incorrect #ifdef and just mark the function
> 'inline' like the other related helpers. This is simpler
> and means we no longer have to match the #ifdef with the
> caller.
>
> Fixes: 5f3345c17079 ("memcg, kmem: further deprecate kmem.limit_in_bytes")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks. I guess this should be squashed into the commit 5f3345c17079
("memcg, kmem: further deprecate kmem.limit_in_bytes").

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

> ---
> The 5f3345c17079 commit is in -mm, so the commit ID is not
> stable. Feel free to just fold this into the other patch, or
> take out that reference
> ---
>  mm/memcontrol.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6538595994d2..9edccfeac804 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2770,8 +2770,7 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>         return try_charge_memcg(memcg, gfp_mask, nr_pages);
>  }
>
> -#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
> -static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
> +static inline void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>  {
>         if (mem_cgroup_is_root(memcg))
>                 return;
> @@ -2780,7 +2779,6 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>         if (do_memsw_account())
>                 page_counter_uncharge(&memcg->memsw, nr_pages);
>  }
> -#endif
>
>  static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
>  {
> --
> 2.29.2
>
