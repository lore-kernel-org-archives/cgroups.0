From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] mm: Identify compound pages sooner in
 isolate_migratepages_block
Date: Fri, 14 Aug 2020 15:20:05 +0800
Message-ID: <76f64f08-e2c7-9862-5e7f-6251032735f0@linux.alibaba.com>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
 <20200813040240.13054.76770.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200813040240.13054.76770.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

It has a slight performance drop too...

Thanks
Alex

在 2020/8/13 下午12:02, Alexander Duyck 写道:
> Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  mm/compaction.c |   33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
