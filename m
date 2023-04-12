From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 11:37:53 -0400
Message-ID: <20230412153758.3088111-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681313911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tcf4K424VGDcdSaKtEm81lLzwyCEljjvVM6IbOXUCaM=;
        b=VWLdg/KNm0gIXlWpNkBKhfctqh2+ivXhkBmWLLRbnYgtS8xrj/gkeSrV2hOwd04IPIzze2
        oViJ9B3YBhPqasaHwJptPFkd0Fco75beOECVIKeg75rFFHFJNLJEQDYP+5p2mb8S6/eF1w
        7JRHDVIhBWl5VylvG8CWXtJJEY9+VuY=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch series introduces a new "isolcpus" partition type to the
existing list of {member, root, isolated} types. The primary reason
of adding this new "isolcpus" partition is to facilitate the
distribution of isolated CPUs down the cgroup v2 hierarchy.

The other non-member partition types have the limitation that their
parents have to be valid partitions too. It will be hard to create a
partition a few layers down the hierarchy.

It is relatively rare to have applications that require creation of
a separate scheduling domain (root). However, it is more common to
have applications that require the use of isolated CPUs (isolated),
e.g. DPDK. One can use the "isolcpus" or "nohz_full" boot command options
to get that statically. Of course, the "isolated" partition is another
way to achieve that dynamically.

Modern container orchestration tools like Kubernetes use the cgroup
hierarchy to manage different containers. If a container needs to use
isolated CPUs, it is hard to get those with existing set of cpuset
partition types. With this patch series, a new "isolcpus" partition
can be created to hold a set of isolated CPUs that can be pull into
other "isolated" partitions.

The "isolcpus" partition is special that there can have at most one
instance of this in a system. It serves as a pool for isolated CPUs
and cannot hold tasks or sub-cpusets underneath it. It is also not
cpu-exclusive so that the isolated CPUs can be distributed down the
sibling hierarchies, though those isolated CPUs will not be useable
until the partition type becomes "isolated".

Once isolated CPUs are needed in a cgroup, the administrator can write
a list of isolated CPUs into its "cpuset.cpus" and change its partition
type to "isolated" to pull in those isolated CPUs from the "isolcpus"
partition and use them in that cgroup. That will make the distribution
of isolated CPUs to cgroups that need them much easier.

In the future, we may be able to extend this special "isolcpus" partition
type to support other isolation attributes like those that can be
specified with the "isolcpus" boot command line and related options.

Waiman Long (5):
  cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE
    handling
  cgroup/cpuset: Add a new "isolcpus" paritition root state
  cgroup/cpuset: Make isolated partition pull CPUs from isolcpus
    partition
  cgroup/cpuset: Documentation update for the new "isolcpus" partition
  cgroup/cpuset: Extend test_cpuset_prs.sh to test isolcpus partition

 Documentation/admin-guide/cgroup-v2.rst       |  89 ++-
 kernel/cgroup/cpuset.c                        | 548 +++++++++++++++---
 .../selftests/cgroup/test_cpuset_prs.sh       | 376 ++++++++----
 3 files changed, 789 insertions(+), 224 deletions(-)

-- 
2.31.1

