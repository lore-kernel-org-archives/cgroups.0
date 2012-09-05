From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/6] device_cgroup: replace internally whitelist
 with exception list
Date: Wed, 5 Sep 2012 03:30:02 +0000
Message-ID: <20120905033002.GG13310@mail.hallyn.com>
References: <20120904143419.892872876@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120904143419.892872876-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> The original model of device_cgroup is having a whitelist where all the
> allowed devices are listed. The problem with this approach is that is
> impossible to have the case of allowing everything but few devices.
> 
> The reason for that lies in the way the whitelist is handled internally:
> since there's only a whitelist, the "all devices" entry would have to be
> removed and replaced by the entire list of possible devices but the ones
> that are being denied.  Since dev_t is 32 bits long, representing the allowed
> devices as a bitfield is not memory efficient.
> 
> This patch replaces the "whitelist" by a "exceptions" list and the default
> policy is kept as "deny_all" variable in dev_cgroup structure.
> 
> The current interface determines that whenever "a" is written to devices.allow
> or devices.deny, the entry masking all devices will be added or removed,
> respectively. This behavior is kept and it's what will determine the default
> policy:
> 
> 	# cat devices.list 
> 	a *:* rwm
> 	# echo a >devices.deny
> 	# cat devices.list 
> 	# echo a >devices.allow
> 	# cat devices.list 
> 	a *:* rwm
> 
> The interface is also preserved. For example, if one wants to block only access
> to /dev/null:
> 	# ls -l /dev/null
> 	crw-rw-rw- 1 root root 1, 3 Jul 24 16:17 /dev/null
> 	# echo a >devices.allow
> 	# echo "c 1:3 rwm" >devices.deny
> 	# cat /dev/null
> 	cat: /dev/null: Operation not permitted
> 	# echo >/dev/null
> 	bash: /dev/null: Operation not permitted
> 	# mknod /tmp/null c 1 3
> 	mknod: /tmp/null: Operation not permitted
> 	# echo "c 1:3 r" >devices.allow
> 	# cat /dev/null
> 	# echo >/dev/null
> 	bash: /dev/null: Operation not permitted
> 	# mknod /tmp/null c 1 3
> 	mknod: /tmp/null: Operation not permitted
> 	# echo "c 1:3 rw" >devices.allow
> 	# echo >/dev/null
> 	# cat /dev/null
> 	# mknod /tmp/null c 1 3
> 	mknod: /tmp/null: Operation not permitted
> 	# echo "c 1:3 rwm" >devices.allow
> 	# echo >/dev/null
> 	# cat /dev/null
> 	# mknod /tmp/null c 1 3
> 	#
> 
> v2:
> - stop using simple_strtoul()
> - fix checkpatch warnings
> - rename deny_all to behavior
> - updated documentation
> - added new files to cgroupfs to better reflect the internal state
> 
>  Documentation/cgroups/devices.txt |   73 ++++--
>  security/device_cgroup.c          |  443 +++++++++++++++++++++++---------------
>  2 files changed, 333 insertions(+), 183 deletions(-)
> 
> -- 
> Aristeu

Thanks, Aristeu, very nice.

-serge
