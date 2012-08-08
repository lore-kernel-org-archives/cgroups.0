From: Vecu BOSSEUR <vecu.bosseur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Limiting CPU resources of a cgroup (how do I) HELP REQUESTED
Date: Wed, 8 Aug 2012 14:24:13 +0200
Message-ID: <CACivvv0G3CspFnFud569vgdh=_2sofb4P3f2sfdFRuu2XSvRaQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=BmSUavpSD/vXvLyyIhUN8pf5QAhpExfJwodE92PrC3k=;
        b=XU1AiLChVv0GR14gEus+sHpnCGZAyHJXxy/A7c1o04QChCFx4+wXtVKnGOHdtuOSz+
         4kxPELVbZwKl9kQ1cGjFAK0A571zZIwNkynzHqeMSYhN9l0qevmavJDcfqlKSL6vhSn5
         dXPisQ0A9w2qzikK/Pb3Q6o9Mfi+0vk2P6XEsNZDx33F67bgFUEbtMtqyCSSRmwg+79w
         Dssf7PibwIhOojLbf6PhbIoB2fNPdYc4hQ/gb/N/ltdkx6vnsklnlBzGHgmCMA08UOJv
         rMLnI5pxx5LTV0nEI4FXM1uQxDY8TO2L8/k/17UEcqnoewY9L8MPcWPLgBy3TjmlJxqX
         F4ow==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Dear Friends or Foes ;-)


It is quite some time now that I first tried to find an adequate
solution to my problem; none managed to get me right yet :=-(

Basically, I would like to limit CPU resource usage (i.e. ~= time
share) allocated to a said cgroup to let's say 30% of the machine
processing power, or 30 % of time.
( SMP and HyperThreading technologies will change the interpretation
of that goal; regardless, please read on. )

I am in the very need to throttle some cgroup's CPU usage, regardless
the overall machine CPU utilisation. I mean that I need to cap the
processing power dedicated and allowed to some cgroup, whether the
CPU(s) is(are) otherwise IDLE or BUSY (with respect to other tasks or
groups).

Any hint on how to accomplish this?

All that I happend to do was to create a renice-boosted daemon that
alternately froze then unfroze the said cgroup (using a calculated
time ratio between running/frozen states) to keep the cgroup's CPU
usage under control.

You can ea
