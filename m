From: Dima Zavin <dmitriyz-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cpuset: fix a deadlock due to incomplete patching of cpusets_enabled()
Date: Fri, 28 Jul 2017 01:48:50 -0700
Message-ID: <CAPz4a6C3JDPdkcvgo1JfynDfheDy2gkE1JcOZVhChry7C1yBwQ@mail.gmail.com>
References: <alpine.DEB.2.20.1707261158560.9311@nuc-kabylake>
 <20170727164608.12701-1-dmitriyz@waymo.com> <41954034-9de1-de8e-f915-51a4b0334f98@suse.cz>
Reply-To: dmitriyz-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waymo.com; s=google;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=CCxTeiDMOSmAUuJKUI7KBNJnyLiypniR6qzRc/2Ryt4=;
        b=XgRSIgroLAdkb8NEqQV0pUTYuXCS/0prhIc651HgdRsEHIERu4sgDzDWeSKssuMRSb
         eqkNclA0/hxLtnwy3vEH5a/wyBWg6XGiMVnOErzOoxTpECPTEORX/b4T2QoojSTkVlvi
         H7k28fk4kb+rUzdUGAT7YNYumFCZXGH3TGYfk=
In-Reply-To: <41954034-9de1-de8e-f915-51a4b0334f98-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cliff Spradlin <cspradlin-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Fri, Jul 28, 2017 at 12:45 AM, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
> [+CC PeterZ]
>
> On 07/27/2017 06:46 PM, Dima Zavin wrote:
>> In codepaths that use the begin/retry interface for reading
>> mems_allowed_seq with irqs disabled, there exists a race condition that
>> stalls the patch process after only modifying a subset of the
>> static_branch call sites.
>>
>> This problem manifested itself as a dead lock in the slub
>> allocator, inside get_any_partial. The loop reads
>> mems_allowed_seq value (via read_mems_allowed_begin),
>> performs the defrag operation, and then verifies the consistency
>> of mem_allowed via the read_mems_allowed_retry and the cookie
>> returned by xxx_begin. The issue here is that both begin and retry
>> first check if cpusets are enabled via cpusets_enabled() static branch.
>> This branch can be rewritted dynamically (via cpuset_inc) if a new
>> cpuset is created. The x86 jump label code fully synchronizes across
>> all CPUs for every entry it rewrites. If it rewrites only one of the
>> callsites (specifically the one in read_mems_allowed_retry) and then
>> waits for the smp_call_function(do_sync_core) to complete while a CPU is
>> inside the begin/retry section with IRQs off and the mems_allowed value
>> is changed, we can hang. This is because begin() will always return 0
>> (since it wasn't patched yet) while retry() will test the 0 against
>> the actual value of the seq counter.
>
> Hm I wonder if there are other static branch users potentially having
> similar problem. Then it would be best to fix this at static branch
> level. Any idea, Peter? An inelegant solution would be to have indicate
> static_branch_(un)likely() callsites ordering for the patching. I.e.
> here we would make sure that read_mems_allowed_begin() callsites are
> patched before read_mems_allowed_retry() when enabling the static key,
> and the opposite order when disabling the static key.
>

This was my main worry, that I'm just patching up one incarnation of
this problem
and other clients will eventually trip over this.

>> The fix is to cache the value that's returned by cpusets_enabled() at the
>> top of the loop, and only operate on the seqcount (both begin and retry) if
>> it was true.
>
> Maybe we could just return e.g. -1 in read_mems_allowed_begin() when
> cpusets are disabled, and test it in read_mems_allowed_retry() before
> doing a proper seqcount retry check? Also I think you can still do the
> cpusets_enabled() check in read_mems_allowed_retry() before the
> was_enabled (or cookie == -1) test?

Hmm, good point! If cpusets_enabled() is true, then we can still test against
was_enabled and do the right thing (adds one extra branch in that case). When
it's false, we still benefit from the static_branch fanciness. Thanks!

Re setting the cookie to -1, I didn't really want to overload the
cookie value but
rather just make the state explicit so it's easier to grawk as this is
all already
subtle enough.
