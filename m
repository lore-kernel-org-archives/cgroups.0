From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Mon, 15 Oct 2012 23:12:31 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210152311460.9480@chino.kir.corp.google.com>
References: <1350367837-27919-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=KdsXnfxlqMY2U6ZAbPzb3HmQD8c8jQH0YU/VqfEImco=;
        b=h/Wm7yGhWYQ/R9b1Zf4W+mwp2hwKpje2KjlZ04DMNd80pJmoc96Uvsx810S3HHsLNV
         +Oj1fsBAvaX4YxRuAlBDUXEk28Poi9pWkw8lLnysNZ7WvlG1n31LIwF7dfIAmIL/hAjA
         6xbfui7j2QpZMjrp5xcXp2bhuJ+QdKpIwRV+tTMpoFwjKNBNk8s1Ly7WAGJfr8+2ggk0
         F0pq5OBv4VQ7cUseKDBWh5HQxtv6Rm+z3G4zxqd8GwPf2YRZpbYtEyJBlw4HOxkFvt8o
         4CPrGGWCKT8QP+bY91U/Rcp9SPge9AjONDnOdRKXetmcwFMvr6sswCusO/HLv6eXrein
         R1RA==
In-Reply-To: <1350367837-27919-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 16 Oct 2012, Sha Zhengju wrote:

> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
> task in out-of-memory situations, but it only works on overall system-wide oom.
> But it's also a useful indication in memcg so we take it into consideration
> while oom happening in memcg. Other sysctl such as panic_on_oom has already
> been memcg-ware.
> 

You're working on an old kernel, mem_cgroup_out_of_memory() has moved to 
mm/memcontrol.c.  Please rebase on 3.7-rc1 and send an updated patch, 
which otherwise looks good.
