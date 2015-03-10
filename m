From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Tue, 10 Mar 2015 19:19:06 +1100
Message-ID: <CAOviyaj3mf66ho15WrD8qB=ECxKWYTAkWodxWaFVMWeZG4d0FQ@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<1425010639-16492-1-git-send-email-cyphar@cyphar.com>
	<1425010639-16492-2-git-send-email-cyphar@cyphar.com>
	<20150309030636.GC13283@htj.duckdns.org>
	<CAOviyaip7Faz98YWzGoTaXGYVb72sfD+ZL4Xa89reU9+=43jFA@mail.gmail.com>
	<20150309065902.GP13283@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150309065902.GP13283-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Hi Tejun,

>> The reason is that when cgroup_can_fork() is called, the css_set doesn't
>> contain the pids cgroup it's forking to. You can verify this by moving that
>> segment of code back to it's original position and compiling/rebooting/testing
>> the pids cgroup. You will get a WARN each time you try to attach to a new pids
>> cgroup, because when your shell forks the counter for the original pids cgroup
>> hierarchy gets incremented but when the command exits the counter for the *new*
>> pids cgroup hierarchy gets decremented. Essentially it's because we need to
>> reference the css_set of the newly forked process (as it exists when
>> cgroup_fork() runs) when incrementing the hierarchy -- otherwise we will
>> increment/decrement a different hierarchy between fork() and exit().
>>
>> If there's a correct way of doing this, I'm all ears. I had a bad feeling that
>> moving that section would break the whole visibility issue in the same fashion
>> as I did in v1 of this patchset. The thing is, I'm not sure there's a way to
>> access the new css_set of the task as though it is attached without making it
>> visible prematurely (because we need the css_set to refer to the right
>> hierarchy in order to conditionally decide the fork).
>
> You can charge the parent's at can_attach(), remember which one you
> charged, and at post_fork() if the parent's has changed inbetween, fix
> it up.  Again, you may end up breaking the hard limit of the new pids
> cgroup at this point but that's fine.  The cgroup membership changing
> inbetween pretty much implies that organization operation happened
> inbetween.

I'm not sure how to check for equality between two `css_set`s (or just two
`css`s). Is there a function to do so? Also, I'm not sure if there's a nice way
of doing a charge that stops if you hit a certain `css` (unless we start
passing `css_set`s to the fork/exit callbacks -- and then we can uncharge the
old css_set and charge the new one).

--
Aleksa Sarai (cyphar)
www.cyphar.com
