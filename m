From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg 2/3] memcg: remove charge forcinig for dying tasks
Date: Wed, 20 Oct 2021 17:21:33 +0300
Message-ID: <cbda9b6b-3ee5-06ab-9a3b-debf361b55bb@virtuozzo.com>
References: <YW/WoJDFM3ddHn7Y@dhcp22.suse.cz>
 <cover.1634730787.git.vvs@virtuozzo.com>
 <56180e53-b705-b1be-9b60-75e141c8560c@virtuozzo.com>
 <YXAOjQO5r1g/WKmn@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=ggO+FpcKH1wkkXlq2EYHdQ27UcwvObsXNymYB1kX5vo=; b=qICVdC1lEfiKYzFU0
        8K47Lgduio85XZ6eCdSooKhVX2NtJObrUJsfhOgPRI1/7qkO7qepJK0z71tuX3axsSQsNHaPSDFiO
        YQxBeX7rWzBQlrSjhah3Y+4HBc3kWbSLYmtHP5nEt0pcUMUyUUPdH3GRLUO+mhlIXrBHEJUdf0+X8
        =;
In-Reply-To: <YXAOjQO5r1g/WKmn-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 20.10.2021 15:41, Michal Hocko wrote:
> On Wed 20-10-21 15:13:46, Vasily Averin wrote:
>> ToDo: should we keep task_is_dying() in mem_cgroup_out_of_memory() ?
>>
>> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
>> ---
>>  mm/memcontrol.c | 20 +++++++-------------
>>  1 file changed, 7 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6da5020a8656..74a7379dbac1 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -239,7 +239,7 @@ enum res_type {
>>  	     iter != NULL;				\
>>  	     iter = mem_cgroup_iter(NULL, iter, NULL))
>>  
>> -static inline bool should_force_charge(void)
>> +static inline bool task_is_dying(void)
>>  {
>>  	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
>>  		(current->flags & PF_EXITING);
>> @@ -1575,7 +1575,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>  	 * A few threads which were not waiting at mutex_lock_killable() can
>>  	 * fail to bail out. Therefore, check again after holding oom_lock.
>>  	 */
>> -	ret = should_force_charge() || out_of_memory(&oc);
>> +	ret = task_is_dying() || out_of_memory(&oc);
> 
> Why are you keeping the task_is_dying check here? IIRC I have already
> pointed out that out_of_memory already has some means to do a bypass
> when needed.

It was a misunderstanding.
I've been waiting for your final decision.

I have no good arguments "pro" or strong objection "contra". 
However, I prefer to keep task_is_dying() so as not to touch other tasks unnecessarily.

I can't justify why its removal is necessary,
but on the other hand, it shouldn't break anything.

I can drop it if you think it's necessary.

Thank you,
	Vasily Averin

