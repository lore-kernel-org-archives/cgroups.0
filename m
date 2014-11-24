From: Michal Hocko <mhocko@suse.cz>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI0=?= =?utf-8?Q?=3A?= low memory
 killer
Date: Mon, 24 Nov 2014 17:17:57 +0100
Message-ID: <20141124161554.GA11742@curandero.mameluci.net>
References: <AF7C0ADF1FEABA4DABABB97411952A2EC91E38@CN-MBX02.HTC.COM.TW>
 <20141120095802.GA24575@dhcp22.suse.cz>
 <AF7C0ADF1FEABA4DABABB97411952A2EC91EF5@CN-MBX02.HTC.COM.TW>
 <20141120101855.GB24575@dhcp22.suse.cz>
 <AF7C0ADF1FEABA4DABABB97411952A2EC91FE0@CN-MBX02.HTC.COM.TW>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ECstwTdOlK5SvvW8x975mQLCoS+4tHl9mf0DpzWqad8=;
        b=oT+IOX3yuf/pUXJVmGrlP4P+zgSDALSrH4Zrzaah1+v3RKpvKlyvk+xa4BNBhhQmfh
         T3XFDk/k2PsThYjU2ke8lmcCSqW0Ok6VQqqtF571nSC/EQZARionFLq3DX0+FCTs6RVS
         UNLRK06DOq75RAUk4F74vFgfr+yFPccNVk3D3VnCr3TP/AOImmBW1wwGPVp6yjPezBjj
         lckFszZ8Kte0TzIxhZ6ZwBx7wSi9rYkXXiK0YuLCZwTx6MEXpwuwsQ5Bs0Agk1KfpJsD
         6z93yAGEZqR0c2VbgwA2+jaFLtYntd3tcEBpMdU2MxMisdEDB2K2dcgJb/8iBAwogi2M
         IwCw==
Content-Disposition: inline
In-Reply-To: <AF7C0ADF1FEABA4DABABB97411952A2EC91FE0@CN-MBX02.HTC.COM.TW>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhiyuan_zhu@htc.com
Cc: hannes@cmpxchg.org, Future_Zhou@htc.com, Rachel_Zhang@htc.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, greg@kroah.com, Sai_Shen@htc.com

On Thu 20-11-14 12:05:00, zhiyuan_zhu@htc.com wrote:
> Hi Greg/Michal
> Very sorry I have a mistake in previous mail. (It should be nr_file_pages not nr_free_pages)
> I rearrange this problem.
> 
> // *********** log begin **********
> 6      161030.084144       2014-11-07 21:44:53.304        lowmemorykiller: Killing 'om.htc.launcher' (4486), adj 294,
> 6      161030.084144       2014-11-07 21:44:53.304           to free 47856kB on behalf of 'kworker/u8:14' (20594) because
> 6      161030.084144       2014-11-07 21:44:53.304           cache 72460kB is below limit 73728kB for oom_score_adj 235

This is missing the last line which dumps Free memory (at least from the
snippet below, because nothing like that is in the current driver code
anymore)

> //  **** /proc/meminfo 's result
> 4      161030.084797       2014-11-07 21:44:53.304        Cached:           142448 kB
> // *********** log end **********
> 
> After I checked the android's low memory strategy: kernel/drivers/staging/android/lowmemorykiller.c
> 
> // ****** code begin *********
> 		other_file = global_page_state(NR_FILE_PAGES) -
> 						global_page_state(NR_SHMEM) -
> 						total_swapcache_pages();
> 
> 		lowmem_print(1, "Killing '%s' (%d), adj %hd,\n" \
> 				"   to free %ldkB on behalf of '%s' (%d) because\n" \
> 				"   cache %ldkB is below limit %ldkB for oom_score_adj %hd\n" \
> 				"   Free memory is %ldkB above reserved\n",
> 			     selected->comm, selected->pid,
> 			     selected_oom_score_adj,
> 			     selected_tasksize * (long)(PAGE_SIZE / 1024),
> 			     current->comm, current->pid,
> 			     other_file * (long)(PAGE_SIZE / 1024),
> 			     minfree * (long)(PAGE_SIZE / 1024),
> 			     min_score_adj,
> 			     other_free * (long)(PAGE_SIZE / 1024));
> // ******* code end ************
> 
> So android's strategy's free memory is = other_file = (nr file pages - nr shmem - total swapcache pages) * 4K = [cache 72460kB]
> But the system's free memory is: Cached:        142448 kB  // from /proc/meminfo

I have already pointed you at meminfo_proc_show() which calculates the
shown value as:
	cached = global_page_state(NR_FILE_PAGES) -
	                        total_swapcache_pages() - i.bufferram;

That means that the two differ by NR_SHMEM - i.bufferram. 

> And system's free memory is: Cached + MemFree + Buffers is largely
> than the memory which anroid lowmemorykiller calculated memory [cache
> 72460K] At this time point, system will kill some important processes,
> but system have enough memory.  This is android's lowmemorykiller
> defect? or Linux kernel memory's defect?

It looks most likely be lowmemory killer bug but this is hard to tell as
I do not know which kernel version are you looking at and what are the
additional patch on top of Vanilla kernel.
The upstream code doesn't care about Cached value as presented by
/proc/meminfo

> So I have some questions:
> I have a question: what's the nr file pages mean?

It counts page cache pages (aka pages backed by a file). This includes
also SHMEM pages.

> What different between nr_file_pages from Cached (from /proc/meminfo)?

See above about meminfo_proc_show.

> And nr shmem, swapcache pages are small, so I think this is the key
> problem why android's stragegy calculated free memory is largely less
> than /proc/meminfo Cached's value.

I do not see the value of shmem and swapcache from the time when the
situation was evaluated.

Anyway I do not think there would be problem with counters but rather
the way how they are used by lowmemory killer and I would be looking
into that code first before checking the core kernel.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
