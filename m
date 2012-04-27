From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 0/7 v2] memcg: prevent failure in pre_destroy()
Date: Fri, 27 Apr 2012 14:45:30 +0900
Message-ID: <4F9A327A.6050409@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This is a v2 patch for preventing failure in memcg->pre_destroy().
With this patch, ->pre_destroy() will never return error code and
users will not see warning at rmdir(). And this work will simplify
memcg->pre_destroy(), largely.

This patch is based on linux-next + hugetlb memory control patches.

I post this as RFC because I'll have vacation in the next week and
hugetlb patches are not visible in linux-next yet.
So, I'm not in hurry. Please review when you have time.

I'll rebase this onto memcg-devel in the next post.
== BTW, memory cgroup's github is here == 
git://github.com/mstsxfx/memcg-devel.git

Since v1, Whole patch designs are changed. In this version, I didn't
remove ->pre_destroy() but make it succeed always. There are no
asynchronous operation and no big patches. But this introduces
2 changes to cgroup core.

After this series, if use_hierarchy==0, all resources will be moved
to root cgroup at rmdir() or force_empty().

Brief patch conents are

0001 : my version of compile-fix for linux-next, Aneesh will post his own version.
0002 : fix error code in hugetlb_force_memcg_empty
0003 : add res_counter_uncharge_until()
0004 : use res_counter_uncharge_until() at move_parent()
0005 : move charges to root cgroup at rmdir, if use_hierarchy=0
0006 : clean up mem_cgroup_move_account()
0007 : cgroup : avoid attaching task to cgroup where ->pre_destroy() is running.
0008 : cgroup : avoid creating a new cgroup under a cgroup where ->pre_destroy() is running.
0009 : remove -EINTR from memcg->pre_destroy().

Thanks,
-Kame
