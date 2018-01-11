From: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Thu, 11 Jan 2018 15:21:33 +0300
Message-ID: <4a8f667d-c2ae-e3df-00fd-edc01afe19e1@virtuozzo.com>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com>
 <20180111104239.GZ1732@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qXaJNZQ9QGxLf23jgZktHa868i18i2icXPDKoxuqFYs=;
 b=gehcdN9is8BO9R2oKjf+LwbqpzoJB2kvkwvlpy+M1vD+GFAuIyoActe8UCusp43Z6WrME+B1aLDUguBoCN68dWX6LcZdzhXk/ClkAZDw7WXcKl28gGmVLa+3/KN8vD/s5RGW1W5R/YJHSUsdk7sylNbt6ADHTjfjkc1N+evQRyc=
In-Reply-To: <20180111104239.GZ1732-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>



On 01/11/2018 01:42 PM, Michal Hocko wrote:
> On Wed 10-01-18 15:43:17, Andrey Ryabinin wrote:
> [...]
>> @@ -2506,15 +2480,13 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>  		if (!ret)
>>  			break;
>>  
>> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
>> -
>> -		curusage = page_counter_read(counter);
>> -		/* Usage is reduced ? */
>> -		if (curusage >= oldusage)
>> -			retry_count--;
>> -		else
>> -			oldusage = curusage;
>> -	} while (retry_count);
>> +		usage = page_counter_read(counter);
>> +		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
>> +						GFP_KERNEL, !memsw)) {
> 
> If the usage drops below limit in the meantime then you get underflow
> and reclaim the whole memcg. I do not think this is a good idea. This
> can also lead to over reclaim. Why don't you simply stick with the
> original SWAP_CLUSTER_MAX (aka 1 for try_to_free_mem_cgroup_pages)?
> 

Because, if new limit is gigabytes bellow the current usage, retrying to set
new limit after reclaiming only 32 pages seems unreasonable.

So, I made this:


From: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: mm-memcg-try-harder-to-decrease-limit_in_bytes-fix

Protect from overreclaim if usage become lower than limit.

Signed-off-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4671ae8a8b1a..6120bb619547 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2455,7 +2455,7 @@ static DEFINE_MUTEX(memcg_limit_mutex);
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				   unsigned long limit, bool memsw)
 {
-	unsigned long usage;
+	unsigned long nr_pages;
 	bool enlarge = false;
 	int ret;
 	bool limits_invariant;
@@ -2487,8 +2487,8 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 		if (!ret)
 			break;
 
-		usage = page_counter_read(counter);
-		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
+		nr_pages = max_t(long, 1, page_counter_read(counter) - limit);
+		if (!try_to_free_mem_cgroup_pages(memcg, nr_pages,
 						GFP_KERNEL, !memsw)) {
 			ret = -EBUSY;
 			break;
-- 
2.13.6
