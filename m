From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Tue, 19 Oct 2021 13:30:06 +0300
Message-ID: <687bf489-f7a7-5604-25c5-0c1a09e0905b@virtuozzo.com>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
 <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
 <YW1gRz0rTkJrvc4L@dhcp22.suse.cz>
 <339ae4b5-6efd-8fc2-33f1-2eb3aee71cb2@virtuozzo.com>
 <YW6GoZhFUJc1uLYr@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=foWliLIfpQWzapm4jJyfpBLdUGM8c6MljuN+v8bBOMc=; b=HdOLW0+VUbhUAxYyo
        xFMPtfsWVBp7UcoRg/Zyv+rg7ln267R85lA7sDQe4R3blKbiQDbiviad9ir7keWF83BPjZ9eXkR5a
        bfXlJDPi5jOXZ9Kh+XwmYPvarrYj3wU4HWh9bCk1K/JcHXJQiSdnyiJkUl6iPplUlxMovK5UQCd24
        =;
In-Reply-To: <YW6GoZhFUJc1uLYr-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 19.10.2021 11:49, Michal Hocko wrote:
> On Tue 19-10-21 09:30:18, Vasily Averin wrote:
> [...]
>> With my patch ("memcg: prohibit unconditional exceeding the limit of dying tasks") try_charge_memcg() can fail:
>> a) due to fatal signal
>> b) when mem_cgroup_oom -> mem_cgroup_out_of_memory -> out_of_memory() returns false (when select_bad_process() found nothing)
>>
>> To handle a) we can follow to your suggestion and skip excution of out_of_memory() in pagefault_out_of memory()
>> To handle b) we can go to retry: if mem_cgroup_oom() return OOM_FAILED.

> How is b) possible without current being killed? Do we allow remote
> charging?

out_of_memory for memcg_oom
 select_bad_process
  mem_cgroup_scan_tasks
   oom_evaluate_task
    oom_badness

        /*
         * Do not even consider tasks which are explicitly marked oom
         * unkillable or have been already oom reaped or the are in
         * the middle of vfork
         */
        adj = (long)p->signal->oom_score_adj;
        if (adj == OOM_SCORE_ADJ_MIN ||
                        test_bit(MMF_OOM_SKIP, &p->mm->flags) ||
                        in_vfork(p)) {
                task_unlock(p);
                return LONG_MIN;
        }

This time we handle userspace page fault, so we cannot be kenrel thread,
and cannot be in_vfork().
However task can be marked as oom unkillable, 
i.e. have p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN

It can be set via oom_score_adj_write().

Thank you,
	Vasily Averin
