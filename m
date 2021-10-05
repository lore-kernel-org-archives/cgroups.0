From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH mm v2] vmalloc: back off when the current task is
 OOM-killed
Date: Tue, 5 Oct 2021 17:00:05 +0300
Message-ID: <dd6f3cc5-70f3-4275-6458-118c463bf38a@virtuozzo.com>
References: <YVGmMSJ3NrQZjLP8@dhcp22.suse.cz>
 <83efc664-3a65-2adb-d7c4-2885784cf109@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=Ed1xsp8lTrCrW27f1J4vH57YUUHw0q5d5pOknhx3OhI=; b=dlg9oxUUL9ON2P7NI
        FPotPplwDm0pN9yRtW6uR6cImMJygenILBxuPbXKwHqwkrR4Xsm7PM70jOo1HQjb2RHaPSRAf8sNN
        43yHyfSpf5DwKO2Vlo3GxDZ1spky8JiojDNWL2JimTvGua0MPzIGIEIvEsmMJTyevyQJZawJhUsLI
        =;
In-Reply-To: <83efc664-3a65-2adb-d7c4-2885784cf109-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 10/5/21 4:52 PM, Vasily Averin wrote:
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

I briefly checked this patch together with 
 v3 memcg: prohibit unconditional exceeding the limit of dying tasks
 over v5.15-rc4.
I executed LTP on host, all oom, cgroup and memcg tests was successfully finished.
and then experimented with memcg limited LXC containers.
I did not noticed any troubles on my test node.
Thank you,
	Vasily Averin
