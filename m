From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 4/5] cpuset: Restrict load balancing off cpus to
 subset of cpus.isolated
Date: Tue, 1 May 2018 12:51:48 -0700
Message-ID: <20180501195148.GC2368884@devbig577.frc2.facebook.com>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
 <1524145624-23655-5-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oXhQ6JJaPGDHGmHZichdHB9Ey33nTB4yn1y2HibhGBU=;
        b=Ow/TJ58DR5HsKshg+1IT3tQXgYAk4yXNVIv2OgBZLcrp+8y7R2uTgXl9FmeAhmGSte
         VfQ0g92cTt6i4IJeH66ZNSRFTQa8Y2at+PQfz+8ncfzWSuw36TrjvJO+bmFinLQG2UJI
         H+iZJVddvb10dzu9YKmER06WJUQiZYBT+KYeIsLK4pEfrwx6ztM02Z6mpHa1WcifOQrx
         hhwKaG6Az3LplrNUBLFpHnk5aMYWo/eOjeeP59n4R4edzc8YKCZieDUnAqDQaPWdtrQy
         iMbhLlWt9ZR283pzU4DeGMzWBoyI77AbPo6AjzkPKVcA9RApYJG/0BeGyVBSmJi3b1Ba
         IlOA==
Content-Disposition: inline
In-Reply-To: <1524145624-23655-5-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

Hello, Waiman.

Sorry about the delay.

On Thu, Apr 19, 2018 at 09:47:03AM -0400, Waiman Long wrote:
> With the addition of "cpuset.cpus.isolated", it makes sense to add the
> restriction that load balancing can only be turned off if the CPUs in
> the isolated cpuset are subset of "cpuset.cpus.isolated".
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  Documentation/cgroup-v2.txt |  7 ++++---
>  kernel/cgroup/cpuset.c      | 29 ++++++++++++++++++++++++++---
>  2 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index 8d89dc2..c4227ee 100644
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -1554,9 +1554,10 @@ Cpuset Interface Files
>  	and will not be moved to other CPUs.
>  
>  	This flag is hierarchical and is inherited by child cpusets. It
> -	can be turned off only when the CPUs in this cpuset aren't
> -	listed in the cpuset.cpus of other sibling cgroups, and all
> -	the child cpusets, if present, have this flag turned off.
> +	can be explicitly turned off only when it is a direct child of
> +	the root cgroup and the CPUs in this cpuset are subset of the
> +	root's "cpuset.cpus.isolated".	Moreover, the CPUs cannot be
> +	listed in the "cpuset.cpus" of other sibling cgroups.

It is a little bit convoluted that the isolation requires coordination
among root's isolated file and the first-level children's cpus file
and the flag.  Maybe I'm missing something but can't we do something
like the following?

* Add isolated flag file, which can only be modified on empty (in
  terms of cpus) first level children.

* Once isolated flag is set, CPUs can only be added to the cpus file
  iff they aren't being used by anyone else and automatically become
  isolated.

The first level cpus file is owned by the root cgroup anyway, so
there's no danger regarding delegation or whatever and the interface
would be a lot simpler.

Thanks.

-- 
tejun
