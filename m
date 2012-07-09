From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 00/11] mm: memcg: charge/uncharge improvements
Date: Mon, 9 Jul 2012 17:35:24 +0200
Message-ID: <20120709153524.GO4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1341449103-1986-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 05-07-12 02:44:52, Johannes Weiner wrote:
> Hello,
> 
> the biggest thing is probably #1, no longer trying (and failing) to
> charge replacement pages during migration and thus compaction.  The
> rest is cleanups and tiny optimizations that move some checks out of
> the charge and uncharge core paths that do not apply to all types of
> pages alike.

Nice clean up Johannes.
Thanks!

> 
>  include/linux/memcontrol.h |   11 +--
>  mm/memcontrol.c            |  205 +++++++++++++++++++++++---------------------
>  mm/migrate.c               |   27 ++-----
>  mm/shmem.c                 |   11 ++-
>  mm/swapfile.c              |    3 +-
>  5 files changed, 124 insertions(+), 133 deletions(-)
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
