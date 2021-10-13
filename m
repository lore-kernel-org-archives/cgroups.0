From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 1/2] memcg: flush stats only if updated
Date: Wed, 13 Oct 2021 20:01:30 +0200
Message-ID: <20211013180130.GB22036@blackbody.suse.cz>
References: <20211001190040.48086-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634148091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bnGWW8txEiGiwfqJHyEBYUwfb5etYjAXJP0AbtxNWE0=;
        b=PRCA6mW40Xj9Xc312LnvvnDJ6HOaWqe1Gh/O1mgyfxcbtckTD1MXC4JkbNTLPidMAV33zL
        9O2ZgrWeLF/cs8gPkqOfNTx2lLX1UkIapks1huu23KL9Aw+JEdyyx82RbnQT0mYl4jo2ln
        NZH1Lrb38EY1aKBLkY0PiX0VdchuvEY=
Content-Disposition: inline
In-Reply-To: <20211001190040.48086-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 01, 2021 at 12:00:39PM -0700, Shakeel Butt <shakeelb-hpIqsD4AKl=
fQT0dZR+AlfA@public.gmane.org> wrote:
> In this patch we kept the stats update codepath very minimal and let the
> stats reader side to flush the stats only when the updates are over a
> specific threshold.  For now the threshold is (nr_cpus * CHARGE_BATCH).

BTW, a noob question -- are the updates always single page sized?

This is motivated by apples vs oranges comparison since the
	nr_cpus * MEMCG_CHARGE_BATCH=20
suggests what could the expected error be in pages (bytes). But it's mostly
wrong since: a) uncertain single-page updates, b) various counter
updates summed together. I wonder whether the formula can serve to
provide at least some (upper) estimate.


> +static inline void memcg_rstat_updated(struct mem_cgroup *memcg)
> +{
> +	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
> +	if (!(__this_cpu_inc_return(stats_updates) % MEMCG_CHARGE_BATCH))
> +		atomic_inc(&stats_flush_threshold);
> +}

Neat trick! (I guess there are no benchmarks complaining about this
(yet)).

Overall,

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

