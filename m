From: Ronny Meeus <ronny.meeus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Short process stall after assigning it to a cgroup
Date: Fri, 18 Jun 2021 07:32:56 +0200
Message-ID: <CAMJ=MEfjxBXWxR6PPbeoQGKc6aXQCoDjyfiOinKamR3u2xwS7w@mail.gmail.com>
References: <CAMJ=MEegYBi_G=_nk1jaJh-dtJj59EFs6ehCwP5qSBqEKseQ-Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=uWO1hK3ZXvOVh7b8YIGuK4UjnlgoPUKf+n3eG1ZZy9I=;
        b=tTF2w6u94nDeH6OQs79EePuzBVO4u511wVqE9LUkHs2Xz2SMGJSGAkzsQkLitLTsm6
         T9T1jDDKCu22/q8q14stHvaFAeuM3IS2Ona4qENUX94BvmxcRzjqNr7fY+8sqXfzkxsw
         i/TQya1wwe4B+SGkbXaP65nA4zZLkFontPXuaa+D7AzDb9s21x5kjNtuVy9mUHIoexa5
         +JjDIMFNWHPQgr2VJFIRC5JeQ9e9mQst5o/JuFC57wmFVpDl/oZUAPo5cCa5jMg8qm4A
         zIAcNHHcYWZYpNYmfGS3RVEP1CsnsKyPrz7N9ZhbAjccQla4ecfp6Kpg2EbHU1Fhp1BH
         eARA==
In-Reply-To: <CAMJ=MEegYBi_G=_nk1jaJh-dtJj59EFs6ehCwP5qSBqEKseQ-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Op ma 14 jun. 2021 om 17:29 schreef Ronny Meeus <ronny.meeus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>
> Hello
>
> I want to use cgroups to control my heavy cpuload consuming applications.
> All apps are running in the realtime domain and I'm using kernel 4.9
> and cgroup v1.
>
> I created a small application that monitors the CPU load (by reading
> the /proc filesystem) and when it enters a full load condition, I
> dynamically start to put the high consuming processes into a cgroup
> (which were created during system start-up). Each process will have
> it's own cgroup created under the root-cgroup.
>
> The budget I assign to the process is equal to the budget it has
> consumed in the previous measurement interval (for example 5s). As
> long as the load continues to be high, I start to gradually reduce the
> budget of the cgroup until the system is idle enough.
>
> This works reasonably well, but in some cases I see that a very high
> load consuming application is stopped completely at the moment it is
> put in a cgroup, although the budget allocated to it is correctly
> calculated based on the load it consumed in my previous interval.
>
> An example:
> - cpu.rt_period_us = 1000000
> - cpu.rt_runtime_us = 400000
> I would assume that an application put in a cgroup with this
> configuration can consume 40% of the CPU and it actually does. But
> sometimes, immediately after the process assignment, it stops for a
> short period (something like 1 or 2s) and then starts to consume 40%
> again.
>
> Is that expected behavior?
>
> It looks like the "budget" it has consumed in the root-cgroup is taken
> into account when it is moved to its own group and this results in the
> stall.
>
> Best regards,
> Ronny

Note that this is a dual-core CPU and the process that is doing the cgroup
updates is running in a single thread. So that other core will most
probably running the application that is moved into the child cgroup.
