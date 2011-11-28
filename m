From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 1/8] mm: oom_kill: remove memcg argument from oom_kill_task()
Date: Mon, 28 Nov 2011 06:07:17 +0530
Message-ID: <CAKTCnzmfk5O24R2Lh08e-WgA75TtTaO11vZjJOnPXxHhThX-XA@mail.gmail.com>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=XHI9IvJ+stkCSgELufvL0tFRey4NkRqr1ziNxxhArrc=;
        b=ittzrxLlW05Y3GjvRHjzV10fJtPvt04EBLNJBTEX3ZMqcQyC+XYseypQmDTdtCsuxi
         PZNQP73hMN/Bne6/3VJX6WGPiy2qV099PQg6igbdBf8PrZw4oelpqxXYvi1SmnuK5ipx
         zRIjjfb/xSKP6/Pa/MLpKdSP15k3gP/rqXiYA=
In-Reply-To: <1322062951-1756-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> w=
rote:
>
> From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> The memcg argument of oom_kill_task() hasn't been used since 341aea2
> 'oom-kill: remove boost_dying_task_prio()'. =A0Kill it.
>
> Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0mm/oom_kill.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 471dedb..fd9e303 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -423,7 +423,7 @@ static void dump_header(struct task_struct *p, gf=
p_t gfp_mask, int order,
> =A0}
>
> =A0#define K(x) ((x) << (PAGE_SHIFT-10))
> -static int oom_kill_task(struct task_struct *p, struct mem_cgroup *m=
em)
> +static int oom_kill_task(struct task_struct *p)
> =A0{
> =A0 =A0 =A0 =A0struct task_struct *q;
> =A0 =A0 =A0 =A0struct mm_struct *mm;
> @@ -522,7 +522,7 @@ static int oom_kill_process(struct task_struct *p=
, gfp_t gfp_mask, int order,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0} while_each_thread(p, t);
>
> - =A0 =A0 =A0 return oom_kill_task(victim, mem);
> + =A0 =A0 =A0 return oom_kill_task(victim);
> =A0}
>

Looks good!

Balbir Singh
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
