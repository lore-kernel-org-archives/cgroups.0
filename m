From: Ronny Meeus <ronny.meeus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Short process stall after assigning it to a cgroup
Date: Mon, 14 Jun 2021 17:29:35 +0200
Message-ID: <CAMJ=MEegYBi_G=_nk1jaJh-dtJj59EFs6ehCwP5qSBqEKseQ-Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bNme+EzHVzrIQEXwYwbnMcehdQ/ZaTsor5me0kGBI+A=;
        b=NFSC8hXLt1UmmA/yEyGFseJidXegBmq+NZ1BAg51wCEhbt0II8ZiQJ7Hzdz9go8FTH
         NpLqfJX2qL3XCZLJzAq6VacSqe/Y03/2x8Ah+7Lp7n7wZmUgWyA7r/dMcyGq2SeO+67R
         2WN62J/Bdx/CNxOvPDRuuQ2fdUQDuRm3YH1lGQP+Or4Gg+0lKYpALATDdu6vW/O1PflW
         tRpOkmvwkJR9TicaaFYpjXLr3ivh8HapLJToWvTarG+yjI2c2blLNy8+jOs4DeWna9jn
         l91YIPY7iBP7PC1FZO/XHSOZcCnA/Xl49xGiEGtZDDrmVwC0lTmgfw3HCKvg7vq5gl35
         Qk7w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello

I want to use cgroups to control my heavy cpuload consuming applications.
All apps are running in the realtime domain and I'm using kernel 4.9
and cgroup v1.

I created a small application that monitors the CPU load (by reading
the /proc filesystem) and when it enters a full load condition, I
dynamically start to put the high consuming processes into a cgroup
(which were created during system start-up). Each process will have
it's own cgroup created under the root-cgroup.

The budget I assign to the process is equal to the budget it has
consumed in the previous measurement interval (for example 5s). As
long as the load continues to be high, I start to gradually reduce the
budget of the cgroup until the system is idle enough.

This works reasonably well, but in some cases I see that a very high
load consuming application is stopped completely at the moment it is
put in a cgroup, although the budget allocated to it is correctly
calculated based on the load it consumed in my previous interval.

An example:
- cpu.rt_period_us = 1000000
- cpu.rt_runtime_us = 400000
I would assume that an application put in a cgroup with this
configuration can consume 40% of the CPU and it actually does. But
sometimes, immediately after the process assignment, it stops for a
short period (something like 1 or 2s) and then starts to consume 40%
again.

Is that expected behavior?

It looks like the "budget" it has consumed in the root-cgroup is taken
into account when it is moved to its own group and this results in the
stall.

Best regards,
Ronny
