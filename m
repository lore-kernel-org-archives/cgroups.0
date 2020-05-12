From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v2 1/3] mm: prepare for swap over-high accounting and
 penalty calculation
Date: Tue, 12 May 2020 10:28:19 -0700
Message-ID: <20200512102819.4858a60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200511225516.2431921-1-kuba@kernel.org>
        <20200511225516.2431921-2-kuba@kernel.org>
        <20200512070858.GO29153@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589304502;
        bh=1p6BnnVdA+O7XO+1OEIQ+R7NdNbgDqC3c6zfHthSp6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GbmmbJ9PguPY/A4f4QbueuezRI1+jd98ZVdzclvgkFeb6uc4RlSMcCjD5qOtNdQJb
         5vspDSdmmn+dCdTXnGLRfJ+IOfciS3uR3+KBs8wtuTUFKMt3BA3ACws/5DE1Xm3FHc
         pS5QQ1RuxSAXbSfJl7VRA2b01Ey8EerSWtK5eb94=
In-Reply-To: <20200512070858.GO29153-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Tue, 12 May 2020 09:08:58 +0200 Michal Hocko wrote:
> On Mon 11-05-20 15:55:14, Jakub Kicinski wrote:
> > Slice the memory overage calculation logic a little bit so we can
> > reuse it to apply a similar penalty to the swap. The logic which
> > accesses the memory-specific fields (use and high values) has to
> > be taken out of calculate_high_delay().
> > 
> > Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> some recommendations below.

Thank you!

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 05dcb72314b5..8a9b671c3249 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2321,41 +2321,48 @@ static void high_work_func(struct work_struct *work)
> >   #define MEMCG_DELAY_PRECISION_SHIFT 20
> >   #define MEMCG_DELAY_SCALING_SHIFT 14
> >  
> > -/*
> > - * Get the number of jiffies that we should penalise a mischievous cgroup which
> > - * is exceeding its memory.high by checking both it and its ancestors.
> > - */
> > -static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
> > -					  unsigned int nr_pages)
> > +static u64 calculate_overage(unsigned long usage, unsigned long high)  
> 
> the naming is slightly confusing. I would concider the return value
> to be in memory units rather than time because I would read it as
> overrage of high. calculate_throttle_penalty would be more clear to me.

Hm. The unit is the fraction of high. Here is the code, it's quite hard
to read in diff form (I should have used --histogram, sorry):

static u64 calculate_overage(unsigned long usage, unsigned long high)
{
	u64 overage;

	if (usage <= high)
		return 0;

	/*
	 * Prevent division by 0 in overage calculation by acting as if
	 * it was a threshold of 1 page
	 */
	high = max(high, 1UL);

	overage = usage - high;
	overage <<= MEMCG_DELAY_PRECISION_SHIFT;
	return div64_u64(overage, high);
}

calculate_throttle_penalty() sounds like it returns time. How about
something like calc_overage_frac() ? Or calc_overage_perc()?
(abbreviating to "calc" so the caller fits on a line)
