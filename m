From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2 11/29] cgroups: ability to stop res charge propagation
 on bounded ancestor
Date: Tue, 15 May 2012 11:59:45 +0900
Message-ID: <4FB1C6A1.1020602@jp.fujitsu.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-12-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1336758272-24284-12-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>, Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

(2012/05/12 2:44), Glauber Costa wrote:

> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Moving a task from a cgroup to another may require to substract its
> resource charge from the old cgroup and add it to the new one.
> 
> For this to happen, the uncharge/charge propagation can just stop when we
> reach the common ancestor for the two cgroups.  Further the performance
> reasons, we also want to avoid to temporarily overload the common
> ancestors with a non-accurate resource counter usage if we charge first
> the new cgroup and uncharge the old one thereafter.  This is going to be a
> requirement for the coming max number of task subsystem.
> 
> To solve this, provide a pair of new API that can charge/uncharge a
> resource counter until we reach a given ancestor.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Paul Menage <paul@paulmenage.org>
> Acked-by: Glauber Costa <glommer@parallels.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Tim Hockin <thockin@hockin.org>
> Cc: Tejun Heo <htejun@gmail.com>
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


Where is this function called in this series ?

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
