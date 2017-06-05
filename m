From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/6] mm: vmstat: move slab statistics from zone to node
 counters
Date: Mon, 5 Jun 2017 14:38:31 -0700
Message-ID: <20170605143831.dac73f489bfe2644e103d2b3@linux-foundation.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
        <20170530181724.27197-3-hannes@cmpxchg.org>
        <20170531091256.GA5914@osiris>
        <20170531113900.GB5914@osiris>
        <20170531171151.e4zh7ffzbl4w33gd@yury-thinkpad>
        <87mv9s2f8f.fsf@concordia.ellerman.id.au>
        <20170605183511.GA8915@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605183511.GA8915-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Yury Norov <ynorov-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 5 Jun 2017 14:35:11 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5107,6 +5107,7 @@ static void build_zonelists(pg_data_t *pgdat)
>   */
>  static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
>  static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
> +static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
>  static void setup_zone_pageset(struct zone *zone);

There's a few kb there.  It just sits evermore unused after boot?
