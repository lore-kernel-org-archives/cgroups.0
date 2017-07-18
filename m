From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Tue, 18 Jul 2017 13:35:51 -0400
Message-ID: <b9fed984-76a4-b27a-b570-9b5fafa2614b@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <20170717142609.GC3519177@devbig577.frc2.facebook.com>
 <20170718172801.f56273tzgzn3xkne@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 5D2E6C04D2A4
In-Reply-To: <20170718172801.f56273tzgzn3xkne-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 07/18/2017 01:28 PM, Peter Zijlstra wrote:
> On Mon, Jul 17, 2017 at 10:26:09AM -0400, Tejun Heo wrote:
>> Hello, Peter.
>>
>> On Mon, Jul 17, 2017 at 04:14:09PM +0200, Peter Zijlstra wrote:
>>> AFAICT this is not in fact what I suggested... :/
>> Heh, sorry about misattributing that.  I was mostly referring to the
>> overall idea of marking each cgroup domain or threaded rather than
>> subtree.
>>
>>> My proposal did not have that invalid state. It would simply refuse to
>>> change the type from thread to domain in the case where the parent is
>>> not a domain.
>>>
>>> Also, my proposal maintained the normal property inheritance rules. A
>>> child cgroup's creation 'type' would be that of its parent and not
>>> always be 'domain'.
>> But aren't both of the above get weird when the parent can host both
>> domain and threaded children?
>>
>> 	  R
>>        /
>>       A(D)
>>
>> If you create another child B under R, it's naturally gonna be a
>> domain.  Let's say you turn that to threaded.
>>
>> 	   R
>>        /   \
>>      A(D) B(T)
>>
>> And now try to create another child C, should that be a domain or
>> threaded?
> Domain of course, as R must be a domain, and hence all its children
> start out as such.
>
>> If we only inherit from the second level on, which is in itself
>> already confusing, that still leads to invalid configs for non-root
>> thread roots.
> I don't see how. I don't get the example Waiman gave, what is wrong
> with:
>
> 	R (D)
> 	|
> 	A (D)
>        / \
>      C(D) B(T) 
>
> ? Afaict that's a perfectly valid configuration.

From what I understand, C is considered to be in an invalid state
because of the no internal process rule. A in this case is the thread
root, so it can have internal process. If C is a domain and a child of
A, we will have the case that internal processes in A is competing
against cgroup C.

I have been advocating (in one of my RFC patches) that we should relax
the rules to allow internal processes when only threaded controllers are
enabled as they are supposed to be able to handle internal processes.

Cheers,
Longman
