From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] memcg: switch lruvec stats to rstat
Date: Mon, 05 Jul 2021 13:30:21 +0800
Message-ID: <877di549aq.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20210615174435.4174364-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210615174435.4174364-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Shakeel Butt's
        message of "Tue, 15 Jun 2021 10:44:34 -0700")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, =?utf-8?Q?Michal_Kou?= =?utf-8?Q?tn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, Shakeel,

Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

> The commit 2d146aa3aa84 ("mm: memcontrol: switch to rstat") but skipped
> the conversion of the lruvec stats as such stats are read in the
> performance critical code paths and flushing stats may have impacted the
> performances of the applications. This patch converts the lruvec stats
> to rstat and later patch adds the periodic flushing of the stats and
> thus remove the need to synchronously flushing the stats in the
> performance critical code paths.
>
> The rstat conversion comes with the price i.e. memory cost. Effectively
> this patch reverts the savings done by the commit f3344adf38bd ("mm:
> memcontrol: optimize per-lruvec stats counter memory usage"). However
> this cost is justified due to negative impact of the inaccurate lruvec
> stats on many heuristics. One such case is reported in [1].
>
> The memory reclaim code is filled with plethora of heuristics and many
> of those heuristics reads the lruvec stats. So, inaccurate stats can
> make such heuristics ineffective. [1] reports the impact of inaccurate
> lruvec stats on the "cache trim mode" heuristic. Inaccurate lruvec stats
> can impact the deactivation and aging anon heuristics as well.
>
> [1] https://lore.kernel.org/linux-mm/20210311004449.1170308-1-ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

Sorry for late reply.  I have just verified that this patchset can
resolve the problem as in the above link for me.  Thanks!

Best Regards,
Huang, Ying

> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> Changes since v1:
> - no changes
>
