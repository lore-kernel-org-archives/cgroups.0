From: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: how to make memory.memsw.failcnt is nonzero
Date: Fri, 06 Jan 2012 17:47:10 +0800
Message-ID: <4F06C31E.4010904@cn.fujitsu.com>
References: <4EFADFF8.5020703@cn.fujitsu.com> <20120103160411.GD3891@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120103160411.GD3891-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Michal Hocko said the following on 2012-1-4 0:04:
>> # echo 15M > memory.memsw.limit_in_bytes
>> # dd if=/dev/zero of=/tmp/temp_file count=20 bs=1M
>> Killed
>> # grep "failcnt" /var/log/messages | tail -2
>> Dec 28 17:08:45 K-test kernel: memory: usage 10240kB, limit 10240kB, failcnt 86
>> Dec 28 17:08:45 K-test kernel: memory+swap: usage 10240kB, limit 15360kB, failcnt 0
>> # cat memory.memsw.failcnt
>> 0
>>
>> The limit is 15M, but memory+swap usage also is 10M.
>> I think memory+swap usage should be 15M and memsw.failcnt should be nonzero.
>>
> So there is almost 10M of page cache that we can simply reclaim. If we
> use 40M limit then we are OK. So this looks like the small limit somehow
> tricks our math in the reclaim path and we think there is nothing to
> reclaim.
> I will look into this.

Thanks for you reply.
If there is something wrong, I think the bug will be in mem_cgroup_do_charge()
of mm/memcontrol.c

2210         ret = res_counter_charge(&memcg->res, csize, &fail_res);
2211 
2212         if (likely(!ret)) {
2213                 if (!do_swap_account)
2214                         return CHARGE_OK;
2215                 ret = res_counter_charge(&memcg->memsw, csize, &fail_res);
2216                 if (likely(!ret))
2217                         return CHARGE_OK;
2218 
2219                 res_counter_uncharge(&memcg->res, csize);
2220                 mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
2221                 flags |= MEM_CGROUP_RECLAIM_NOSWAP;
2222         } else
2223                 mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);

When hit memory.limit_in_bytes, res_counter_charge() will return -ENOMEM,
this will execute line 2222: } else.
But I think when hit memory.limit_in_bytes, the function should determine further
to memory.memsw.limit_in_bytes.
This think is OK?

-- 
Best Regards,
Peng
