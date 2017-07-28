From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] cpuset: fix a deadlock due to incomplete patching of
 cpusets_enabled()
Date: Fri, 28 Jul 2017 16:05:42 +0200
Message-ID: <9e14ff85-1680-e76d-1b71-22301c16c286@suse.cz>
References: <alpine.DEB.2.20.1707261158560.9311@nuc-kabylake>
 <20170727164608.12701-1-dmitriyz@waymo.com>
 <41954034-9de1-de8e-f915-51a4b0334f98@suse.cz>
 <20170728093047.ykgbufjj74xa5x3r@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170728093047.ykgbufjj74xa5x3r-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dima Zavin <dmitriyz-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cliff Spradlin <cspradlin-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>

On 07/28/2017 11:30 AM, Peter Zijlstra wrote:
> On Fri, Jul 28, 2017 at 09:45:16AM +0200, Vlastimil Babka wrote:
>> [+CC PeterZ]
>>
>> On 07/27/2017 06:46 PM, Dima Zavin wrote:
>>> In codepaths that use the begin/retry interface for reading
>>> mems_allowed_seq with irqs disabled, there exists a race condition that
>>> stalls the patch process after only modifying a subset of the
>>> static_branch call sites.
>>>
>>> This problem manifested itself as a dead lock in the slub
>>> allocator, inside get_any_partial. The loop reads
>>> mems_allowed_seq value (via read_mems_allowed_begin),
>>> performs the defrag operation, and then verifies the consistency
>>> of mem_allowed via the read_mems_allowed_retry and the cookie
>>> returned by xxx_begin. The issue here is that both begin and retry
>>> first check if cpusets are enabled via cpusets_enabled() static branch.
>>> This branch can be rewritted dynamically (via cpuset_inc) if a new
>>> cpuset is created. The x86 jump label code fully synchronizes across
>>> all CPUs for every entry it rewrites. If it rewrites only one of the
>>> callsites (specifically the one in read_mems_allowed_retry) and then
>>> waits for the smp_call_function(do_sync_core) to complete while a CPU is
>>> inside the begin/retry section with IRQs off and the mems_allowed value
>>> is changed, we can hang. This is because begin() will always return 0
>>> (since it wasn't patched yet) while retry() will test the 0 against
>>> the actual value of the seq counter.
>>
>> Hm I wonder if there are other static branch users potentially having
>> similar problem. Then it would be best to fix this at static branch
>> level. Any idea, Peter? An inelegant solution would be to have indicate
>> static_branch_(un)likely() callsites ordering for the patching. I.e.
>> here we would make sure that read_mems_allowed_begin() callsites are
>> patched before read_mems_allowed_retry() when enabling the static key,
>> and the opposite order when disabling the static key.
> 
> I'm not aware of any other sure ordering requirements. But you can
> manually create this order by using 2 static keys. Then flip them in the
> desired order.

Right, thanks for the suggestion. I think that would be preferable to
complicating the cookie handling. Add a new key next to
cpusets_enabled_key, let's say "cpusets_enabled_pre_key". Make
read_mems_allowed_begin() check this key instead of cpusets_enabled().
Change cpuset_inc/dec to inc/dec also this new key in the right order
and that should be it. Dima, can you try that or should I?

Thanks,
Vlastimil

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 
