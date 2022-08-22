From: Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for low/min
Date: Sun, 21 Aug 2022 20:20:14 -0400
Message-ID: <CACSApvbSnCN8Fy1E3KyhkBDF=_h4vg==eoJGzM1Njf0ArX+zcg@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=itKnzEEgxdRanMi9GUPBS95li3Z7do6JuAGWEAWhYEg=;
        b=guVICWeqFQ8c3vdR8GBUuEyOVA0+5EO5OmTjHqWEu6VFAbXZCzD8du432ghmvYgJhQ
         RvhjnmWNjHAres1/WFOa7u85aN+wL7vVAGauR2TkbUDtfiEBAXM8d8woD4OK3YR4i9By
         ROoju+R4k73Q8z6CL8yQaelkmRtkkt2ChGCPVsaia6rbwlV4wz6sduV7nkHR4czQ01aV
         nTYqLzKSWXx8g3YTHTp1n3tr3K0/HL5bsdRB9fZYGzYXdMycMvI6WQgC+dNqstFVupCb
         Dr7SNfpCd7U3oIUkjp6zD1NCoV474OmknfhA3jNoJFdCbarhzlTJZXkn6gHjiS5kG4O4
         fcTQ==
In-Reply-To: <20220822001737.4120417-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Aug 21, 2022 at 8:17 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> For cgroups using low or min protections, the function
> propagate_protected_usage() was doing an atomic xchg() operation
> irrespectively. It only needs to do that operation if the new value of
> protection is different from older one. This patch does that.
>
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy with top
> level having min and low setup appropriately. More specifically
> memory.min equal to size of netperf binary and memory.low double of
> that.
>
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
>
> Results (average throughput of netperf):
> Without (6.0-rc1)       10482.7 Mbps
> With patch              14542.5 Mbps (38.7% improvement)
>
> With the patch, the throughput improved by 38.7%
>
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Nice speed up!

Acked-by: Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  mm/page_counter.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index eb156ff5d603..47711aa28161 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
>                                       unsigned long usage)
>  {
>         unsigned long protected, old_protected;
> -       unsigned long low, min;
>         long delta;
>
>         if (!c->parent)
>                 return;
>
> -       min = READ_ONCE(c->min);
> -       if (min || atomic_long_read(&c->min_usage)) {
> -               protected = min(usage, min);
> +       protected = min(usage, READ_ONCE(c->min));
> +       old_protected = atomic_long_read(&c->min_usage);
> +       if (protected != old_protected) {
>                 old_protected = atomic_long_xchg(&c->min_usage, protected);
>                 delta = protected - old_protected;
>                 if (delta)
>                         atomic_long_add(delta, &c->parent->children_min_usage);
>         }
>
> -       low = READ_ONCE(c->low);
> -       if (low || atomic_long_read(&c->low_usage)) {
> -               protected = min(usage, low);
> +       protected = min(usage, READ_ONCE(c->low));
> +       old_protected = atomic_long_read(&c->low_usage);
> +       if (protected != old_protected) {
>                 old_protected = atomic_long_xchg(&c->low_usage, protected);
>                 delta = protected - old_protected;
>                 if (delta)
> --
> 2.37.1.595.g718a3a8f04-goog
>
