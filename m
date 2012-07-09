From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 11/11] mm: memcg: only check anon swapin page charges
 for swap cache
Date: Mon, 09 Jul 2012 12:44:30 +0900
Message-ID: <4FFA539E.70805@jp.fujitsu.com>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-12-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341449103-1986-12-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/07/05 9:45), Johannes Weiner wrote:
> shmem knows for sure that the page is in swap cache when attempting to
> charge a page, because the cache charge entry function has a check for
> it.  Only anon pages may be removed from swap cache already when
> trying to charge their swapin.
> 
> Adjust the comment, though: '4969c11 mm: fix swapin race condition'
> added a stable PageSwapCache check under the page lock in the
> do_swap_page() before calling the memory controller, so it's
> unuse_pte()'s pte_same() that may fail.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

