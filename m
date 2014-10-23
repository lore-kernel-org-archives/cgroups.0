From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: Fix NULL pointer deref in task_in_mem_cgroup()
Date: Thu, 23 Oct 2014 14:19:29 -0400
Message-ID: <20141023181929.GB15937@phnom.home.cmpxchg.org>
References: <1414082865-4091-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1414082865-4091-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu, Oct 23, 2014 at 06:47:45PM +0200, Jan Kara wrote:
> 'curr' pointer in task_in_mem_cgroup() can be NULL when we race with
> somebody clearing task->mm. Check for it before dereferencing the
> pointer.

If task->mm is already NULL, we fall back to mem_cgroup_from_task(),
which definitely returns a memcg unless you pass NULL in there.  So I
don't see how that could happen, and the NULL checks in the fallback
branch as well as in __mem_cgroup_same_or_subtree seem bogus to me.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
