From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: strange oom behaviour on 3.10
Date: Wed, 9 Oct 2013 20:24:12 -0400
Message-ID: <20131010002412.GC856@cmpxchg.org>
References: <CAJ75kXYqNfWejMhykEqmby4Yvs1w+Tv+QxKHZF67j77HJnco5A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=GJ+INu1k27skg0wxro+NUDGi2lYzTPFu9ybi0IUFTl4=;
	b=nRIyYzqdVQAKhmDMU1EZBkl7QRI8Cu76MINY7jkdTQNLFE0v6lhngdGcwzjaBw/ad2EV+gO5RBxxPNXkJz3+uJrXRsNtExNeMDLPXnmD9ZL8wYzU9ug2/ILMnSniPUAVdIZCzWXBzfJnd80Q1was0hEOkQDmTkqYGnTb+XhbWiM=;
Content-Disposition: inline
In-Reply-To: <CAJ75kXYqNfWejMhykEqmby4Yvs1w+Tv+QxKHZF67j77HJnco5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi William,

On Wed, Oct 09, 2013 at 05:54:20PM +0200, William Dauchy wrote:
> Hi,
> 
> I have been through a strange issue with cgroups on v3.10.x.
> The oom is triggered for a cgroups wich has reached the memory limit.
> I'm getting several:
> 
> Task in /lxc/VM_A killed as a result of limit of /lxc/VM_A
> memory: usage 262144kB, limit 262144kB, failcnt 44742
> 
> which is quite normal.
> The last one is:
> Task in / killed as a result of limit of /lxc/VM_A
> memory: usage 128420kB, limit 262144kB, failcnt 44749
> 
> Why do I have a oom kill is this case since the memory usage is ok?

I suspect a task's OOM context is set up but not handled, so later on
when another task triggers an OOM the OOM killer is invoked on
whatever memcg that OOM context was pointing to.

> Why is it choosing a task in / instead of in /lxc/VM_A?

The memcg in the OOM context could have been freed and corrupted at
that point.

Can you try this patch on top of what you have right now?

---
 mm/memcontrol.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ba3051a..d60f560 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2706,6 +2706,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	if (unlikely(task_in_memcg_oom(current)))
 		goto bypass;
 
+	if (gfp_mask & __GFP_NOFAIL)
+		oom = false;
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
@@ -2803,10 +2806,10 @@ done:
 	*ptr = memcg;
 	return 0;
 nomem:
-	*ptr = NULL;
-	if (gfp_mask & __GFP_NOFAIL)
-		return 0;
-	return -ENOMEM;
+	if (!(gfp_mask & __GFP_NOFAIL)) {
+		*ptr = NULL;
+		return -ENOMEM;
+	}
 bypass:
 	*ptr = root_mem_cgroup;
 	return -EINTR;
-- 
1.8.4
