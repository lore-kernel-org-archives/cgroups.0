From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Date: Fri, 23 Mar 2012 10:45:57 +0100
Message-ID: <20120323094557.GA5123@tiehlicka.suse.cz>
References: <4F69A4C4.4080602@jp.fujitsu.com>
 <20120322143610.e4df49c9.akpm@linux-foundation.org>
 <4F6BC166.80407@jp.fujitsu.com>
 <20120322173000.f078a43f.akpm@linux-foundation.org>
 <4F6BC94C.80301@jp.fujitsu.com>
 <20120323085301.GA1739@cmpxchg.org>
 <4F6C3BB2.6090108@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F6C3BB2.6090108-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org" <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Fri 23-03-12 18:00:34, KAMEZAWA Hiroyuki wrote:
> (2012/03/23 17:53), Johannes Weiner wrote:
> 
> > On Fri, Mar 23, 2012 at 09:52:28AM +0900, KAMEZAWA Hiroyuki wrote:
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index b2ee6df..ca8b3a1 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -5147,7 +5147,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
> >>  		return NULL;
> >>  	if (PageAnon(page)) {
> >>  		/* we don't move shared anon */
> >> -		if (!move_anon() || page_mapcount(page) > 2)
> >> +		if (!move_anon())
> >>  			return NULL;
> >>  	} else if (!move_file())
> >>  		/* we ignore mapcount for file pages */
> >> @@ -5158,26 +5158,32 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
> >>  	return page;
> >>  }
> >>  
> >> +#ifdef CONFFIG_SWAP
> > 
> > That will probably disable it for good :)
> > 
> 
> 
> Thank you for your good eyes.. I feel I can't trust my eyes ;(
> 
> 
> ==
> From d7ed385bad22d352bb28aeb9380591b72ec5bec5 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Date: Wed, 21 Mar 2012 19:03:40 +0900
> Subject: [PATCH] memcg: fix/change behavior of shared anon at moving task.
> 
> This patch changes memcg's behavior at task_move().
> 
> At task_move(), the kernel scans a task's page table and move
> the changes for mapped pages from source cgroup to target cgroup.

charges?

> There has been a bug at handling shared anonymous pages for a long time.
> 
> Before patch:
>   - The spec says 'shared anonymous pages are not moved.'
>   - The implementation was 'shared anonymoys pages may be moved'.
>     If page_mapcount <=2, shared anonymous pages's charge were moved.
> 
> After patch:
>   - The spec says 'all anonymous pages are moved'.
>   - The implementation is 'all anonymous pages are moved'.
> 
> Considering usage of memcg, this will not affect user's experience.
> 'shared anonymous' pages only exists between a tree of processes
> which don't do exec(). Moving one of process without exec() seems
> not sane. 

Why it wouldn't be sane?

> For example, libcgroup will not be affected by this change.
> (Anyway, no one noticed the implementation for a long time...)
> 
> Below is a discussion log:
> 
>  - current spec/implementation are complex
>  - Now, shared file caches are moved
>  - It adds unclear check as page_mapcount(). To do correct check,
>    we should check swap users, etc.
>  - No one notice this implementation behavior. So, no one get benefit
>    from the design.
>  - In general, once task is moved to a cgroup for running, it will not
>    be moved....
>  - Finally, we have control knob as memory.move_charge_at_immigrate.
> 
> Here is a patch to allow moving shared pages, completely. This makes
> memcg simpler and fix current broken code.
> 
> Changelog:
>   - fixed CONFFIG_SWAP...
> Changelog:
>   - fixed comment around find_get_page()
>   - changed CONFIG_SWAP handling
>   - updated patch description

Anyway the patch looks good to me and I agree that we should make anon
moving easier.
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> 
> Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  Documentation/cgroups/memory.txt |    9 ++++-----
>  include/linux/swap.h             |    9 ---------
>  mm/memcontrol.c                  |   22 ++++++++++++++--------
>  mm/swapfile.c                    |   31 -------------------------------
>  4 files changed, 18 insertions(+), 53 deletions(-)
> 
[...]
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
