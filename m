From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
Date: Mon, 19 Mar 2012 16:00:35 +0900
Message-ID: <4F66D993.2080100@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F669C2E.1010502@jp.fujitsu.com> <874ntlkrp6.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <874ntlkrp6.fsf-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/03/19 15:52), Aneesh Kumar K.V wrote:

> On Mon, 19 Mar 2012 11:38:38 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
>>
>>> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>
>>> This patch implements a memcg extension that allows us to control
>>> HugeTLB allocations via memory controller.
>>>
>>
>>
>> If you write some details here, it will be helpful for review and
>> seeing log after merge.
> 
> Will add more info.
> 
>>
>>
>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>> ---
>>>  include/linux/hugetlb.h    |    1 +
>>>  include/linux/memcontrol.h |   42 +++++++++++++
>>>  init/Kconfig               |    8 +++
>>>  mm/hugetlb.c               |    2 +-
>>>  mm/memcontrol.c            |  138 ++++++++++++++++++++++++++++++++++++++++++++
>>>  5 files changed, 190 insertions(+), 1 deletions(-)
> 
> ....
> 
>>> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
>>> +static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
>>> +{
>>> +	int idx;
>>> +	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
>>> +		if (memcg->hugepage[idx].usage > 0)
>>> +			return 1;
>>> +	}
>>> +	return 0;
>>> +}
>>
>>
>> Please use res_counter_read_u64() rather than reading the value directly.
>>
> 
> The open-coded variant is mostly derived from mem_cgroup_force_empty. I
> have updated the patch to use res_counter_read_u64. 
> 

Ah, ok. it's(maybe) my bad. I'll schedule a fix.


Thanks,
-Kame
