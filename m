From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix occasional OOMs due to proportional
 memory.low reclaim
Date: Mon, 23 Aug 2021 18:09:29 +0200
Message-ID: <YSPIOZOVG2qplLIW@blackbook>
References: <20210817180506.220056-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629734970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4eFiPUzslOJAtwIAy5T1boXHUjZS+B3BFncyco1H9t0=;
        b=NquIf+8HHYFommojg9qouyGn7kgUzV1xmNACFJshhh9se3FdrIE5O4RaqMolDjBC5qJXP+
        RdQ/9+JCgPxmJgZPlLeOLSnW5XB1Au8FPrJdcsY8lpb+3zyuNQQ2LIHB36CbjdSeGkwG8F
        6qgCzo2IBMVEZ4s1MHEi8GO28hWMb9k=
Content-Disposition: inline
In-Reply-To: <20210817180506.220056-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello

(and sorry for a belated reply).

On Tue, Aug 17, 2021 at 02:05:06PM -0400, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> @@ -2576,6 +2578,15 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
> [...]
> +			/* memory.low scaling, make sure we retry before OOM */
> +			if (!sc->memcg_low_reclaim && low > min) {
> +				protection = low;
> +				sc->memcg_low_skipped = 1;

IIUC, this won't result in memory.events:low increment although the
effect is similar (breaching (partial) memory.low protection) and signal
to the user is comparable (overcommited memory.low).

Admittedly, this patch's behavior adheres to the current documentation
(Documentation/admin-guide/cgroup-v2.rst):

> The number of times the cgroup is reclaimed due to high memory
> pressure even though its usage is under the low boundary,

however, that definition might not be what the useful indicator would
be now.
Is it worth including these partial breaches into memory.events:low?

Regards,
Michal
