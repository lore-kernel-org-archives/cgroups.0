From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v2 1/8] cgroup: convert cgroup_ida to cgroup_idr
Date: Thu, 25 Jul 2013 09:08:59 +0800
Message-ID: <51F07AAB.2040607@huawei.com>
References: <51EFA554.6080801@huawei.com> <51EFA570.5020907@huawei.com> <20130724140702.GD2540@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130724140702.GD2540@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On 2013/7/24 22:07, Michal Hocko wrote:
> On Wed 24-07-13 17:59:12, Li Zefan wrote:
>> This enables us to lookup a cgroup by its id.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks for the review! I'll wait a couple of days for other comments,
and then update the patchset.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
