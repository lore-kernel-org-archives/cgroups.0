From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 0/3] cgroup: add xattr support
Date: Thu, 01 Mar 2012 14:16:57 +0800
Message-ID: <4F4F1459.4080300@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lennart Poettering <mzxreary@0pointer.de>, Kay Sievers <kay.sievers@vrfy.org>, Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Eric Paris <eparis@redhat.com>

This can be used to attach metadata to a cgroup, which is required
by systemd.

As lazy as I am, here just quoted from Lennart for the detailed use
cases:

>> What would the use case be for this?
>
> Attaching meta information to services, in an easily discoverable
> way. For example, in systemd we create one cgroup for each service, and
> could then store data like the main pid of the specific service as an
> xattr on the cgroup itself. That way we'd have almost all service state
> in the cgroupfs, which would make it possible to terminate systemd and
> later restart it without losing any state information. But there's more:
> for example, some very peculiar services cannot be terminated on
> shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
> services in question could just mark that on their cgroup, by setting an
> xattr. On the more desktopy side of things there are other
> possibilities: for example there are plans defining what an application
> is along the lines of a cgroup (i.e. an app being a collection of
> processes). With xattrs one could then attach an icon or human readable
> program name on the cgroup.
>
> The key idea is that this would allow attaching runtime meta information
> to cgroups and everything they model (services, apps, vms), that doesn't
> need any complex userspace infrastructure, has good access control
> (i.e. because the file system enforces that anyway, and there's the
> "trusted." xattr namespace), notifications (inotify), and can easily be
> shared among applications.
>
> Lennart

Changelog v1->v2:
- add kmem_xattr APIs
- use these new APIs in both tmpfs and cgroup

Early discussions can be found in this thread:

https://lkml.org/lkml/2012/1/16/51

Note: this patchset is based on Tejun's cgroup.git/for-next

--
 fs/xattr.c               |  167 +++++++++++++++++++++++++++++++++++++++++
 include/linux/cgroup.h   |   18 +++-
 include/linux/shmem_fs.h |    3 +-
 include/linux/xattr.h    |   23 ++++++
 init/Kconfig             |   12 +++
 kernel/cgroup.c          |  184 ++++++++++++++++++++++++++++++++++++----------
 mm/shmem.c               |  151 +++-----------------------------------
 7 files changed, 371 insertions(+), 187 deletions(-)
