From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
Date: Wed, 21 Mar 2012 10:18:43 +0530
Message-ID: <87obrqsgno.fsf@linux.vnet.ibm.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F669C2E.1010502@jp.fujitsu.com> <874ntlkrp6.fsf@linux.vnet.ibm.com> <4F66D993.2080100@jp.fujitsu.com> <4F671AE6.5020204@parallels.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F671AE6.5020204-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> writes:

> On 03/19/2012 11:00 AM, KAMEZAWA Hiroyuki wrote:
>> (2012/03/19 15:52), Aneesh Kumar K.V wrote:
>>
>>>
>>>>> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
>>>>> +static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
>>>>> +{
>>>>> +	int idx;
>>>>> +	for (idx = 0; idx<  hugetlb_max_hstate; idx++) {
>>>>> +		if (memcg->hugepage[idx].usage>  0)
>>>>> +			return 1;
>>>>> +	}
>>>>> +	return 0;
>>>>> +}
>>>>
>>>>
>>>> Please use res_counter_read_u64() rather than reading the value directly.
>>>>
>>>
>>> The open-coded variant is mostly derived from mem_cgroup_force_empty. I
>>> have updated the patch to use res_counter_read_u64.
>>>
>>
>> Ah, ok. it's(maybe) my bad. I'll schedule a fix.
>>
> Kame,
>
> I actually have it ready here. I can submit it if you want.
>
> This one has bitten me as well when I was trying to experiment with the 
> res_counter performance...

Do we really need memcg.res.usage to be accurate in that while loop ? If
we miss a zero update because we encountered a partial update; in the
next loop we will find it zero right ?

-aneesh
