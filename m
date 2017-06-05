From: Guenter Roeck <groeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: Re: [6/6] mm: memcontrol: account slab stats
 per lruvec]
Date: Mon, 5 Jun 2017 13:30:39 -0700
Message-ID: <CABXOdTfZiMbLM2crzxdfcr74XoqabXiR5fL3ku=a8owiL6NyJA@mail.gmail.com>
References: <20170605202345.GB32498@roeck-us.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=4aE3F9C+fSBNHObnQ30mJrf/IS5G7cC/PPaCopZnXQY=;
        b=RQDziK6IKwioaF5OOF4w9keNhHzJCPRGq6edFwUu1dVPkzl9oH67C3fVnyB32CyBOY
         xT8dKpck/ya017l9t9x82SIJU7j5q3qr751Kc2AKZNO2rF9BaXXMXbyOEfUF9mUycb+g
         ihHCHQ4O5vgmOVK2wasjWCVGAPEG47IWKPKqn4wPLLeEElFYdXBMaAtFTYdM16Bgd1jS
         vQxxIvZXmHMicVjH3FCZJjPbJQNWAp8gIFjw/Cfow/ub0XmQzfuMDo7wLkEgj3qT8EqV
         Qj8Bw9quspp9RqDMnOPYIYGCH+08l5UpyiyKrW1nHDy/zwBsvvQYBbD/GwhDQnlsqWlH
         Ll2w==
In-Reply-To: <20170605202345.GB32498-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>

Something in my original reply classifies the message as spam. Trying this way.

On Mon, Jun 5, 2017 at 1:23 PM, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:
> ----- Forwarded message from Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> -----
>
> Date: Mon, 5 Jun 2017 13:52:54 -0400
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
> Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton
>         <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
>         linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
> Subject: Re: [6/6] mm: memcontrol: account slab stats per lruvec
> User-Agent: Mutt/1.8.2 (2017-04-18)
>
> On Mon, Jun 05, 2017 at 09:52:03AM -0700, Guenter Roeck wrote:
>> On Tue, May 30, 2017 at 02:17:24PM -0400, Johannes Weiner wrote:
>> > Josef's redesign of the balancing between slab caches and the page
>> > cache requires slab cache statistics at the lruvec level.
>> >
>> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> > Acked-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Presumably this is already known, but a remarkable number of crashes
>> in next-20170605 bisects to this patch.
>
> Thanks Guenter.
>
> Can you test if the fix below resolves the problem?

xtensa and x86_64 pass after this patch has been applied. arm and
aarch64 still crash with the same symptoms. I didn't test any others.

Crash log for arm is at
http://kerneltests.org/builders/qemu-arm-next/builds/711/steps/qemubuildcommand/logs/stdio

Guenter

>
> ---
>
> From 47007dfcd7873cb93d11466a93b1f41f6a7a434f Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Date: Sun, 4 Jun 2017 07:02:44 -0400
> Subject: [PATCH] mm: memcontrol: per-lruvec stats infrastructure fix 2
>
> Even with the previous fix routing !page->mem_cgroup stats to the root
> cgroup, we still see crashes in certain configurations as the root is
> not initialized for the earliest possible accounting sites in certain
> configurations.
>
> Don't track uncharged pages at all, not even in the root. This takes
> care of early accounting as well as special pages that aren't tracked.
>
> Because we still need to account at the pgdat level, we can no longer
> implement the lruvec_page_state functions on top of the lruvec_state
> ones. But that's okay. It was a little silly to look up the nodeinfo
> and descend to the lruvec, only to container_of() back to the nodeinfo
> where the lruvec_stat structure is sitting.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index bea6f08e9e16..da9360885260 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -585,27 +585,27 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
>  static inline void __mod_lruvec_page_state(struct page *page,
>                                            enum node_stat_item idx, int val)
>  {
> -       struct mem_cgroup *memcg;
> -       struct lruvec *lruvec;
> -
> -       /* Special pages in the VM aren't charged, use root */
> -       memcg = page->mem_cgroup ? : root_mem_cgroup;
> +       struct mem_cgroup_per_node *pn;
>
> -       lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
> -       __mod_lruvec_state(lruvec, idx, val);
> +       __mod_node_page_state(page_pgdat(page), idx, val);
> +       if (mem_cgroup_disabled() || !page->mem_cgroup)
> +               return;
> +       __mod_memcg_state(page->mem_cgroup, idx, val);
> +       pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
> +       __this_cpu_add(pn->lruvec_stat->count[idx], val);
>  }
>
>  static inline void mod_lruvec_page_state(struct page *page,
>                                          enum node_stat_item idx, int val)
>  {
> -       struct mem_cgroup *memcg;
> -       struct lruvec *lruvec;
> -
> -       /* Special pages in the VM aren't charged, use root */
> -       memcg = page->mem_cgroup ? : root_mem_cgroup;
> +       struct mem_cgroup_per_node *pn;
>
> -       lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
> -       mod_lruvec_state(lruvec, idx, val);
> +       mod_node_page_state(page_pgdat(page), idx, val);
> +       if (mem_cgroup_disabled() || !page->mem_cgroup)
> +               return;
> +       mod_memcg_state(page->mem_cgroup, idx, val);
> +       pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
> +       this_cpu_add(pn->lruvec_stat->count[idx], val);
>  }
>
>  unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
> --
> 2.13.0
>
>
> ----- End forwarded message -----
