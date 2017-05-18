From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 18 May 2017 13:21:02 -0400
Message-ID: <5fd96236-532a-964f-f130-c93272edbc8e@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170517214718.GH942@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com BDCA07247C
In-Reply-To: <20170517214718.GH942@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

On 05/17/2017 05:47 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, May 15, 2017 at 09:34:10AM -0400, Waiman Long wrote:
>> The current thread mode semantics aren't sufficient to fully support
>> threaded controllers like cpu. The main problem is that when thread
>> mode is enabled at root (mainly for performance reason), all the
>> non-threaded controllers cannot be supported at all.
>>
>> To alleviate this problem, the roles of thread root and threaded
>> cgroups are now further separated. Now thread mode can only be enabled=

>> on a non-root leaf cgroup whose parent will then become the thread
>> root. All the descendants of a threaded cgroup will still need to be
>> threaded. All the non-threaded resource will be accounted for in the
>> thread root. Unlike the previous thread mode, however, a thread root
>> can have non-threaded children where system resources like memory
>> can be further split down the hierarchy.
>>
>> Now we could have something like
>>
>> 	R -- A -- B
>> 	 \
>> 	  T1 -- T2
>>
>> where R is the thread root, A and B are non-threaded cgroups, T1 and
>> T2 are threaded cgroups. The cgroups R, T1, T2 form a threaded subtree=

>> where all the non-threaded resources are accounted for in R.  The no
>> internal process constraint does not apply in the threaded subtree.
>> Non-threaded controllers need to properly handle the competition
>> between internal processes and child cgroups at the thread root.
>>
>> This model will be flexible enough to support the need of the threaded=

>> controllers.
> I do like the approach and it does address the issue with requiring at
> least one level of nesting for the thread mode to be used with other
> controllers.  I need to think a bit more about it and mull over what
> Peterz was suggesting in the old thread.  I'll get back to you soon
> but I'd really prefer this and the earlier related patches to be in
> its own patchset so that we aren't dealing with different things at
> the same time.
>
> Thanks.
>
I have studied the email exchanges with your original thread mode
patchset. This patchset is aimed to hopefully address all the concerns
that Peterz has. This enhanced thread mode should address a big part of
the concern. However, I am not sure if this patch, by itself, is enough
to address all his concerns. That is why I also include 2 other major
changes in the next 2 patches. My goal is to move forward to allow all
controllers to be enabled for v2 eventually. We are not there yet, but I
hope this patchset can move thing forward meaningfully.

Regards,
Longman


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
