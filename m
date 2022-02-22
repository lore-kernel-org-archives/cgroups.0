From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/6] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 21 Feb 2022 21:41:08 -0800
Message-ID: <CALvZod7DfxHp+_NenW+NY81WN_Li4kEx4rDodb2vKhpC==sd5g@mail.gmail.com>
References: <20220221182540.380526-1-bigeasy@linutronix.de> <20220221182540.380526-4-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DF/LA0DJAyi2WkgDraeDPTQYetYLIgsh4V0sksoNxzk=;
        b=pauzJMJQ80pndaDK1GCL00PrQYlmURkbBHxp5EYP4alcPDhwEYiE3PGsaVWmuzwyx8
         yDc0O6G+EKinFKPyAVhHXNSWWrlhN5V6Nwj10pGm1+cZoXVlCcqVfw2Z8kWDsFCJ1lKp
         V9ijY5loDbTA2wnRyzF2T9aP/i6DiUxCLLzqoJb90HxytGV6d6/guf58n+b4D1CMiQfJ
         deQRBEHB14gFWu+UocLv+P81SyQ/l/ay467CP/26OKI2k7cl1Xn2yTH2Adb+0VxKm39a
         1EffzbbcUUiJsLSjNtqEP0lDEuk9j4lx6X6bqQITLpdzcIG9peoaS+FN+4kfPi7x6fYc
         DZGA==
In-Reply-To: <20220221182540.380526-4-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Mon, Feb 21, 2022 at 10:26 AM Sebastian Andrzej Siewior
<bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
>
[...]
> +       /*
> +        * The caller from rmap relay on disabled preemption becase they never
> +        * update their counter from in-interrupt context. For these two
> +        * counters we check that the update is never performed from an
> +        * interrupt context while other caller need to have disabled interrupt.
> +        */
> +       __memcg_stats_lock();
> +       if (IS_ENABLED(CONFIG_DEBUG_VM)) {
> +               if (idx == NR_ANON_MAPPED || idx == NR_FILE_MAPPED)

NR_ANON_THPS, NR_SHMEM_PMDMAPPED, NR_FILE_PMDMAPPED are missing and
the switch statement would be cleaner.
