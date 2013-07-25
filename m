From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v2 0/8] memcg, cgroup: kill css_id
Date: Thu, 25 Jul 2013 08:59:15 +0800
Message-ID: <51F07863.2070705@huawei.com>
References: <51EFA554.6080801@huawei.com> <20130724143214.GL2540@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130724143214.GL2540@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On 2013/7/24 22:32, Michal Hocko wrote:
> On Wed 24-07-13 17:58:44, Li Zefan wrote:
>> This patchset converts memcg to use cgroup->id, and then we can remove
>> cgroup css_id.
>>
>> As we've removed memcg's own refcnt, converting memcg to use cgroup->id
>> is very straight-forward.
>>
>> The patchset is based on Tejun's cgroup tree.
> 
> Does it depend on any particular patches? I am asking because I would
> need to cherry pick those and apply them into my -mm git tree before
> these.
> 

Nope, but you should see a few but small conflicts if you apply them to
your git tree.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
