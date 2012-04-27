From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
Date: Fri, 27 Apr 2012 11:13:31 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1204271110370.28516@chino.kir.corp.google.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com> <20120424142232.GC8626@somewhere>
 <alpine.DEB.2.00.1204241319360.753@chino.kir.corp.google.com> <20120427113841.GB3514@somewhere.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=zi1J09xKDX40r/st0E2+Xlt3jqa6/RCNZLepTmw2AK8=;
        b=SbbwUhGY1Zf7IFvQwsIQ/uoLbebuANu6uW2GLb8114cnBuLAMiZWL4ASO4Ac1n5lEY
         v33+A+cn33BThFQL8NRMJPNh7mp/YEXesA/uM4Q1zOKIlIJ7kleRYxmfRxW+P6RGS/FO
         A5DErZrVE67D1qCk+dAlKUUQhapzmQjyvuicZXSike8KN7vqjyedu3416laDMh08QVt3
         lKclWxt1qM9WG0CDQsELqI8MPOHYSO2h+t1InDfT81X/NZFVJPNSleXoLgXCB2n8U/81
         U/M3zxYUXVnNTmzKqNlmj9Tp04x+ZQKWk/uFKvta5HGNDl1p1P1uFs64d5/7WrJsXUYY
         2THg==
In-Reply-To: <20120427113841.GB3514-oHC15RC7JGTpAmv0O++HtFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Fri, 27 Apr 2012, Frederic Weisbecker wrote:

> > No, because memory is represented by mm_struct, not task_struct, so you 
> > must charge to p->mm->owner to allow for moving threads amongst memcgs 
> > later for memory.move_charge_at_immigrate.  You shouldn't be able to 
> > charge two different memcgs for memory represented by a single mm.
> 
> The idea I had was more that only the memcg of the thread that does the allocation
> is charged. But the problem is that this allocation can be later deallocated
> from another thread. So probably charging the owner is indeed the only sane
> way to go with user memory.
> 

It's all really the same concept: if we want to move memory of a process, 
willingly free memory in the process itself, or free memory of a process 
by way of the oom killer, we need a way to do that for the entire process 
so the accounting makes sense afterwards.  And since we have that 
requirement for user memory, it makes sense that its consistent with slab 
as well.  I don't think a thread of a process should be able to charge 
slab to one memcg while its user memory is charged to another memcg.
