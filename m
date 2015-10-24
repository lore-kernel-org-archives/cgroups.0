From: Shayan Pooya <shayan-UQzSddOuLosdnm+yROfE0A@public.gmane.org>
Subject: piping core dump to a program escapes container
Date: Sat, 24 Oct 2015 14:54:35 -0700
Message-ID: <CABAubTgj8+xngrvc7sNbYS_Hq+-rGAYCz0y433ByiZ45dZuT0w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I noticed the following core_pattern behavior in my linux box while
running docker containers. I am not sure if it is bug, but it is
inconsistent and not documented.

If the core_pattern is set on the host, the containers will observe
and use the pattern for dumping cores (there is no per cgroup
core_pattern). According to core(5) for setting core_pattern one can:

1. echo "/tmp/cores/core.%e.%p" > /proc/sys/kernel/core_pattern
2. echo "|/bin/custom_core /tmp/cores/ %e %p " > /proc/sys/kernel/core_pattern

The former pattern evaluates the /tmp/cores path in the container's
filesystem namespace. Which means, the host does not see a core file
in /tmp/cores.

However, the latter evaluates the /bin/custom_core path in the global
filesystem namespace. Moreover, if /bin/core decides to write the core
to a path (/tmp/cores in this case as shown by the arg to
custom_core), the path will be evaluated in the global filesystem
namespace as well.

The latter behaviour is counter-intuitive and error-prone as the
container can fill up the core-file directory which it does not have
direct access to (which means the core is also not accessible for
debugging if someone only has access to the container).

Currently, I work around this issue by detecting that the process is
crashing from a container (by comparing the namespace pid to the
global pid) and refuse to dump the core if it is from a container.

Tested on Ubuntu (kernel 3.16) and Fedora (kernel 4.1).
