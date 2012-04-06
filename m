From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH -V5 00/14] memcg: Add memcg extension to control HugeTLB allocation
Date: Sat,  7 Apr 2012 00:20:46 +0530
Message-ID: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

This patchset implements a memory controller extension to control
HugeTLB allocations. The extension allows to limit the HugeTLB
usage per control group and enforces the controller limit during
page fault. Since HugeTLB doesn't support page reclaim, enforcing
the limit at page fault time implies that, the application will get
SIGBUS signal if it tries to access HugeTLB pages beyond its limit.
This requires the application to know beforehand how much HugeTLB
pages it would require for its use.

The goal is to control how many HugeTLB pages a group of task can
allocate. It can be looked at as an extension of the existing quota
interface which limits the number of HugeTLB pages per hugetlbfs
superblock. HPC job scheduler requires jobs to specify their resource
requirements in the job file. Once their requirements can be met,
job schedulers like (SLURM) will schedule the job. We need to make sure
that the jobs won't consume more resources than requested. If they do
we should either error out or kill the application.

Patches are on top of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5

Changes from V4:
 * Add support for charge/uncharge during page migration
 * Drop the usage of page->lru in unmap_hugepage_range.

Changes from v3:
 * Address review feedback.
 * Fix a bug in cgroup removal related parent charging with use_hierarchy set

Changes from V2:
* Changed the implementation to limit the HugeTLB usage during page
  fault time. This simplifies the extension and keep it closer to
  memcg design. This also allows to support cgroup removal with less
  complexity. Only caveat is the application should ensure its HugeTLB
  usage doesn't cross the cgroup limit.

Changes from V1:
* Changed the implementation as a memcg extension. We still use
  the same logic to track the cgroup and range.

Changes from RFC post:
* Added support for HugeTLB cgroup hierarchy
* Added support for task migration
* Added documentation patch
* Other bug fixes

-aneesh

