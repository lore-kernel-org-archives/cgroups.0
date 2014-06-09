From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
Date: Mon, 9 Jun 2014 02:13:57 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com>
References: <53902A44.50005@cn.fujitsu.com> <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org> <539192F1.7050308@cn.fujitsu.com> <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com> <539574F1.2060701@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=JVE4oZl+oVuYZgx4eqxhT1I/iNcpMDPgLA/U5TJMlN4=;
        b=MDAelVtPiVSrdNv3JquPPVQ7ZGZkeGk+FTYvHKlho4k4TGd72Y6r03b6lc2Jz5frWZ
         bxRLodppQHwd1q2qz6CWTUKybE3CY1r/wFMMfJnQsuA70VghYmugUGo3NMUboFO5/ypi
         phGX2e2aYZe3PEU9Pib09ouZvCybJzOT1IparSByrQsptVHMdelFRR0JFEOcTDnEzW1m
         RMhyeCWdB/X+4VIkCBzUV3W6QARhWIZewtUcyfO96BMXmbrReldWqRCDWMSCoqyVLwQE
         1v2AYO7fh83JCIwhr816xJVXxhzGKUuOXqEembjyZfi2CK9nz926f7umyYDzqJ5Gn8ey
         wo5w==
In-Reply-To: <539574F1.2060701@cn.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>, stable@vger.kernel.org, Li Zefan <lizefan@huawei.com>

On Mon, 9 Jun 2014, Gu Zheng wrote:

> > I think your patch addresses the problem that you're reporting but misses 
> > the larger problem with cpuset.mems rebinding on fork().  When the 
> > forker's task_struct is duplicated (which includes ->mems_allowed) and it 
> > races with an update to cpuset_being_rebound in update_tasks_nodemask() 
> > then the task's mems_allowed doesn't get updated.
> 
> Yes, you are right, this patch just wants to address the bug reported above.
> The race condition you mentioned above inherently exists there, but it is yet
> another issue, the rcu lock here makes no sense to it, and I think we need
> additional sync-mechanisms if want to fix it.

Yes, the rcu lock is not providing protection for any critical section 
here that requires (1) the forker's cpuset to be stored in 
cpuset_being_rebound or (2) the forked thread's cpuset to be rebound by 
the cpuset nodemask update, and no race involving the two.

> But thinking more, though the current implementation has flaw, but I worry
> about the negative effect if we really want to fix it. Or maybe the fear
> is unnecessary.:) 
> 

It needs to be slightly rewritten to work properly without negatively 
impacting the latency of fork().  Do you have the cycles to do it?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
