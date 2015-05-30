From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 8/8] cgroup: implement the PIDs subsystem
Date: Sat, 30 May 2015 16:50:34 +1000
Message-ID: <CAOviyaht-5LnBhW81coZKOwcqW+DqN0MnMUy0K6EgQPMVkMYsg@mail.gmail.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
	<1431960667-26593-9-git-send-email-cyphar@cyphar.com>
	<20150519080055.GA3644@twins.programming.kicks-ass.net>
	<CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA@mail.gmail.com>
	<alpine.DEB.2.11.1505191508530.4225@nanos>
	<20150528204051.GB27479@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528204051.GB27479-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

>> That's complete and utter nonsense. What has the parent limit to do
>> with the overflow of the child limit?
>>
>> parent:        limit 100   usecnt 80
>> child:         limit 10    usecnt 10
>>
>> So moving anything into child is violating the constraints and has to
>> be refused. Anything else is just dirty hackery.
>
> And the one who's moving the process there might as well raise the
> limit in the child all the same.  It doesn't make any difference
> without delegation and with delegation we need to restrict migration
> at the exactly same junctions.  We can't delegate otherwise.  And the
> resource limit for the delegated subtree is enforced from its parent
> which delegatee can't escape how it changes the configuration or moves
> processes around.

Here's a case where we've delegated a subtree, for an example of how a
delegated subtree can't overcome `subtree_parent`'s limit -- and by
extension `parent`'s limit:

parent: limit=128 usage=64
-- subtree_parent: limit=64 usage=32
---- subtree_child: limit=2 usage=1

If you delegate a subtree (such that a process cannot attach processes
to `parent`), then it is not possible for the subtree to violate
`subtree_parent`'s limit. This is because the ability to migrate a
process mid-fork relies on the ability to *actually* fork in the
_original_ cgroup (`subtree_parent` or `subtree_child` [which requires
the ability to fork in `subtree_parent`]). Once you've hit
subtree_parent's limit, there's no way for you to violate that limit.
The only other method I can think of is if you do the mid-fork thing
to migrate into `subtree_child`, then you migrate the two processes
into `subtree_parent`. This won't help you either, because if you then
continue and try to fork in `subtree_child` and then migrate, you'll
be blocked if the fork would violate `subtree_parent`'s limit.

If you try to attach to `subtree_child` a process that is mid-fork,
you'll bump the usage count to 3 (while this is bad, I can't really
think of any way we can tell can_attach() that the process is
mid-fork). If you do it again (because we don't stop can_attach()),
you aren't blocked by the fact that you're attaching to a cgroup that
has already exceeded its usage count, so you'll bump the count to 5 --
this I can understand would _seem_ to indicate a broken controller.
And you /can/ continue this ad infinitum -- up _until_ you run out of
the ability to make new processes inside `subtree_parent` (which
*will* happen). At that point, can_fork() will fail the fork on
`subtree_parent`, before you can attempt to migrate mid-fork.

And I just want to point out that if you have the ability to attach
processes to `subtree_child`, then you *already* have the right to
violate its set limit through attach anyway (or just changing the
limit) -- so the fact you can do this mid-fork isn't untoward at all.
If a user has the ability to just disable the cgroup's limit, then why
should that same user be hampered when attempting to attach processes
that said cgroup (which is an administrative operation -- so you'd
assume that they're clever enough to know that migration into a cgroup
may bump usage so it's greater than the limit [or that they just
RTFM'd])?

--
Aleksa Sarai (cyphar)
www.cyphar.com
