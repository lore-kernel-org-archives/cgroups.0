From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Sun, 7 May 2023 21:03:44 -0400
Message-ID: <405b2805-538c-790b-5bf8-e90d3660f116@redhat.com>
References: <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
 <ZDmFLfII8EUX_ocY@slm.duckdns.org>
 <c61ca9d0-c514-fb07-c2f2-3629e8898984@redhat.com>
 <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
 <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
 <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
 <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
 <ZFGOTHQj3k5rzmyR@blackbook>
 <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001@redhat.com>
 <ZFUo5IYAIwTEKR4_@slm.duckdns.org>
 <759603dd-7538-54ad-e63d-bb827b618ae3@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683507829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNJL2kG/0UIHUcIFT9+ra+rm25yTkCXYyXj8ZQWBWis=;
        b=hfu5vvivKXmLf+xWAOAGXAKYedEPFpNEwM1o5832eDYn9rOPCyzaxLBtKmLHCCkx/SQ88F
        VcOfoXBVIwmAdLUeFyyuh3EkOYJDRLNm0x4MPJ+xGL2Vel/EFOfwQPX2TZBR8fD319Kr37
        wj4nGh3tjjUpunx3dO1ajZOE35nTCVk=
Content-Language: en-US
In-Reply-To: <759603dd-7538-54ad-e63d-bb827b618ae3@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

Hi,

The following is the proposed text for "cpuset.cpus.reserve" and 
"cpuset.cpus.partition" of the new cpuset partition in 
Documentation/admin-guide/cgroup-v2.rst.

   cpuset.cpus.reserve
     A read-write multiple values file which exists only on root
     cgroup.

     It lists all the CPUs that are reserved for adjacent and remote
     partitions created in the system.  See the next section for
     more information on what an adjacent or remote partitions is.

     Creation of adjacent partition does not require touching this
     control file as CPU reservation will be done automatically.
     In order to create a remote partition, the CPUs needed by the
     remote partition has to be written to this file first.

     A "+" prefix can be used to indicate a list of additional
     CPUs that are to be added without disturbing the CPUs that are
     originally there.  For example, if its current value is "3-4",
     echoing ""+5" to it will change it to "3-5".

     Once a remote partition is destroyed, its CPUs have to be
     removed from this file or no other process can use them.  A "-"
     prefix can be used to remove a list of CPUs from it.  However,
     removing CPUs that are currently used in existing partitions
     may cause those partitions to become invalid.  A single "-"
     character without any number can be used to indicate removal
     of all the free CPUs not allocated to any partitions to avoid
     accidental partition invalidation.

   cpuset.cpus.partition
     A read-write single value file which exists on non-root
     cpuset-enabled cgroups.  This flag is owned by the parent cgroup
     and is not delegatable.

     It accepts only the following input values when written to.

       ==========    =====================================
       "member"    Non-root member of a partition
       "root"    Partition root
       "isolated"    Partition root without load balancing
       ==========    =====================================

     A cpuset partition is a collection of cgroups with a partition
     root at the top of the hierarchy and its descendants except
     those that are separate partition roots themselves and their
     descendants.  A partition has exclusive access to the set of
     CPUs allocated to it.  Other cgroups outside of that partition
     cannot use any CPUs in that set.

     There are two types of partitions - adjacent and remote.  The
     parent of an adjacent partition must be a valid partition root.
     Partition roots of adjacent partitions are all clustered around
     the root cgroup.  Creation of adjacent partition is done by
     writing the desired partition type into "cpuset.cpus.partition".

     A remote partition does not require a partition root parent.
     So a remote partition can be formed far from the root cgroup.
     However, its creation is a 2-step process.  The CPUs needed
     by a remote partition ("cpuset.cpus" of the partition root)
     has to be written into "cpuset.cpus.reserve" of the root
     cgroup first.  After that, "isolated" can be written into
     "cpuset.cpus.partition" of the partition root to form a remote
     isolated partition which is the only supported remote partition
     type for now.

     All remote partitions are terminal as adjacent partition cannot
     be created underneath it.

     The root cgroup is always a partition root and its state cannot
     be changed.  All other non-root cgroups start out as "member".

     When set to "root", the current cgroup is the root of a new
     partition or scheduling domain.

     When set to "isolated", the CPUs in that partition will
     be in an isolated state without any load balancing from the
     scheduler.  Tasks placed in such a partition with multiple
     CPUs should be carefully distributed and bound to each of the
     individual CPUs for optimal performance.

     The value shown in "cpuset.cpus.effective" of a partition root is
     the CPUs that are dedicated to that partition and not available
     to cgroups outside of that partittion.

     A partition root ("root" or "isolated") can be in one of the
     two possible states - valid or invalid.  An invalid partition
     root is in a degraded state where some state information may
     be retained, but behaves more like a "member".

     All possible state transitions among "member", "root" and
     "isolated" are allowed.

     On read, the "cpuset.cpus.partition" file can show the following
     values.

       ============================= =====================================
       "member"            Non-root member of a partition
       "root"            Partition root
       "isolated"            Partition root without load balancing
       "root invalid (<reason>)"    Invalid partition root
       "isolated invalid (<reason>)"    Invalid isolated partition root
       ============================= =====================================

     In the case of an invalid partition root, a descriptive string on
     why the partition is invalid is included within parentheses.

     For an adjacent partition root to be valid, the following
     conditions must be met.

     1) The "cpuset.cpus" is exclusive with its siblings , i.e. they
        are not shared by any of its siblings (exclusivity rule).
     2) The parent cgroup is a valid partition root.
     3) The "cpuset.cpus" is not empty and must contain at least
        one of the CPUs from parent's "cpuset.cpus", i.e. they overlap.
     4) The "cpuset.cpus.effective" cannot be empty unless there is
        no task associated with this partition.

     For a remote partition root to be valid, the following conditions
     must be met.

     1) The same exclusivity rule as adjacent partition root.
     2) The "cpuset.cpus" is not empty and all the CPUs must be
        present in "cpuset.cpus.reserve" of the root cgroup and none
        of them are allocated to another partition.
     3) The "cpuset.cpus" value must be present in all its ancestors
        to ensure proper hierarchical cpu distribution.

     External events like hotplug or changes to "cpuset.cpus" can
     cause a valid partition root to become invalid and vice versa.
     Note that a task cannot be moved to a cgroup with empty
     "cpuset.cpus.effective".

     For a valid partition root with the sibling cpu exclusivity
     rule enabled, changes made to "cpuset.cpus" that violate the
     exclusivity rule will invalidate the partition as well as its
     sibling partitions with conflicting cpuset.cpus values. So
     care must be taking in changing "cpuset.cpus".

     A valid non-root parent partition may distribute out all its CPUs
     to its child partitions when there is no task associated with it.

     Care must be taken to change a valid partition root to
     "member" as all its child partitions, if present, will become
     invalid causing disruption to tasks running in those child
     partitions. These inactivated partitions could be recovered if
     their parent is switched back to a partition root with a proper
     set of "cpuset.cpus".

     Poll and inotify events are triggered whenever the state of
     "cpuset.cpus.partition" changes.  That includes changes caused
     by write to "cpuset.cpus.partition", cpu hotplug or other
     changes that modify the validity status of the partition.
     This will allow user space agents to monitor unexpected changes
     to "cpuset.cpus.partition" without the need to do continuous
     polling.

Cheers,
Longman

