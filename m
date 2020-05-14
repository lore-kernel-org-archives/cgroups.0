From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v2 3/3] mm: automatically penalize tasks with high
 swap use
Date: Thu, 14 May 2020 09:42:46 +0200
Message-ID: <20200514074246.GZ29153@dhcp22.suse.cz>
References: <20200511225516.2431921-1-kuba@kernel.org>
 <20200511225516.2431921-4-kuba@kernel.org>
 <20200512072634.GP29153@dhcp22.suse.cz>
 <20200512105536.748da94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200513083249.GS29153@dhcp22.suse.cz>
 <20200513113623.0659e4c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200513113623.0659e4c4-CbGlpYbfshD2+ikPA6JUzH8MC5kE+Go+7OQnqPW8cmTNHmdVIy2bbWItS4zQEDct@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed 13-05-20 11:36:23, Jakub Kicinski wrote:
> On Wed, 13 May 2020 10:32:49 +0200 Michal Hocko wrote:
> > On Tue 12-05-20 10:55:36, Jakub Kicinski wrote:
> > > On Tue, 12 May 2020 09:26:34 +0200 Michal Hocko wrote:  
> > > > On Mon 11-05-20 15:55:16, Jakub Kicinski wrote:  
> > > > > Use swap.high when deciding if swap is full.    
> > > > 
> > > > Please be more specific why.  
> > > 
> > > How about:
> > > 
> > >     Use swap.high when deciding if swap is full to influence ongoing
> > >     swap reclaim in a best effort manner.  
> > 
> > This is still way too vague. The crux is why should we treat hard and
> > high swap limit the same for mem_cgroup_swap_full purpose. Please
> > note that I am not saying this is wrong. I am asking for a more
> > detailed explanation mostly because I would bet that somebody
> > stumbles over this sooner or later.
> 
> Stumbles in what way?

Reading the code and trying to understand why this particular decision
has been made. Because it might be surprising that the hard and high
limits are treated same here.

> Isn't it expected for the kernel to take reasonable precautions to
> avoid hitting limits?

Isn't the throttling itself the precautious? How does the swap cache
and its control via mem_cgroup_swap_full interact here. See? This is
what I am asking to have explained in the changelog.

[...]
> > > > I would also suggest to explain or ideally even separate the swap
> > > > penalty scaling logic to a seprate patch. What kind of data it is
> > > > based on?  
> > > 
> > > It's a hard thing to get production data for since, as we mentioned
> > > we don't expect the limit to be hit. It was more of a process of
> > > experimentation and finding a gradual slope that "felt right"...
> > > 
> > > Is there a more scientific process we can follow here? We want the
> > > delay to be small at first for a first few pages and then grow to
> > > make sure we stop the task from going too much over high. The square
> > > function works pretty well IMHO.  
> > 
> > If there is no data to showing this to be an improvement then I would
> > just not add an additional scaling factor. Why? Mostly because once we
> > have it there it would be extremely hard to change. MM is full of
> > these little heuristics that are copied over because nobody dares to
> > touch them. If a different scaling is really needed it can always be
> > added later with some data to back that.
> 
> Oh, I misunderstood the question, you were asking about the scaling
> factor.. The allocation of swap is in larger batches, according to 
> my tests, example below (AR - after reclaim, swap overage changes 
> after memory reclaim). 
>                                     mem overage AR
>      swap pages over_high AR        |    swap overage AR
>  swap pages over at call.   \       |    |      . mem sleep
>    mem pages over_high.  \   \      |    |     /  . swap sleep
>                        v  v   v     v    v    v  v
>  [   73.360533] sleep (32/10->67) [-35|13379] 0+253
>  [   73.631291] sleep (32/ 3->54) [-18|13430] 0+205
>  [   73.851629] sleep (32/22->35) [-20|13443] 0+133
>  [   74.021396] sleep (32/ 3->60) [-29|13500] 0+230
>  [   74.263355] sleep (32/28->79) [-44|13551] 0+306
>  [   74.585689] sleep (32/29->91) [-17|13627] 0+355
>  [   74.958675] sleep (32/27->79) [-31|13679] 0+311
>  [   75.293021] sleep (32/29->86) [ -9|13750] 0+344
>  [   75.654218] sleep (32/22->72) [-24|13800] 0+290
>  [   75.962467] sleep (32/22->73) [-39|13865] 0+296
> 
> That's for a process slowly leaking memory. Swap gets over the high by
> about 2.5x MEMCG_CHARGE_BATCH on average. Hence to keep the same slope
> I was trying to scale it back.
> 
> But you make a fair point, someone more knowledgeable can add the
> heuristic later if it's really needed.

Or just make it a separate patch with all that information. This would
allow anybody touching that code in the future to understand the initial
motivation.

I am still not sure this scaling is a good fit in general (e.g. how does
it work with THP swapping?) though but this can be discussed separately
at least.

-- 
Michal Hocko
SUSE Labs
