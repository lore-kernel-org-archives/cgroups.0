From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH 2/7] memcg: remove MEMCG_NR_FILE_MAPPED
Date: Wed, 11 Jul 2012 16:00:43 +0800
Message-ID: <4FFD32AB.8090704@gmail.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>	<1340881111-5576-1-git-send-email-handai.szj@taobao.com> <xr93ehok1wf2.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=2ZFkRFP58C1MVi8MBcqPNhvMfU96FxNalgJzegQmxaY=;
        b=RA6gyobDGiGzmiP+uhtNjewV3PMk9jOuObjI3KNRj0hlwgXbBW0ZGb1f7eZGB1r7Eq
         FhR0sKanod+f43J8QGoqUu1rxB2Y0+Dh94bc9Gej1AFd9xkWEnizZqFjHufI8mhusc2G
         jud9Tz4BdqCXEyLtgDnj5w6azQZPBsKoE9l7OTyzpa1h8/M8MYKSOs0ZBrbCOs0ij4E9
         BxOy+RJxQcvsXM8+2k/VTF2hg1GTR83bxNhsMwSwKPmGW9Fg5vEnBbcAL5/6U5v8I9NT
         039PL3x7lAM31zNnQKGiLKqXZ9Pu5NENwyWjlCFcE0Jbyo/4Wh3IgeCETUU+rkb02Z3x
         el6g==
In-Reply-To: <xr93ehok1wf2.fsf@gthelen.mtv.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Greg Thelen <gthelen@google.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz, linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

On 07/10/2012 05:01 AM, Greg Thelen wrote:
> On Thu, Jun 28 2012, Sha Zhengju wrote:
>
>> From: Sha Zhengju<handai.szj@taobao.com>
>>
>> While accounting memcg page stat, it's not worth to use MEMCG_NR_FILE_MAPPED
>> as an extra layer of indirection because of the complexity and presumed
>> performance overhead. We can use MEM_CGROUP_STAT_FILE_MAPPED directly.
>>
>> Signed-off-by: Sha Zhengju<handai.szj@taobao.com>
>> ---
>>   include/linux/memcontrol.h |   25 +++++++++++++++++--------
>>   mm/memcontrol.c            |   24 +-----------------------
>>   mm/rmap.c                  |    4 ++--
>>   3 files changed, 20 insertions(+), 33 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 83e7ba9..20b0f2d 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -27,9 +27,18 @@ struct page_cgroup;
>>   struct page;
>>   struct mm_struct;
>>
>> -/* Stats that can be updated by kernel. */
>> -enum mem_cgroup_page_stat_item {
>> -	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
>> +/*
>> + * Statistics for memory cgroup.
>> + */
>> +enum mem_cgroup_stat_index {
>> +	/*
>> +	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
>> +	 */
>> +	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
>> +	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
>> +	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>> +	MEM_CGROUP_STAT_SWAP, /* # of pages, swapped out */
>> +	MEM_CGROUP_STAT_NSTATS,
>>   };
> Nit.  Moving mem_cgroup_stat_index from memcontrol.c to memcontrol.h is
> fine with me.  But this does increase the distance between related
> defintions of definition mem_cgroup_stat_index and
> mem_cgroup_stat_names.  These two lists have to be kept in sync.  So it
> might help to add a comment to both indicating their relationship so we
> don't accidentally modify the enum without updating the dependent string
> table.
>
> Otherwise, looks good.
>
> Reviewed-by: Greg Thelen<gthelen@google.com>

Sorry for the delay.
OK, I'll add some comment here. Thanks for reminding!

Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
