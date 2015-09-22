From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: make mem_cgroup_read_stat() unsigned
Date: Tue, 22 Sep 2015 15:24:23 -0700
Message-ID: <20150922152423.5751d932aebfe12cdd40a618@linux-foundation.org>
References: <1442960192-83405-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442960192-83405-1-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 22 Sep 2015 15:16:32 -0700 Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> mem_cgroup_read_stat() returns a page count by summing per cpu page
> counters.  The summing is racy wrt. updates, so a transient negative sum
> is possible.  Callers don't want negative values:
> - mem_cgroup_wb_stats() doesn't want negative nr_dirty or nr_writeback.
> - oom reports and memory.stat shouldn't show confusing negative usage.
> - tree_usage() already avoids negatives.
> 
> Avoid returning negative page counts from mem_cgroup_read_stat() and
> convert it to unsigned.

Someone please remind me why this code doesn't use the existing
percpu_counter library which solved this problem years ago.

>  	for_each_possible_cpu(cpu)

and which doesn't iterate across offlined CPUs.

