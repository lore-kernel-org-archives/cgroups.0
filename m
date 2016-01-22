From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: PROBLEM: BUG when using memory.kmem.limit_in_bytes
Date: Fri, 22 Jan 2016 09:48:54 -0500
Message-ID: <20160122144854.GA14432@cmpxchg.org>
References: <CAKB58ikDkzc8REt31WBkD99+hxNzjK4+FBmhkgS+NVrC9vjMSg@mail.gmail.com>
 <20160122135042.GF26192@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160122135042.GF26192@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Brian Christiansen <brian.o.christiansen@gmail.com>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri, Jan 22, 2016 at 04:50:42PM +0300, Vladimir Davydov wrote:
> From first glance, it looks like the bug was triggered, because
> mem_cgroup_css_offline was run for a child cgroup earlier than for its
> parent. This couldn't happen for sure before the cgroup was switched to
> percpu_ref, because cgroup_destroy_wq has always had max_active == 1.
> Now, however, it looks like this is perfectly possible for
> css_killed_ref_fn is called from an rcu callback - see kill_css ->
> percpu_ref_kill_and_confirm. This breaks kmemcg assumptions.
> 
> I'll take a look what can be done about that.

It's an acknowledged problem in the cgroup core then, and not an issue
with kmemcg. Tejun sent a fix to correct the offlining order here:

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1056544.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
