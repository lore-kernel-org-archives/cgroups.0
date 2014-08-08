From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 0/4] mm: memcontrol: populate unified hierarchy interface v2
Date: Fri,  8 Aug 2014 17:38:10 -0400
Message-ID: <1407533894-25845-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=PXbdEFWYZR2VXSd5z/g4iTKhcFiXPj8salTY0fs+CUw=;
	b=SMB5POJZcsvV61bJV/NqH9OqqT5C7yH25QI2//HR3QHr460AUuuFPLUO+VjyXnF4RHpu4I8a6jJfjzOZ47AUeUxpFvglj1ri1Q9imcjOtsp3DDuedX2CScDTsi3jARcYq3JugfDRJSwl2hCdgvdylPVdbdPgjGpit1Iwff7aDRY=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

memory cgroups are fundamentally broken when it comes to partitioning
the machine for many concurrent jobs.  In real life, workloads expand
and contract over time, and the hard limit is too static to reflect
this - it either wastes memory outside of the group, or wastes memory
inside the group.  As a result, the hard limit is mostly just used to
catch extreme consumption peaks, while workload trimming and balancing
is left to global reclaim and global OOM handling.  That in turn
requires more and more cgroup-awareness on the global level to make up
for the lack of useful policy enforcement on the cgroup level itself.

The ongoing versioning of the cgroup user interface gives us a chance
to fix such brokenness, and also clean up the interface and fix a lot
of the inconsistencies and ugliness that crept in over time.

This series adds a minimal set of control files to version 2 of the
memcg interface, implementing a new approach to machine partitioning.

Version 2 of this series is in response to feedback from Michal.  Some
of the changes are in code, but mostly it improves the documentation
and changelogs to describe the fundamental problems with the original
approach to machine partitioning and makes a case for the new model.

 Documentation/cgroups/unified-hierarchy.txt |  65 ++++++++
 include/linux/res_counter.h                 |  29 ++++
 include/linux/swap.h                        |   6 +-
 kernel/res_counter.c                        |   3 +
 mm/memcontrol.c                             | 250 +++++++++++++++++++---------
 mm/vmscan.c                                 |   7 +-
 6 files changed, 277 insertions(+), 83 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
