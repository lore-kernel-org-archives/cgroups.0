From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Sat, 18 Apr 2015 06:48:55 +1000
Message-ID: <CAOviyah2dBbc5MecxzCfOt36dVfCaN7F7u+5ycPmp3eVDc_J2Q@mail.gmail.com>
References: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
	<1428799917-15141-4-git-send-email-cyphar@cyphar.com>
	<20150413142439.GA2596@htj.duckdns.org>
	<CAOviyajqc_ip2Lpa5NTLLXxQ7JghYXg1UL3vXDdpbbnhmsfXEQ@mail.gmail.com>
	<20150414121732.GL2596@htj.duckdns.org>
	<CAOviyaj6eQ6s50+DrQN8yFAp7q5Y6b4ReFOT8XT0UufPb5J0xQ@mail.gmail.com>
	<20150417144519.GC1954@htj.duckdns.org>
	<CAOviyagcvtpDL1OONXR_-fX6X6N+-KfDw5mmpn=iQU+ZNps02g@mail.gmail.com>
	<20150417204206.GI16743@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150417204206.GI16743-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>> >> Do you also want me to completely drop the COUNT macro? IMO it makes
>> >> the CGROUP_<TAG>_COUNT consolidation much nicer.
>> >
>> > What's wrong with simply having start and end tags?
>>
>> Because you'd have to write (CGROUP_TAG_END - CGROUP_TAG_START) every
>> time? It's a small addition and it makes referencing the range of a
>> tagged section much easier.
>
> Wouldn't loops look more like
>
>         for (subsys = CGROUP_TAG_START; subsys < CGROUP_TAG_END; subsys++)

Sorry, I meant for defining arrays. `state[CGROUP_TAG_END -
CGROUP_TAG_START]` is just more annoying to type and read than
`state[CGROUP_TAG_COUNT]`.

> And even if not, just define a separate macro for the length.  It's
> not like we're gonna have a lot of tags.

Do you mean like this?

#define SUBSYS_TAG_COUNT(_tag) (CGROUP_ ## _tag ## _END - CGROUP_ ##
_tag ## _START)

That's fine I guess, I just wanted to match CGROUP_SUBSYS_COUNT in
semantics, but I'll do that if you prefer it that way.

--
Aleksa Sarai (cyphar)
www.cyphar.com
