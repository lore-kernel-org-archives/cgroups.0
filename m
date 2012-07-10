From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/5] mm, oom: move declaration for mem_cgroup_out_of_memory
 to oom.h
Date: Tue, 10 Jul 2012 14:05:00 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1207101404470.12399@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=v0O3PkPtYf9BVJbNzdkIr6kgOfvfBK31k5BPwOcOyWM=;
        b=HwGQ3MpIh2udE+sQFMFiS5ET4pLxh3Nw5K2oQoGmr2srI70nQA8323jt52v7eViQvu
         GUyye1w6ohMkxQDzEPZb2evEzTdwFJSwqHqeOJ1iaEqcAd6TugCxyBFl8zjR7iszMx32
         wUZtaomJRJ4b5jq+7H0SVc09ruIuz62bZWM3WsnpzZCtfu3XwTRtHrr8BdLaaprmTYga
         MMhQzHo+LGraq1RkAlLkAMyj05xpEHRoAoxHIPrr86EYFiowTPzEYkptnJjFOZv+G2l2
         QBR+8KnUkCgfdkSDm21yaa94Vtv/Pa2+/2hHk6qTQ1MpKUm2hq1EmRgJugklFxiFUrA/
         IvqQ==
In-Reply-To: <alpine.DEB.2.00.1206291404530.6040-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 29 Jun 2012, David Rientjes wrote:

> mem_cgroup_out_of_memory() is defined in mm/oom_kill.c, so declare it in
> linux/oom.h rather than linux/memcontrol.h.
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Ping on this patchset?
