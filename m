From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Mon, 02 May 2016 18:00:06 -0400
Message-ID: <1462226406.3036.17.camel@HansenPartnership.com>
References: <1462110065-4904-1-git-send-email-asarai@suse.de>
	 <1462110065-4904-2-git-send-email-asarai@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1462226412;
	bh=z6BZMkNhdprxsD3n6WcOnxEm+/C+MzYkMa8eUq6nTGQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=CwsGww3bAiSRQTybO0X8BTy13k/ESzjhN4NWHqgtFaw8V8cvkQBmBOMId+qBVeWCR
	 N2VcOVsd5f5I8hhRTOOYS5XAh+ff6dTUcgCm1GwN+W6ETyQt4eHbD1JW/gPpT8WrjZ
	 MxRF4BXBZ3kmwWv6LadtLhTcufPBsRkxBD9zE9Lo=
In-Reply-To: <1462110065-4904-2-git-send-email-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

On Sun, 2016-05-01 at 23:41 +1000, Aleksa Sarai wrote:
> Allow an unprivileged processes to control subtrees of their 
> associated cgroup, a necessary feature if an unprivileged container 
> (set up with an unprivileged user namespace) wishes to take advantage 
> of cgroups for its own subprocesses.
> 
> Change the mode of the cgroup directory for each cgroup association,
> allowing the process to create subtrees and modify the limits of the
> subtrees *without* allowing the process to modify its own limits. Due 
> to the cgroup core restrictions and unix permission model, this 
> allows for processes to create new subtrees without breaking the 
> cgroup limits for the process.

Actually, that's not really what this patch does.  If you unshare
without having created any cgroups, it sets the other permission of the
entire top level hierarchy to o+rwx:

jejb@jarvis:~> unshare -r --cgroup
root@jarvis:~# ls -l /sys/fs/cgroup/
total 0
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 blkio/
lrwxrwxrwx 1 nobody nogroup 11 May  2 14:50 cpu -> cpu,cpuacct/
lrwxrwxrwx 1 nobody nogroup 11 May  2 14:50 cpuacct -> cpu,cpuacct/
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 cpu,cpuacct/
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 cpuset/
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 devices/
dr-xr-xrwx 3 nobody nogroup  0 May  2 15:04 freezer/
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 hugetlb/
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 memory/
lrwxrwxrwx 1 nobody nogroup 16 May  2 14:50 net_cls -> net_cls,net_prio/
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 net_cls,net_prio/
lrwxrwxrwx 1 nobody nogroup 16 May  2 14:50 net_prio -> net_cls,net_prio/
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 perf_evesnt/
dr-xr-xrwx 2 nobody nogroup  0 May  2 14:50 pids/
dr-xr-xr-x 4 nobody nogroup  0 May  2 14:50 systemd/

But this is visible even to an unprivileged user not in any namespace,
meaning that now any user may create a cgroup control directory:

jejb@jarvis:~> ls -l /sys/fs/cgroup/
total 0
dr-xr-xrwx 2 root root  0 May  2 14:50 blkio/
lrwxrwxrwx 1 root root 11 May  2 14:50 cpu -> cpu,cpuacct/
lrwxrwxrwx 1 root root 11 May  2 14:50 cpuacct -> cpu,cpuacct/
dr-xr-xrwx 2 root root  0 May  2 14:50 cpu,cpuacct/
dr-xr-xrwx 2 root root  0 May  2 14:50 cpuset/
dr-xr-xrwx 2 root root  0 May  2 14:50 devices/
dr-xr-xrwx 3 root root  0 May  2 15:04 freezer/
dr-xr-xrwx 2 root root  0 May  2 14:50 hugetlb/
dr-xr-xrwx 2 root root  0 May  2 14:50 memory/
lrwxrwxrwx 1 root root 16 May  2 14:50 net_cls -> net_cls,net_prio/
dr-xr-xrwx 2 root root  0 May  2 14:50 net_cls,net_prio/
lrwxrwxrwx 1 root root 16 May  2 14:50 net_prio -> net_cls,net_prio/
dr-xr-xrwx 2 root root  0 May  2 14:50 perf_event/
dr-xr-xrwx 2 root root  0 May  2 14:50 pids/
dr-xr-xr-x 4 root root  0 May  2 14:50 systemd/

ironically, this now makes the root group a permission denier (at least
for my distribution), because if I were in the root group (and not
root), the r-x on the group would rule the rwx on other ... I really
don't think that sounds correct.

Perhaps what you should to be arguing then that the default permissions
of the cgroup directories need to be all rwx for everyone and then your
patch becomes unnecessary?

Alternatively, if the desire is fully to virtualize /sys/fs/cgroups,
then I think we have to decide how that would happen.  I think the
default requirements would be that a pid namespace be established (so
only the tasks in that pid namespace would be able to be controlled by
the cgroup namespace.  That, I think requires that any given cgroup
namespace "own" a pid namespace (being the one present when it was
created) but that it only gets a new virtual set of directories owned
by the userns owner if there's a pid namespace established for the
cgroup and cgroup->user_ns == pid_ns->user_ns (meaning we established a
user ns then a pid one then a cgroup one, so it's now safe to treat
root in the user_ns as owning the virtualized cgroup directories).  We
could do this in the same way that proc gets virtualized after
remounting (in a new mount namespace) on fork into a pid namespace.

James
