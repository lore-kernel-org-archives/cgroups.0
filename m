From: Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 10/23] slab/slub: struct memcg_params
Date: Mon, 30 Apr 2012 12:42:28 -0700
Message-ID: <CABCjUKDKwJMZioQPBwdiN-SUOW7VQkkBajwbKHUCSz1sdM6dQQ@mail.gmail.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com>
	<1334959051-18203-11-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=XNI4u2S0bcnbQ+p1hU2ibJnIaONgQMJonK1b0g4/lsg=;
        b=jMJmSVRaooAzXj8CJ/V2Tw9rv19albQ+wwWyGZ7Sg4xdIL98sswg6lkraNKrUui3Gz
         aHhZjVYkvs/9luqhnrX+ztELMJLlRrI0iuyZ3foRZ5PH89734J+xx0UHbqaz8lh/79FX
         LIaHe1tp5RhmWum/oOVXMcfePGICTUnuvUjY3KgRy1qVKt3bDy2257LdinUuXGveivsV
         p4gmjZj8zXXgsLlu66X46AHj/UOBUNOBdJ4BfNmBDWt+YXndS1dUX8fyDG4pH1ZQ433/
         IvzWsX+rcxlrAs+FuHLpqAlccrHRrwwqQ2eHtacSuOvf3zjfNQe3Z0jsr+0spLgOJj/o
         aaUA==
In-Reply-To: <1334959051-18203-11-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>, Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, Apr 20, 2012 at 2:57 PM, Glauber Costa <glommer@parallels.com> wrot=
e:
> For the kmem slab controller, we need to record some extra
> information in the kmem_cache structure.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>
> ---
> =A0include/linux/slab.h =A0 =A0 | =A0 15 +++++++++++++++
> =A0include/linux/slab_def.h | =A0 =A04 ++++
> =A0include/linux/slub_def.h | =A0 =A03 +++
> =A03 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index a595dce..a5127e1 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -153,6 +153,21 @@ unsigned int kmem_cache_size(struct kmem_cache *);
> =A0#define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
> =A0#endif
>
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +struct mem_cgroup_cache_params {
> + =A0 =A0 =A0 struct mem_cgroup *memcg;
> + =A0 =A0 =A0 int id;
> +
> +#ifdef CONFIG_SLAB
> + =A0 =A0 =A0 /* Original cache parameters, used when creating a memcg ca=
che */
> + =A0 =A0 =A0 size_t orig_align;
> + =A0 =A0 =A0 atomic_t refcnt;
> +
> +#endif
> + =A0 =A0 =A0 struct list_head destroyed_list; /* Used when deleting cpus=
et cache */

s,cpuset,memcg,

Sorry about that.

-- Suleiman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
