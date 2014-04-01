From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 2/4] timer: don't migrate pinned timers
Date: Tue, 1 Apr 2014 10:02:43 +0530
Message-ID: <CAKohpokYfdY+40kmhgrC6Yr9vfv4GtAW2Ph3+=57YbfmJsnU9w@mail.gmail.com>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar@linaro.org>
	<7htxae5plh.fsf@paris.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7htxae5plh.fsf-4poPxKt068f/PtFMR13I2A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 31 March 2014 21:26, Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>> +             if (is_pinned) {
>> +                     pr_warn("%s: can't migrate pinned timer: %p, removing it\n",
>> +                                     __func__, timer);
>
> printk message will be confusing: removing it from what?

Hmm.. So, I am looking to do two modifications here. Just need inputs
if that would be the right thing to do:

- do a WARN() here as these timers should have been already removed
- change print to: "can't migrate pinned timer %p, deactivating timer"

Looks fine?
