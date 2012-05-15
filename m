From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v3 1/6] memcg: fix error code in hugetlb_force_memcg_empty()
Date: Tue, 15 May 2012 10:10:34 +0900
Message-ID: <4FB1AD0A.50901@jp.fujitsu.com>
References: <4FACDED0.3020400@jp.fujitsu.com> <4FACDFAE.5050808@jp.fujitsu.com> <20120514181556.GE2366@google.com> <20120514183219.GG2366@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120514183219.GG2366-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

(2012/05/15 3:32), Tejun Heo wrote:

> On Mon, May 14, 2012 at 11:15:56AM -0700, Tejun Heo wrote:
>> On Fri, May 11, 2012 at 06:45:18PM +0900, KAMEZAWA Hiroyuki wrote:
>>> -		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
>>> +		if (cgroup_task_count(cgroup)
>>> +			|| !list_empty(&cgroup->children)) {
>>> +			ret = -EBUSY;
>>>  			goto out;
>>
>> Why break the line?  It doesn't go over 80 col.
> 
> Ooh, it does.  Sorry, my bad.  But still, isn't it more usual to leave
> the operator in the preceding line and align the start of the second
> line with the first?  ie.
> 
> 		if (cgroup_task_count(cgroup) ||
> 		    !list_empty(&cgroup->children)) {
> 


How about this ?
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Fri, 27 Apr 2012 13:19:19 +0900
Subject: [PATCH] memcg: fix error code in hugetlb_force_memcg_empty()

Changelog:
 - clean up.
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/hugetlb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1d3c8ea9..82ec623 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1922,8 +1922,11 @@ int hugetlb_force_memcg_empty(struct cgroup *cgroup)
 	int ret = 0, idx = 0;
 
 	do {
-		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
+		if (cgroup_task_count(cgroup) ||
+		    !list_empty(&cgroup->children)){
+			ret = -EBUSY;
 			goto out;
+		}
 		/*
 		 * If the task doing the cgroup_rmdir got a signal
 		 * we don't really need to loop till the hugetlb resource
-- 
1.7.4.1


