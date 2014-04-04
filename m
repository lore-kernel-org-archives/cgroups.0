From: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 2/4] timer: don't migrate pinned timers
Date: Fri, 04 Apr 2014 08:15:19 -0700
Message-ID: <7h8urlyvlk.fsf@paris.lan>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar@linaro.org>
	<7htxae5plh.fsf@paris.lan>
	<CAKohpokYfdY+40kmhgrC6Yr9vfv4GtAW2Ph3+=57YbfmJsnU9w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKohpokYfdY+40kmhgrC6Yr9vfv4GtAW2Ph3+=57YbfmJsnU9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Viresh Kumar's message of "Tue, 1 Apr 2014 10:02:43 +0530")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

> On 31 March 2014 21:26, Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>>> +             if (is_pinned) {
>>> +                     pr_warn("%s: can't migrate pinned timer: %p, removing it\n",
>>> +                                     __func__, timer);
>>
>> printk message will be confusing: removing it from what?
>
> Hmm.. So, I am looking to do two modifications here. Just need inputs
> if that would be the right thing to do:
>
> - do a WARN() here as these timers should have been already removed
> - change print to: "can't migrate pinned timer %p, deactivating timer"
>
> Looks fine?

Yes.
