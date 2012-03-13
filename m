From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 0/8] memcg: Add memcg extension to control HugeTLB allocation
Date: Tue, 13 Mar 2012 12:37:04 +0530
Message-ID: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hi,

This patchset implements a memory controller extension to control
HugeTLB allocations. The extension allows to limit the HugeTLB
usage per control group and enforces the controller limit during
page fault. Since HugeTLB doesn't support page reclaim, enforcing
the limit at page fault time implies that, the application will get
SIGBUS signal if it tries to access HugeTLB pages beyond its limit.
This requires the application to know beforehand how much HugeTLB
pages it would require for its use.

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


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
