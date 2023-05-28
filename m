From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Sun, 28 May 2023 17:18:50 -0400
Message-ID: <18793f4a-fd39-2e71-0b77-856afb01547b@redhat.com>
References: <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
 <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
 <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
 <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
 <ZFGOTHQj3k5rzmyR@blackbook>
 <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001@redhat.com>
 <ZFUo5IYAIwTEKR4_@slm.duckdns.org>
 <759603dd-7538-54ad-e63d-bb827b618ae3@redhat.com>
 <405b2805-538c-790b-5bf8-e90d3660f116@redhat.com>
 <ZGvHUjOCjwat91Gq@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685308736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Um1A7pr7TdEip1EPUsNyisBw5ieK06CvDe/AUKbysUg=;
        b=gMGd50ofVJzEEuqVwJzCObnJUOJ4v9788a/oVy2Cp09L29lHUAN5E8j6DpwdI70yAdnlc2
        pnpG5TgwqJxpV5Z2OvOmfi+TLmT6w5LRIUGI349G5AXkmoAxraJObyqdbYUAgknav1Vsl/
        1IGrn76Qbgyv7Vs/QMleGldfvEvQ2Fk=
Content-Language: en-US
In-Reply-To: <ZGvHUjOCjwat91Gq@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

On 5/22/23 15:49, Tejun Heo wrote:
> Hello, Waiman.

Sorry for the late reply as I had been off for almost 2 weeks due to PTO.


>
> On Sun, May 07, 2023 at 09:03:44PM -0400, Waiman Long wrote:
> ...
>>    cpuset.cpus.reserve
>>      A read-write multiple values file which exists only on root
>>      cgroup.
>>
>>      It lists all the CPUs that are reserved for adjacent and remote
>>      partitions created in the system.  See the next section for
>>      more information on what an adjacent or remote partitions is.
>>
>>      Creation of adjacent partition does not require touching this
>>      control file as CPU reservation will be done automatically.
>>      In order to create a remote partition, the CPUs needed by the
>>      remote partition has to be written to this file first.
>>
>>      A "+" prefix can be used to indicate a list of additional
>>      CPUs that are to be added without disturbing the CPUs that are
>>      originally there.  For example, if its current value is "3-4",
>>      echoing ""+5" to it will change it to "3-5".
>>
>>      Once a remote partition is destroyed, its CPUs have to be
>>      removed from this file or no other process can use them.  A "-"
>>      prefix can be used to remove a list of CPUs from it.  However,
>>      removing CPUs that are currently used in existing partitions
>>      may cause those partitions to become invalid.  A single "-"
>>      character without any number can be used to indicate removal
>>      of all the free CPUs not allocated to any partitions to avoid
>>      accidental partition invalidation.
> Why is the syntax different from .cpus? Wouldn't it be better to keep them
> the same?

Unlike cpuset.cpus, cpuset.cpus.reserve is supposed to contains CPUs 
that are used in multiple partitions. Also automatic reservation of 
adjacent partitions can happen in parallel. That is why I think it will 
be safer if we allow incremental increase or decrease of reserve CPUs to 
be used for remote partitions. I will include this reasoning into the 
doc file.


>>    cpuset.cpus.partition
>>      A read-write single value file which exists on non-root
>>      cpuset-enabled cgroups.  This flag is owned by the parent cgroup
>>      and is not delegatable.
>>
>>      It accepts only the following input values when written to.
>>
>>        ==========    =====================================
>>        "member"    Non-root member of a partition
>>        "root"    Partition root
>>        "isolated"    Partition root without load balancing
>>        ==========    =====================================
>>
>>      A cpuset partition is a collection of cgroups with a partition
>>      root at the top of the hierarchy and its descendants except
>>      those that are separate partition roots themselves and their
>>      descendants.  A partition has exclusive access to the set of
>>      CPUs allocated to it.  Other cgroups outside of that partition
>>      cannot use any CPUs in that set.
>>
>>      There are two types of partitions - adjacent and remote.  The
>>      parent of an adjacent partition must be a valid partition root.
>>      Partition roots of adjacent partitions are all clustered around
>>      the root cgroup.  Creation of adjacent partition is done by
>>      writing the desired partition type into "cpuset.cpus.partition".
>>
>>      A remote partition does not require a partition root parent.
>>      So a remote partition can be formed far from the root cgroup.
>>      However, its creation is a 2-step process.  The CPUs needed
>>      by a remote partition ("cpuset.cpus" of the partition root)
>>      has to be written into "cpuset.cpus.reserve" of the root
>>      cgroup first.  After that, "isolated" can be written into
>>      "cpuset.cpus.partition" of the partition root to form a remote
>>      isolated partition which is the only supported remote partition
>>      type for now.
>>
>>      All remote partitions are terminal as adjacent partition cannot
>>      be created underneath it.
> Can you elaborate this extra restriction a bit further?

Are you referring to the fact that only remote isolated partitions are 
supported? I do not preclude the support of load balancing remote 
partitions. I keep it to isolated partitions for now for ease of 
implementation and I am not currently aware of a use case where such a 
remote partition type is needed.

If you are talking about remote partition being terminal. It is mainly 
because it can be more tricky to support hierarchical adjacent 
partitions underneath it especially if it is not isolated. We can 
certainly support it if a use case arises. I just don't want to 
implement code that nobody is really going to use.

BTW, with the current way the remote partition is created, it is not 
possible to have another remote partition underneath it.

>
> In general, I think it'd be really helpful if the document explains the
> reasoning behind the design decisions. ie. Why is reserving for? What
> purpose does it serve that the regular isolated ones cannot? That'd help
> clarifying the design decisions.

I understand your concern. If you think it is better to support both 
types of remote partitions or hierarchical adjacent partitions 
underneath it for symmetry purpose, I can certain do that. It just needs 
to take a bit more time.

Cheers,
Longman

