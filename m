From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: memcg/cgroup: do not fail fail on pre_destroy callbacks
Date: Fri, 26 Oct 2012 13:37:27 +0200
Message-ID: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hi,
memcg is the only controller which might fail in its pre_destroy
callback which makes the cgroup core more complicated for no good
reason. This is an attempt to change this unfortunate state.

I have previously posted this as an RFC https://lkml.org/lkml/2012/10/17/246
and the feedback was mostly positive. Nobody seem to see any issues with
the approach so let's move on from the RFC. The patchset still needs
good portion of testing and I am working on it. I would also like to see some
Acks ;)
The patchset is posted as v3 because some of the patches went trough 2
revisions during RFC.

The first two patches are just clean ups. They could be merged even
without the rest.

The real change, although the code is not changed that much, is the 3rd
patch. It changes the way how we handle mem_cgroup_move_parent failures.
We have to realize that all those failures are *temporal*. Because we
are either racing with the page removal or the page is temporarily off
the LRU because of migration resp. global reclaim. As a result we do
not fail mem_cgroup_force_empty_list if the page cannot be moved to the
parent and rather retry until the LRU is empty.

The 4th patch is for cgroup core. I have moved cgroup_call_pre_destroy
after css are frozen and the group is marked as removed which means
that all css_tryget will fail as well as no new task can attach the group
resp. no new child group can be added.

Tejun is planning to build on top of that and make some more cleanups
in the cgroup core (namely get rid of of the whole retry code in
cgroup_rmdir).
This makes unfortunate inter-tree dependency between Andrew's and
Tejun's tree therefore I have based all the work on 3.6 kernel so that
it can be merged into Tejun's cgroup tree as well into -mm git tree
(Andrew will see all the changes from linux-next). I do not like to
push memcg changes through other than Andrew's tree but this seems to
be easier as other cgroup changes will probably depend on the Tejun's
cleanups. Is everybody OK with this?

The last two patches are trivial follow ups for the cgroups core change
because now we know that nobody will interfere with us so we can drop
those empty && no child condition.

See the specific patches for the changelogs.

Michal Hocko (6):
      memcg: split mem_cgroup_force_empty into reclaiming and reparenting parts
      memcg: root_cgroup cannot reach mem_cgroup_move_parent
      memcg: Simplify mem_cgroup_force_empty_list error handling
      cgroups: forbid pre_destroy callback to fail
      memcg: make mem_cgroup_reparent_charges non failing
      hugetlb: do not fail in hugetlb_cgroup_pre_destroy

Cumulative diffstat:
 kernel/cgroup.c     |   30 ++++-------
 mm/hugetlb_cgroup.c |   11 ++--
 mm/memcontrol.c     |  148 ++++++++++++++++++++++++++++++---------------------
 3 files changed, 99 insertions(+), 90 deletions(-)
