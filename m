From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Skip high limit check in root memcg
Date: Tue, 21 Feb 2023 13:20:40 +0100
Message-ID: <Y/S3GHT1P6awZaPb@dhcp22.suse.cz>
References: <20230210094550.5125-1-haifeng.xu@shopee.com>
 <Y+uvRKo7OQ02yB4K@dhcp22.suse.cz>
 <82918a12-d83e-10c0-0e04-eec26657b699@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676982041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/pPOmc8J5hAf3q/Y/a2xOjxE2qyO5NAgOlot5by34Ug=;
        b=adl9zF7FVIFwpy3FfqrYyQsmS9buTCDOWREiOShNzNSX0CYhpOpkj3xO5TJ1AXk4kAuLH0
        hp1NMsbo2avX4LWssvzErTPnTmd+Zy/5gjp8cHBmPNi1xQTu1KEDcBftGHrkifubfkmcdr
        2kg5PI9mVnEJqSPTP2JpokFwFimJWug=
Content-Disposition: inline
In-Reply-To: <82918a12-d83e-10c0-0e04-eec26657b699-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 21-02-23 18:29:39, Haifeng Xu wrote:
> 
> 
> On 2023/2/14 23:56, Michal Hocko wrote:
> > On Fri 10-02-23 09:45:50, Haifeng Xu wrote:
> >> The high limit checks the memory usage from given memcg to root memcg.
> >> However, there is no limit in root memcg. So this check makes no sense
> >> and we can ignore it.
> > 
> > Is this check actually addining any benefit? Have you measured aby
> > performance gains by this change?
> > 
> >> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> >> ---
> >>  mm/memcontrol.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 73afff8062f9..a31a56598f29 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -2780,6 +2780,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >>  	do {
> >>  		bool mem_high, swap_high;
> >>  
> >> +		/* There is no need for root memcg to check high limit */
> >> +		if (mem_cgroup_is_root(memcg))
> >> +			break;
> >> +
> >>  		mem_high = page_counter_read(&memcg->memory) >
> >>  			READ_ONCE(memcg->memory.high);
> >>  		swap_high = page_counter_read(&memcg->swap) >
> >> -- 
> >> 2.25.1
> > 
> 
> test steps:
> 1. mkdir -p /sys/fs/cgroup/memory/test
> 2. echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
> 3. ./mmap_test
> 
> The test result show that with or without the patch, the time taken is almost the same.

This is in line with my expectation. So the question is whether the
additional check is really worth it. 
-- 
Michal Hocko
SUSE Labs
