From: Dominique Michel <dominique.michel-1veRC/wliwjtRgLqZ5aouw@public.gmane.org>
Subject: future of a real time cpu group
Date: Wed, 15 Jan 2014 18:43:02 +0100
Message-ID: <20140115184302.13e4ff20@tux.fritz.box>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

That's my first email on that list. I use the cgroups from about 2 years
ago in order to get real time operations with jack audio, that without
the need of running a -rt kernel. It use CONFIG_RT_GROUP_SCHED
and cpu.rt_runtime_us with libcgroup in order to define a rt cgroup for
the audio applications. That as described here:
http://trac.jackaudio.org/wiki/Cgroups

If I want to shift to systemd, do you know if systemd can support
such a setup or a similar setup, now or in the future?

You are working hard to transform the cgroup into one unique hierarchy.
Will CONFIG_RT_GROUP_SCHED survive that move, or will it be something
similar that will enable real time operation similar to those of the -rt
kernel patch?

Is it right that libcgroup will not work any more with the new cgroup
implementation you are working on? And if yes, are you aware of other
control implementations than systemd?

Best Regards,
Dominique
