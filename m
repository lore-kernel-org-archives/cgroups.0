From: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Thu, 26 Jan 2023 15:14:25 -0300
Message-ID: <Y9LDAZmApLeffrT8@tpad>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674758236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gGHM4HTnlAbJdDikf/52fslq7b3KLZl+rEC55qRtjz8=;
        b=JSjITrknLTtsu+ihWn04jkGS+x8UN7nKj6sQVv7+Kn3eN/e4jRX+dBh9npwzFAUXmomLzv
        VdXYLORfXQUNoAsZc4luvsXEBkwjFThJrBwQQohJr3ZX4D2j9omdWVlJz4ZJz4Vfbpoa6W
        AgHGZeD+aWwsiOOEnoOA+3SA4n8RL5c=
Content-Disposition: inline
In-Reply-To: <Y9IvoDJbLbFcitTc-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 26, 2023 at 08:45:36AM +0100, Michal Hocko wrote:
> On Wed 25-01-23 15:22:00, Marcelo Tosatti wrote:
> [...]
> > Remote draining reduces interruptions whether CPU 
> > is marked as isolated or not:
> > 
> > - Allows isolated CPUs from benefiting of pcp caching.
> > - Removes the interruption to non isolated CPUs. See for example 
> > 
> > https://lkml.org/lkml/2022/6/13/2769
> 
> This is talking about page allocato per cpu caches, right? In this patch
> we are talking about memcg pcp caches. Are you sure the same applies
> here?

Both can stall the users of the drain operation.

"Minchan Kim tested this independently and reported;

	My workload is not NOHZ CPUs but run apps under heavy memory
	pressure so they goes to direct reclaim and be stuck on
	drain_all_pages until work on workqueue run."

Therefore using a workqueue to drain memcg pcps also depends on the 
remote CPU executing that work item in time (which can stall
the following). No?

===

   7   3141  mm/memory.c <<wp_page_copy>>
             if (mem_cgroup_charge(page_folio(new_page), mm, GFP_KERNEL))
   8   4118  mm/memory.c <<do_anonymous_page>>
             if (mem_cgroup_charge(page_folio(page), vma->vm_mm, GFP_KERNEL))
   9   4577  mm/memory.c <<do_cow_fault>>
             if (mem_cgroup_charge(page_folio(vmf->cow_page), vma->vm_mm,
  10    621  mm/migrate_device.c <<migrate_vma_insert_page>>
             if (mem_cgroup_charge(page_folio(page), vma->vm_mm, GFP_KERNEL))
  11    710  mm/shmem.c <<shmem_add_to_page_cache>>
             error = mem_cgroup_charge(folio, charge_mm, gfp);

