From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Wed, 9 Feb 2022 13:29:31 -0500 (EST)
Message-ID: <919214156.50301.1644431371345.JavaMail.zimbra@efficios.com>
References: <20220208184208.79303-1-namhyung@kernel.org> <20220209090908.GK23216@worktop.programming.kicks-ass.net> <24fe6a08-5931-8e8d-8d77-459388c4654e@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 959143B44D5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1644431371;
        bh=+Zw/hovgsG1BmQcx6P8MQWbrVbn2r+dD1nEP9OsP7vM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=d+/EJaPNp+fG2gPBRFh9aZtT/SzlY0BX9NyB3hkOcS9zHh3V1BO8Lz/3adWucY2QW
         fmTuQ3YcN/KOYJrI8BuHL72b6g6lUEW6w4xwgAMoqSiW7w7szEM9zsL/eHioPgbpXt
         BhOBvhBW78a6BZjb9dC5qSmzAh+B/y3sbfqKHplgFhF/QqJkHvfRrYlFNTh8PtgLE5
         YuimU6VD1LdRv7w1yOFSszTZpzhDbxLS6XX6bIZpG6sh4sOKBDn+HUVj5k8p6VVtC1
         gkcbUtZ/uVhNNHX3U8U1+Wcy3GCtGTDanpe09W6+vdOFPKH58JmcUWSnShPQC5H0Ee
         EHG/4T/xZ8KSg==
In-Reply-To: <24fe6a08-5931-8e8d-8d77-459388c4654e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, "Paul E. McKenney" <paul.mckenney-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org

----- On Feb 9, 2022, at 1:19 PM, Waiman Long longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:

> On 2/9/22 04:09, Peter Zijlstra wrote:
>> On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:
>>
>>> Eventually I'm mostly interested in the contended locks only and I
>>> want to reduce the overhead in the fast path.  By moving that, it'd be
>>> easy to track contended locks with timing by using two tracepoints.
>> So why not put in two new tracepoints and call it a day?
>>
>> Why muck about with all that lockdep stuff just to preserve the name
>> (and in the process continue to blow up data structures etc..). This
>> leaves distros in a bind, will they enable this config and provide
>> tracepoints while bloating the data structures and destroying things
>> like lockref (which relies on sizeof(spinlock_t)), or not provide this
>> at all.
>>
>> Yes, the name is convenient, but it's just not worth it IMO. It makes
>> the whole proposition too much of a trade-off.
>>
>> Would it not be possible to reconstruct enough useful information from
>> the lock callsite?
>>
> I second that as I don't want to see the size of a spinlock exceeds 4
> bytes in a production system.
> 
> Instead of storing additional information (e.g. lock name) directly into
> the lock itself. Maybe we can store it elsewhere and use the lock
> address as the key to locate it in a hash table. We can certainly extend
> the various lock init functions to do that. It will be trickier for
> statically initialized locks, but we can probably find a way to do that too.

If we go down that route, it would be nice if we can support a few different
use-cases for various tracers out there.

One use-case (a) requires the ability to query the lock name based on its address as key.
For this a hash table is a good fit. This would allow tracers like ftrace to
output lock names in its human-readable output which is formatted within the kernel.

Another use-case (b) is to be able to "dump" the lock { name, address } tuples
into the trace stream (we call this statedump events in lttng), and do the
translation from address to name at post-processing. This simply requires
that this information is available for iteration for both the core kernel
and module locks, so the tracer can dump this information on trace start
and module load.

Use-case (b) is very similar to what is done for the kernel tracepoints. Based
on this, implementing the init code that iterates on those sections and populates
a hash table for use-case (a) should be easy enough.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
