From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v2 1/3] mm/memcg: mz already removed from rb_tree in
 mem_cgroup_largest_soft_limit_node()
Date: Mon, 14 Mar 2022 23:21:33 +0000
Message-ID: <20220314232133.owoq5vzsd2bvggma@master>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
 <Yi8QN+5oeUWWJQNv@dhcp22.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6R11bvjmYsahK0gJVGfVX+7+GFhuag8IbRPGFQJNZaM=;
        b=j/wjktA6qFCOxz1OA06/g8dx7uSwFMKqT1oNnSCtnjX9Lwo4cFU16UFCNsIueVvXs3
         45cYyul1S9P2C1B2MTsXqDa+LqH63ZmJDUpI/YuAkns8KCXgyzG+XhkXpr/Sb2PaBZVQ
         jtm2fGEWfakDVIzWQT6BBDk4cQ/qmZE24a5z6tPgjz6b8d3yvqR33lFdb9rzMIoz9f6y
         UzW/dz/Hy034/KJ/7PKPUFNDjOoOqD/03/K1NY/K9qqYu58Yw5ZUpnevBvhbCt9D35Xs
         CJNYN4OQxQcseaAPOhKoLWG9KQ70ftA298t96NXG+TUhplqRXylnSw91DLK+l9P+g6r/
         kAmQ==
Content-Disposition: inline
In-Reply-To: <Yi8QN+5oeUWWJQNv-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Mar 14, 2022 at 10:51:51AM +0100, Michal Hocko wrote:
>On Sat 12-03-22 07:16:21, Wei Yang wrote:
>> When mz is not NULL, mem_cgroup_largest_soft_limit_node() has removed
>> it from rb_tree.
>> 
>> Not necessary to call __mem_cgroup_remove_exceeded() again.
>
>Yes, the call seems to be unnecessary with the current code. mz can
>either come from mem_cgroup_largest_soft_limit_node or
>__mem_cgroup_largest_soft_limit_node both rely on the latter so the mz
>is always off the tree indeed.
> 
>> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>After the changelog is completed you can add
>Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Will adjust it.

>
>In general, though, I am not a super fan of changes like these. The code
>works as expected, the call for __mem_cgroup_remove_exceeded will not
>really add much of an overhead and at least we can see that mz is always
>removed before it is re-added back. In a hot path I would care much more
>of course but this is effectivelly a dead code as the soft limit itself
>is mostly a relict of past.
>
>Please keep this in mind when you want to make further changes to this
>area. The review is not free of cost and I am not sure spending time on
>this area is worthwhile unless there is a real usecase in mind.
>

Yes, after more understanding of the code, I found soft reclaim seems to be
not that often.

Thanks for your time and will choose some more important area for change.

>Thanks!
>
>> ---
>>  mm/memcontrol.c | 1 -
>>  1 file changed, 1 deletion(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index f898320b678a..d70bf5cf04eb 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3458,7 +3458,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>>  		nr_reclaimed += reclaimed;
>>  		*total_scanned += nr_scanned;
>>  		spin_lock_irq(&mctz->lock);
>> -		__mem_cgroup_remove_exceeded(mz, mctz);
>>  
>>  		/*
>>  		 * If we failed to reclaim anything from this memory cgroup
>> -- 
>> 2.33.1
>
>-- 
>Michal Hocko
>SUSE Labs

-- 
Wei Yang
Help you, Help me
