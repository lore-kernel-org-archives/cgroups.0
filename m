From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Wed, 9 Feb 2022 15:17:38 -0500
Message-ID: <f8b7760f-16a2-6ada-de88-9e21a7e8fef9@redhat.com>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220209090908.GK23216@worktop.programming.kicks-ass.net>
 <24fe6a08-5931-8e8d-8d77-459388c4654e@redhat.com>
 <919214156.50301.1644431371345.JavaMail.zimbra@efficios.com>
 <69e5f778-8715-4acf-c027-58b6ec4a9e77@redhat.com>
 <CAM9d7ci=N2NVj57k=W0ebqBzfW+ThBqYSrx-CZbgwGcbOSrEGA@mail.gmail.com>
 <718973621.50447.1644434890744.JavaMail.zimbra@efficios.com>
 <CAM9d7cj=tj6pA48q_wkQOGn-2vUc9FRj63bMBOm5R7OukmMbTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644437867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KHy+FrMszZUXNvq7VkE1Sw+oLSzIRN5aM5gdNpzgAuE=;
        b=VzOJEpmAzd93oUA+joxWfCChYeeAvHgHqRFIIc2EghoML73dzEDx3j1exxCkDK2uIfAip3
        8CfYVKOqpcP8eZ5A9wZmyLeQkIfg8cEHLhUIipoyT0faLJppPHgtfnn++WlTRB+cgT3ODL
        FFKyIhpPoNDk+/4dhyhRSuz0Dib4uqk=
Content-Language: en-US
In-Reply-To: <CAM9d7cj=tj6pA48q_wkQOGn-2vUc9FRj63bMBOm5R7OukmMbTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, intel-gfx <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, paulmck <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


On 2/9/22 14:45, Namhyung Kim wrote:
> On Wed, Feb 9, 2022 at 11:28 AM Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> ----- On Feb 9, 2022, at 2:22 PM, Namhyung Kim namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>>> I'm also concerning dynamic allocated locks in a data structure.
>>> If we keep the info in a hash table, we should delete it when the
>>> lock is gone.  I'm not sure we have a good place to hook it up all.
>> I was wondering about this use case as well. Can we make it mandatory to
>> declare the lock "class" (including the name) statically, even though the
>> lock per-se is allocated dynamically ? Then the initialization of the lock
>> embedded within the data structure would simply refer to the lock class
>> definition.
> Isn't it still the same if we have static lock classes that the entry needs
> to be deleted from the hash table when it frees the data structure?
> I'm more concerned about free than alloc as there seems to be no
> API to track that in a place.

We may have to invent some new APIs to do that. For example, 
spin_lock_exit() can be the counterpart of spin_lock_init() and so on. 
Of course, existing kernel code have to be modified to designate the 
point after which a lock is no longer being used or is freed.

Cheers,
Longman

