From: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom notifications
 to access reserves
Date: Thu, 12 Dec 2013 10:42:20 -0800
Message-ID: <CAAAKZwtuydFdiiSsKMuOUv3nr9trjuKvKoDO2aM0QsJKu1TMZA@mail.gmail.com>
References: <20131204054533.GZ3556@cmpxchg.org> <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org> <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206190105.GE13373@htj.dyndns.org> <alpine.DEB.2.02.1312061441390.8949@chino.kir.corp.google.com>
 <20131210215037.GB9143@htj.dyndns.org> <alpine.DEB.2.02.1312101522400.22701@chino.kir.corp.google.com>
 <20131211124240.GA24557@htj.dyndns.org> <CAAAKZwsmM-C=kLGV=RW=Y4Mq=BWpQzuPruW6zvEr9p0Xs4GD5g@mail.gmail.com>
 <20131212142156.GB32683@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        bh=5OTC1mGWF4OxMokD/fiwSJyo0fsV6yNjqA0YTwda+e4=;
        b=Mvz5QGaAhoA1o5yo0j0yG5aDdUEDB7TKKBlhlrJphB/C+LPkakxaFHItRiMHwHrFLA
         2Nh7w8kvcFEZQ4iX6Xuajhxuzygenlhminwcv5X2xiBRITq3gZ01zbmaCGp9StqUPFch
         c6InmM1fFkNOxbTy8zzx5vPVugxgVzOPA+ALDVapw1BaSxwf6aKZ/cFCdH8hMn0lHvi5
         4JU5UZtA33dv6MKhjMqhJJxT2J3oAcIBvOd4Ingp0SikKCtazKPwwNK+2F8Xh52dsyYy
         k4ob0QQqm++BZCQnhz5CCJKjKBJf8yJVWykgT1YrLYRs4AyFJpXaEPqCmpp2a9FGDMwT
         5fWw==
In-Reply-To: <20131212142156.GB32683-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Dec 12, 2013 at 6:21 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hey, Tim.
>
> Sidenote: Please don't top-post with the whole body quoted below
> unless you're adding new cc's.  Please selectively quote the original
> message's body to remind the readers of the context and reply below
> it.  It's a basic lkml etiquette and one with good reasons.  If you
> have to top-post for whatever reason - say you're typing from a
> machine which doesn't allow easy editing of the original message,
> explain so at the top of the message, or better yet, wait till you can
> unless it's urgent.

Yeah sorry.  Replying from my phone is awkward at best.  I know better :)

> On Wed, Dec 11, 2013 at 09:37:46PM -0800, Tim Hockin wrote:
>> The immediate problem I see with setting aside reserves "off the top"
>> is that we don't really know a priori how much memory the kernel
>> itself is going to use, which could still land us in an overcommitted
>> state.
>>
>> In other words, if I have your 128 MB machine, and I set aside 8 MB
>> for OOM handling, and give 120 MB for jobs, I have not accounted for
>> the kernel.  So I set aside 8 MB for OOM and 100 MB for jobs, leaving
>> 20 MB for jobs.  That should be enough right?  Hell if I know, and
>> nothing ensures that.
>
> Yes, sure thing, that's the reason why I mentioned "with some slack"
> in the original message and also that it might not be completely the
> same.  It doesn't allow you to aggressively use system level OOM
> handling as the sizing estimator for the root cgroup; however, it's
> more of an implementation details than something which should guide
> the overall architecture - it's a problem which lessens in severity as
> [k]memcg improves and its coverage becomes more complete, which is the
> direction we should be headed no matter what.

In my mind, the ONLY point of pulling system-OOM handling into
userspace is to make it easier for crazy people (Google) to implement
bizarre system-OOM policies.  Example:

When we have a system OOM we want to do a walk of the administrative
memcg tree (which is only a couple levels deep, users can make
non-admin sub-memcgs), selecting the lowest priority entity at each
step (where both tasks and memcgs have a priority and the priority
range is much wider than the current OOM scores, and where memcg
priority is sometimes a function of memcg usage), until we reach a
leaf.

Once we reach a leaf, I want to log some info about the memcg doing
the allocation, the memcg being terminated, and maybe some other bits
about the system (depending on the priority of the selected victim,
this may or may not be an "acceptable" situation).  Then I want to
kill *everything* under that memcg.  Then I want to "publish" some
information through a sane API (e.g. not dmesg scraping).

This is basically our policy as we understand it today.  This is
notably different than it was a year ago, and it will probably evolve
further in the next year.

Teaching the kernel all of this stuff has proven to be sort of
difficult to maintain and forward-port, and has been very slow to
evolve because of how painful it is to test and deploy new kernels.

Maybe we can find a way to push this level of policy down to the
kernel OOM killer?  When this was mentioned internally I got shot down
(gently, but shot down none the less).  Assuming we had
nearly-reliable (it doesn't have to be 100% guaranteed to be useful)
OOM-in-userspace, I can keep the adminstrative memcg metadata in
memory, implement killing as cruelly as I need, and do all of the
logging and publication after the OOM kill is done.  Most importantly
I can test and deploy new policy changes pretty trivially.

Handling per-memcg OOM is a different discussion.  Here is where we
want to be able to extract things like heap profiles or take stats
snapshots, grow memcgs (if so configured) etc.  Allowing our users to
have a moment of mercy before we put a bullet in their brain enables a
whole new realm of debugging, as well as a lot of valuable features.

> It'd depend on the workload but with memcg fully configured it
> shouldn't fluctuate wildly.  If it does, we need to hunt down whatever
> is causing such fluctuatation and include it in kmemcg, right?  That
> way, memcg as a whole improves for all use cases not just your niche
> one and I strongly believe that aligning as many use cases as possible
> along the same axis, rather than creating a large hole to stow away
> the exceptions, is vastly more beneficial to *everyone* in the long
> term.

We have a long tail of kernel memory usage.  If we provision machines
so that the "do work here" first-level memcg excludes the average
kernel usage, we have a huge number of machines that will fail to
apply OOM policy because of actual overcommitment.  If we provision
for 95th or 99th percentile kernel usage, we're wasting large amounts
of memory that could be used to schedule jobs.  This is the
fundamental problem we face with static apportionment (and we face it
in a dozen other situations, too).  Expressing this set-aside memory
as "off-the-top" rather than absolute limits makes the whole system
more flexible.

> There'd still be all the bells and whistles to configure and monitor
> system-level OOM and if there's justified need for improvements, we
> surely can and should do that; however, with the heavy lifting / hot
> path offloaded to the per-memcg userland OOM handlers, I believe it's
> reasonable to expect the burden on system OOM handler being noticeably
> less, which is the way it should be.  That's the last guard against
> the whole system completely locking up and we can't extend its
> capabilities beyond that easily and we most likely don't even want to.
>
> If I take back a step and look at the two options and their pros and
> cons, which path we should take is rather obvious to me.  I hope you
> see it too.
>
> Thanks.
>
> --
> tejun
