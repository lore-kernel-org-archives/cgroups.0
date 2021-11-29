From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Mon, 29 Nov 2021 14:39:43 +0100
Message-ID: <YaTYH67jSNWqYySF@dhcp22.suse.cz>
References: <YZ8DZHERun6Fej2P@casper.infradead.org>
 <20211125080238.GA7356@haolee.io>
 <YZ9e3pzHKmn5nev0@dhcp22.suse.cz>
 <20211125123133.GA7758@haolee.io>
 <YZ+bI1fNpKar0bSU@dhcp22.suse.cz>
 <CA+PpKP=hsuBmvv09OcD2Nct8B8Cqa03UfKFHAHzKxwE0SXGP4g@mail.gmail.com>
 <YaC7BcTSijFj+bxR@dhcp22.suse.cz>
 <20211126162623.GA10277@haolee.io>
 <YaSRtKwTCOj7JnR6@dhcp22.suse.cz>
 <YaTUR9WcGoOG4oLo@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638193184; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MCR2AjsamUOBWBaNMd3hj2AgMrYiQAsklcYI7+6tUNc=;
        b=BF5tF/zTTzcePDATMm5ORv0aj2GjCP5cOtzN4OFHtX5kugS+UYnnvq8iIVlAj5+YX67rPU
        N1SgE1s+MKgLvYeBKJBG8FmbAW4++jm4NgeKnbZN6iYGUrq+j+PdCSs94+YaVrVmeD8r6p
        9pOiWBR86RlkVMXhKlBclXTwMIayApg=
Content-Disposition: inline
In-Reply-To: <YaTUR9WcGoOG4oLo-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 29-11-21 13:23:19, Matthew Wilcox wrote:
> On Mon, Nov 29, 2021 at 09:39:16AM +0100, Michal Hocko wrote:
> > On Fri 26-11-21 16:26:23, Hao Lee wrote:
> > [...]
> > > I will try Matthew's idea to use semaphore or mutex to limit the number of BE
> > > jobs that are in the exiting path. This sounds like a feasible approach for
> > > our scenario...
> > 
> > I am not really sure this is something that would be acceptable. Your
> > problem is resource partitioning. Papering that over by a lock is not
> > the right way to go. Besides that you will likely hit a hard question on
> > how many tasks to allow to run concurrently. Whatever the value some
> > workload will very likely going to suffer. We cannot assume admin to
> > chose the right value because there is no clear answer for that. Not to
> > mention other potential problems - e.g. even more priority inversions
> > etc.
> 
> I don't see how we get priority inversions.  These tasks are exiting; at
> the point they take the semaphore, they should not be holding any locks.
> They're holding a resource (memory) that needs to be released, but a
> task wanting to acquire memory must already be prepared to sleep.

At least these scenarios come to mind
- a task being blocked by other lower priority tasks slowly tearing down
  their address space - essentially a different incarnation of the same
  problem this is trying to handle
- a huge memory backed task waiting many for smaller ones to finish
- waste of resources on properly partitioned systems. Why should
  somebody block tasks when they are acting on different lruvecs and
  cpus?

-- 
Michal Hocko
SUSE Labs
