From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Wed, 9 Feb 2022 14:56:23 -0500 (EST)
Message-ID: <575163430.50481.1644436583757.JavaMail.zimbra@efficios.com>
References: <20220208184208.79303-1-namhyung@kernel.org> <20220209090908.GK23216@worktop.programming.kicks-ass.net> <24fe6a08-5931-8e8d-8d77-459388c4654e@redhat.com> <919214156.50301.1644431371345.JavaMail.zimbra@efficios.com> <69e5f778-8715-4acf-c027-58b6ec4a9e77@redhat.com> <CAM9d7ci=N2NVj57k=W0ebqBzfW+ThBqYSrx-CZbgwGcbOSrEGA@mail.gmail.com> <718973621.50447.1644434890744.JavaMail.zimbra@efficios.com> <CAM9d7cj=tj6pA48q_wkQOGn-2vUc9FRj63bMBOm5R7OukmMbTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com E627B3B4E7F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1644436583;
        bh=TGXHNcESyLk7e4fzBk383pOUPG79qFlYdVN8p53Ep/Q=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=o2rMAwb82gk7CvIC1/Lg6Ovt8Ys6ualxXZZEJUIKPgpUsZnCRkpg0CTrB6sSGJHw4
         OGw22rdi0SSLref9YrWriHrt4yZXTgoVohqZF5bRFmtFF1xwyls8hv2A+THlk0FHMu
         tiOkWfGSipmXDJGG0hD9nxGnUNw28RXeYFKHNvJMTJEt19vk9eFeRK3AKqT6Zd+Rfq
         Eli3lK06XO9htl+iJXGczHmHtM5VJoxV8wYgHNYdOXotrFgrQh2BcLtrwe1a/9VVfJ
         z4tNmAat+9f3PE1+P2dRQt+/bBMnlw44dJZYqv1P6HvSjjbIakgi7sEATlyFrZynWi
         WsAcN9S5ot38g==
In-Reply-To: <CAM9d7cj=tj6pA48q_wkQOGn-2vUc9FRj63bMBOm5R7OukmMbTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, intel-gfx <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, paulmck <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

----- On Feb 9, 2022, at 2:45 PM, Namhyung Kim namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> On Wed, Feb 9, 2022 at 11:28 AM Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>>
>> ----- On Feb 9, 2022, at 2:22 PM, Namhyung Kim namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>> > I'm also concerning dynamic allocated locks in a data structure.
>> > If we keep the info in a hash table, we should delete it when the
>> > lock is gone.  I'm not sure we have a good place to hook it up all.
>>
>> I was wondering about this use case as well. Can we make it mandatory to
>> declare the lock "class" (including the name) statically, even though the
>> lock per-se is allocated dynamically ? Then the initialization of the lock
>> embedded within the data structure would simply refer to the lock class
>> definition.
> 
> Isn't it still the same if we have static lock classes that the entry needs
> to be deleted from the hash table when it frees the data structure?
> I'm more concerned about free than alloc as there seems to be no
> API to track that in a place.

If the lock class is defined statically, even for dynamically initialized
locks, then its associated object sits either in the core kernel or within
a module.

So if it's in the core kernel, it could be added to the hash table at kernel
init and stay there forever.

If it's in a module, it would be added to the hash table on module load and
removed on module unload. We would have to be careful about how the ftrace
printout to human readable text deals with missing hash table data, because
that printout will happen after buffering, so an untimely module unload could
make this address to string mapping unavailable for a few events. If we care
about getting this corner case right there are a few things we could do as
well.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
