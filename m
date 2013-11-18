From: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 18 Nov 2013 11:30:56 +0100
Message-ID: <CAJ75kXamrtQz5-cYS7tYtYeP1ZLf2pzSE7UnEPpyORzpG3BASg@mail.gmail.com>
References: <5270BFE7.4000602@huawei.com> <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home> <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home> <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com> <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com> <20131107235301.GB1092@cmpxchg.org> <20131108001437.GC1092@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=h6CsOdWhfj+hzjSn8zCjjokMYEl/j3LBMfyob392PhE=;
        b=MZQYxG7gOyFGM3fwpmWmqxZPrP8KvkO7Kv/ClzPCy7waS7j5O2oE+5wuQJOrU7Ux6J
         qaCLlB4Yygm2Mq18RZVyP6yPYhlUttqCY3Etiy35NqpeVAI50frAaXkcw2IR2UwE9iys
         HllEq8QomgfMN/ToF5n2N5bnDjj7dg1lzoWzoodDlKAaNSiy/Ue9/5Iu4u34nXcsR6UL
         7bdau7LF5glmstedLv2LUJ9d3oPaD8TBgSCH0c3jS5WSJkC3fvNCzJ7WnaQF1FFqnoCY
         m50I6yz97PLMdeIWwEiVUutouvuZI6kSOvf79QYX69elgqutlOeWMquqrbLZuslRvfLJ
         KqrQ==
In-Reply-To: <20131108001437.GC1092-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Johannes,

On Fri, Nov 8, 2013 at 1:14 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> So how about this?

this patch seems to fix my issue I reported you some weeks ago with a
oom looping issue.
Tested on a 3.10.x

> ---
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Subject: [patch] mm: memcg: reparent charges during css_free()
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org # 3.8+
> ---
>  mm/memcontrol.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index cc4f9cbe760e..3dce2b50891c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6341,7 +6341,34 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  {
>         struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> -
> +       /*
> +        * XXX: css_offline() would be where we should reparent all
> +        * memory to prepare the cgroup for destruction.  However,
> +        * memcg does not do css_tryget() and res_counter charging
> +        * under the same RCU lock region, which means that charging
> +        * could race with offlining, potentially leaking charges and
> +        * sending out pages with stale cgroup pointers:
> +        *
> +        * #0                        #1
> +        *                           rcu_read_lock()
> +        *                           css_tryget()
> +        *                           rcu_read_unlock()
> +        * disable css_tryget()
> +        * call_rcu()
> +        *   offline_css()
> +        *     reparent_charges()
> +        *                           res_counter_charge()
> +        *                           css_put()
> +        *                             css_free()
> +        *                           pc->mem_cgroup = dead memcg
> +        *                           add page to lru
> +        *
> +        * We still reparent most charges in offline_css() simply
> +        * because we don't want all these pages stuck if a long-term
> +        * reference like a swap entry is holding on to the cgroup
> +        * past offlining, but make sure we catch any raced charges:
> +        */
> +       mem_cgroup_reparent_charges(memcg);
>         memcg_destroy_kmem(memcg);
>         __mem_cgroup_free(memcg);
>  }
> --
> 1.8.4.2


-- 
William
