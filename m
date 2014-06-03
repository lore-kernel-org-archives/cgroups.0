From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
Subject: /sys/fs/cgroup/openrc/???/tasks sometimes missing
Date: Tue, 03 Jun 2014 20:08:39 +0200
Message-ID: <538E0F27.908@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: UML devel <user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, gentoo-dev-cnFmAm88PdgLnqt3yJz4RQ@public.gmane.org

If I boot a 32 bit stable Gentoo Linux as a user mode linux guest with current kernels (host is a 32 bit stable Gentoo too), then I do observe sometimes during the boot process error messages from the init system of Gentoo (OpenRC) like the following (for subsystem rngd in this example) :

 * Starting haveged ...                                                                                               [ ok ]
/lib/rc/sh/rc-cgroup.sh: line 87: /sys/fs/cgroup/openrc/rngd/tasks: No such file or directory
 * Starting rngd ...                                                                                                  [ ok ]

And indeed, that directory is missing. A restart of the appropriate service however creates those entries. The Gentoo bug entry https://bugs.gentoo.org/show_bug.cgi?id=489386 tells me :

"It's known race in cgroups, I'm going to address this issue on one of the following weekends. The problem is that issue is not reproducible on my systems."

but  that's all since 5 months. Now I'm wondering if this just happens for an UML guest and who knows how to fix it ?

-- 
Toralf
