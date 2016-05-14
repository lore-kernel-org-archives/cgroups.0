From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v4 0/2] cgroup: allow management of subtrees by new cgroup namespaces
Date: Sat, 14 May 2016 13:19:58 +1000
Message-ID: <1463196000-13900-1-git-send-email-asarai@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>

This is an updated (and rewritten) version of v3 of this patchset[1].

The main difference is that I changed how we the "allow management" is
implemented. Rather than just chmod-ing the cgroup directory (which
everyone agreed was quite an odd way of doing it),
unshare(CLONE_NEWCGROUP) will create a new subtree in every cgroup the
task is associated with. The task will then be migrated to those
subtrees (which form the root cset of the cgroup namespace). This change
will be transparent to namespaced processes, and they'll gain a new
ability (the ability to create cgroups).

The name of the cgroup is randomly generated to ensure we don't get
conflicts (but maybe this should be dealt with in a nicer way). In
addition, I've updated the cgroup.procs write permission checks to be
user namespace aware, but I also added an additional "permitted" case
(where all of the tasks are in the same cgroup namespace and %current
has CAP_SYS_ADMIN in all of the relevant user namespaces).

I'm not _completely_ convinced about the addition of that case, and
maybe we should drop it (but I might be biased since this all comes from
the requirements of rootless containers).

Also, I haven't added a way to disable the functionality on a per-cgroup
(or even global) basis. Maybe there should be a way to do that, but I'm
not sure how it should be done (a cgroup.ns_subtrees file that allows
administrators to change it on a per-cgroup basis, or just a sysctl?).

PTAL.

[1]: https://lkml.org/lkml/2016/5/2/280

Aleksa Sarai (2):
  cgroup: make cgroup.procs permissions userns-aware
  cgroup: implement subtree creation on copy_cgroup_ns()

 kernel/cgroup.c | 149 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 126 insertions(+), 23 deletions(-)

-- 
2.8.2
