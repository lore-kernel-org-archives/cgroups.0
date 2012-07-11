From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 03/11] mm: shmem: do not try to uncharge known swapcache
 pages
Date: Wed, 11 Jul 2012 11:48:54 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1207111118310.1797@eggly.anvils>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-4-git-send-email-hannes@cmpxchg.org> <20120709144657.GF4627@tiehlicka.suse.cz> <alpine.LSU.2.00.1207091311300.1842@eggly.anvils> <20120710171628.GB29114@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=H/jqzBn3q4PyzVJ8b3hIFw6eLtDJZG2bncqpPW0+1nw=;
        b=k1Ag8Rl08gnbaXbfrhZLTzJ0BuWdyNUax0hd6elAuuEtG1VcxPntb5HPc0WwG9s5Fd
         wsT7ElztC5Ng6Cq0oUr0F0CotzwQ+dCsgqT/jQK1/2VK2VwtvesrEQAlsogkrUath3p/
         DlOEnxb512jTyEyDlPkh0er5ra3Kruk6989yXvHm/+bCEoV6g/nMIlD/VNQpDfD9GByY
         7Xsq6oVHo0w3jJwyVVWHd8Ku4ieHNUyBrhoTsh2+VW9mgWfzBa8ICWy+17ML54KOLpfg
         2KicBzKUYa1RmdyQb7/yLv3fR0LJZs8AVuMicMJs5HSeGxWZgjIB+/N6eqqk8e36mLTX
         RxFQ==
In-Reply-To: <20120710171628.GB29114-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 10 Jul 2012, Michal Hocko wrote:
> On Mon 09-07-12 13:37:39, Hugh Dickins wrote:
> > On Mon, 9 Jul 2012, Michal Hocko wrote:
> > > 
> > > Maybe I am missing something but who does the uncharge from:
> > > shmem_unuse
> > >   mem_cgroup_cache_charge
> > >   shmem_unuse_inode
> > >     shmem_add_to_page_cache
> > 
> > There isn't any special uncharge for shmem_unuse(): once the swapcache
> > page is matched up with its memcg, it will get uncharged by one of the
> > usual routes to swapcache_free() when the page is freed: maybe in the
> > call from __remove_mapping(), maybe when free_page_and_swap_cache()
> > ends up calling it.
> > 
> > Perhaps you're worrying about error (or unfound) paths in shmem_unuse()?
> 
> Yes that was exactly my concern.
> 
> > By the time we make the charge, we know for sure that it's a shmem page,
> > and make the charge appropriately; in racy cases it might get uncharged
> > again in the delete_from_swap_cache().  Can the unfound case occur these
> > days?  
> 
> I cannot find a change that would prevent from that.

Yes.

> 
> > I'd have to think more deeply to answer that, but the charge will
> > not go missing.

Yes, the unfound case certainly can still occur these days.  It's very
similar to the race with truncation/eviction which shmem_unuse_inode()
already allows for (-ENOENT from shmem_add_to_page_cache()).  In that
"error" case, the swap entry got removed after we found it in the
file's radix tree, before we get to replace it there.  Whereas in the
"unfound" case, the swap entry got removed from the file's radix tree
before we even found it there, so we haven't a clue which file it ever
belonged to.

But it doesn't matter.  We have charged the memcg (the original memcg if
memsw is enabled, or swapoff's own if memsw is disabled), and the charge
is redundant now that the page has been truncated; but it's a common
occurrence with swapcache (most common while PageWriteback or PageLocked)
that the swap and charge cannot be released immediately, and it sorts
itself out under pressure once the page reaches the bottom of the
inactive anon and __remove_mapping()'s swapcache_free().

The worst of it is misleading stats meanwhile; but SwapCache has
always been tiresome that way (duplicated in memory and on swap).

The crucial change with regard to unfound entries was back in 2.6.33,
when we added SWAP_MAP_SHMEM: prior to that, we didn't know in advance
if the swap belonged to shmem or to task, and had to be more careful
about when we charge.

Hugh
