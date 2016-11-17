From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: memory.force_empty is deprecated
Date: Thu, 17 Nov 2016 21:39:41 +1100
Message-ID: <5b03def0-2dc4-842f-0d0e-53cc2d94936f@gmail.com>
References: <OF57AEC2D2.FA566D70-ON48258061.002C144F-48258061.002E2E50@notes.na.collabserv.com>
 <20161104152103.GC8825@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=EV44O5UxwWQdYSIEgclgDXm6QdaN0LmXCY8jTrlx3JI=;
        b=lVMRDRGIuqhycl9jcTSJQV8zK3c64CcZuWfO6gaAKWoHq9jiOUZQDWa12lJIxBPs9z
         eW32oDOIdi4pvqDmIakCz1VTXrXN0kbIHrFlJe6YNDwd1UXurVRvyTd3DTAI/0stcuXb
         q8npPzuwC9P+F+KfQpn/PZAeYCRvsmpUDRhVQwawbtaxDgoet4Q29SWgDkNCucC6+jXx
         BODLA4JZDNNqZzojEahhDgQ366P+96/oiKILxdn1VzUdSGm2cIMDpaXOMN1111Xy8IDj
         wy2IfVAB0dcyAbp7XVNsaCUrfNxVxdqq7ju9RPtXTCEEfkv4HsWkoNhQuXDtNjWVE6wg
         7BxQ==
In-Reply-To: <20161104152103.GC8825@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Zhao Hui Ding <dingzhh@cn.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org



On 05/11/16 02:21, Johannes Weiner wrote:
> Hi,
> 
> On Fri, Nov 04, 2016 at 04:24:25PM +0800, Zhao Hui Ding wrote:
>> Hello,
>>
>> I'm Zhaohui from IBM Spectrum LSF development team. I got below message 
>> when running LSF on SUSE11.4, so I would like to share our use scenario 
>> and ask for the suggestions without using memory.force_empty.
>>
>> memory.force_empty is deprecated and will be removed. Let us know if it is 
>> needed in your usecase at linux-mm@kvack.org
>>
>> LSF is a batch workload scheduler, it uses cgroup to do batch jobs 
>> resource enforcement and accounting. For each job, LSF creates a cgroup 
>> directory and put job's PIDs to the cgroup.
>>
>> When we implement LSF cgroup integration, we found creating a new cgroup 
>> is much slower than renaming an existing cgroup, it's about hundreds of 
>> milliseconds vs less than 10 milliseconds.
> 

We added force_empty a long time back so that we could force delete
cgroups. There was no definitive way of removing references to the cgroup
from page_cgroup otherwise.

> Cgroup creation/deletion is not expected to be an ultra-hot path, but
> I'm surprised it takes longer than actually reclaiming leftover pages.
> 
> By the time the jobs conclude, how much is usually left in the group?
> 
> That said, is it even necessary to pro-actively remove the leftover
> cache from the group before starting the next job? Why not leave it
> for the next job to reclaim it lazily should memory pressure arise?
> It's easy to reclaim page cache, and the first to go as it's behind
> the next job's memory on the LRU list.

It might actually make sense to migrate all tasks out and check what
the left overs look like -- should be easy to reclaim. Also be mindful
if you are using v1 and have use_hierarchy set.

Balbir Singh.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
