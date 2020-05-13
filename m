From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] memcg: Fix memcg_kmem_bypass() for remote memcg charging
Date: Wed, 13 May 2020 05:22:13 -0700
Message-ID: <CALvZod5EzSAdFJh-wjN9TfdUwsjL5Zfn6xao5S9nWvhiL+oL+w@mail.gmail.com>
References: <e6927a82-949c-bdfd-d717-0a14743c6759@huawei.com>
 <20200513090502.GV29153@dhcp22.suse.cz> <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
 <20200513112905.GX29153@dhcp22.suse.cz> <3a721f62-5a66-8bc5-247b-5c8b7c51c555@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4WVF9KPrx80M2FEl5rcn7EVSYU4t2bvsS4X5mKVR70=;
        b=TibQPMRLGxR/UEGYf/uFO/xAeZsv+91v7ZJOOVnjVs2cosCRf8uOioq3qh0ur1V4La
         1fK6QMjhpmQdwIPDMsCDRH5WV3DO2lKFnntzgNopufNe8gCTrVOioUHqzfGsxJS8MG3V
         Tvee5Ni+saMMCCjEu7sMr/N/e5OA3iCLTq/k63XGROTwmFwu960Je6JaAhw8883Zu4Qb
         hBgX9CJgSd4aYUcNKVCOVzqCY8zMGIgu4UXWrjxkt8h3/JcAUKUn2oy0wN+TdIVC27qE
         PMDDLVSKbdD/uEKND56/OKBgrawT/iLgTJNg7md7s4/aAbpEbNJ1wFNa/PQop3myu8AE
         SLSQ==
In-Reply-To: <3a721f62-5a66-8bc5-247b-5c8b7c51c555-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Wed, May 13, 2020 at 4:47 AM Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> While trying to use remote memcg charging in an out-of-tree kernel module
> I found it's not working, because the current thread is a workqueue thread.
>
> As we will probably encounter this issue in the future as the users of
> memalloc_use_memcg() grow, it's better we fix it now.
>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>
> v2: add a comment as sugguested by Michal. and add changelog to explain why
> upstream kernel needs this fix.
>
> ---
>
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a3b97f1..43a12ed 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2802,6 +2802,9 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
>
>  static inline bool memcg_kmem_bypass(void)
>  {
> +       /* Allow remote memcg charging in kthread contexts. */
> +       if (unlikely(current->active_memcg))
> +               return false;

What about __GFP_ACCOUNT allocations in the interrupt context?

e.g.

memalloc_use_memcg(memcg);
--->interrupt
--->alloc_page(GFP_KERNEL_ACCOUNT) in interrupt context.
alloc_page(GFP_KERNEL_ACCOUNT);
memalloc_unuse_memcg();


>         if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
>                 return true;
>         return false;
> --
> 2.7.4
>
