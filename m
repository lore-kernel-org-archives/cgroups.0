From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Fri, 31 May 2013 03:22:59 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com> <20130530150539.GA18155@dhcp22.suse.cz> <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com> <20130531081052.GA32491@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=kElAcLiGTi74/j2p8/Y4Ykt3bCQDD3F8IzMWhmGSSrs=;
        b=nCUOGRgXj2DlFGXOsNTGCdlWCJonIMJZfTsy6v7OCT7c6JwsZKFCpF2Dc9Brf1zYLH
         0vklcIguSjmt4YvrfiS+BXyemHgW4usWFDZxLRf3QnY8MycMPsAR2rczgKuGoK3YM0gz
         ICicgKizho8c56aygjT1tqxVeC6sxuRgfUbqBpxXE+gBBoO0y3vNPM6I1vWAQ/vV+c+2
         pH69nuLw/zhpT/Xe5QcIApH4suzKuR0O4wuzXneYrnzC08p3WtcrIZShWBNqYGTld1Sk
         XfdZnV8754T6YXnuOo7yRdqy9943SKzm4352MJgUVEvtcqB4u4JDPolSGqVxVA+mPwoX
         fBNA==
In-Reply-To: <20130531081052.GA32491-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 31 May 2013, Michal Hocko wrote:

> I have always discouraged people from running oom handler in the same
> memcg (or even in the same hierarchy).
> 

We allow users to control their own memcgs by chowning them, so they must 
be run in the same hierarchy if they want to run their own userspace oom 
handler.  There's nothing in the kernel that prevents that and the user 
has no other option but to run in a parent cgroup.

> Yes, mmap_sem is tricky. Nothing in the proc code should take it for
> writing and charges are done with mmap_sem held for reading but that
> doesn't prevent from non-oom thread to try to get it for writing which
> would block also all future readers. We have also seen i_mutex being
> held during charge so you have to be careful about that one as well but
> I am not aware of other locks that could be a problem.
> 
> The question is, do you really need to open any /proc/<pid>/ files which
> depend on mmap_sem (e.g. maps, smaps). /proc/<pid>/status should tell you
> about used memory. Or put it another way around. What kind of data you
> need for your OOM handler?
> 

It's too easy to simply do even a "ps ax" in an oom memcg and make that 
thread completely unresponsive because it allocates memory.

> I might be thinking about different use cases but user space OOM
> handlers I have seen so far had quite a good idea what is going on
> in the group and who to kill.

Then perhaps I'm raising constraints that you've never worked with, I 
don't know.  We choose to have a priority-based approach that is inherited 
by children; this priority is kept in userspace and and the oom handler 
would naturally need to know the set of tasks in the oom memcg at the time 
of oom and their parent-child relationship.  These priorities are 
completely independent of memory usage.

> > If the oom notifier is in the oom cgroup, it may not be able to       
> > successfully read the memcg "tasks" file to even determine the set of 
> > eligible processes.
> 
> It would have to use preallocated buffer and have mlocked all the memory
> that will be used during oom event.
> 

Wrong, the kernel itself allocates memory when reading this information 
and that would fail in an oom memcg.
