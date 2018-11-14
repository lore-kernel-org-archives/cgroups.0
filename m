From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH cgroup/for-4.21 1/2] cpuset: Minor cgroup2 interface
 updates
Date: Tue, 13 Nov 2018 18:09:38 -0800
Message-ID: <adc9e840-0fe9-343e-6e0e-b878287016c5@redhat.com>
References: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/13/2018 12:13 PM, Tejun Heo wrote:
> From b1e3aeb11c5e86ee0988a038c4e7682d6beaa977 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 13 Nov 2018 12:03:33 -0800
>
> * Rename the partition file from "cpuset.sched.partition" to
>   "cpuset.cpus.partition".
>
> * When writing to the partition file, drop "0" and "1" and only accept
>   "member" and "root".
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Waiman Long <longman@redhat.com>
> ---
> Two minor cpuset interface followup patches.  Applying to
> cgroup/for-4.21.
>
> Thanks.
>
>  Documentation/admin-guide/cgroup-v2.rst | 6 +++---
>  kernel/cgroup/cpuset.c                  | 8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index f83a5231bbe3..07e06136a550 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1708,15 +1708,15 @@ Cpuset Interface Files
>  
>  	Its value will be affected by memory nodes hotplug events.
>  
> -  cpuset.sched.partition
> +  cpuset.cpus.partition
>  	A read-write single value file which exists on non-root
>  	cpuset-enabled cgroups.  This flag is owned by the parent cgroup
>  	and is not delegatable.
>  
>          It accepts only the following input values when written to.
>  
> -        "root" or "1"   - a paritition root
> -        "member" or "0" - a non-root member of a partition
> +        "root"   - a paritition root
> +        "member" - a non-root member of a partition
>  
>  	When set to be a partition root, the current cgroup is the
>  	root of a new partition or scheduling domain that comprises
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b897314bab53..1151e93d71b6 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2468,11 +2468,11 @@ static ssize_t sched_partition_write(struct kernfs_open_file *of, char *buf,
>  	buf = strstrip(buf);
>  
>  	/*
> -	 * Convert "root"/"1" to 1, and convert "member"/"0" to 0.
> +	 * Convert "root" to ENABLED, and convert "member" to DISABLED.
>  	 */
> -	if (!strcmp(buf, "root") || !strcmp(buf, "1"))
> +	if (!strcmp(buf, "root"))
>  		val = PRS_ENABLED;
> -	else if (!strcmp(buf, "member") || !strcmp(buf, "0"))
> +	else if (!strcmp(buf, "member"))
>  		val = PRS_DISABLED;
>  	else
>  		return -EINVAL;
> @@ -2631,7 +2631,7 @@ static struct cftype dfl_files[] = {
>  	},
>  
>  	{
> -		.name = "sched.partition",
> +		.name = "cpus.partition",
>  		.seq_show = sched_partition_show,
>  		.write = sched_partition_write,
>  		.private = FILE_PARTITION_ROOT,

I am fine with both of your patches.

Acked-by: Waiman Long <longman@redhat.com>

