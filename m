From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] Revert "mm: memcontrol: avoid workload stalls when
 lowering memory.high"
Date: Fri, 22 Jan 2021 11:52:03 -0800
Message-ID: <20210122195203.GA150782@carbon.dhcp.thefacebook.com>
References: <20210122184341.292461-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=GMYOkqyoO/vq7SaP26fB4RE24TheJ12GDjxPk0mdcvw=;
 b=WT8eYVGcEOr7IpxOr1sq2iS1W1yXvB97XCEVxwGkWoPz4T6x36G6jMpXhIo3tiudLZpB
 ju8cUAwKwN7HLhrmW7iF973oyxNFsN38uuV1OILCS7pz8+tkStMBg5nBOVtoFNF8SWnV
 z/5CsDjv6lVDlgWZ/5KxyPl1nudth/4fmhE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMYOkqyoO/vq7SaP26fB4RE24TheJ12GDjxPk0mdcvw=;
 b=W/7iV3tUp5W5Qg205uabbpD48JRtuHv6QNqhoGp9lVsfbbA5DZ5futVt9NDNIeI+Ha2un4po1RsboOsWpqLVtIiPa3E03rvIsBjTslMUO/WH+pkVXsB6Y9hiPbik/KBPPBJRawPznNJfPUrHO2YfPpj5HGuNBqMyi1DQMELz5tM=
Content-Disposition: inline
In-Reply-To: <20210122184341.292461-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jan 22, 2021 at 01:43:41PM -0500, Johannes Weiner wrote:
> This reverts commit 536d3bf261a2fc3b05b3e91e7eef7383443015cf, as it
> can cause writers to memory.high to get stuck in the kernel forever,
> performing page reclaim and consuming excessive amounts of CPU cycles.
> 
> Before the patch, a write to memory.high would first put the new limit
> in place for the workload, and then reclaim the requested delta. After
> the patch, the kernel tries to reclaim the delta before putting the
> new limit into place, in order to not overwhelm the workload with a
> sudden, large excess over the limit. However, if reclaim is actively
> racing with new allocations from the uncurbed workload, it can keep
> the write() working inside the kernel indefinitely.
> 
> This is causing problems in Facebook production. A privileged
> system-level daemon that adjusts memory.high for various workloads
> running on a host can get unexpectedly stuck in the kernel and
> essentially turn into a sort of involuntary kswapd for one of the
> workloads. We've observed that daemon busy-spin in a write() for
> minutes at a time, neglecting its other duties on the system, and
> expending privileged system resources on behalf of a workload.
> 
> To remedy this, we have first considered changing the reclaim logic to
> break out after a couple of loops - whether the workload has converged
> to the new limit or not - and bound the write() call this way.
> However, the root cause that inspired the sequence change in the first
> place has been fixed through other means, and so a revert back to the
> proven limit-setting sequence, also used by memory.max, is preferable.
> 
> The sequence was changed to avoid extreme latencies in the workload
> when the limit was lowered: the sudden, large excess created by the
> limit lowering would erroneously trigger the penalty sleeping code
> that is meant to throttle excessive growth from below. Allocating
> threads could end up sleeping long after the write() had already
> reclaimed the delta for which they were being punished.
> 
> However, erroneous throttling also caused problems in other scenarios
> at around the same time. This resulted in commit b3ff92916af3 ("mm,
> memcg: reclaim more aggressively before high allocator throttling"),
> included in the same release as the offending commit. When allocating
> threads now encounter large excess caused by a racing write() to
> memory.high, instead of entering punitive sleeps, they will simply be
> tasked with helping reclaim down the excess, and will be held no
> longer than it takes to accomplish that. This is in line with regular
> limit enforcement - i.e. if the workload allocates up against or over
> an otherwise unchanged limit from below.
> 
> With the patch breaking userspace, and the root cause addressed by
> other means already, revert it again.
> 
> Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 5.8+
> Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
