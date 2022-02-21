From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 3/5] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 21 Feb 2022 14:18:25 +0100
Message-ID: <20220221131825.GA7534@blackbody.suse.cz>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-4-bigeasy@linutronix.de>
 <CALvZod4eZWVfibhxu0P0ZQ35cB=vDbde=VNeXiBZfED=k3YPOQ@mail.gmail.com>
 <YhN4BSQ1RLomLoyl@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645449507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aRXcFsOUSSMa2BGcwAaU3jThpHs0aCs0hHkKe3j5Nk0=;
        b=iSPAuStelADUpXCvEe6gFVGnj6K+QDQusZ4BDFfdwORGpDkOAjfsZiTn85OAbt4uLT9ihu
        5K++/pWtAOqwrTi2yYTl10O9i9URTzTtP5pb8q964FMvvCAgqmMRi+3wEmzFgFtfeRhbWQ
        y0ie2MMVgIl2g2HE25jHlMCQrk115Ng=
Content-Disposition: inline
In-Reply-To: <YhN4BSQ1RLomLoyl-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Mon, Feb 21, 2022 at 12:31:17PM +0100, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> What about memcg_rstat_updated()? It does:
> 
> |         x = __this_cpu_add_return(stats_updates, abs(val));
> |         if (x > MEMCG_CHARGE_BATCH) {
> |                 atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
> |                 __this_cpu_write(stats_updates, 0);
> |         }
> 
> The writes to stats_updates can happen from IRQ-context and with
> disabled preemption only. So this is not good, right?

These counters serve as a hint for aggregating per-cpu per-cgroup stats.
If they were systematically mis-updated, it could manifest by
missing "refresh signal" from the given CPU. OTOH, this lagging is also
meant to by limited by elapsed time thanks to periodic flushing.

This could affect freshness of the stats not their accuracy though.


HTH,
Michal

