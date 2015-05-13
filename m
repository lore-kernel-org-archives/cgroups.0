From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Thu, 14 May 2015 03:04:52 +1000
Message-ID: <CAOviyah9yyXJG0eUeizpb5ZnzNUAKfxXGkXJw-5sNw7sQOAEuA@mail.gmail.com>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
	<1429446154-10660-5-git-send-email-cyphar@cyphar.com>
	<20150422162954.GF10738@htj.duckdns.org>
	<CAOviyagHJhxD8E+CeEdy399ARPaNyyiSJSJjByK=5ALN5jxbJw@mail.gmail.com>
	<20150424153657.GC24029@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150424153657.GC24029-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun

>> >> +     /* We use INT_MAX as the maximum value of pid_t. */
>> >> +     if (limit < 0 || limit > INT_MAX)
>> >
>> > This is kinda weird if we're using PIDS_MAX for max as it may end up
>> > showing "max" after some larger number is written to the file.
>>
>> The reason for this is because I believe you said "PIDS_MAX isn't
>> meant to be exposed to userspace" (one of the previous patchsets used
>> PIDS_MAX as the maximum valid value).
>
> Yeah, but wouldn't it be weird to allow the userland to input PIDS_MAX
> (whatever value that may be) and reads back max?  It can be whatever
> maximum input value + 1, no?

Would you be okay with this?

    if (limit < 0 || limit >= PIDS_MAX)

I'd prefer if we used PIDS_MAX as the maximum input value as well as
being the internal representation of the maximum, rather than
switching to something like INT_MAX.

--
Aleksa Sarai (cyphar)
www.cyphar.com
