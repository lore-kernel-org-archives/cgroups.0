From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Wed, 9 Feb 2022 14:17:09 -0500 (EST)
Message-ID: <593915946.50384.1644434229077.JavaMail.zimbra@efficios.com>
References: <20220208184208.79303-1-namhyung@kernel.org> <20220209090908.GK23216@worktop.programming.kicks-ass.net> <24fe6a08-5931-8e8d-8d77-459388c4654e@redhat.com> <919214156.50301.1644431371345.JavaMail.zimbra@efficios.com> <69e5f778-8715-4acf-c027-58b6ec4a9e77@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 477333B492B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1644434229;
        bh=yADqTyQkhJP9OM2muqi1wi9cZWwijNMCjs7GZNnU5nc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=hjAFoufIR8rv34T8WsJNcQHG8/h0g9PvgdEhLOVfwKchQzI7I7kmaa8BmDDKxMIb8
         qWMtRNQ9+HYHp5RDTPgJQyWNwtJShaSLCaeaWeVFtlSiRpb8mSI0xOOaYinY+Fpkkt
         3o3JwteTLTuKrtXLK4G2qjxABKI2FQHxhvqVkuso+VgtU/YXYUEpEM75ArV9nCO66D
         msEjAjad96iZYXYzCEJmCdSbVqIUrQKcdJ4RHsEWlhVnJx0YsSZuQdgiRpNm7EF9IZ
         TqtlkNotNQEZholmuLFREIRKaa75WLNb0VPCsfQLH6JPerbhUJFETOJh59k9GszePF
         ibWtvtXK55TGA==
In-Reply-To: <69e5f778-8715-4acf-c027-58b6ec4a9e77-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, "Paul E. McKenney" <paul.mckenney-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, intel-gfx <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

----- On Feb 9, 2022, at 2:02 PM, Waiman Long longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:

> On 2/9/22 13:29, Mathieu Desnoyers wrote:
>> ----- On Feb 9, 2022, at 1:19 PM, Waiman Long longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
>>
>>> On 2/9/22 04:09, Peter Zijlstra wrote:
>>>> On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:
>>>>
>>>>> Eventually I'm mostly interested in the contended locks only and I
>>>>> want to reduce the overhead in the fast path.  By moving that, it'd be
>>>>> easy to track contended locks with timing by using two tracepoints.
>>>> So why not put in two new tracepoints and call it a day?
>>>>
>>>> Why muck about with all that lockdep stuff just to preserve the name
>>>> (and in the process continue to blow up data structures etc..). This
>>>> leaves distros in a bind, will they enable this config and provide
>>>> tracepoints while bloating the data structures and destroying things
>>>> like lockref (which relies on sizeof(spinlock_t)), or not provide this
>>>> at all.
>>>>
>>>> Yes, the name is convenient, but it's just not worth it IMO. It makes
>>>> the whole proposition too much of a trade-off.
>>>>
>>>> Would it not be possible to reconstruct enough useful information from
>>>> the lock callsite?
>>>>
>>> I second that as I don't want to see the size of a spinlock exceeds 4
>>> bytes in a production system.
>>>
>>> Instead of storing additional information (e.g. lock name) directly into
>>> the lock itself. Maybe we can store it elsewhere and use the lock
>>> address as the key to locate it in a hash table. We can certainly extend
>>> the various lock init functions to do that. It will be trickier for
>>> statically initialized locks, but we can probably find a way to do that too.
>> If we go down that route, it would be nice if we can support a few different
>> use-cases for various tracers out there.
>>
>> One use-case (a) requires the ability to query the lock name based on its
>> address as key.
>> For this a hash table is a good fit. This would allow tracers like ftrace to
>> output lock names in its human-readable output which is formatted within the
>> kernel.
>>
>> Another use-case (b) is to be able to "dump" the lock { name, address } tuples
>> into the trace stream (we call this statedump events in lttng), and do the
>> translation from address to name at post-processing. This simply requires
>> that this information is available for iteration for both the core kernel
>> and module locks, so the tracer can dump this information on trace start
>> and module load.
>>
>> Use-case (b) is very similar to what is done for the kernel tracepoints. Based
>> on this, implementing the init code that iterates on those sections and
>> populates
>> a hash table for use-case (a) should be easy enough.
> 
> Yes, that are good use cases for this type of functionality. I do need
> to think about how to do it for statically initialized lock first.

Tracepoints already solved that problem.

Look at the macro DEFINE_TRACE_FN() in include/linux/tracepoint.h. You will notice that
it statically defines a struct tracepoint in a separate section and a tracepoint_ptr_t
in a __tracepoints_ptrs section.

Then the other parts of the picture are in kernel/tracepoint.c:

extern tracepoint_ptr_t __start___tracepoints_ptrs[];
extern tracepoint_ptr_t __stop___tracepoints_ptrs[];

and kernel/module.c:find_module_sections()

#ifdef CONFIG_TRACEPOINTS
        mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
                                             sizeof(*mod->tracepoints_ptrs),
                                             &mod->num_tracepoints);
#endif

and the iteration code over kernel and modules in kernel/tracepoint.c.

All you need in addition is in include/asm-generic/vmlinux.lds.h, we add
to the DATA_DATA define an entry such as:

        STRUCT_ALIGN();                                                 \
        *(__tracepoints)                                                \

and in RO_DATA:

                . = ALIGN(8);                                           \
                __start___tracepoints_ptrs = .;                         \
                KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
                __stop___tracepoints_ptrs = .; 

AFAIU, if you do something similar for a structure that contains your relevant
lock information, it should be straightforward to handle statically initialized
locks.

Thanks,

Mathieu


> 
> Thanks,
> Longman

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
