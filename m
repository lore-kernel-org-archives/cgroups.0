From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
Date: Wed, 11 Apr 2012 23:26:22 +0200
Message-ID: <20120411212621.GD24831@tiehlicka.suse.cz>
References: <1334167824-19142-1-git-send-email-glommer@parallels.com>
 <20120411132635.bfddc6bd.akpm@linux-foundation.org>
 <4F85EEED.1090906@parallels.com>
 <20120411141244.2839d9a8.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120411141244.2839d9a8.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed 11-04-12 14:12:44, Andrew Morton wrote:
> On Wed, 11 Apr 2012 17:51:57 -0300
> Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
> > On 04/11/2012 05:26 PM, Andrew Morton wrote:
> > >>
> > >> >    failed:
> > >> >  -	BUG();
> > >> >    	unlock_page(page);
> > >> >    	page_cache_release(page);
> > >> >    	return NULL;
> > > Cute.
> > >
> > > AFAICT what happened was that in my April 2002 rewrite of this code I
> > > put a non-fatal buffer_error() warning in that case to tell us that
> > > something bad happened.
> > >
> > > Years later we removed the temporary buffer_error() and mistakenly
> > > replaced that warning with a BUG().  Only it*can*  happen.
> > >
> > > We can remove the BUG() and fix up callers, or we can pass retry=1 into
> > > alloc_page_buffers(), so grow_dev_page() "cannot fail".  Immortal
> > > functions are a silly fiction, so we should remove the BUG() and fix up
> > > callers.
> > >
> > Any particular caller you are concerned with ?
> 
> Didn't someone see a buggy caller in btrfs?

No I missed that __getblk (__getblk_slow) returns NULL only if
grow_buffers < 0 while it returns 0 for the allocation failure.

Sorry for confusion.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
