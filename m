From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH mm v2] vmalloc: back off when the current task is
 OOM-killed
Date: Thu, 7 Oct 2021 12:55:41 -0700
Message-ID: <20211007125541.db0f3ff2bdbd8fa7dc1db03d@linux-foundation.org>
References: <YVGmMSJ3NrQZjLP8@dhcp22.suse.cz>
        <83efc664-3a65-2adb-d7c4-2885784cf109@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633636542;
        bh=l66xkvwo5JDJqPQgPip89gZwXEOnO407CqbFPpfYp94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NSeYGN3XXLrQYf0fPcCt6hWBohOXv+xiotZkcXFQ7+M4XEPsvno7qUvSzhInEfkdm
         na9gMTTn3OoaSGuNFnHSOIEs1c+kqJVJe+nyBfC4krIYIcGU/spgPCxbMvUP/9futO
         kEDwoSwwNI8UT31HhqEGNTNN+DhPwAyl8Aej+Ruo=
In-Reply-To: <83efc664-3a65-2adb-d7c4-2885784cf109-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, 5 Oct 2021 16:52:40 +0300 Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:

> Huge vmalloc allocation on heavy loaded node can lead to a global
> memory shortage. Task called vmalloc can have worst badness and
> be selected by OOM-killer, however taken fatal signal does not
> interrupt allocation cycle. Vmalloc repeat page allocaions
> again and again, exacerbating the crisis and consuming the memory
> freed up by another killed tasks.
> 
> After a successful completion of the allocation procedure, a fatal
> signal will be processed and task will be destroyed finally.
> However it may not release the consumed memory, since the allocated
> object may have a lifetime unrelated to the completed task.
> In the worst case, this can lead to the host will panic
> due to "Out of memory and no killable processes..."
> 
> This patch allows OOM-killer to break vmalloc cycle, makes OOM more
> effective and avoid host panic. It does not check oom condition directly,
> however, and breaks page allocation cycle when fatal signal was received.
> 
> This may trigger some hidden problems, when caller does not handle
> vmalloc failures, or when rollaback after failed vmalloc calls own
> vmallocs inside. However all of these scenarios are incorrect:
> vmalloc does not guarantee successful allocation, it has never been called
> with __GFP_NOFAIL and threfore either should not be used for any rollbacks
> or should handle such errors correctly and not lead to critical
> failures.
> 

This needed a little rework due to
https://lkml.kernel.org/r/20210928121040.2547407-1-chenwandun-hv44wF8Li92Xj1p+fO2waQ@public.gmane.org
Please check and retest sometime?

--- a/mm/vmalloc.c~vmalloc-back-off-when-the-current-task-is-oom-killed
+++ a/mm/vmalloc.c
@@ -2887,6 +2887,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 
 	page = NULL;
 	while (nr_allocated < nr_pages) {
+		if (fatal_signal_pending(current))
+			break;
+
 		if (nid == NUMA_NO_NODE)
 			page = alloc_pages(gfp, order);
 		else
_

