From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 03/11] mm: shmem: do not try to uncharge known swapcache
 pages
Date: Tue, 10 Jul 2012 19:16:29 +0200
Message-ID: <20120710171628.GB29114@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-4-git-send-email-hannes@cmpxchg.org>
 <20120709144657.GF4627@tiehlicka.suse.cz>
 <alpine.LSU.2.00.1207091311300.1842@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207091311300.1842-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 09-07-12 13:37:39, Hugh Dickins wrote:
> On Mon, 9 Jul 2012, Michal Hocko wrote:
> > 
> > Maybe I am missing something but who does the uncharge from:
> > shmem_unuse
> >   mem_cgroup_cache_charge
> >   shmem_unuse_inode
> >     shmem_add_to_page_cache
> 
> There isn't any special uncharge for shmem_unuse(): once the swapcache
> page is matched up with its memcg, it will get uncharged by one of the
> usual routes to swapcache_free() when the page is freed: maybe in the
> call from __remove_mapping(), maybe when free_page_and_swap_cache()
> ends up calling it.
> 
> Perhaps you're worrying about error (or unfound) paths in shmem_unuse()?

Yes that was exactly my concern.

> By the time we make the charge, we know for sure that it's a shmem page,
> and make the charge appropriately; in racy cases it might get uncharged
> again in the delete_from_swap_cache().  Can the unfound case occur these
> days?  

I cannot find a change that would prevent from that.

> I'd have to think more deeply to answer that, but the charge will
> not go missing.
> 
> Hugh

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
