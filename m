From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
Date: Thu, 08 Nov 2012 20:37:45 +0800
Message-ID: <509BA799.505@gmail.com>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com> <1352277696-21724-1-git-send-email-handai.szj@taobao.com> <alpine.DEB.2.00.1211070956540.27451@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=1+9tUMYlvkzTu+p5aPVTaWD60MXvzMLlET37uPHEt6E=;
        b=H2IsbyhGVwTL4uH2ZKxi8aT2S4vNSk8q+xq48sAroBjD3MjByMud2C8QvSlCtY0TPF
         l0HmWdRMyWPeqrm+OtPsjxzezKBL0EQwJgLZ3ShQXu5zFIc9szgdJxX0WPL1M/mwLKi6
         53iyaKv/kBOYPA61Egpx7ilzAfOxs+lGYRmyx+nrNg4DlkdCrlkrpuWe9itJc3TnOg1F
         WqPwlcqh+rmhTfdku84uX8T738CtTZ1g9NR8psVgTiv+OR99PJHkd1PkoJJcR16/6VEG
         OWiOVAIyCXaNL1et+AY33m/hF4fbwyR+E61lxZHbZsvxbMp+B9gSwGtQZMFhYnOiFvC5
         GczA==
In-Reply-To: <alpine.DEB.2.00.1211070956540.27451-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/08/2012 02:02 AM, David Rientjes wrote:
> On Wed, 7 Nov 2012, Sha Zhengju wrote:
>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 0eab7d5..2df5e72 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -118,6 +118,14 @@ static const char * const mem_cgroup_events_nam=
es[] =3D {
>>   	"pgmajfault",
>>   };
>>
>> +static const char * const mem_cgroup_lru_names[] =3D {
>> +	"inactive_anon",
>> +	"active_anon",
>> +	"inactive_file",
>> +	"active_file",
>> +	"unevictable",
>> +};
>> +
>>   /*
>>    * Per memcg event counter is incremented at every pagein/pageout.=
 With THP,
>>    * it will be incremated by the number of pages. This counter is u=
sed for
>> @@ -1501,8 +1509,59 @@ static void move_unlock_mem_cgroup(struct mem=
_cgroup *memcg,
>>   	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>>   }
>>
>> +#define K(x) ((x)<<  (PAGE_SHIFT-10))
>> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
>> +{
>> +	struct mem_cgroup *mi;
>> +	unsigned int i;
>> +
>> +	if (!memcg->use_hierarchy&&  memcg !=3D root_mem_cgroup) {
>> +		for (i =3D 0; i<  MEM_CGROUP_STAT_NSTATS; i++) {
>> +			if (i =3D=3D MEM_CGROUP_STAT_SWAP&&  !do_swap_account)
>> +				continue;
>> +			printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
> This printk isn't continuing any previous printk, so using KERN_CONT =
here
> will require a short header to be printed first ("Memcg: "?) with
> KERN_INFO before the iterations.
>

Yep...I think I lost it while rebasing... sorry for the stupid mistake.

>> +				K(mem_cgroup_read_stat(memcg, i)));
>> +		}
>> +
>> +		for (i =3D 0; i<  MEM_CGROUP_EVENTS_NSTATS; i++)
>> +			printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
>> +				mem_cgroup_read_events(memcg, i));
>> +
>> +		for (i =3D 0; i<  NR_LRU_LISTS; i++)
>> +			printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
>> +				K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
>> +	} else {
>> +
> Spurious newline.
>
> Eek, is there really no way to avoid this if-conditional and just use
> for_each_mem_cgroup_tree() for everything and use
>
> 	mem_cgroup_iter_break(memcg, iter);
> 	break;
>
> for !memcg->use_hierarchy?
>

Now I'm shamed at my bad brain of yesterday by sending this chunk out..=
=2E
Yes, the if-part code above is obviously unwanted, and the=20
for_each_mem_cgroup_tree
can handle hierarchy already.


>> +		for (i =3D 0; i<  MEM_CGROUP_STAT_NSTATS; i++) {
>> +			long long val =3D 0;
>> +
>> +			if (i =3D=3D MEM_CGROUP_STAT_SWAP&&  !do_swap_account)
>> +				continue;
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val +=3D mem_cgroup_read_stat(mi, i);
>> +			printk(KERN_CONT "%s:%lldKB ", mem_cgroup_stat_names[i], K(val))=
;
>> +		}
>> +
>> +		for (i =3D 0; i<  MEM_CGROUP_EVENTS_NSTATS; i++) {
>> +			unsigned long long val =3D 0;
>> +
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val +=3D mem_cgroup_read_events(mi, i);
>> +			printk(KERN_CONT "%s:%llu ",
>> +				mem_cgroup_events_names[i], val);
>> +		}
>> +
>> +		for (i =3D 0; i<  NR_LRU_LISTS; i++) {
>> +			unsigned long long val =3D 0;
>> +
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val +=3D mem_cgroup_nr_lru_pages(mi, BIT(i));
>> +			printk(KERN_CONT "%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
>> +		}
>> +	}
>> +	printk(KERN_CONT "\n");
>> +}
>>   /**
>> - * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock he=
ld in read mode.
>>    * @memcg: The memory cgroup that went over limit
>>    * @p: Task that is going to be killed
>>    *
>> @@ -1569,6 +1628,8 @@ done:
>>   		res_counter_read_u64(&memcg->kmem, RES_USAGE)>>  10,
>>   		res_counter_read_u64(&memcg->kmem, RES_LIMIT)>>  10,
>>   		res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
>> +
>> +	mem_cgroup_print_oom_stat(memcg);
> I think this should be folded into mem_cgroup_print_oom_info(), I don=
't
> see a need for a new function.
>
>>   }
>>
>>   /*
>> @@ -5195,14 +5256,6 @@ static int memcg_numa_stat_show(struct cgroup=
 *cont, struct cftype *cft,
>>   }
>>   #endif /* CONFIG_NUMA */
>>
>> -static const char * const mem_cgroup_lru_names[] =3D {
>> -	"inactive_anon",
>> -	"active_anon",
>> -	"inactive_file",
>> -	"active_file",
>> -	"unevictable",
>> -};
>> -
>>   static inline void mem_cgroup_lru_names_not_uptodate(void)
>>   {
>>   	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) !=3D NR_LRU_LISTS);
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 7e9e911..4b8a6dd 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -421,8 +421,10 @@ static void dump_header(struct task_struct *p, =
gfp_t gfp_mask, int order,
>>   	cpuset_print_task_mems_allowed(current);
>>   	task_unlock(current);
>>   	dump_stack();
>> -	mem_cgroup_print_oom_info(memcg, p);
>> -	show_mem(SHOW_MEM_FILTER_NODES);
>> +	if (memcg)
>> +		mem_cgroup_print_oom_info(memcg, p);
> mem_cgroup_print_oom_info() already returns immediately for !memcg, s=
o I'm
> not sure why this change is made.
>

Here the if-else checking is aiming at printing distinct messages for=20
memcg & non-memcg.
IMHO, global state has little actual use for memcg-oom and why not we=20
wipe off it=EF=BC=9F
Though mem_cgroup_print_oom_info already checking for !memcg, the=20
if-statement
can avoid one function call and save the deep-enough oom call stack a=20
little.

>> +	else
>> +		show_mem(SHOW_MEM_FILTER_NODES);
> Well that's disappointing if memcg =3D=3D root_mem_cgroup, we'd proba=
bly like
> to know the global memory state to determine what the problem is.
>

I really wondering if there is any case that can pass root_mem_cgroup=20
down here.
It's called by global or memcg oom killer and the global oom will set=20
memcg=3DNULL
directly instead of root_mem_cgroup. Besides, root memcg will not go=20
through charging
and there is no chance to call mem_cgroup_out_of_memory for root cgroup=
=20
tasks.



Thanks,
Sha


>>   	if (sysctl_oom_dump_tasks)
>>   		dump_tasks(memcg, nodemask);
>>   }
> .
>
