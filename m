From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10 03/35] dcache: convert dentry_stat.nr_unused to
 per-cpu counters
Date: Thu, 6 Jun 2013 15:25:46 -0700
Message-ID: <20130606152546.52f614d852da32d28a0b460f@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-4-git-send-email-glommer@openvz.org>
	<20130605160731.91a5cd3ff700367f5e155d83@linux-foundation.org>
	<20130606014509.GN29338@dastard>
	<20130605194801.f9b25abf.akpm@linux-foundation.org>
	<51B0834A.8020606@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51B0834A.8020606@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On Thu, 6 Jun 2013 16:40:42 +0400 Glauber Costa <glommer@parallels.com> wrote:

> +/*
> + * Here we resort to our own counters instead of using generic per-cpu counters
> + * for consistency with what the vfs inode code does. We are expected to harvest
> + * better code and performance by having our own specialized counters.
> + *
> + * Please note that the loop is done over all possible CPUs, not over all online
> + * CPUs. The reason for this is that we don't want to play games with CPUs going
> + * on and off. If one of them goes off, we will just keep their counters.
> + *
> + * glommer: See cffbc8a for details, and if you ever intend to change this,
> + * please update all vfs counters to match.

Handling CPU hotplug is really quite simple - see lib/percpu_counter.c

(I can't imagine why percpu_counter_hotcpu_callback() sums all the
counters - all it needs to do is to spill hcpu's counter into current's
counter).

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
