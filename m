From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: rework inactive_ratio logic
Date: Tue, 21 Feb 2012 15:01:25 +0400
Message-ID: <4F437985.7060005@openvz.org>
References: <20120215162442.13588.21790.stgit@zurg> <20120221101825.GA1676@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=8ykoBvF+pjLie9vGEleCj+DQUPDvZLaKdPpa60Vs7yU=;
        b=HIs102YHMop7Q4IggCfBSta6FYvEi2OsG6VCXuVfGeS3q+gcOsntYHBJ9YEW72PPy3
         LTuUYHlshRAGEqdgb0IGh/f2sQC3SKkz/B9V42RECJ7VRlO3Nipvz5+q4+00KC+RNCKz
         NKH9Wr5Gi7fPR0dV81FAW7ri8IyH8B9pOgi5Q=
In-Reply-To: <20120221101825.GA1676-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Johannes Weiner wrote:
> On Wed, Feb 15, 2012 at 08:24:42PM +0400, Konstantin Khlebnikov wrote:
>> This patch adds mem_cgroup->inactive_ratio calculated from hierarchical memory limit.
>> It updated at each limit change before shrinking cgroup to this new limit.
>> Ratios for all child cgroups are updated too, because parent limit can affect them.
>> Update precedure can be greatly optimized if its performance becomes the problem.
>> Inactive ratio for unlimited or huge limit does not matter, because we'll never hit it.
>>
>> At global reclaim always use global ratio from zone->inactive_ratio.
>> At mem-cgroup reclaim use inactive_ratio from target memory cgroup,
>> this is cgroup which hit its limit and cause this reclaimer invocation.
>>
>> Thus, global memory reclaimer will try to keep ratio for all lru lists in zone
>> above one mark, this guarantee that total ratio in this zone will be above too.
>> Meanwhile mem-cgroup will do the same thing for its lru lists in all zones, and
>> for all lru lists in all sub-cgroups in hierarchy.
>>
>> Also this patch removes some redundant code.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>
> I don't think we should take the zone ratio when we then proceed to
> scan a bunch of LRU lists that could individually be much smaller than
> the zone.  Especially since the ratio function is not a linear one.
>
> Otherwise the target ratios can be way too big for small lists, see
> the comment above mm/page_alloc.c::calculate_zone_inactive_ratio().
>
> Consequently, I also disagree on using sc->target_mem_cgroup.
>
> This whole mechanism is about balancing one specific pair of inactive
> vs. an active list according their size.  We shouldn't derive policy
> from numbers that are not correlated to this size.

Ok, maybe then we can move this inactive_ratio calculation right into
inactive_anon_is_low(). Then we can kill precalculated zone->inactive_ratio
and calculate it every time, even in non-memcg case, because zone-size also
not always correlate with anon lru size.
Looks like int_sqrt() is fast enough for this.
