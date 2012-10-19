From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Fri, 19 Oct 2012 17:33:18 +0800
Message-ID: <50811E5E.1090205@huawei.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz> <1350480648-10905-5-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1350480648-10905-5-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>

On 2012/10/17 21:30, Michal Hocko wrote:
> Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
> safely move on and forbit all the callbacks to fail. The last missing
> piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
> that css_tryget fails so no new charges for the memcg can happen.

> The callbacks are also called from within cgroup_lock to guarantee that
> no new tasks show up. 

I'm afraid this won't work. See commit 3fa59dfbc3b223f02c26593be69ce6fc9a940405
("cgroup: fix potential deadlock in pre_destroy")

> We could theoretically call them outside of the
> lock but then we have to move after CGRP_REMOVED flag is set.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  kernel/cgroup.c |   30 +++++++++---------------------
>  1 file changed, 9 insertions(+), 21 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
