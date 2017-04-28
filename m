From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] mm/memcontrol: fix reclaim bugs in mem_cgroup_iter
Date: Fri, 28 Apr 2017 14:55:45 -0700
Message-ID: <1493416547-19212-1-git-send-email-sean.j.christopherson@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

This patch set contains two bug fixes for mem_cgroup_iter().  The bugs
were found by code inspection and were confirmed via synthetic testing
that forcefully setup the failing conditions.

Bug #1 is a race condition where mem_cgroup_iter() incorrectly returns
the same memcg to multiple threads reclaiming from the same root, zone,
priority and generation.  mem_cgroup_iter() doesn't check the result of
cmpxchg(iter->pos...) when setting the new pos, and so fails to detect
that it will return the same memcg as the thread that successfully set
iter->position.  If multiple threads read the same iter->position value,
then they will call css_next_descendant_pre() with the same css and will
compute the same memcg (unless they see different versions of the tree
due to an RCU update).

Bug #2 is also a race condition of sorts, with the same setup conditions
as bug #1.  If a reclaimer's initial call to mem_cgroup_iter() triggers
a restart of the hierarchy walk, i.e. css_next_descendant_pre() returns
NULL and prev == NULL, mem_cgroup_iter() fails to increment iter->gen...
even though it has started a new walk of the hierarchy.  This technically
isn't a bug for the thread that triggered the restart as it's reasonable
for that thread to perform a full walk of the tree, but other threads
in the current reclaim generation will incorrectly continue to walk the
tree since iter->generation won't be updated until one of the reclaimers
reaches the end of the hierarchy a second time.

The two patches can be applied independently, but I included them in a
single series as the fix for bug #1 can theoretically exacerbate bug #2,
and bug #2 is likely more serious as it results in a duplicate walk of
the entire tree as opposed to a duplicate reclaim of a single memcg.


Sean Christopherson (2):
  mm/memcontrol: check cmpxchg(iter->pos...) result in mem_cgroup_iter()
  mm/memcontrol: inc reclaim gen if restarting walk in mem_cgroup_iter()

 mm/memcontrol.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 9 deletions(-)

