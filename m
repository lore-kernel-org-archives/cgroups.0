From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/2] mm/memcontrol.c: Reduce reclaim retries in mem_cgroup_resize_limit()
Date: Fri, 19 Jan 2018 06:49:29 -0800
Message-ID: <CALvZod7HS6P0OU6Rps8JeMJycaPd4dF5NjxV8k1y2-yosF2bdA@mail.gmail.com>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
 <20180119132544.19569-1-aryabinin@virtuozzo.com> <20180119132544.19569-2-aryabinin@virtuozzo.com>
 <20180119133510.GD6584@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=N02FebtAGD5vCCRdskBP/VH52MaejUNLu6vAU5z6CHk=;
        b=lK5TIAkMAjngL0PobJ33QYkUor3BuKiBVK2cKqe+/E+Fe6rEfqhfF9s3xpyyMrJwyj
         5iG6cgac/HLei2QL2HCzClwjYJ1WchqF8gA+PsgV2rWcrb/akQDwwIm8iOoML9AvGwuD
         JnPU/gStFvZqQgRmS4GCkmU4BcqmgY66A/0R7IXWfno/vOXc1tdgTSZSIzA8OziLyOVu
         4GqPDLZZAzvW8AHp5DMwV7xd0XuniFyG3Kr6n1SAE/7VeKeyCZgIuFz2Cv57C20tOxFG
         d4nZDlCR8f7ZtEBIfC36v+Gw/r9lQthge4/pR4lCCIU0saOknn4n0mPPTrIk6UfMmhBR
         MUwg==
In-Reply-To: <20180119133510.GD6584-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Jan 19, 2018 at 5:35 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri 19-01-18 16:25:44, Andrey Ryabinin wrote:
>> Currently mem_cgroup_resize_limit() retries to set limit after reclaiming
>> 32 pages. It makes more sense to reclaim needed amount of pages right away.
>>
>> This works noticeably faster, especially if 'usage - limit' big.
>> E.g. bringing down limit from 4G to 50M:
>>
>> Before:
>>  # perf stat echo 50M > memory.limit_in_bytes
>>
>>      Performance counter stats for 'echo 50M':
>>
>>             386.582382      task-clock (msec)         #    0.835 CPUs utilized
>>                  2,502      context-switches          #    0.006 M/sec
>>
>>            0.463244382 seconds time elapsed
>>
>> After:
>>  # perf stat echo 50M > memory.limit_in_bytes
>>
>>      Performance counter stats for 'echo 50M':
>>
>>             169.403906      task-clock (msec)         #    0.849 CPUs utilized
>>                     14      context-switches          #    0.083 K/sec
>>
>>            0.199536900 seconds time elapsed
>
> But I am not going ack this one. As already stated this has a risk
> of over-reclaim if there a lot of charges are freed along with this
> shrinking. This is more of a theoretical concern so I am _not_ going to

If you don't mind, can you explain why over-reclaim is a concern at
all? The only side effect of over reclaim I can think of is the job
might suffer a bit over (more swapins & pageins). Shouldn't this be
within the expectation of the user decreasing the limits?

> nack. If we ever see such a problem then reverting this patch should be
> pretty straghtforward.
>
>> Signed-off-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

>> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  mm/memcontrol.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 9d987f3e79dc..09bac2df2f12 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2448,6 +2448,7 @@ static DEFINE_MUTEX(memcg_limit_mutex);
>>  static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>                                  unsigned long limit, bool memsw)
>>  {
>> +     unsigned long nr_pages;
>>       bool enlarge = false;
>>       int ret;
>>       bool limits_invariant;
>> @@ -2479,8 +2480,9 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>               if (!ret)
>>                       break;
>>
>> -             if (!try_to_free_mem_cgroup_pages(memcg, 1,
>> -                                     GFP_KERNEL, !memsw)) {
>> +             nr_pages = max_t(long, 1, page_counter_read(counter) - limit);
>> +             if (!try_to_free_mem_cgroup_pages(memcg, nr_pages,
>> +                                             GFP_KERNEL, !memsw)) {
>>                       ret = -EBUSY;
>>                       break;
>>               }
>> --
>> 2.13.6
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
>
> --
> Michal Hocko
> SUSE Labs
