From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Fri, 2 Jun 2017 16:36:22 -0400
Message-ID: <cf47d637-204c-49ea-94ec-c2bf0cf10614@redhat.com>
References: <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
 <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
 <ffa991a3-074d-ffd5-7a6a-556d6cdd08fe@redhat.com>
 <20170601184740.GC3494@htj.duckdns.org>
 <ca834386-c41c-2797-702f-91516b06779f@redhat.com>
 <20170601203815.GA13390@htj.duckdns.org>
 <e65745c2-3b07-eb8b-b638-04e9bb1ed1e6@redhat.com>
 <20170601205203.GB13390@htj.duckdns.org>
 <1e775dcf-61b2-29d5-a214-350dc81c632b@redhat.com>
 <20170601211823.GC13390@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 1BDCED0A82
In-Reply-To: <20170601211823.GC13390@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

On 06/01/2017 05:18 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Jun 01, 2017 at 05:12:42PM -0400, Waiman Long wrote:
>> Are you referring to keeping the no internal process restriction and
>> document how to work around that instead? I would like to hear what
>> workarounds are currently being used.
> What we've been talking about all along - just creating explicit leaf
> nodes.
>
>> Anyway, you currently allow internal process in thread mode, but not i=
n
>> non-thread mode. I would prefer no such restriction in both thread and=

>> non-thread mode.
> Heh, so, these aren't arbitrary.  The contraint is tied to
> implementing resource domains and thread subtree doesn't have resource
> domains in them, so they don't need the constraint.  I'm sorry about
> the short replies but I'm kinda really tied up right now.  I'm gonna
> do the thread mode so that it can be agnostic w.r.t. the internal
> process constraint and I think it could be helpful to decouple these
> discussions.  We've been having this discussion for a couple years now
> and it looks like we're gonna go through it all over, which is fine,
> but let's at least keep that separate.

I wouldn't argue further on that if you insist. However, I still want to
relax the constraint somewhat by abandoning the no internal process
constraint  when only threaded controllers (non-resource domains) are
enabled even when thread mode has not been explicitly enabled. It is a
modified version my second alternative. Now the question is which
controllers are considered to be resource domains. I think memory and
blkio are in the list. What else do you think should be considered
resource domains?

Cheers,
Longman



any of the resource domains (!threaded) controllers are enabled.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
