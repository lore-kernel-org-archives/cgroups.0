From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 27 Feb 2020 14:56:03 -0500
Message-ID: <20200227195606.46212-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pHZKSP3VYnp46GXjDiGlb2OsfVMbe+Fm/ufXK0JaZec=;
        b=ghhFE02MoIHofcbDHVRBX9U/7eYfI4j70g1jWmFx0XEAoGpx7H47Gm0IWki1DRpFWc
         AqetnajsS/aYstusDRdzWPmEqTkl4wXNs/GAvuHu+DaaQM59ogrAZGzjP0MCSo19sPDL
         Poe40EqlTElaA/+u1CqJaB2Z6SxWrAQw6x9MBcfaUuZoc51ePJ+a3oYqcvBWc0OBDBry
         h8ctnmZ6CZdjFXHF2seaePaRSJrTPH8gi7/+I0suTK/cROfvShjCwDl5XMmcxabuH+Jq
         JbVgIl+KZ5Ygbamyx4ahqc89JV07ytB/RvEZSH6GcE+40H9BMjdM4i0yhnwIUqYm/xka
         U1pQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Changes since v2:
- Changelog & documentation updates (Michal Hocko, Michal Koutny)

Changes since v1:
- improved Changelogs based on the discussion with Roman. Thanks!
- fix div0 when recursive & fixed protection is combined
- fix an unused compiler warning

The current memory.low (and memory.min) semantics require protection
to be assigned to a cgroup in an untinterrupted chain from the
top-level cgroup all the way to the leaf.

In practice, we want to protect entire cgroup subtrees from each other
(system management software vs. workload), but we would like the VM to
balance memory optimally *within* each subtree, without having to make
explicit weight allocations among individual components. The current
semantics make that impossible.

They also introduce unmanageable complexity into more advanced
resource trees. For example:

          host root
          `- system.slice
             `- rpm upgrades
             `- logging
          `- workload.slice
             `- a container
                `- system.slice
                `- workload.slice
                   `- job A
                      `- component 1
                      `- component 2
                   `- job B

From a host-level perspective, we would like to protect the outer
workload.slice subtree as a whole from rpm upgrades, logging etc. But
for that to be effective, right now we'd have to propagate it down
through the container, the inner workload.slice, into the job cgroup
and ultimately the component cgroups where memory is actually,
physically allocated. This may cross several tree delegation points
and namespace boundaries, which make such a setup near impossible.

CPU and IO on the other hand are already distributed recursively. The
user would simply configure allowances at the host level, and they
would apply to the entire subtree without any downward propagation.

To enable the above-mentioned usecases and bring memory in line with
other resource controllers, this patch series extends memory.low/min
such that settings apply recursively to the entire subtree. Users can
still assign explicit shares in subgroups, but if they don't, any
ancestral protection will be distributed such that children compete
freely amongst each other - as if no memory control were enabled
inside the subtree - but enjoy protection from neighboring trees.

In the above example, the user would then be able to configure shares
of CPU, IO and memory at the host level to comprehensively protect and
isolate the workload.slice as a whole from system.slice activity.

Patch #1 fixes an existing bug that can give a cgroup tree more
protection than it should receive as per ancestor configuration.

Patch #2 simplifies and documents the existing code to make it easier
to reason about the changes in the next patch.

Patch #3 finally implements recursive memory protection semantics.

Because of a risk of regressing legacy setups, the new semantics are
hidden behind a cgroup2 mount option, 'memory_recursiveprot'.

More details in patch #3.

 Documentation/admin-guide/cgroup-v2.rst |  11 ++
 include/linux/cgroup-defs.h             |   5 +
 kernel/cgroup/cgroup.c                  |  17 ++-
 mm/memcontrol.c                         | 220 +++++++++++++++++-------------
 mm/page_counter.c                       |  12 +-
 5 files changed, 160 insertions(+), 105 deletions(-)


