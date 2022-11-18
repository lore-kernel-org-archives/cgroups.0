From: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: cgroup v1 and balance_dirty_pages
Date: Fri, 18 Nov 2022 09:26:59 +0530
Message-ID: <c7bd9e56-d49b-f68c-3c98-e345ed21680b@linux.ibm.com>
References: <87wn7uf4ve.fsf@linux.ibm.com> <Y3ZPZyaX1WN3tad4@cmpxchg.org>
 <697e50fd-1954-4642-9f61-1afad0ebf8c6@linux.ibm.com>
 <9fb5941b-2c74-87af-a476-ce94b43bb542@linux.ibm.com>
 <Y3ZhyfROmGKn/jfr@cmpxchg.org>
 <db372090-cd6d-32e9-2ed1-0d5f9dc9c1df@linux.ibm.com>
 <Y3Z0ZIroRFd1B6ad@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+OlmRwhv1JUQ0IRPgAVeFsCWRQ3D77HqxBzZtnsNbBw=;
 b=pZhh+fl+SD7CKNk7p5bgNBBYbBLsVmm/5nyT02zUFA94QtwPrDNQ3kJ+RyijV3YfLeLi
 RKxhCb719M4gUgDOQUpbmo5PhbVbYpJwC7KypG4OlaSBhtycdAOE++/LOc9LHbxOgn+9
 +aWMVuA2NpkQRkdtfHXjrahcV1FgE+LrACpjumVSjwIzj//Mtp3Sa/GsmUaLt/FyaIDc
 yJgBWvsLt4I98j+2cJjhfp9BsabbsWsR2Tkj9U7yXMcjfA8xsqak4VMdx9Pvuf4yyb5n
 tUxrdiUnddbwDx7kxCqGGmM8MNTpqWJkkjz8JzvXdq7VAO5MAc6n0lPaL9S6qcAbXbco eQ== 
Content-Language: en-US
In-Reply-To: <Y3Z0ZIroRFd1B6ad-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/17/22 11:20 PM, Johannes Weiner wrote:
> On Thu, Nov 17, 2022 at 10:46:53PM +0530, Aneesh Kumar K V wrote:
>> On 11/17/22 10:01 PM, Johannes Weiner wrote:
>>> On Thu, Nov 17, 2022 at 09:21:10PM +0530, Aneesh Kumar K V wrote:
>>>> On 11/17/22 9:12 PM, Aneesh Kumar K V wrote:
>>>>> On 11/17/22 8:42 PM, Johannes Weiner wrote:
>>>>>> Hi Aneesh,
>>>>>>
>>>>>> On Thu, Nov 17, 2022 at 12:24:13PM +0530, Aneesh Kumar K.V wrote:
>>>>>>> Currently, we don't pause in balance_dirty_pages with cgroup v1 when we
>>>>>>> have task dirtying too many pages w.r.t to memory limit in the memcg.
>>>>>>> This is because with cgroup v1 all the limits are checked against global
>>>>>>> available resources. So on a system with a large amount of memory, a
>>>>>>> cgroup with a smaller limit can easily hit OOM if the task within the
>>>>>>> cgroup continuously dirty pages.
>>>>>>
>>>>>> Page reclaim has special writeback throttling for cgroup1, see the
>>>>>> folio_wait_writeback() in shrink_folio_list(). It's not as smooth as
>>>>>> proper dirty throttling, but it should prevent OOMs.
>>>>>>
>>>>>> Is this not working anymore?
>>>>>
>>>>> The test is a simple dd test on on a 256GB system.
>>>>>
>>>>> root@lp2:/sys/fs/cgroup/memory# mkdir test
>>>>> root@lp2:/sys/fs/cgroup/memory# cd test/
>>>>> root@lp2:/sys/fs/cgroup/memory/test# echo 120M > memory.limit_in_bytes 
>>>>> root@lp2:/sys/fs/cgroup/memory/test# echo $$ > tasks 
>>>>> root@lp2:/sys/fs/cgroup/memory/test# dd if=/dev/zero of=/home/kvaneesh/test bs=1M 
>>>>> Killed
>>>>>
>>>>>
>>>>> Will it hit the folio_wait_writeback, because it is sequential i/o and none of the folio
>>>>> we are writing will be in writeback?
>>>>
>>>> Other way to look at this is, if the writeback is never started via balance_dirty_pages,
>>>> will we be finding folios in shrink_folio_list that is in writeback? 
>>>
>>> The flushers are started from reclaim if necessary. See this code from
>>> shrink_inactive_list():
>>>
>>> 	/*
>>> 	 * If dirty folios are scanned that are not queued for IO, it
>>> 	 * implies that flushers are not doing their job. This can
>>> 	 * happen when memory pressure pushes dirty folios to the end of
>>> 	 * the LRU before the dirty limits are breached and the dirty
>>> 	 * data has expired. It can also happen when the proportion of
>>> 	 * dirty folios grows not through writes but through memory
>>> 	 * pressure reclaiming all the clean cache. And in some cases,
>>> 	 * the flushers simply cannot keep up with the allocation
>>> 	 * rate. Nudge the flusher threads in case they are asleep.
>>> 	 */
>>> 	if (stat.nr_unqueued_dirty == nr_taken)
>>> 		wakeup_flusher_threads(WB_REASON_VMSCAN);
>>>
>>> It sounds like there isn't enough time for writeback to commence
>>> before the memcg already declares OOM.
>>>
>>> If you place a reclaim_throttle(VMSCAN_THROTTLE_WRITEBACK) after that
>>> wakeup, does that fix the issue?
>>
>> yes. That helped. One thing I noticed is with that reclaim_throttle, we
>> don't end up calling folio_wait_writeback() at all. But still the
>> dd was able to continue till the file system got full. 
>>
>> Without that reclaim_throttle(), we do end up calling folio_wait_writeback()
>> but at some point hit OOM 
> 
> Interesting. This is probably owed to the discrepancy between total
> memory and the cgroup size. The flusher might put the occasional
> cgroup page under writeback, but cgroup reclaim will still see mostly
> dirty pages and not slow down enough.
> 
> Would you mind sending a patch for adding that reclaim_throttle()?
> Gated on !writeback_throttling_sane(), with a short comment explaining
> that the flushers may not issue writeback quickly enough for cgroup1
> writeback throttling to work on larger systems with small cgroups.

I will do that. 

-aneesh


