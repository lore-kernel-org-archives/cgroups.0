From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v8 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Tue, 7 Apr 2015 23:47:02 +1000
Message-ID: <CAOviyagYWk1VJW3upKsOS8rOiBQFTn752eJA_C2SkHnCh7EUrw@mail.gmail.com>
References: <1427878641-5273-1-git-send-email-cyphar@cyphar.com>
	<1427878641-5273-4-git-send-email-cyphar@cyphar.com>
	<20150401160258.GP9974@htj.duckdns.org>
	<CAOviyai9dvCTGK=VUm0uDSo7XbmKk1BFDrRzL15ppAWf8YjG3w@mail.gmail.com>
	<20150406150536.GA10582@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150406150536.GA10582@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hi Tejun,

>> I tried doing this and the kernel would refuse to boot. I believe it has
>> something to do with the ordering of early_init subsystems, but I'm not
>
> Hmmm... yeah, failure in early_init can be tricky to debug.

Okay, I took another look and it isn't that there are hard ordering
dependencies, it's because of how I wrote the tagging macro for cgroup_subsys.h
that caused a NULL deref during the early_init. Whoops.

>> entirely sure (this optimisation can be dealt with later [it's non-critical],
>> so IMO this should be done in a separate patchset [if at all]). Also, your
>> later comments would fix the subsys bitmask problem (we can just pass the
>> default %NULL), we don't even need to test the index.
>
> [...] I don't
> think it's a good idea to send the patches as-are because we can't
> debug and fix them properly, right? [...]

In what way are they hard to debug?

> [...] If there are hard ordering
> dependencies, the range of subsystems which require fork/exit doesn't
> have to be at the beginning.

I just spent a few hours trying to write it and it's just too dodgy to live.
Either you have a solution that won't work with nested tags, and is generally
just kind of bad or you have a solution that requires you to keep two separate
enumerations in sync. And of course you need to offset the index you're looking
stuff up in ss_state so that also looks bad.

But that's all besides the point because, *even if* it I had a clean solution,
it still wouldn't solve the fact that we are
> [...] adding quite a few loops in relatively hot paths.
You kind of _need_ to loop over all the subsystems in either case, the only
difference between having an array of CGROUP_SUBSYS_COUNT pointers or
CGROUP_PREFORK_COUNT is the few bytes of memory you've "saved" (at the expense
of making the callback code essentially unreadable).

--
Aleksa Sarai (cyphar)
www.cyphar.com
