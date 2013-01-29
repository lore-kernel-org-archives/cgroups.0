From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH v2 6/6] memcg: init/free swap cgroup strucutres upon create/free
 child memcg
Date: Tue, 29 Jan 2013 18:27:38 +0800
Message-ID: <5107A41A.5080502@oracle.com>
References: <510658FC.50009@oracle.com> <51079D7C.8030400@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51079D7C.8030400@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Lord Glauber Costa of Sealand <glommer@parallels.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org

On 01/29/2013 05:59 PM, Lord Glauber Costa of Sealand wrote:
> On 01/28/2013 02:54 PM, Jeff Liu wrote:
>>  static void free_rcu(struct rcu_head *rcu_head)
>> @@ -6116,6 +6117,8 @@ mem_cgroup_css_alloc(struct cgroup *cont)
>>  			INIT_WORK(&stock->work, drain_local_stock);
>>  		}
>>  	} else {
>> +		if (swap_cgroup_init())
>> +			goto free_out;
>>  		parent = mem_cgroup_from_cont(cont->parent);
>>  		memcg->use_hierarchy = parent->use_hierarchy;
>>  		memcg->oom_kill_disable = parent->oom_kill_disable;
> Be aware that this will conflict with latest -mm where those were moved
> to css_online().
Thanks for the kind reminder, will work out the next round posts based
on latest -mm or Michal's.

-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
