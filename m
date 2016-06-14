From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 03/18] memcontrol: present maximum used memory also for
 cgroup-v2
Date: Tue, 14 Jun 2016 15:47:20 +0000
Message-ID: <b9d04ccd-28d2-993a-2a40-bbed7b6289d4@gmail.com>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-4-git-send-email-toiwoton@gmail.com>
 <20160614070130.GB5681@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=SbzBRmuogwnehxT/akdu1tTDD+VPgIB/FUNGwMQfJa4=;
        b=iq+HTAvTYWCZnyNd/83c8yfazlFZx9O7z9CgrsYSz/85bq8ws+Lx4ddjGW6TNNkMKY
         MC37XDwgV00CENuk1HyGAYSp6yX4kcbvL0STfS/1V7q/klq4qDqtBTr1nljRWN1nX5ps
         4U67IZBE7HT0nrg8fhfVPslzQT/ceE0ODSthfSzuLroZ8DB+f8WbfDzyq0Lueu1cA0k8
         roeBZQNM/DJvzSQ/aRJ/FlyEDcxqxcVYL9gZSrtftUh2lGW+f54p8EWVjEgYF9iLPkTU
         gc/PbfTegqJCnvOLozvLj0ECgL5rS2ZN+JUkNG8YRqFsd2Me3TdjBPJNDdSTV1QGT6wz
         rh/g==
In-Reply-To: <20160614070130.GB5681-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On 06/14/16 07:01, Michal Hocko wrote:
> On Mon 13-06-16 22:44:10, Topi Miettinen wrote:
>> Present maximum used memory in cgroup memory.current_max.
> 
> It would be really much more preferable to present the usecase in the
> patch description. It is true that this information is presented in the
> v1 API but the current policy is to export new knobs only when there is
> a reasonable usecase for it.
> 

This was stated in the cover letter:
https://lkml.org/lkml/2016/6/13/857

"There are many basic ways to control processes, including capabilities,
cgroups and resource limits. However, there are far fewer ways to find out
useful values for the limits, except blind trial and error.

This patch series attempts to fix that by giving at least a nice starting
point from the actual maximum values. I looked where each limit is checked
and added a call to limit bump nearby."

"Cgroups
[RFC 02/18] cgroup_pids: track maximum pids
[RFC 03/18] memcontrol: present maximum used memory also for
[RFC 04/18] device_cgroup: track and present accessed devices

For tasks and memory cgroup limits the situation is somewhat better as the
current tasks and memory status can be easily seen with ps(1). However, any
transient tasks or temporary higher memory use might slip from the view.
Device use may be seen with advanced MAC tools, like TOMOYO, but there is no
universal method. Program sources typically give no useful indication about
memory use or how many tasks there could be."

I can add some of this to the commit message, is that sufficient for you?

>> Signed-off-by: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  include/linux/page_counter.h |  7 ++++++-
>>  mm/memcontrol.c              | 13 +++++++++++++
>>  2 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
>> index 7e62920..be4de17 100644
>> --- a/include/linux/page_counter.h
>> +++ b/include/linux/page_counter.h
>> @@ -9,9 +9,9 @@ struct page_counter {
>>  	atomic_long_t count;
>>  	unsigned long limit;
>>  	struct page_counter *parent;
>> +	unsigned long watermark;
>>  
>>  	/* legacy */
>> -	unsigned long watermark;
>>  	unsigned long failcnt;
>>  };
>>  
>> @@ -34,6 +34,11 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
>>  	return atomic_long_read(&counter->count);
>>  }
>>  
>> +static inline unsigned long page_counter_read_watermark(struct page_counter *counter)
>> +{
>> +	return counter->watermark;
>> +}
>> +
>>  void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
>>  void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
>>  bool page_counter_try_charge(struct page_counter *counter,
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 75e7440..5513771 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4966,6 +4966,14 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
>>  	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
>>  }
>>  
>> +static u64 memory_current_max_read(struct cgroup_subsys_state *css,
>> +				   struct cftype *cft)
>> +{
>> +	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>> +
>> +	return (u64)page_counter_read_watermark(&memcg->memory) * PAGE_SIZE;
>> +}
>> +
>>  static int memory_low_show(struct seq_file *m, void *v)
>>  {
>>  	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
>> @@ -5179,6 +5187,11 @@ static struct cftype memory_files[] = {
>>  		.read_u64 = memory_current_read,
>>  	},
>>  	{
>> +		.name = "current_max",
>> +		.flags = CFTYPE_NOT_ON_ROOT,
>> +		.read_u64 = memory_current_max_read,
>> +	},
>> +	{
>>  		.name = "low",
>>  		.flags = CFTYPE_NOT_ON_ROOT,
>>  		.seq_show = memory_low_show,
>> -- 
>> 2.8.1
> 
