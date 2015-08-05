From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] cgroup: define controller file conventions
Date: Wed, 5 Aug 2015 09:39:40 +0900
Message-ID: <55C15B4C.9080202@jp.fujitsu.com>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
 <20150804193101.GI17598@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804193101.GI17598-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 2015/08/05 4:31, Tejun Heo wrote:
>  From 6abc8ca19df0078de17dc38340db3002ed489ce7 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 4 Aug 2015 15:20:55 -0400
>
> Traditionally, each cgroup controller implemented whatever interface
> it wanted leading to interfaces which are widely inconsistent.
> Examining the requirements of the controllers readily yield that there
> are only a few control schemes shared among all.
>
> Two major controllers already had to implement new interface for the
> unified hierarchy due to significant structural changes.  Let's take
> the chance to establish common conventions throughout all controllers.
>
> This patch defines CGROUP_WEIGHT_MIN/DFL/MAX to be used on all weight
> based control knobs and documents the conventions that controllers
> should follow on the unified hierarchy.  Except for io.weight knob,
> all existing unified hierarchy knobs are already compliant.  A
> follow-up patch will update io.weight.
>
> v2: Added descriptions of min, low and high knobs.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
> Hello,
>
> Added low/high descriptions and applied to the following git branch.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.3-unified-base
>
> The branch currently only contains this patch and will stay stable so
> that it can be pulled from.  I kept the base weight as DFL for now.
> If we decide to change it, I'll apply the change on top.
>
> Thanks.
>
>   Documentation/cgroups/unified-hierarchy.txt | 80 ++++++++++++++++++++++++++---
>   include/linux/cgroup.h                      |  9 ++++
>   2 files changed, 81 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
> index 86847a7..1ee9caf 100644
> --- a/Documentation/cgroups/unified-hierarchy.txt
> +++ b/Documentation/cgroups/unified-hierarchy.txt
> @@ -23,10 +23,13 @@ CONTENTS
>   5. Other Changes
>     5-1. [Un]populated Notification
>     5-2. Other Core Changes
> -  5-3. Per-Controller Changes
> -    5-3-1. blkio
> -    5-3-2. cpuset
> -    5-3-3. memory
> +  5-3. Controller File Conventions
> +    5-3-1. Format
> +    5-3-2. Control Knobs
> +  5-4. Per-Controller Changes
> +    5-4-1. blkio
> +    5-4-2. cpuset
> +    5-4-3. memory
>   6. Planned Changes
>     6-1. CAP for resource control
>
> @@ -372,14 +375,75 @@ supported and the interface files "release_agent" and
>   - The "cgroup.clone_children" file is removed.
>
>
> -5-3. Per-Controller Changes
> +5-3. Controller File Conventions
>
> -5-3-1. blkio
> +5-3-1. Format
> +
> +In general, all controller files should be in one of the following
> +formats whenever possible.
> +
> +- Values only files
> +
> +  VAL0 VAL1...\n
> +
> +- Flat keyed files
> +
> +  KEY0 VAL0\n
> +  KEY1 VAL1\n
> +  ...
> +
> +- Nested keyed files
> +
> +  KEY0 SUB_KEY0=VAL00 SUB_KEY1=VAL01...
> +  KEY1 SUB_KEY0=VAL10 SUB_KEY1=VAL11...
> +  ...
> +
> +For a writeable file, the format for writing should generally match
> +reading; however, controllers may allow omitting later fields or
> +implement restricted shortcuts for most common use cases.
> +
> +For both flat and nested keyed files, only the values for a single key
> +can be written at a time.  For nested keyed files, the sub key pairs
> +may be specified in any order and not all pairs have to be specified.
> +
> +
> +5-3-2. Control Knobs
> +
> +- Settings for a single feature should generally be implemented in a
> +  single file.
> +
> +- In general, the root cgroup should be exempt from resource control
> +  and thus shouldn't have resource control knobs.
> +
> +- If a controller implements ratio based resource distribution, the
> +  control knob should be named "weight" and have the range [1, 10000]
> +  and 100 should be the default value.  The values are chosen to allow
> +  enough and symmetric bias in both directions while keeping it
> +  intuitive (the default is 100%).
> +
> +- If a controller implements an absolute resource guarantee and/or
> +  limit, the control knobs should be named "min" and "max"
> +  respectively.  If a controller implements best effort resource
> +  gurantee and/or limit, the control knobs should be named "low" and
> +  "high" respectively.
> +
> +  In the above four control files, the special token "max" should be
> +  used to represent upward infinity for both reading and writing.
> +
so, for memory controller, we'll have

(in alphabet order)
memory.failcnt
memory.force_empty  (<= should this be removed ?)
memory.kmem.failcnt
memory.kmem.max
memory.kmem.max_usage
memory.kmem.slabinfo
memory.kmem.tcp.failcnt
memory.kmem.tcp.max
memory.kmem.tcp.max_usage
memory.kmem.tcp.usage
memory.kmem.usage
memory.max
memory.max_usage
memory.move_charge_at_immigrate
memory.numa_stat
memory.oom_control
memory.pressure_level
memory.high
memory.swapiness
memory.usage
memory.use_hierarchy (<= removed)

?
-Kame
