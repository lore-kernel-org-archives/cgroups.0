From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
Date: Fri, 11 May 2012 18:41:36 +0900
Message-ID: <4FACDED0.3020400@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi, here is v3 based on memcg-devel tree.
git://github.com/mstsxfx/memcg-devel.git

This patch series is for avoiding -ENOMEM at calling pre_destroy() 
which is called at rmdir(). After this patch, charges will be moved
to root (if use_hierarchy==0) or parent (if use_hierarchy==1), and
we'll not see -ENOMEM in rmdir() of cgroup.

v2 included some other patches than ones for handling -ENOMEM problem,
but I divided it. I'd like to post others in different series, later.
No logical changes in general, maybe v3 is cleaner than v2.

0001 ....fix error code in memcg-hugetlb
0002 ....add res_counter_uncharge_until
0003 ....use res_counter_uncharge_until in memcg
0004 ....move charges to root is use_hierarchy==0
0005 ....cleanup for mem_cgroup_move_account()
0006 ....remove warning of res_counter_uncharge_nofail (from Costa's slub accounting series).

Regards,
-Kame
