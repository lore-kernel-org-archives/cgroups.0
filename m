From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] mm, thp: make deferred_split_shrinker memcg-aware
Date: Fri, 20 Oct 2017 09:12:50 +0200
Message-ID: <20171020071250.ftqn2d356yekkp5k@dhcp22.suse.cz>
References: <20171019200323.42491-1-nehaagarwal@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171019200323.42491-1-nehaagarwal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neha Agarwal <nehaagarwal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Kemi Wang <kemi.wang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 19-10-17 13:03:23, Neha Agarwal wrote:
> deferred_split_shrinker is NUMA aware. Making it memcg-aware if
> CONFIG_MEMCG is enabled to prevent shrinking memory of memcg(s) that are
> not under memory pressure. This change isolates memory pressure across
> memcgs from deferred_split_shrinker perspective, by not prematurely
> splitting huge pages for the memcg that is not under memory pressure.

Why do we need this? THP pages are usually not shared between memcgs. Or
do you have a real world example where this is not the case? Your patch
is adding quite a lot of (and to be really honest very ugly) code so
there better should be a _very_ good reason to justify it. I haven't
looked very closely to the code, at least all those ifdefs in the code
are too ugly to live.
-- 
Michal Hocko
SUSE Labs
