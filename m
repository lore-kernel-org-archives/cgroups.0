From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
Date: Fri, 25 Apr 2014 10:21:05 +0530
Message-ID: <CAKohpomQH01gCeUfqFFeHVNX7N7CSyo7zdj3LGBv9=U=cE46EA@mail.gmail.com>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<201404240725.s3O7PrUv003720@toshiba.co.jp>
	<CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg@mail.gmail.com>
	<201404240832.s3O8WHd0011014@toshiba.co.jp>
	<CAKohpokk4rGeP3QfVT5_HBO4pc=22yPBLV78D++y1Ab72y1OJQ@mail.gmail.com>
	<201404240924.s3O9OYCC021688@toshiba.co.jp>
	<CAKohponA4-cm2_FB=8R8aVEWNhtUfOUebcfzn7W+XR0zKHCtxw@mail.gmail.com>
	<201404250031.s3P0V2DY022219@toshiba.co.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201404250031.s3P0V2DY022219-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 25 April 2014 06:01, Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org> wrote:
>
>>> I can't keep it as a separate patch and so would be required to merge
>>> it into my original patch..
>>
>> And the reason being: "No patch is supposed to break things, otherwise
>> git bisect wouldn't work smoothly".. And so git bisect would complain
>> this issue after my patch and so I have to merge the fixes you gave into
>> the original patch as its not yet merged.
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Ok, no problem then.

Do you want me to add your Tested-by for my next version ?
