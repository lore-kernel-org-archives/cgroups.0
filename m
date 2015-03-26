From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v6 2/3] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri, 27 Mar 2015 08:41:05 +1100
Message-ID: <CAOviyah+5DFxYtUo1=LMdQLAte=YR1s4JYoH_DNZEfpoBUfSRw@mail.gmail.com>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
	<1426307835-5893-3-git-send-email-cyphar@cyphar.com>
	<20150316165335.GC8353@htj.duckdns.org>
	<CAOviyahTq1K6zBRfmXfepabiQ7xU8ZoNdq0jPd3nP4Q-0H1DDQ@mail.gmail.com>
	<20150326150223.GA1953@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150326150223.GA1953@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hi,

>> callback if the association changes [we could call it something else if you
>> like, since reapply_fork() is a pids-specific name -- what about switch_fork(),
>> reassoc_fork(), re_fork() or something to show that it's a callback if the
>> association changes?] (the subsystem can decide if they want to ignore it / if
>> they don't want to touch it) and we deal with pinning / dropping the ref of the
>> css_set for the current task inside the cgroup_* callbacks. That way, we don't
>> start messing around with post-fork() callbacks that aren't related to the new
>> conditional stuff.
>
> You can't pin css_set from inside cgroup callbacks.  It's a construct
> which in general shouldn't be accessible outside cgroup core.

Yeah, sorry I meant css (you aren't pinning, but you're still saving under RCU
and dealing with the association-related stuff inside post_fork).


>> I mean, if you want to have a random, completely unused and essentially
>> vestigial argument to ss->fork() [if you don't use the new can_fork() callbacks
>> (and actually care about storing private data)] then I can just write that. It
>> just looks like a weird callback API imho.
>
> It's an opaque token from pre.  If a subsys doesn't have pre, it's
> NULL.  I don't see anything weird about that, so let's please go that
> way.

Alright, if you think that's the best way. I still think it's weird, but I
guess that's probably just down to personal taste.


--
Aleksa Sarai (cyphar)
www.cyphar.com
