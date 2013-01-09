From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Date: Wed, 9 Jan 2013 12:42:20 -0800
Message-ID: <20130109124220.ad9f1a54.akpm@linux-foundation.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
	<1357731938-8417-12-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357731938-8417-12-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed,  9 Jan 2013 15:45:38 +0400
Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> The file cpu.stat_percpu will show various scheduler related
> information, that are usually available to the top level through other
> files.
> 
> For instance, most of the meaningful data in /proc/stat is presented
> here. Given this file, a container can easily construct a local copy of
> /proc/stat for internal consumption.
> 
> The data we export is comprised of:
> * all the tick information, previously available only through cpuacct,
>   like user time, system time, etc.
> 
> * wait time, which can be used to construct analogous information to
>   steal time in hypervisors,
> 
> * nr_switches and nr_running, which are cgroup-local versions of
>   their global counterparts.
> 
> The file includes a header, so fields can come and go if needed.

Please update this changelog to fully describe the proposed userspace
interfaces.  That means full pathnames and example output. 
Understanding these interfaces is the most important part of reviewing
this patchset, so this info should be prominent.

Also, this patchset appears to alter (or remove?) existing userspace
interfaces?  If so, please clearly describe those alterations and also
share your thinking on the back-compatibility issues.

Also, I'm not seeing any changes to Docmentation/ in this patchset. 
How do we explain the interface to our users?


From a quick read, it appears that the output will be something along
the lines of:

user nice system irq softirq guest guest_nice wait nr_switches nr_running
cpu0 nn nn nn nn nn ...
cpu1 nn nn nn nn nn ...

which looks pretty terrible.  Apart from being very hard to read, it
means that we can never remove fields.  A nicer and more extensible
interface would be

cpu:0 nice:nn system:nn irq:nn ...


