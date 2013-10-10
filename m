From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 0/7] improve memcg oom killer robustness v2
Date: Wed, 9 Oct 2013 20:14:22 -0400
Message-ID: <20131010001422.GB856@cmpxchg.org>
References: <20130917141013.GA30838@dhcp22.suse.cz>
 <20130918160304.6EDF2729@pobox.sk>
 <20130918180455.GD856@cmpxchg.org>
 <20130918181946.GE856@cmpxchg.org>
 <20130918195504.GF856@cmpxchg.org>
 <20130926185459.E5D2987F@pobox.sk>
 <20130926192743.GP856@cmpxchg.org>
 <20131007130149.5F5482D8@pobox.sk>
 <20131007192336.GU856@cmpxchg.org>
 <20131009204450.6AB97915@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=7eydHiNifFRAcD0gf1hyW+mmdnEK0IqaYkVe9WNt1bs=;
	b=ZY/Bslfq9aVBHW9Y/IxT9b6bMQ/jqioeXDSVgvXTLaxju5ZsIHJQy7zB023mEEDQS5iosbZodlfdPVPPCoVdKc8U5Vuy6bN22GknVCd76MK0UwzfqKgQsiOlNGPUMhNZxLlzj29qd+MpP6pChVsJ6qVEkVyH4pIyr53+UBbVbCc=;
Content-Disposition: inline
In-Reply-To: <20131009204450.6AB97915-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi azur,

On Wed, Oct 09, 2013 at 08:44:50PM +0200, azurIt wrote:
> Joahnnes,
> 
> i'm very sorry to say it but today something strange happened.. :) i was just right at the computer so i noticed it almost immediately but i don't have much info. Server stoped to respond from the net but i was already logged on ssh which was working quite fine (only a little slow). I was able to run commands on shell but i didn't do much because i was afraid that it will goes down for good soon. I noticed few things:
>  - htop was strange because all CPUs were doing nothing (totally nothing)
>  - there were enough of free memory
>  - server load was about 90 and was raising slowly
>  - i didn't see ANY process in 'run' state
>  - i also didn't see any process with strange behavior (taking much CPU, memory or so) so it wasn't obvious what to do to fix it
>  - i started to kill Apache processes, everytime i killed some, CPUs did some work, but it wasn't fixing the problem
>  - finally i did 'skill -kill apache2' in shell and everything started to work
>  - server monitoring wasn't sending any data so i have no graphs
>  - nothing interesting in logs
> 
> I will send more info when i get some.

Somebody else reported a problem on the upstream patches as well.  Any
chance you can confirm the stacks of the active but not running tasks?

It sounds like they are stuck on a waitqueue, the question is which
one.  I forgot to disable OOM for __GFP_NOFAIL allocations, so they
could succeed and leak an OOM context.  task structs are not
reinitialized between alloc & free so a different task could later try
to oom trylock a memcg that has been freed, fail, and wait
indefinitely on the OOM waitqueue.  There might be a simpler
explanation but I can't think of anything right now.

But the OOM context is definitely being leaked, so please apply the
following for your next reboot:

---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5aee2fa..83ad39b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2341,6 +2341,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	 */
 	if (!*ptr && !mm)
 		goto bypass;
+
+	if (gfp_mask & __GFP_NOFAIL)
+		oom = false;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
-- 
1.8.4
