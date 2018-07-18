From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Wed, 18 Jul 2018 11:21:18 -0400
Message-ID: <a1eb4971-ff23-6fd8-d75b-112d63f0aee9@redhat.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <4cf9924e-7b97-187f-a1f5-853a45165abb@redhat.com>
 <151fc655-7e29-f060-789e-ee6c5c23d132@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <151fc655-7e29-f060-789e-ee6c5c23d132@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/10/2018 11:23 AM, Waiman Long wrote:
> On 07/06/2018 04:32 PM, Waiman Long wrote:
>> On 07/03/2018 11:58 AM, Tejun Heo wrote:
>>> Hello, Waiman.
>>>
>>> On Tue, Jul 03, 2018 at 08:41:31AM +0800, Waiman Long wrote:
>>>>> So, effective changing when enabling partition on a child feels wrong
>>>>> to me.  It's supposed to contain what's actually allowed to the cgroup
>>>>> from its parent and that shouldn't change regardless of how those
>>>>> resources are used.  It's still given to the cgroup from its parent.
>>>> Another way to work around this issue is to expose the reserved_cpus in
>>>> the parent for holding CPUs that can taken by a chid partition. That
>>>> will require adding one more cpuset file for those cgroups that are
>>>> partition roots.
>>> Yeah, that should work.
>>>
>> Thinking about it a bit more, that approach will make creating a
>> partition a multi-step process:
>>
>> 1) Reserve the CPUs in reserved_cpus.
>> 2) enable sched.partition
>> 3) Write the CPUs list into cpus.
>>
>> There are also more exception cases that need to be handled. The current
>> approach, on the other hands, is much simpler and easier to understand
>> and use.
>>
>>>> I don't mind restricting that to the first level children for now. That
>>>> does restrict where we can put the container root if we want a separate
>>>> partition for a container. Let's hear if others have any objection about
>>>> that.
>>> As currently implemented, partioning locks away the cpus which should
>>> be a system level decision, not container level, so it makes sense to
>>> me that it is only available to system root.
>> So my preference is to allow partition only on the first level children
>> of the root for the time being. I think it should cover most of the use
>> cases. I will update the patchset to reflect that.
>>
>> Cheers,
>> Longman
>>
> Below is the incremental patch that allow partitioning only on the first
> level children of the root. Please let me know your thourght on that.
>
> Thanks,
> Longman
>
> -------------[ Cut here ]-------------------------
>
> From 5a41209da94385efff87d79f6523265c710cbea5 Mon Sep 17 00:00:00 2001
> From: Waiman Long <longman@redhat.com>
> Date: Tue, 10 Jul 2018 10:23:16 -0400
> Subject: [PATCH v11 10/10] cpuset: Restrict sched.partition to first level
>  children of root only
>
> Enabling partition on a v2 cpuset has the side effect of affecting the
> effective CPUs of its parent which is currently unique to partitioning.
> As we are not sure about the repercussion of enabling that globally,
> we are now restricting the enabling of sched.partition to the first
> level children of the root cgroup in the default hierarchy.
>
> This is done by removing the "cpuset.sched.partition" control file
> on cgroups that are not the first level children of the root. A new
> show_cfile function pointer is added to the cftype structure. If it
> is defined, it will be called to return a boolean value to determine
> if the corresponding control file should show up in the cgroup. It
> provides a more flexible mechanism to determine the visibility of the
> control file than a simple CFTYPE_* flag can do.
>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 10 +++++-----
>  include/linux/cgroup-defs.h             |  9 +++++++++
>  kernel/cgroup/cgroup.c                  |  4 ++++
>  kernel/cgroup/cpuset.c                  | 10 ++++++++++
>  4 files changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst
> b/Documentation/admin-guide/cgroup-v2.rst
> index f7cde15..cf7cd88 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1585,10 +1585,10 @@ Cpuset Interface Files
>      Its value will be affected by memory nodes hotplug events.
>  
>    cpuset.sched.partition
> -    A read-write single value file which exists on non-root
> -    cpuset-enabled cgroups.  It is a binary value flag that accepts
> -    either "0" (off) or "1" (on).  This flag is set and owned by the
> -        parent cgroup.
> +    A read-write single value file which exists on the first level
> +    children of the root cgroup.  It is a binary value flag that
> +    accepts either "0" (off) or "1" (on).  This flag is set and
> +    owned by the parent cgroup.
>  
>      If set, it indicates that the current cgroup is the root of a
>      new partition or scheduling domain that comprises itself and
> @@ -1603,7 +1603,7 @@ Cpuset Interface Files
>         exclusive, i.e. they are not shared by any of its siblings.
>      2) The "cpuset.cpus" is also a proper subset of the parent's
>         "cpuset.cpus.effective".
> -    3) The parent cgroup is a partition root.
> +    3) The parent cgroup is the root cgroup.
>      4) There is no child cgroups with cpuset enabled.  This is for
>         eliminating corner cases that have to be handled if such a
>         condition is allowed.
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index c0e68f9..be79487 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -565,6 +565,15 @@ struct cftype {
>      ssize_t (*write)(struct kernfs_open_file *of,
>               char *buf, size_t nbytes, loff_t off);
>  
> +    /*
> +     * show_cfile(), if defined, will return a boolean value to
> +     * determine if the control file should show up in the cgroup.
> +     * It provides more flexibility in deciding where the control
> +     * file should appear than simple criteria like on-root or
> +     * not-on-root.
> +     */
> +    bool (*show_cfile)(struct cgroup_subsys_state *css);
> +
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>      struct lock_class_key    lockdep_key;
>  #endif
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 077370b..0afdab8 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3612,6 +3612,10 @@ static int cgroup_addrm_files(struct
> cgroup_subsys_state *css,
>          if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgroup_parent(cgrp))
>              continue;
>  
> +        /* Should the control file show up in the cgroup */
> +        if (cft->show_cfile && !cft->show_cfile(css))
> +            continue;
> +
>          if (is_add) {
>              ret = cgroup_add_file(css, cgrp, cft);
>              if (ret) {
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 62b7e61..2f85c1e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2106,6 +2106,15 @@ static s64 cpuset_read_s64(struct
> cgroup_subsys_state *css, struct cftype *cft)
>  }
>  
>  /*
> + * The sched.partition control file should only show up in the first
> + * level children of the root cgroup.
> + */
> +static bool cpuset_show_partition(struct cgroup_subsys_state *css)
> +{
> +    return parent_cs(css_cs(css)) == &top_cpuset;
> +}
> +
> +/*
>   * for the common functions, 'private' gives the type of file
>   */
>  
> @@ -2250,6 +2259,7 @@ static s64 cpuset_read_s64(struct
> cgroup_subsys_state *css, struct cftype *cft)
>          .name = "sched.partition",
>          .read_u64 = cpuset_read_u64,
>          .write_u64 = cpuset_write_u64,
> +        .show_cfile = cpuset_show_partition,
>          .private = FILE_PARTITION_ROOT,
>          .flags = CFTYPE_NOT_ON_ROOT,
>      },

Tejun,

What do you think about this patch?

Are there any other issues you have with this patchset?

Thanks,
Longman

