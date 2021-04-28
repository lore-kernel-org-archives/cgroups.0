From: Odin Ugedal <odin-lVFEcm3hDZTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] sched/fair: Fix unfairness caused by missing load decay
Date: Wed, 28 Apr 2021 15:10:22 +0200
Message-ID: <CAFpoUr1KOvLSUoUac8MMTD+TREDWmDpeku950U=_p-oBDE4Avw@mail.gmail.com>
References: <20210425080902.11854-1-odin@uged.al> <20210425080902.11854-2-odin@uged.al>
 <20210427142611.GA22056@vingu-book>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yCqiPinRq7KbHRxw2+1CXLudhDzt8HuMBSPIFpRiJPQ=;
        b=op0etC5f3iUvcNGm81crqMGzOmX3gWMXzJ1+rzIG/28W0YXHGVhDZikIUWNtLjtHcV
         N5bDI277rR4vU5GWFEoGG5TddC76vb5yoAhS5AjLe50YPBa0VSTIQCNkGP7lP70EA5Hv
         pum91yU819opegmcarW/Xkhb4kPpl34BF/gLEQUBRP5IrfDqM9nVUFrqoTYhr1qo3fZA
         Rtcw/hUDlSIljTYbcOcRo4awy0mbjxf1q+vVlTg0XEyAzEHgw7n8bmNv03Ll42cMok3m
         3CfnuCqpwzKRuyhuSLqHXPqQ3rg4wTERINUrqlNHeaT3RTloj79T+iEBFkNO+IHU/OAq
         vGtA==
In-Reply-To: <20210427142611.GA22056@vingu-book>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

> Would be good to mention that the problem happens only if the new cfs_rq has
> been removed from the leaf_cfs_rq_list because its PELT metrics were already
> null. In such case __update_blocked_fair() never updates the blocked load of
> the new cfs_rq and never propagate the removed load in the hierarchy.

Well, it does technically occur when PELT metrics were null and therefore
removed from this leaf_cfs_rq_list, that is correct. We do however not add
newly created cfs_rq's to leaf_cfs_rq_list, so that is also a reason for it
to occur. Most users of cgroups are probably creating a new cgroup and then
attaching a process to it, so I think that will be the _biggest_ issue.

> The fix tag should be :
> Fixes: 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing path")
>
> This patch re-introduced the del of idle cfs_rq from leaf_cfs_rq_list in order to
> skip useless update of blocked load.

Thanks for pointing me at that patch! A quick look makes me think that that
commit caused the issue to occur _more often_, but was not the one that
introduced it. I should probably investigate a bit more tho., since I didn't
dig that deep in it. It is not a clean revert for that patch on v5.12,
but I did apply the diff below to test. It is essentially what the patch
039ae8bcf7a5 does, as far as I see. There might however been more commits
beteen those, so I might take a look further behind to see.

Doing this does make the problem less severe, resulting in ~90/10 load on the
example that without the diff results in ~99/1. So with this diff/reverting
039ae8bcf7a5, there is still an issue.

Should I keep two "Fixes", or should I just take one of them?

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 794c2cb945f8..5fac4fbf6f84 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7941,8 +7941,8 @@ static bool __update_blocked_fair(struct rq *rq,
bool *done)
                 * There can be a lot of idle CPU cgroups.  Don't let fully
                 * decayed cfs_rqs linger on the list.
                 */
-               if (cfs_rq_is_decayed(cfs_rq))
-                       list_del_leaf_cfs_rq(cfs_rq);
+               // if (cfs_rq_is_decayed(cfs_rq))
+               //      list_del_leaf_cfs_rq(cfs_rq);

                /* Don't need periodic decay once load/util_avg are null */
                if (cfs_rq_has_blocked(cfs_rq))

> propagate_entity_cfs_rq() already goes across the tg tree to
> propagate the attach/detach.
>
> would be better to call list_add_leaf_cfs_rq(cfs_rq)  inside this function
> instead of looping twice the tg tree. Something like:
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 33b1ee31ae0f..18441ce7316c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -11026,10 +11026,10 @@ static void propagate_entity_cfs_rq(struct sched_entity *se)
>         for_each_sched_entity(se) {
>                 cfs_rq = cfs_rq_of(se);
>
> -               if (cfs_rq_throttled(cfs_rq))
> -                       break;
> +               if (!cfs_rq_throttled(cfs_rq))
> +                       update_load_avg(cfs_rq, se, UPDATE_TG);
>
> -               update_load_avg(cfs_rq, se, UPDATE_TG);
> +               list_add_leaf_cfs_rq(cfs_rq);
>         }
>  }
>  #else


Thanks for that feedback!

I did think about that, but was not sure what would be the best one.
If it is "safe" to always run list_add_leaf_cfs_rq there (since it is used in
more places than just on cgroup change and move to fair class), I do agree
that that is a better solution. Will test that, and post a new patch
if it works as expected.

Also, the current code will exit from the loop in case a cfs_rq is throttled,
while your suggestion will keep looping. For list_add_leaf_cfs_rq that is fine
(and required), but should we keep running update_load_avg? I do think it is ok,
and the likelihood of a cfs_rq being throttled is not that high after all, so
I guess it doesn't really matter.

Thanks
Odin
