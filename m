From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH mm v2 3/3] mm: automatically penalize tasks with high
 swap use
Date: Thu, 14 May 2020 16:21:30 -0400
Message-ID: <20200514202130.GA591266@cmpxchg.org>
References: <20200511225516.2431921-1-kuba@kernel.org>
 <20200511225516.2431921-4-kuba@kernel.org>
 <20200512072634.GP29153@dhcp22.suse.cz>
 <20200512105536.748da94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200513083249.GS29153@dhcp22.suse.cz>
 <20200513113623.0659e4c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200514074246.GZ29153@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1meGT6deW+cm9r8U3rKE8gfgbUmpVzugGQGtQegwdek=;
        b=aKK0TMX0pk/9RwZizRVuCVDWyUUYYIdGUZsQ3V3UYrJ8W8B6lNV5sx2CubAcVsG8hc
         Rl1vSghEPrTJDWEjzRewOEZ64O38ezkj0i8OOdIkSLHJKm4G8y4aPtMAgimCBKmJrdba
         OdnwfJAENAkztepkCyRUKYWzsC7RivQaER7BnzHaQX9VRr9yF4gosz/2dYsOy9cUyVGG
         rGEXF/YJWG1AQcp0T8qDPxP2f+bS7ynZ5cTEsjnl59JjI3iTBGIExouBn/YBp6aQPzcy
         XSTTGUGO60bHVhouy90AULrVPXM1Kz4bfF2F9j04uQH3dGasqaTkzhhtpe/QuOpyyA6G
         oiOQ==
Content-Disposition: inline
In-Reply-To: <20200514074246.GZ29153-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Thu, May 14, 2020 at 09:42:46AM +0200, Michal Hocko wrote:
> On Wed 13-05-20 11:36:23, Jakub Kicinski wrote:
> > On Wed, 13 May 2020 10:32:49 +0200 Michal Hocko wrote:
> > > On Tue 12-05-20 10:55:36, Jakub Kicinski wrote:
> > > > On Tue, 12 May 2020 09:26:34 +0200 Michal Hocko wrote:  
> > > > > On Mon 11-05-20 15:55:16, Jakub Kicinski wrote:  
> > > > > > Use swap.high when deciding if swap is full.    
> > > > > 
> > > > > Please be more specific why.  
> > > > 
> > > > How about:
> > > > 
> > > >     Use swap.high when deciding if swap is full to influence ongoing
> > > >     swap reclaim in a best effort manner.  
> > > 
> > > This is still way too vague. The crux is why should we treat hard and
> > > high swap limit the same for mem_cgroup_swap_full purpose. Please
> > > note that I am not saying this is wrong. I am asking for a more
> > > detailed explanation mostly because I would bet that somebody
> > > stumbles over this sooner or later.
> > 
> > Stumbles in what way?
> 
> Reading the code and trying to understand why this particular decision
> has been made. Because it might be surprising that the hard and high
> limits are treated same here.

I don't quite understand the controversy.

The idea behind "swap full" is that as long as the workload has plenty
of swap space available and it's not changing its memory contents, it
makes sense to generously hold on to copies of data in the swap
device, even after the swapin. A later reclaim cycle can drop the page
without any IO. Trading disk space for IO.

But the only two ways to reclaim a swap slot is when they're faulted
in and the references go away, or by scanning the virtual address space
like swapoff does - which is very expensive (one could argue it's too
expensive even for swapoff, it's often more practical to just reboot).

So at some point in the fill level, we have to start freeing up swap
slots on fault/swapin. Otherwise we could eventually run out of swap
slots while they're filled with copies of data that is also in RAM.

We don't want to OOM a workload because its available swap space is
filled with redundant cache.

That applies to physical swap limits, swap.max, and naturally also to
swap.high which is a limit to implement userspace OOM for swap space
exhaustion.

> > Isn't it expected for the kernel to take reasonable precautions to
> > avoid hitting limits?
> 
> Isn't the throttling itself the precautious? How does the swap cache
> and its control via mem_cgroup_swap_full interact here. See? This is
> what I am asking to have explained in the changelog.

It sounds like we need better documentation of what vm_swap_full() and
friends are there for. It should have been obvious why swap.high - a
limit on available swap space - hooks into it.
