From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V5] memcg, oom: provide more precise dump info while memcg
 oom happening
Date: Fri, 21 Dec 2012 11:55:12 +0800
Message-ID: <CAFj3OHWDdiKiY+MJXnUw9y0v=Z0XiUsCBeYXWpwf1iMbkzeqhw@mail.gmail.com>
References: <1355925061-3858-1-git-send-email-handai.szj@taobao.com>
	<20121219141218.c1bb423b.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=bvIaxnHRZvk37eBPgB9XBg4MSc1v3GMN3CHmw8ik3T4=;
        b=FZplnJu+IRfiT9R6/qlQWyheXMZ/P7bE2KiKVRFp2/pG9RCpggVH/5tn3vsJQRAJPL
         /nv7mM9GlaZLTYZa7oB/vhr+a8hOXT1BAtUr7TykI58jbo3MbM6MHdnbe5U3agcEQ2rM
         TCkECNLhSy0/z1G/2FovBdq37Hz0HeIPbHxi3ek+OAUvqAIn0S5GpEDfg2cTBO6Z2Xay
         YAa55RpTBxWqzM6jEFISeAs0/q0OYRhCR/bbkT/hIsalCkYvP4u4Dul/rz6f1nNxAMyd
         a0pZQD19ZYon7JW8bpCj8a2RyFSecqb2I4C24ZqwIShEiMgIAtrHV2nCsd4HKpUgc9gB
         BupQ==
In-Reply-To: <20121219141218.c1bb423b.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu, Dec 20, 2012 at 6:12 AM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, 19 Dec 2012 21:51:01 +0800
> Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> +             pr_info("Memory cgroup stats");
>
> Well if we're going to do that, we may as well finish the job:
>
>
> From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Subject: mm/memcontrol.c: convert printk(KERN_FOO) to pr_foo()
>
> Cc: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
>
>  mm/memcontrol.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff -puN mm/memcontrol.c~mm-memcontrolc-convert-printkkern_foo-to-pr_foo mm/memcontrol.c
> --- a/mm/memcontrol.c~mm-memcontrolc-convert-printkkern_foo-to-pr_foo
> +++ a/mm/memcontrol.c
> @@ -1574,7 +1574,7 @@ void mem_cgroup_print_oom_info(struct me
>         }
>         rcu_read_unlock();
>
> -       printk(KERN_INFO "Task in %s killed", memcg_name);
> +       pr_info("Task in %s killed", memcg_name);
>
>         rcu_read_lock();
>         ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
> @@ -1587,19 +1587,18 @@ void mem_cgroup_print_oom_info(struct me
>         /*
>          * Continues from above, so we don't need an KERN_ level
>          */
> -       printk(KERN_CONT " as a result of limit of %s\n", memcg_name);
> +       pr_cont(" as a result of limit of %s\n", memcg_name);
>  done:
>
> -       printk(KERN_INFO "memory: usage %llukB, limit %llukB, failcnt %llu\n",
> +       pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
>                 res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
>                 res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
>                 res_counter_read_u64(&memcg->res, RES_FAILCNT));
> -       printk(KERN_INFO "memory+swap: usage %llukB, limit %llukB, "
> -               "failcnt %llu\n",
> +       pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %llu\n",
>                 res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
>                 res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
>                 res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> -       printk(KERN_INFO "kmem: usage %llukB, limit %llukB, failcnt %llu\n",
> +       pr_info("kmem: usage %llukB, limit %llukB, failcnt %llu\n",
>                 res_counter_read_u64(&memcg->kmem, RES_USAGE) >> 10,
>                 res_counter_read_u64(&memcg->kmem, RES_LIMIT) >> 10,
>                 res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
> @@ -4424,8 +4423,8 @@ void mem_cgroup_print_bad_page(struct pa
>
>         pc = lookup_page_cgroup_used(page);
>         if (pc) {
> -               printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
> -                      pc, pc->flags, pc->mem_cgroup);
> +               pr_alert("pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
> +                        pc, pc->flags, pc->mem_cgroup);
>         }
>  }
>  #endif
> _
>


Thanks Andrew! : )

Acked-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
