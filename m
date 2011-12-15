From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch v3] oom, memcg: fix exclusion of memcg threads after
 they have detached their mm
Date: Fri, 16 Dec 2011 07:18:55 +0900
Message-ID: <20111216071855.25abd0ad.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.DEB.2.00.1112131659100.32369@chino.kir.corp.google.com>
	<20111214102942.GA11786@tiehlicka.suse.cz>
	<alpine.DEB.2.00.1112141838470.27595@chino.kir.corp.google.com>
	<20111215155926.GA22819@tiehlicka.suse.cz>
	<alpine.DEB.2.00.1112151335370.17878@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1112151335370.17878-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, 15 Dec 2011 13:36:11 -0800 (PST)
David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> The oom killer relies on logic that identifies threads that have already
> been oom killed when scanning the tasklist and, if found, deferring until
> such threads have exited.  This is done by checking for any candidate
> threads that have the TIF_MEMDIE bit set.
> 
> For memcg ooms, candidate threads are first found by calling
> task_in_mem_cgroup() since the oom killer should not defer if there's an
> oom killed thread in another memcg.
> 
> Unfortunately, task_in_mem_cgroup() excludes threads if they have
> detached their mm in the process of exiting so TIF_MEMDIE is never
> detected for such conditions.  This is different for global, mempolicy,
> and cpuset oom conditions where a detached mm is only excluded after
> checking for TIF_MEMDIE and deferring, if necessary, in
> select_bad_process().
> 
> The fix is to return true if a task has a detached mm but is still in the
> memcg or its hierarchy that is currently oom.  This will allow the oom
> killer to appropriately defer rather than kill unnecessarily or, in the
> worst case, panic the machine if nothing else is available to kill.
> 
> Acked-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
