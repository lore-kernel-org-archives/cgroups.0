From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 16:58:01 +0200
Message-ID: <CACT4Y+Y+fwJ1-v89kw3vgyHO_BWk97WOVOE1BsZdqDiiSFcGzQ@mail.gmail.com>
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
        bh=5heqjLtIh2P9cp6olcrtjwvOWQ8BujIPtW5xOyTuJDk=;
        b=UOJvlunIwt4WexOUnFEMpagfRsK+S/8w8auyk5rG0sNSpFnPeeCOgmsLSUKzAzVOsh
         iKockaq6sbwYYe4gLCbC2WneWnOh+ALHggCxcmAQozx90K0YIWeil9R/pmRhsSJmYNZk
         Y2Alc6C5TDHKW+T7KP+pzim0d+QJo4mzUbPeZoF7HRq5YN64bb9qqGHqlcLqJIorrHJI
         LeMQXMSbctD3uy9AokSm6dZsuMmEnLfifIxkELkdvhsucNOlno+JKSNU9G1PZeaUPtqk
         q95fg83+bpXxfcgMMS7lVBppbCECdBelRo1Roz+AfM+x78rmib7zbjQqqPKDEgarGHt5
         /moQ==
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
>
> Sure there is that panic_on_warn thingy which you seem to be using and I
> suspect it is a reason why you are so careful about warnings in general
> but my experience tells me that this configuration is barely usable
> except for testing (which is your case).
>
> But as I've said, I do not insist on WARN here. All I care about is to
> warn user that something might go south and this may be either due to
> misconfiguration or a subtly wrong memcg reclaim/OOM handler behavior.

I am a bit lost. Can limit=0 legally lead to the warnings? Or there is
also a kernel bug on top of that and it's actually a kernel bug that
provokes the warning?
If it's a kernel bug, then I propose to stop arguing about
configuration and concentrate on the bug.
If it's just the misconfiguration that triggers the warning,  then can
we separate the 2 causes of the warning (user misconfiguration and
kernel bugs)? Say, return EINVAL when mem limit is set to 0 (and print
a line to console if necessary)? Or if the limit=0 is somehow not
possible/desirable to detect right away, check limit=0 at the point of
the warning and don't want?
