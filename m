From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Tue, 3 Dec 2013 22:34:49 -0500
Message-ID: <20131204033449.GX3556@cmpxchg.org>
References: <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
 <20131118154115.GA3556@cmpxchg.org>
 <20131118165110.GE32623@dhcp22.suse.cz>
 <20131122165100.GN3556@cmpxchg.org>
 <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com>
 <20131127163435.GA3556@cmpxchg.org>
 <20131202200221.GC5524@dhcp22.suse.cz>
 <20131202212500.GN22729@cmpxchg.org>
 <20131203120454.GA12758@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=3NixDbBheEvgjbgxVPL/4ezUFiFjCr8OqYjDVprdfF8=;
	b=nwt2VU1oegKnVBNr2vebceeIj5X7LsL0dqP2sJY22j8slJJdDrYxIKPEtNmtfchEe5yldB3aqWtKi69YLqSRR/8VLKtLHqpdRvO29qlzkOMC8bnmmfHeujSXREqMGSO5HJKV99dDjcS9nznRu+LaBwJhGeSUGcU/F3MEL9uS8dw=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Tue, Dec 03, 2013 at 03:50:41PM -0800, David Rientjes wrote:
> On Tue, 3 Dec 2013, Michal Hocko wrote:
> 
> > OK, as it seems that the notification part is too controversial, how
> > would you like the following? It reverts the notification part and still
> > solves the fault on exit path. I will prepare the full patch with the
> > changelog if this looks reasonable:
> 
> Um, no, that's not satisfactory because it obviously does the check after 
> mem_cgroup_oom_notify().  There is absolutely no reason why userspace 
> should be woken up when current simply needs access to memory reserves to 
> exit.  You can already get such notification by memory thresholds at the 
> memcg limit.
> 
> I'll repeat: Section 10 of Documentation/cgroups/memory.txt specifies what 
> userspace should do when waking up; one of those options is not "check if 
> the memcg is still actually oom in a short period of time once a charging 
> task with a pending SIGKILL or in the exit path has been able to exit."  
> Users of this interface typically also disable the memcg oom killer 
> through the same file, it's ludicrous to put the responsibility on 
> userspace to determine if the wakeup is actionable and requires it to 
> intervene in one of the methods listed in section 10.

Kind of a bummer that you haven't read anything I wrote...

But here is a patch that defers wakeups until we know for sure that
userspace action is required:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f1a0ae6..cc6adac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2254,8 +2254,17 @@ bool mem_cgroup_oom_synchronize(bool handle)
 
 	locked = mem_cgroup_oom_trylock(memcg);
 
+#if 0
+	/*
+	 * XXX: An unrelated task in the group might exit at any time,
+	 * making the OOM kill unnecessary.  We don't want to wake up
+	 * the userspace handler unless we are certain it needs to
+	 * intervene, so disable notifications until we solve the
+	 * halting problem.
+	 */
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
+#endif
 
 	if (locked && !memcg->oom_kill_disable) {
 		mem_cgroup_unmark_under_oom(memcg);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
