From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [RFC 0/4] per-namespace allowed filesystems list
Date: Mon, 23 Jan 2012 20:56:08 +0400
Message-ID: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This patch creates a list of allowed filesystems per-namespace.
The goal is to prevent users inside a container, even root,
to mount filesystems that are not allowed by the main box admin.

My main two motivators to pursue this are:
 1) We want to prevent a certain tailored view of some virtual
    filesystems, for example, by bind-mounting files with userspace
    generated data into /proc. The ability of mounting /proc inside
    the container works against this effort, while disallowing it
    via capabilities would have the effect of disallowing other
    mounts as well.

2) Some filesystems are known not to behave well under a container
   environment. They require changes to work in a safe-way. We can
   whitelist only the filesystems we want.

This works as a whitelist. Only filesystems in the list are allowed
to be mounted. Doing a blacklist would create problems when, say,
a module is loaded. The whitelist is only checked if it is enabled first.
So any setup that was already working, will keep working. And whoever
is not interested in limiting filesystem mount, does not need
to bother about it.

Please let me know what you guys think about it.

Glauber Costa (4):
  move /proc/filesystems inside /proc/self
  per-namespace allowed filesystems list
  show only allowed filesystems in /proc/filesystems
  fslist netlink interface

 fs/Kconfig                     |    9 +++
 fs/Makefile                    |    1 +
 fs/filesystems.c               |  108 ++++++++++++++++++++++++------
 fs/fsnetlink.c                 |  145 ++++++++++++++++++++++++++++++++++++++++
 fs/namespace.c                 |    5 +-
 fs/proc/base.c                 |   64 +++++++++++++++---
 fs/proc/root.c                 |    1 +
 include/linux/fs.h             |   11 +++
 include/linux/fslist_netlink.h |   35 ++++++++++
 include/linux/mnt_namespace.h  |   20 ++++++
 10 files changed, 368 insertions(+), 31 deletions(-)
 create mode 100644 fs/fsnetlink.c
 create mode 100644 include/linux/fslist_netlink.h

-- 
1.7.7.4
