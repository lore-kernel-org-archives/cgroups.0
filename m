From: SeongJae Park <sj38.park@gmail.com>
Subject: Re: [PATCH 2/2] cgroups: Documentation: fix trivial typos and wrong
 paragraph numberings
Date: Thu, 4 Dec 2014 00:36:09 +0900 (KST)
Message-ID: <alpine.DEB.2.10.1412040033120.1819@hxeon>
References: <1417607625-2775-1-git-send-email-sj38.park@gmail.com> <1417607625-2775-2-git-send-email-sj38.park@gmail.com> <20141203090113.359198f6@lwn.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=CWIDnzl60vE01OUPeJuy0UvAp8eA/zZL3oe293rdooc=;
        b=aoKFIMhsIGZDiyuNeus1SdK7rS7l/GMNWyhfvQWTe8R7hOqP7uPneeXyi5Ta0+LTYJ
         Qq5XI0qhQzZQPjd9T7yJUd9V9Div2nd6QO2OQi0nUkVtCnQXwpehklukif5vVyZFE1Nz
         pZJwRDS2lqzZolmfivR0fVYdw6Qrs7gEOyXX54kWKTEQmf2T2IDtcE9OhxrcCxb/fvCY
         cg9/oyfUxY/x+jfC1wQPuHx1dJOBUVFOakjrthQr5/muoRydAS+BWd7a4qXlQG34t0KG
         s26C4Mjx7Julrq8l48Qwjwlbe7prba+yk9wpwruMwEUyIXeCecPaQmOD/noGV4LtLGor
         pflA==
In-Reply-To: <20141203090113.359198f6@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj38.park@gmail.com>, tj@kernel.org, lizefan@huawei.com, trivial@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org



On Wed, 3 Dec 2014, Jonathan Corbet wrote:

> On Wed,  3 Dec 2014 20:53:45 +0900
> SeongJae Park <sj38.park@gmail.com> wrote:
>
>>  Documentation/cgroups/cpusets.txt | 6 +++---
>>  Documentation/cgroups/memory.txt  | 8 ++++----
>>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> I applied patch 1 to my docs tree, but this one doesn't apply.  Which
> kernel did you base it on?

I based it on latest linux-next tree.

Looks like I should based it on linux-docs tree. I will do for my later 
patches for documentations.

Below is the patch 2 based on linux-docs tree.


========================= >3 ===================================

From 6f0abd850dfdc4ca06a29e62a268b5c8da931053 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 3 Dec 2014 20:45:48 +0900
Subject: [PATCH] cgroups: Documentation: fix trivial typos and wrong 
paragraph
  numberings

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
  Documentation/cgroups/cpusets.txt | 6 +++---
  Documentation/cgroups/memory.txt  | 8 ++++----
  2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt 
b/Documentation/cgroups/cpusets.txt
index 7740038..2e921b5 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -445,7 +445,7 @@ across partially overlapping sets of CPUs would risk 
unstable dynamics
  that would be beyond our understanding.  So if each of two partially
  overlapping cpusets enables the flag 'cpuset.sched_load_balance', then we
  form a single sched domain that is a superset of both.  We won't move
-a task to a CPU outside it cpuset, but the scheduler load balancing
+a task to a CPU outside its cpuset, but the scheduler load balancing
  code might waste some compute cycles considering that possibility.

  This mismatch is why there is not a simple one-to-one relation
@@ -552,8 +552,8 @@ otherwise initial value -1 that indicates the cpuset 
has no request.
     1  : search siblings (hyperthreads in a core).
     2  : search cores in a package.
     3  : search cpus in a node [= system wide on non-NUMA system]
- ( 4  : search nodes in a chunk of node [on NUMA system] )
- ( 5  : search system wide [on NUMA system] )
+   4  : search nodes in a chunk of node [on NUMA system]
+   5  : search system wide [on NUMA system]

  The system default is architecture dependent.  The system default
  can be changed using the relax_domain_level= boot parameter.
diff --git a/Documentation/cgroups/memory.txt 
b/Documentation/cgroups/memory.txt
index 02ab997..228c1cc 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -321,7 +321,7 @@ per cgroup, instead of globally.

  * tcp memory pressure: sockets memory pressure for the tcp protocol.

-2.7.3 Common use cases
+2.7.2 Common use cases

  Because the "kmem" counter is fed to the main user counter, kernel memory 
can
  never be limited completely independently of user memory. Say "U" is the 
user
@@ -349,7 +349,7 @@ set:

  3. User Interface

-0. Configuration
+3.0. Configuration

  a. Enable CONFIG_CGROUPS
  b. Enable CONFIG_RESOURCE_COUNTERS
@@ -357,12 +357,12 @@ c. Enable CONFIG_MEMCG
  d. Enable CONFIG_MEMCG_SWAP (to use swap extension)
  d. Enable CONFIG_MEMCG_KMEM (to use kmem extension)

-1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
+3.1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
  # mount -t tmpfs none /sys/fs/cgroup
  # mkdir /sys/fs/cgroup/memory
  # mount -t cgroup none /sys/fs/cgroup/memory -o memory

-2. Make the new group and move bash into it
+3.2. Make the new group and move bash into it
  # mkdir /sys/fs/cgroup/memory/0
  # echo $$ > /sys/fs/cgroup/memory/0/tasks

--
1.9.1


Thanks,
SeongJae Park

>
> Thanks,
>
> jon
>
