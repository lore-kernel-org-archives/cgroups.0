From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V1 0/9] hugetlbfs: Add cgroup resource controller for hugetlbfs
Date: Mon, 20 Feb 2012 16:51:33 +0530
Message-ID: <1329736902-26870-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@kernel.org

Hi,

This patchset implements a cgroup resource controller for HugeTLB pages.
It is similar to the existing hugetlb quota support in that the limit is
enforced at mmap(2) time and not at fault time. HugeTLB quota limit the
number of huge pages that can allocated per superblock.

For shared mapping we track the region mapped by a task along with the
hugetlb cgroup. We keep the hugetlb cgroup charged even after the task
that did mmap(2) exit. The uncharge happens during truncate. For Private
mapping we charge and uncharge from the current task cgroup.

A sample strace output for an application doing malloc with hugectl is given
below. libhugetlbfs will fallback to normal pagesize if the HugeTLB mmap fails.

open("/mnt/libhugetlbfs.tmp.uhLMgy", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
unlink("/mnt/libhugetlbfs.tmp.uhLMgy")  = 0

.........

mmap(0x20000000000, 50331648, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = -1 ENOMEM (Cannot allocate memory)
write(2, "libhugetlbfs", 12libhugetlbfs)            = 12
write(2, ": WARNING: New heap segment map" ....
mmap(NULL, 42008576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfff946c0000
....


Changes from RFC post:
* Added support for HugeTLB cgroup hierarchy
* Added support for task migration
* Added documentation patch
* Other Bug fixes

-aneesh
