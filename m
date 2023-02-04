From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 2/2] cgroup/cpuset: Don't update tasks' cpumasks for
 cpu offline events
Date: Sat, 4 Feb 2023 10:40:28 +0100
Message-ID: <Y94oDD/8PDGqNLTH@hirez.programming.kicks-ass.net>
References: <20230202143200.128753-1-longman@redhat.com>
 <20230202143200.128753-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NTZ9jPw8WP52KfsFuE2yWYqe1gYLvZrsudm7m6D0hLA=; b=iaOzaaQ0nfwjJY/vgdhOCngjE+
        kGcKMzQGhg3hRO+bSa//sMUGBtSEKmJRUmsXiBfQBRr2snQtNER4Ilnu+Vb/n5rUKhTzIc8HyRwfe
        tWPMJLs245/42xaqzBWiBH8n2ef6gP1/uu2whT71u0wugElh7cm+f1MdrOOjRJ1uTq2zObszcVHQZ
        tBHBmqN9rhK2TEbWMhN8SVUt9gmV+lXAyoUPosHGvdm8UapZtC7ouV9XHKUFBmx6TMRdLa6iG+O5s
        HSYCZMOP6Yt8bud4YGiia5+fBP82MKShAywaHKOtfGMyqSm6CN0ov+464F+mkB42jHNMB7ZhnyMHD
        UD3jBAxA==;
Content-Disposition: inline
In-Reply-To: <20230202143200.128753-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@android.com

On Thu, Feb 02, 2023 at 09:32:00AM -0500, Waiman Long wrote:
> It is a known issue that when a task is in a non-root v1 cpuset, a cpu
> offline event will cause that cpu to be lost from the task's cpumask
> permanently as the cpuset's cpus_allowed mask won't get back that cpu
> when it becomes online again. A possible workaround for this type of
> cpu offline/online sequence is to leave the offline cpu in the task's
> cpumask and do the update only if new cpus are added. It also has the
> benefit of reducing the overhead of a cpu offline event.
> 
> Note that the scheduler is able to ignore the offline cpus and so
> leaving offline cpus in the cpumask won't do any harm.
> 
> Now with v2, only the cpu online events will cause a call to
> hotplug_update_tasks() to update the tasks' cpumasks. For tasks
> in a non-root v1 cpuset, the situation is a bit different. The cpu
> offline event will not cause change to a task's cpumask. Neither does a
> subsequent cpu online event because "cpuset.cpus" had that offline cpu
> removed and its subsequent onlining won't be registered as a change
> to the cpuset. An exception is when all the cpus in the original
> "cpuset.cpus" have gone offline once. In that case, "cpuset.cpus" will
> become empty which will force task migration to its parent. A task's
> cpumask will also be changed if set_cpus_allowed_ptr() is somehow called
> for whatever reason.
> 
> Of course, this patch can cause a discrepancy between v1's "cpuset.cpus"
> and and its tasks' cpumasks. Howver, it can also largely work around
> the offline cpu losing problem with v1 cpuset.

I don't thikn you can simply not update on offline, even if
effective_cpus doesn't go empty, because the intersection between
task_cpu_possible_mask() and effective_cpus might have gone empty.

Very fundamentally, the introduction of task_cpu_possible_mask() means
that you now *HAVE* to always consider affinity settings per-task, you
cannot group them anymore.


