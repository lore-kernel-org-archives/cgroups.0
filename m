From: Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: Re: [PATCH] memcg: Add force_reclaim to reclaim tasks' memory in memcg.
Date: Tue, 18 Jun 2013 18:46:51 +0900
Message-ID: <CAOK=xRM6aJsOQ+bD2Y=f70Jq28stzM95h8GbO-v+EXQ4tObznw@mail.gmail.com>
References: <021801ce65cb$f5b0bc50$e11234f0$%kim@samsung.com>
	<20130610152246.GB14295@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=yOWtAMYno9vjDCK6+5Cbub7rO79NK7OpciP7rQmzCoU=;
        b=Fq3kl0Ivu+Wt0m9AO80NsZy+qwabfv+YKCyeAK8PRUEf3csqc4tC1E0AfG2wSA6T7j
         70qTzs/TGQ+en+q+SewM44tdROQ613qnDtyv137lpByUZ54BBbr9e5c1zRrv5umJTNyq
         Pg3Dq7QSLc2BnShXenBdGoOrlVVphzC9n3vpNwLTT6YXK99ju1nTfcw25Vzjljzmpgtk
         4o2VqQz6lDc+g2rZ/sgSexa67F33ijP4WxgHrdpeIjONk2P6svoXV1qO/Z0ZwOYmCgct
         wFOoCdE0UHia7PLFrWk4wdumkjDtgR9cFtPkJgUBaKlS0Emc66m/kJi8DdzEm7YVgY5+
         fmaA==
In-Reply-To: <20130610152246.GB14295@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>

2013/6/11 Michal Hocko <mhocko@suse.cz>:
> On Mon 10-06-13 20:16:31, Hyunhee Kim wrote:
>> These days, platforms tend to manage memory on low memory state
>> like andloid's lowmemory killer. These platforms might want to
>> reclaim memory from background tasks as well as kill victims
>> to guarantee free memory at use space level. This patch provides
>> an interface to reclaim a given memcg.
>
>> After platform's low memory handler moves tasks that the platform
>> wants to reclaim to a memcg and decides how many pages should be
>> reclaimed, it can reclaim the pages from the tasks by writing the
>> number of pages at memory.force_reclaim.
>
> Why cannot you simply set the soft limit to 0 for the target group which
> would enforce reclaim during the next global reclaim instead?
>
> Or you can even use the hard limit for that. If you know how much memory
> is used by those processes you can simply move them to a group with the
> hard limit reduced by the amount of pages which you want to free and the
> reclaim would happen during taks move.
>

Thanks for the comments. However, having this kind of interface that
can trigger reclaim the given number of pages is more simple and
clear? This also can start reclaim immediatlely. IMHO, calculating and
resetting the hard limit every time we want to start reclaim should be
done more carefully by knowing the exact number of pages charged by
the moved task. I think that this kind of interface could be useful
for platform which handles low memory state at the user space.

>> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  mm/memcontrol.c |   26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 010d6c1..21819c9 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4980,6 +4980,28 @@ static int mem_cgroup_force_empty_write(struct cgroup
>> *cont, unsigned int event)
>>       return ret;
>>  }
>>
>> +static int mem_cgroup_force_reclaim(struct cgroup *cont, struct cftype
>> *cft, u64 val)
>> +{
>> +
>> +     struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>> +     unsigned long nr_to_reclaim = val;
>> +     unsigned long total = 0;
>> +     int loop;
>> +
>> +     for (loop = 0; loop < MEM_CGROUP_MAX_RECLAIM_LOOPS; loop++) {
>> +             total += try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL,
>> false);
>> +
>> +             /*
>> +              * If nothing was reclaimed after two attempts, there
>> +              * may be no reclaimable pages in this hierarchy.
>> +              * If more than nr_to_reclaim pages were already reclaimed,
>> +              * finish force reclaim.
>> +              */
>> +             if (loop && (!total || total > nr_to_reclaim))
>> +                     break;
>> +     }
>> +     return total;
>> +}
>>
>>  static u64 mem_cgroup_hierarchy_read(struct cgroup *cont, struct cftype
>> *cft)
>>  {
>> @@ -5938,6 +5960,10 @@ static struct cftype mem_cgroup_files[] = {
>>               .trigger = mem_cgroup_force_empty_write,
>>       },
>>       {
>> +             .name = "force_reclaim",
>> +             .write_u64 = mem_cgroup_force_reclaim,
>> +     },
>> +     {
>>               .name = "use_hierarchy",
>>               .flags = CFTYPE_INSANE,
>>               .write_u64 = mem_cgroup_hierarchy_write,
>> --
>> 1.7.9.5
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Michal Hocko
> SUSE Labs
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
