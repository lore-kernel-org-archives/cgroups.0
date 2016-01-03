From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: fix cpus_allowed mask for offline/online CPUs
Date: Sun, 3 Jan 2016 08:59:11 -0500
Message-ID: <20160103135911.GG3660@htj.duckdns.org>
References: <2f805346f87680dddfa9253dc9031db3b6ead8ad.1451648318.git.yu.c.chen@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oKl6UQk9U67zc0jVqP2t8Hn8UJz1MJMX16UyGZ2WC6Q=;
        b=iZzlTEuVk3YG33rHXwoHOGvLT/6yxBs73ZvnJjZi9GP6k93lGJmAdlyxnDP+1nLYhU
         8CJmePPTYPfWs4GeAR6aDD4ATPcCjDMZ+7aPHxqX20ig8JDC3pdr63BpjJYRy2kCXGKR
         SwOYh62iBGk553bRmoVEpmxsmjBgwPesGwkzEzWCoG15MvBhb+w/fxgLTfn8tRKHj682
         B7yWivBupF2jcNnpzBuvNbCDGKhEmsZ91/SkDHxmluIv8owm25O64KuLbnx0xC1K/nzW
         1R78xHnbG/zczdy6scQGs/raO67oi0zMOV15OMmtjbfPTnBid72DLDXCdeS6S85jfPx2
         lbYQ==
Content-Disposition: inline
In-Reply-To: <2f805346f87680dddfa9253dc9031db3b6ead8ad.1451648318.git.yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vishnu Pratap Singh <vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pintu Kumar <pintu.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Fri, Jan 01, 2016 at 08:09:13PM +0800, Chen Yu wrote:
> Commit be4c9dd7aee5 ("cpuset: enable onlined cpu/node in effective masks")
> leverages cpuset's cpus_allowed and its parent's effective_cpus to calculate
> the new_cpus by:
> 
> cpumask_and(&new_cpus, cs->cpus_allowed, parent_cs(cs)->effective_cpus);
> 
> However cpus_allowed will also be updated after the CPU is offline, in
> hotplug_update_tasks_legacy, so when the CPU is online again, it will use
> the old cpus_allowed mask to calculate the new_cpus, thus new_cpus will get
> incorrect value after each round of offline/online.
> 
> This problem is found on ubuntu 15.10 with cpuset mounted:
> 
> 1. echo 0 > /sys/devices/system/cpu/cpu2/online
> 2. echo 1 > /sys/devices/system/cpu/cpu2/online
> 3. cat /sys/fs/cgroup/cpuset/cpuset.cpus
>    0-3
> 4. cat /sys/fs/cgroup/cpuset/user.slice/cpuset.cpus
>    0-1,3
> 5. taskset -c 2 ls
>    taskset: failed to set pid 0's affinity: Invalid argument
> 
> This patch works around this problem by introducing a new
> mask cpumask_var_t cpus_sysfs inside struct cpuset,
> which will only be updated by writing value to sysfs.cpuset.cpus,
> and CPU offline/online will use this mask to set the new cpumask
> for a cpuset.

Li?

-- 
tejun
