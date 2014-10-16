From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 3/3] kernel: res_counter: remove the unused API
Date: Thu, 16 Oct 2014 10:46:41 -0400
Message-ID: <20141016144641.GC9180@phnom.home.cmpxchg.org>
References: <1413251163-8517-1-git-send-email-hannes@cmpxchg.org>
 <1413251163-8517-4-git-send-email-hannes@cmpxchg.org>
 <1413444034.2128.27.camel@x220>
 <20141016112021.GC338@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141016112021.GC338-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Valentin Rothberg <valentinrothberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 16, 2014 at 01:20:21PM +0200, Michal Hocko wrote:
> On Thu 16-10-14 09:20:34, Paul Bolle wrote:
> > On Mon, 2014-10-13 at 21:46 -0400, Johannes Weiner wrote:
> > > All memory accounting and limiting has been switched over to the
> > > lockless page counters.  Bye, res_counter!
> > > 
> > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > Acked-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > > Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > 
> > This patch landed in today's linux-next (ie, next 20141016).
> > 
> > >  Documentation/cgroups/resource_counter.txt | 197 -------------------------
> > >  include/linux/res_counter.h                | 223 -----------------------------
> > >  init/Kconfig                               |   6 -
> > >  kernel/Makefile                            |   1 -
> > >  kernel/res_counter.c                       | 211 ---------------------------
> > >  5 files changed, 638 deletions(-)
> > >  delete mode 100644 Documentation/cgroups/resource_counter.txt
> > >  delete mode 100644 include/linux/res_counter.h
> > >  delete mode 100644 kernel/res_counter.c
> > 
> > There's a last reference to CONFIG_RESOURCE_COUNTERS in
> > Documentation/cgroups/memory.txt. That reference could be dropped too,
> > couldn't it?
> ---
> From a54e375e85c814199f480cb4ee7a133a395c5a00 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Date: Thu, 16 Oct 2014 13:15:24 +0200
> Subject: [PATCH] kernel-res_counter-remove-the-unused-api-fix
> 
> ditch the last remainings of res_counter
> 
> Reported-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

That makes sense, although that document is still littered with
out-of-date and seemingly irrelevant information, which is why I
didn't bother to update it.  But your patch is still an improvement,
we should merge it.

Thanks!
