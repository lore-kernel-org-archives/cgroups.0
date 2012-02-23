From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] memcg kernel memory tracking
Date: Thu, 23 Feb 2012 10:18:22 -0800
Message-ID: <CALWz4izD0Ykx8YJWVoECk7jdBLTxSm1vXOjKfkAgUaUVv2FkJw@mail.gmail.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=28YotxkfGv6yhps+PlwBMAR1jdNPtgdEVkxmZRfrz0Q=;
        b=xlQwohCD62S7xzKzjqWwHgb1ul9683YCBIf1YwaeyhqHB2EupIvekMaR/1EWC3drgP
         pRmuc9wPsei6qM9KQKWamEBoGsLnWn5Ys6YsjekInmwVZgkjMOf9QHnku01xhm+DeI3N
         UeS3VqkboxvcngW+SA7n91QRyuk92KAlSANew=
In-Reply-To: <1329824079-14449-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Feb 21, 2012 at 3:34 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> This is a first structured approach to tracking general kernel
> memory within the memory controller. Please tell me what you think.
>
> As previously proposed, one has the option of keeping kernel memory
> accounted separatedly, or together with the normal userspace memory.
> However, this time I made the option to, in this later case, bill
> the memory directly to memcg->res. It has the disadvantage that it be=
comes
> complicated to know which memory came from user or kernel, but OTOH,
> it does not create any overhead of drawing from multiple res_counters
> at read time. (and if you want them to be joined, you probably don't =
care)

Keeping one counter for user and kernel pages makes it easier for
admins to configure the system. About reporting, we should still
report the user and kernel memory separately. It will be extremely
useful when diagnosing the system like heavily memory pressure or OOM.

> Kernel memory is never tracked for the root memory cgroup. This means
> that a system where no memory cgroups exists other than the root, the
> time cost of this implementation is a couple of branches in the slub
> code - none of them in fast paths. At the moment, this works only
> with the slub.
>
> At cgroup destruction, memory is billed to the parent. With no hierar=
chy,
> this would mean the root memcg. But since we are not billing to that,
> it simply ceases to be tracked.
>
> The caches that we want to be tracked need to explicit register into
> the infrastructure.

It would be hard to let users to register which slab to track
explicitly. We should track them all in general, even with the ones
without shrinker, we want to understand how much is used by which
cgroup.

--Ying

>
> If you would like to give it a try, you'll need one of Frederic's pat=
ches
> that is used as a basis for this
> (cgroups: ability to stop res charge propagation on bounded ancestor)
>
> Glauber Costa (7):
> =A0small cleanup for memcontrol.c
> =A0Basic kernel memory functionality for the Memory Controller
> =A0per-cgroup slab caches
> =A0chained slab caches: move pages to a different cache when a cache =
is
> =A0 =A0destroyed.
> =A0shrink support for memcg kmem controller
> =A0track dcache per-memcg
> =A0example shrinker for memcg-aware dcache
>
> =A0fs/dcache.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0136 ++++++++++++++=
+++-
> =A0include/linux/dcache.h =A0 =A0 | =A0 =A04 +
> =A0include/linux/memcontrol.h | =A0 35 +++++
> =A0include/linux/shrinker.h =A0 | =A0 =A04 +
> =A0include/linux/slab.h =A0 =A0 =A0 | =A0 12 ++
> =A0include/linux/slub_def.h =A0 | =A0 =A03 +
> =A0mm/memcontrol.c =A0 =A0 =A0 =A0 =A0 =A0| =A0344 ++++++++++++++++++=
+++++++++++++++++++++++++-
> =A0mm/slub.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0237 ++++++++++++=
++++++++++++++++---
> =A0mm/vmscan.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 60 ++++++++-
> =A09 files changed, 806 insertions(+), 29 deletions(-)
>
> --
> 1.7.7.6
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org =A0For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthem=
eter.ca/
> Don't email: <a href=3Dmailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
