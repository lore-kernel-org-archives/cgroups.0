From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
Date: Tue, 10 Jun 2014 15:16:10 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406101512340.32203@chino.kir.corp.google.com>
References: <53902A44.50005@cn.fujitsu.com> <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org> <539192F1.7050308@cn.fujitsu.com> <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com> <539574F1.2060701@cn.fujitsu.com>
 <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com> <53967465.7070908@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=Txd2YoQOeLXXr1Gkj/AkTa7PFnAhp/ni/V9jrCtHoAs=;
        b=muvcwrgb1LaB7/Ksik+V6F2H2uSCF3eUUIvOaHIN77jiKu8xsdDAc43EjLt7N7607M
         YhIq9W6oUtXh82quEUEo8cZDxQr3oIQM9xR6UmBn/IgmUc3204vam5WlV+H8IK2YD9vU
         dSSK56QfezpFEl4sBBzTKxQ/lkROUlkZU6LVjXoJrswnDmppzSB2ryO3+YIclBuKy9SZ
         ArCHd6p9ruskD1yB63rjObzCbBxunKf6X54GOM7eT8frRSEjmT9kGj3SuRDG+ZWXK5xN
         AfWFzLnyaY+E1gqMSDGSuJJjoQqmo8mV5t5R19bgNOE8gEzaoE9euPVKbKpIrpLT5LKJ
         VuiA==
In-Reply-To: <53967465.7070908-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Gu Zheng <guz.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 10 Jun 2014, Li Zefan wrote:

> > Yes, the rcu lock is not providing protection for any critical section 
> > here that requires (1) the forker's cpuset to be stored in 
> > cpuset_being_rebound or (2) the forked thread's cpuset to be rebound by 
> > the cpuset nodemask update, and no race involving the two.
> >
> 
> Yes, this is a long-standing issue. Besides the race you described, the child
> task's mems_allowed can be wrong if the cpuset's nodemask changes before the
> child has been added to the cgroup's tasklist.
> 
> I remember Tejun once said he wanted to disallow task migration between
> cgroups during fork, and that should fix this problem.
>  

Ok, I don't want to fix it in cpusets if cgroups will eventually prevent 
it, so I need an understanding of the long term plan.  Will cgroups 
continue to allow migration during fork(), Tejun?

> > It needs to be slightly rewritten to work properly without negatively 
> > impacting the latency of fork().  Do you have the cycles to do it?
> > 
> 
> Sounds you have other idea?
> 

It wouldn't be too difficult with a cgroup post fork callback into the 
cpuset code to rebind the nodemask if it has changed, but with my above 
concern those might be yanked out eventually :)
