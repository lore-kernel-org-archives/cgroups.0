From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Wed, 20 May 2015 15:21:58 +0200
Message-ID: <20150520132158.GB28678@dhcp22.suse.cz>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
 <1431978595-12176-4-git-send-email-tj@kernel.org>
 <20150519121321.GB6203@dhcp22.suse.cz>
 <20150519212754.GO24861@htj.duckdns.org>
 <20150520131044.GA28678@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150520131044.GA28678@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-mm@kvack.org, Oleg Nesterov <oleg@redhat.com>

On Wed 20-05-15 15:10:44, Michal Hocko wrote:
[...]
> But I am completely lost in the exit code paths. E.g. what happens
> when the thread group leader exits and the other threads are still
> alive? I would expect another thread would be chosen as a new leader and
> siblings would be updated. But I cannot find that code. Maybe the
> original leader just waits for all other threads to terminate and stay
> in the linked lists.

I've tried a simple test where the main thread (group leader) calls
pthread_exit after it creates another thread. The other thread continues
to run and the leader is marked as Zombie:
$ ./t &
Main pid:2432 tid:2432
Exiting main thread
Secondary pid:2432 tid:2433......

$ ps ax | grep 2432
 2432 pts/3    Zl+    0:00 [t] <defunct>

So I assume the leader simply waits for its threads to finish and it
stays in the sibling list. __unhash_process seems like it does the final
cleanup and unlinks the leader from the lists. Which means that
mm_update_next_owner never sees !group_leader. Is that correct Oleg?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
