From: Chen Baozi <baozich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: remove the unnecessary MEM_CGROUP_STAT_DATA
Date: Tue, 29 May 2012 01:22:41 +0800
Message-ID: <B23B2709-F70C-4B47-80CC-FBC3AA40A907@gmail.com>
References: <1337933501-3985-1-git-send-email-baozich@gmail.com> <20120528133918.GA22185@tiehlicka.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        bh=mGVXH6CZndrDcK8Vr6sv6xJGiecCFLWZkTJI/Rsm+dg=;
        b=nPrwqi1NzxQUMjmKhkaVBNRpiUMqX9hiTYFAPSATVwiTINDPALbwB/xjQQbHMCU9x+
         rvYY9vFRXLdyXT8gjH/4T/rHyQjNKZQQX6v1B7fYR7X4kK602DIkVLo3O10mHLp7qeVh
         55bfGqivzlT9/S1njZxJCkbOzhOFhIfRwvAyxeXdY0Enq6E1pxwL0L2MSbo/niKBqUmj
         hzvnCsO5Wj5/6mNLQMRfhXc42d5OpZwE5qMxAijrsd4QjvfyHzzu9k7YWmoeFEMf5QtU
         OjhFhSqb0whaK4qmOHX3sNcWnVhZ5XqmpLT+zAGU2aQTP3CLDTVCg9Psl+/kmU1nLS1A
         vdnw==
In-Reply-To: <20120528133918.GA22185-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>


On May 28, 2012, at 9:39 PM, Michal Hocko wrote:

> On Fri 25-05-12 16:11:41, Chen Baozi wrote:
>> Since MEM_CGROUP_ON_MOVE has been removed, it comes to be redudant
>> to hold MEM_CGROUP_STAT_DATA to mark the end of data requires
>> synchronization.
> 
> A similar patch has been already posted by Johannes 2 weeks ago
> (http://www.gossamer-threads.com/lists/linux/kernel/1535888) and it
> should appear in -next soonish.
Oh, I see, Thanks for informing.

Baozi

> 
>> 
>> Signed-off-by: Chen Baozi <baozich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> mm/memcontrol.c |    3 +--
>> 1 files changed, 1 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index f342778..446ca94 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -88,7 +88,6 @@ enum mem_cgroup_stat_index {
>> 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
>> 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>> 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>> -	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
>> 	MEM_CGROUP_STAT_NSTATS,
>> };
>> 
>> @@ -2139,7 +2138,7 @@ static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *memcg, int cpu)
>> 	int i;
>> 
>> 	spin_lock(&memcg->pcp_counter_lock);
>> -	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
>> +	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
>> 		long x = per_cpu(memcg->stat->count[i], cpu);
>> 
>> 		per_cpu(memcg->stat->count[i], cpu) = 0;
>> -- 
>> 1.7.1
>> 
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
>> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 
> -- 
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9    
> Czech Republic
