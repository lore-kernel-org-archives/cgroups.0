From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 17:07:26 +0200
Message-ID: <CACT4Y+bbKG4SQoEY+DVYRzyYN4aBJ1goC+B1R26dGtMVPkMonQ@mail.gmail.com>
References: <0000000000005e979605729c1564@google.com> <20180806091552.GE19540@dhcp22.suse.cz>
 <CACT4Y+Ystnwv4M6Uh+HBKbdADAnJ6otfR0GoA20crzqV+b2onQ@mail.gmail.com>
 <20180806094827.GH19540@dhcp22.suse.cz> <CACT4Y+ZJsDo1gjzHvbFVqHcrL=tFJXTAAWLs9mAJSv3+LiCdmA@mail.gmail.com>
 <20180806110224.GI19540@dhcp22.suse.cz> <CACT4Y+awxBatn3GQc7EWHVfHqMLKC9eVKjQMbJkCk0Po-X4VDQ@mail.gmail.com>
 <20180806142124.GP19540@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Fqjl90GKjEPj39+GQcvXhwqPK+DveuoeIiSsfVpvUKA=;
        b=tc42xgkBUIrDxWAibgxXIjRvDi2rtRaJGGKSgvQRP05uvgrVbECuY3SYE9C+Zh2qsO
         3lrw27+/dhJ/DJWpU1QueCnMq9SulmEvHi1uX2A0w/LVmhfva7iy7fniMOqv6wNi07+5
         ibW2fJSoMqqOPSiWr9gQF86iIUIJItqmvA7xHteYZpVEWXzyUFOEfd+aFb4DmvyZGniW
         AsWEkXGFz8IfSp7tOoSv5iBAYTPheeiuSODisombUV9ltFSXwog9vkuu1vBSAf9Q92me
         LX5WvXXuHVz/4XhGiTtpb1a2QD4Lw3y7H7t4LRoYRZ2N/LhxBPIM2tuXobfvwFVlO7kJ
         +w9g==
In-Reply-To: <20180806142124.GP19540@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Dmitry Torokhov <dtor@google.com>

On Mon, Aug 6, 2018 at 4:21 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 06-08-18 13:57:38, Dmitry Vyukov wrote:
>> On Mon, Aug 6, 2018 at 1:02 PM, Michal Hocko <mhocko@kernel.org> wrote:
> [...]
>> >> A much
>> >> friendlier for user way to say this would be print a message at the
>> >> point of misconfiguration saying what exactly is wrong, e.g. "pid $PID
>> >> misconfigures cgroup /cgroup/path with mem.limit=0" without a stack
>> >> trace (does not give any useful info for user). And return EINVAL if
>> >> it can't fly at all? And then leave the "or a kernel bug" part for the
>> >> WARNING each occurrence of which we do want to be reported to kernel
>> >> developers.
>> >
>> > But this is not applicable here. Your misconfiguration is quite obvious
>> > because you simply set the hard limit to 0. This is not the only
>> > situation when this can happen. There is no clear point to tell, you are
>> > doing this wrong. If it was we would do it at that point obviously.
>>
>> But, isn't there a point were hard limit is set to 0? I would expect
>> there is a something like cgroup file write handler with a value of 0
>> or something.
>
> Yeah, but this is only one instance of the problem. Other is that the
> memcg is not reclaimable for any other reasons. And we do not know what
> those might be
>
>>
>> > If you have a strong reason to believe that this is an abuse of WARN I
>> > am all happy to change that. But I haven't heard any yet, to be honest.
>>
>> WARN must not be used for anything that is not kernel bugs. If this is
>> not kernel bug, WARN must not be used here.
>
> This is rather strong wording without any backing arguments. I strongly
> doubt 90% of existing WARN* match this expectation. WARN* has
> traditionally been a way to tell that something suspicious is going on.
> Those situation are mostly likely not fatal but it is good to know they
> are happening.

Today syzbot covers about 1M lines of kernel code, and we fuzz for
several years with panic_on_warn=1 and each unique crash is recorded
and reported. Over several thousands bugs that we reported, there were
maybe 2 dozens of such cases (WARN on invalid user inputs, ENOMEM,
etc). The solution always was to remove the WARNING on covert to
pr_err. As of now, I see only 2 such cases open: this one and WARN on
ENOMEM in input subsystem.

Either way, we do badly need this separation. If there are deviations
we need to continue fixing them.
