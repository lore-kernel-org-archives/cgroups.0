From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Sun, 24 Mar 2013 15:34:51 +0800
Message-ID: <514EAC9B.1010706@huawei.com>
References: <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514C2754.4080701@parallels.com> <20130322094832.GG31457@dhcp22.suse.cz> <514C2C72.5090402@parallels.com> <20130322100609.GI31457@dhcp22.suse.cz> <514C3193.9010609@parallels.com> <20130322105616.GK31457@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130322105616.GK31457@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

>> I read the code as lockdep_assert(memcg_cache_mutex), and then later on
>> mutex_lock(&memcg_mutex). But reading again, that was a just an
>> rcu_read_lock(). Good thing it is Friday
>>
>> You guys can add my Acked-by, and thanks again
> 
> Li, are you ok to take the page via your tree?
> 

I don't have a git tree in kernel.org. It's Tejun that picks up
cgroup patches.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
