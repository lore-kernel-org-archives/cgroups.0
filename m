From: Dima Zavin <dmitriyz@waymo.com>
Subject: Re: [PATCH v2] cpuset: fix a deadlock due to incomplete patching of cpusets_enabled()
Date: Fri, 28 Jul 2017 09:52:21 -0700
Message-ID: <CAPz4a6ALRdkPZd7QBOMrC7t4_SqPPYm3gdhxnuBiVZOmPqs73g@mail.gmail.com>
References: <alpine.DEB.2.20.1707261158560.9311@nuc-kabylake>
 <20170727164608.12701-1-dmitriyz@waymo.com> <41954034-9de1-de8e-f915-51a4b0334f98@suse.cz>
 <20170728093047.ykgbufjj74xa5x3r@hirez.programming.kicks-ass.net> <9e14ff85-1680-e76d-1b71-22301c16c286@suse.cz>
Reply-To: dmitriyz@waymo.com
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waymo.com; s=google;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=1ED2bcNfQSTsB+z/VRwvsh6Xbdi3Uwz/9VE3Qu1XnEg=;
        b=FNDj88DzIsSk4ikE1YZerCkHYRA0CDXXkIS8kK/UvFdQsJXe/7gHqnt5QGqJrPdTov
         GZXSUy7CIVQEz16jxG+IHutApuuVcAwoGQPGyCfB+AxPb7mhwlj924O1Oweb//04ehq8
         pXA0pK+3ZtmGSPb+QWrdv0tav2AxsIfcE/8qg=
In-Reply-To: <9e14ff85-1680-e76d-1b71-22301c16c286@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Christopher Lameter <cl@linux.com>, Li Zefan <lizefan@huawei.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Cliff Spradlin <cspradlin@waymo.com>, Mel Gorman <mgorman@techsingularity.net>

On Fri, Jul 28, 2017 at 7:05 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 07/28/2017 11:30 AM, Peter Zijlstra wrote:
>> On Fri, Jul 28, 2017 at 09:45:16AM +0200, Vlastimil Babka wrote:
>>> [+CC PeterZ]
>>>
>>> On 07/27/2017 06:46 PM, Dima Zavin wrote:
>>>> In codepaths that use the begin/retry interface for reading
>>>> mems_allowed_seq with irqs disabled, there exists a race condition that
>>>> stalls the patch process after only modifying a subset of the
>>>> static_branch call sites.
>>>>
>>>> This problem manifested itself as a dead lock in the slub
>>>> allocator, inside get_any_partial. The loop reads
>>>> mems_allowed_seq value (via read_mems_allowed_begin),
>>>> performs the defrag operation, and then verifies the consistency
>>>> of mem_allowed via the read_mems_allowed_retry and the cookie
>>>> returned by xxx_begin. The issue here is that both begin and retry
>>>> first check if cpusets are enabled via cpusets_enabled() static branch.
>>>> This branch can be rewritted dynamically (via cpuset_inc) if a new
>>>> cpuset is created. The x86 jump label code fully synchronizes across
>>>> all CPUs for every entry it rewrites. If it rewrites only one of the
>>>> callsites (specifically the one in read_mems_allowed_retry) and then
>>>> waits for the smp_call_function(do_sync_core) to complete while a CPU is
>>>> inside the begin/retry section with IRQs off and the mems_allowed value
>>>> is changed, we can hang. This is because begin() will always return 0
>>>> (since it wasn't patched yet) while retry() will test the 0 against
>>>> the actual value of the seq counter.
>>>
>>> Hm I wonder if there are other static branch users potentially having
>>> similar problem. Then it would be best to fix this at static branch
>>> level. Any idea, Peter? An inelegant solution would be to have indicate
>>> static_branch_(un)likely() callsites ordering for the patching. I.e.
>>> here we would make sure that read_mems_allowed_begin() callsites are
>>> patched before read_mems_allowed_retry() when enabling the static key,
>>> and the opposite order when disabling the static key.
>>
>> I'm not aware of any other sure ordering requirements. But you can
>> manually create this order by using 2 static keys. Then flip them in the
>> desired order.
>
> Right, thanks for the suggestion. I think that would be preferable to
> complicating the cookie handling. Add a new key next to
> cpusets_enabled_key, let's say "cpusets_enabled_pre_key". Make
> read_mems_allowed_begin() check this key instead of cpusets_enabled().
> Change cpuset_inc/dec to inc/dec also this new key in the right order
> and that should be it. Dima, can you try that or should I?

Yeah, I like that approach much better. I'll re-spin a new version in a bit.

--Dima

>
> Thanks,
> Vlastimil
>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
