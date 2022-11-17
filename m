From: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: cgroup v1 and balance_dirty_pages
Date: Thu, 17 Nov 2022 21:21:10 +0530
Message-ID: <9fb5941b-2c74-87af-a476-ce94b43bb542@linux.ibm.com>
References: <87wn7uf4ve.fsf@linux.ibm.com> <Y3ZPZyaX1WN3tad4@cmpxchg.org>
 <697e50fd-1954-4642-9f61-1afad0ebf8c6@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VSvo3DzzZ6W9Zwu6bf+7BT7BTowY6XloRvx0HAp2VXg=;
 b=Vp0Lm778Lb7Zr6NKKi4EiSBOCzUMqRjaNe9XDOf5HYK+s4e3f4Hfz66Cg5l/5l2+z4pu
 VQ6O09uvEcmfUkSM4F1UirtN5TJzDlK0RiyzV/D3UPRKtTPtb/4DXXspIWtUHbBjK/P0
 THf01wX6EInqYCyyDNnAXyA57US4/u98ozO9kx0n/f4PPVM+QrOQmEFdmuA9YTq0K4kd
 EfzR5VJLYmGZEgDuNe56iJmBRoFEH5txT1snAEHpeVdLWlxovnFsCLfcKSkp7ip/l7La
 CB6sBhu+yy1ZxyAk0XLcIr+9u5okQPIzvoSi8+DKGgVDBtAYFD2grT2aSEQ7ugi5uRnI QA== 
Content-Language: en-US
In-Reply-To: <697e50fd-1954-4642-9f61-1afad0ebf8c6-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/17/22 9:12 PM, Aneesh Kumar K V wrote:
> On 11/17/22 8:42 PM, Johannes Weiner wrote:
>> Hi Aneesh,
>>
>> On Thu, Nov 17, 2022 at 12:24:13PM +0530, Aneesh Kumar K.V wrote:
>>> Currently, we don't pause in balance_dirty_pages with cgroup v1 when we
>>> have task dirtying too many pages w.r.t to memory limit in the memcg.
>>> This is because with cgroup v1 all the limits are checked against global
>>> available resources. So on a system with a large amount of memory, a
>>> cgroup with a smaller limit can easily hit OOM if the task within the
>>> cgroup continuously dirty pages.
>>
>> Page reclaim has special writeback throttling for cgroup1, see the
>> folio_wait_writeback() in shrink_folio_list(). It's not as smooth as
>> proper dirty throttling, but it should prevent OOMs.
>>
>> Is this not working anymore?
> 
> The test is a simple dd test on on a 256GB system.
> 
> root@lp2:/sys/fs/cgroup/memory# mkdir test
> root@lp2:/sys/fs/cgroup/memory# cd test/
> root@lp2:/sys/fs/cgroup/memory/test# echo 120M > memory.limit_in_bytes 
> root@lp2:/sys/fs/cgroup/memory/test# echo $$ > tasks 
> root@lp2:/sys/fs/cgroup/memory/test# dd if=/dev/zero of=/home/kvaneesh/test bs=1M 
> Killed
> 
> 
> Will it hit the folio_wait_writeback, because it is sequential i/o and none of the folio
> we are writing will be in writeback?

Other way to look at this is, if the writeback is never started via balance_dirty_pages,
will we be finding folios in shrink_folio_list that is in writeback? 

> 
>>
>>> Shouldn't we throttle the task based on the memcg limits in this case?
>>> commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
>>> on traditional hierarchies") indicates we run into issues with enabling
>>> cgroup writeback with v1. But we still can keep the global writeback
>>> domain, but check the throtling needs against memcg limits in
>>> balance_dirty_pages()?
>>
>> Deciding when to throttle is only one side of the coin, though.
>>
>> The other side is selective flushing in the IO context of whoever
>> generated the dirty data, and matching the rate of dirtying to the
>> rate of writeback. This isn't really possible in cgroup1, as the
>> domains for memory and IO control could be disjunct.
>>
>> For example, if a fast-IO cgroup shares memory with a slow-IO cgroup,
>> what's the IO context for flushing the shared dirty data? What's the
>> throttling rate you apply to dirtiers?
> 
> I am not using I/O controller at all. Only cpu and memory controllers are
> used and what I am observing is depending on the system memory size, the container
> with same memory limits will hit OOM on some machine and not on others.
> 
> One of the challenge with the above test is, we are not able to reclaim via
> shrink_folio_list() because these are dirty file lru pages and we take the
> below code path
> 
> 	if (folio_is_file_lru(folio) &&
> 			    (!current_is_kswapd() ||
> 			     !folio_test_reclaim(folio) ||
> 			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
> 	......
> 				goto activate_locked;
> 	}
> 
>  
> 
> -aneesh

