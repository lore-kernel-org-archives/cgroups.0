From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: bind() call in cgroup's css structure
Date: Mon, 9 Apr 2012 10:59:56 -0300
Message-ID: <4F82EB5C.7090003@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Tejun,

During your cgroup refactor, I was wondering if you have any plans to 
get rid of the bind() callback that is called when hierarchies are moved?

At least in tree, there seems to be no users for that.
I actually planned to use it myself, to start or remove a jump label
when cpuacct and cpu cgroups were comounted.

Problem is, because we have some calls in the cpuset cgroup from inside 
the cpu hotplug handler, we end up taking the almighty cgroup_mutex from 
inside the cpu_hotplug.lock.

jump labels take it in most arches through the get_online_cpus() 
function call. This means we effectively can't apply jump labels with 
the cgroup_mutex held, which is the case throughout the whole bind() call.

All that explained, I figured I might as well ask before I attempted a 
solution to that myself: as much as populate(), bind seems to be one of 
the overly complicated callbacks, designed for a scenario in which 
everything can come and go at will, which is something we're trying to fix.

thanks in advance for your answer!
