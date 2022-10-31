From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Mon, 31 Oct 2022 22:09:15 +0800
Message-ID: <Y1/XC+witPxFj04T@feng-clx>
References: <Y1kl8VbPE0RYdyEB@feng-clx>
 <Y1lZV6qHp3gIINGc@dhcp22.suse.cz>
 <87wn8lkbk5.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1ou5DGHrEsKnhri@dhcp22.suse.cz>
 <87o7txk963.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1o63SWD2KmQkT3v@dhcp22.suse.cz>
 <87fsf9k3yg.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1p5vaN1AWhpNWZx@dhcp22.suse.cz>
 <87bkpwkg24.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1+J7+1V1nJXF+3b@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667225388; x=1698761388;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TTF9pvuSA4wR17Q7wTPTvuXU+LnqoHqiUaB2Zn6irYE=;
  b=I4p+nPoAbJX+XF49fxZN3j/gdvtPH2sl8e/ebzTu9IvIuJW409Xm8O0c
   L5lo43mHFws9z8LXdHr/Cj8NIFvAY1e2QjeVGFlR/c2roV6nKkbbBTRpN
   FiuWK64hcK1LBcbZBKUIUA3p090t15OB17niZSrxOyBJWDzMF4a08hmX6
   uuRGHOjh9I/bIyirey5RW2b1b8CJ+qdBqHFxMl0hEB5spEnLO3FXBQTtD
   6tGNJL0nj2cnWSD4vz+SKeEBvPeOaJh6lhp6GueTuw7xI5t96YbaOpJDM
   b82xyxcyHaN4P5TQD/G4ubvDt9pckC0+QrFbRUPz5do4VXq5tq26cwmed
   w==;
Content-Disposition: inline
In-Reply-To: <Y1+J7+1V1nJXF+3b-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, Oct 31, 2022 at 04:40:15PM +0800, Michal Hocko wrote:
> On Fri 28-10-22 07:22:27, Huang, Ying wrote:
> > Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
> > 
> > > On Thu 27-10-22 17:31:35, Huang, Ying wrote:
> [...]
> > >> I think that it's possible for different processes have different
> > >> requirements.
> > >> 
> > >> - Some processes don't care about where the memory is placed, prefer
> > >>   local, then fall back to remote if no free space.
> > >> 
> > >> - Some processes want to avoid cross-socket traffic, bind to nodes of
> > >>   local socket.
> > >> 
> > >> - Some processes want to avoid to use slow memory, bind to fast memory
> > >>   node only.
> > >
> > > Yes, I do understand that. Do you have any specific examples in mind?
> > > [...]
> > 
> > Sorry, I don't have specific examples.
> 
> OK, then let's stop any complicated solution right here then. Let's
> start simple with a per-mm flag to disable demotion of an address space.
> Should there ever be a real demand for a more fine grained solution
> let's go further but I do not think we want a half baked solution
> without real usecases.

Yes, the concern about the high cost for mempolicy from you and Yang is
valid. 

How about the cpuset part? We've got bug reports from different channels
about using cpuset+docker to control meomry placement in memory tiering
system, leading to 2 commits solving them:

2685027fca38 ("cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in
cpuset_init_smp()") 
https://lore.kernel.org/all/20220419020958.40419-1-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

8ca1b5a49885 ("mm/page_alloc: detect allocation forbidden by cpuset and
bail out early")
https://lore.kernel.org/all/1632481657-68112-1-git-send-email-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

From these bug reports, I think it's reasonable to say there are quite
some real world users using cpuset+docker+memory-tiering-system. So
I plan to refine the original cpuset patch with some optimizations
discussed (like checking once for kswapd based shrink_folio_list()).

Thanks,
Feng

> -- 
> Michal Hocko
> SUSE Labs
> 
