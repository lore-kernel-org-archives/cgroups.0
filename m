From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
Date: Thu, 29 Mar 2012 09:18:39 +0900
Message-ID: <4F73AA5F.5050604@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120328134020.GG20949@tiehlicka.suse.cz>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu) <87y5qk1vat.fsf@skywalker.in.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87y5qk1vat.fsf-6yE53ggjAfyqSkle7U1LjlaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/03/29 2:37), Aneesh Kumar K.V wrote:

> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
> 
>> On Fri 16-03-12 23:09:24, Aneesh Kumar K.V wrote:
>> [...]
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 6728a7a..4b36c5e 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>> [...]
>>> @@ -4887,6 +5013,7 @@ err_cleanup:
>>>  static struct cgroup_subsys_state * __ref
>>>  mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>>>  {
>>> +	int idx;
>>>  	struct mem_cgroup *memcg, *parent;
>>>  	long error = -ENOMEM;
>>>  	int node;
>>> @@ -4929,9 +5056,14 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>>>  		 * mem_cgroup(see mem_cgroup_put).
>>>  		 */
>>>  		mem_cgroup_get(parent);
>>> +		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
>>> +			res_counter_init(&memcg->hugepage[idx],
>>> +					 &parent->hugepage[idx]);
>>
>> Hmm, I do not think we want to make groups deeper in the hierarchy
>> unlimited as we cannot reclaim. Shouldn't we copy the limit from the parent?
>> Still not ideal but slightly more expected behavior IMO.
> 
> But we should be limiting the child group based on parent's limit only
> when hierarchy is set right ?
> 
>>
>> The hierarchy setups are still interesting and the limitations should be
>> described in the documentation...
>>
> 
> It should behave similar to memcg. ie, if hierarchy is set, then we limit
> using MIN(parent's limit, child's limit). May be I am missing some of
> the details of memcg use_hierarchy config. My goal was to keep it
> similar to memcg. Can you explain why do you think the patch would
> make it any different ?
> 


Maybe this is a different story but....

Tejun(Cgroup Maintainer) asked us to remove 'use_hierarchy' settings because
most of other cgroups are hierarchical(*). I answered that improvement in res_counter 
latency is required. And now, we have some idea to improve res_counter.
(I'd like to try this after page_cgroup diet series..)

If we change and drop use_hierarchy, the usage similar to current use_hierarchy=0
will be..

	/cgroup/memory/			       = unlimited
			level1		       = unlimited
				level2	       = unlimited
					level3 = limit

To do this, after improvement of res_counter, we entry use_hierarchy into
feature-removal-list and wait for 2 versions..So, this will not affect
your developments, anyway.
 
Thanks,
-Kame

(*) AFAIK, blkio cgroup needs tons of work to be hierarchical...

