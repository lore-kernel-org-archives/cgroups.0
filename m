From: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: how to make memory.memsw.failcnt is nonzero
Date: Mon, 30 Jan 2012 10:47:33 +0800
Message-ID: <4F2604C5.7050900@cn.fujitsu.com>
References: <4EFADFF8.5020703@cn.fujitsu.com> <20120103160411.GD3891@tiehlicka.suse.cz> <4F06C31E.4010904@cn.fujitsu.com> <20120106101219.GB10292@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120106101219.GB10292-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Michal Hocko said the following on 2012-1-6 18:12:
>> If there is something wrong, I think the bug will be in mem_cgroup_do_charge()
>> of mm/memcontrol.c
>>
>> 2210         ret = res_counter_charge(&memcg->res, csize, &fail_res);
>> 2211 
>> 2212         if (likely(!ret)) {
...
>> 2221                 flags |= MEM_CGROUP_RECLAIM_NOSWAP;
>> 2222         } else
>> 2223                 mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
>>
>> When hit memory.limit_in_bytes, res_counter_charge() will return -ENOMEM,
>> this will execute line 2222: } else.
>> But I think when hit memory.limit_in_bytes, the function should determine further
>> to memory.memsw.limit_in_bytes.
>> This think is OK?
> 
> I don't think so. We have an invariant (hard limit is "stronger" than
> memsw limit) memory.limit_in_bytes <= memory.memsw.limit_in_bytes so
> when we hit the hard limit we do not have to consider memsw because
> resource counter:
>  a) we already have to do reclaim for hard limit
>  b) we check whether we might swap out later on in
>  mem_cgroup_hierarchical_reclaim (root_memcg->memsw_is_minimum) so we
>  will not end up swapping just to make hard limit ok and go over memsw
>  limit.
> 
> Please also note that we will retry charging after reclaim if there is a
> chance to meet the limit.
> Makes sense?

Yeah.

But I want to test memory.memsw.failcnt is nonzero, how steps?
Thanks.

-- 
Best Regards,
Peng
