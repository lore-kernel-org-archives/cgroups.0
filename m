From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Date: Wed, 30 May 2012 15:11:01 +0200
Message-ID: <20120530131059.GE25094@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
 <20120530123406.GC25094@somewhere.redhat.com>
 <4FC614CF.5000906@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1r+5oBr+buId+pwuIZBXIzqZq9k3H12NR7Kgrt9h5Dw=;
        b=ixrebmwudcK3abdsbGl6n5SCyZ2TQESsNABHd9u7jhedfTzs0UqfpgSN5aW9IbaXwi
         WZD4nR8Mo/fDQTWiv0KNK1LTmQRo0Aap10O4OLcBE+QLYOPCLJfePyJSlIvCxFv33YOb
         8lZUfFpoNmMc0WZAvFg+1iZZcdb4KDhQoInRfIBBBiEXRvv2Y+CFBbI4rPNtdZyCXHPf
         c3filorRf2LHjcrH9lKsQHAHPoVpgWcDCvHRVxTzt+YbAvEszar5c7YyxbejYwndCxrV
         VTlpz2odEYTvc6d4G10AN4enDqm4vQQ7x9NsX///qJA43rAAguPGOk0vrwGzMew9UFn0
         s2Pg==
Content-Disposition: inline
In-Reply-To: <4FC614CF.5000906-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Wed, May 30, 2012 at 04:38:39PM +0400, Glauber Costa wrote:
> On 05/30/2012 04:34 PM, Frederic Weisbecker wrote:
> >On Fri, May 25, 2012 at 05:03:36PM +0400, Glauber Costa wrote:
> >>+bool __mem_cgroup_new_kmem_page(struct page *page, gfp_t gfp)
> >>+{
> >>+	struct mem_cgroup *memcg;
> >>+	struct page_cgroup *pc;
> >>+	bool ret = true;
> >>+	size_t size;
> >>+	struct task_struct *p;
> >>+
> >>+	if (!current->mm || in_interrupt())
> >>+		return true;
> >>+
> >>+	rcu_read_lock();
> >>+	p = rcu_dereference(current->mm->owner);
> >>+	memcg = mem_cgroup_from_task(p);
> >
> >So this takes the memcg of the group owner rather than the
> >task? I understand why we want this for user memory, but for
> >kernel?
> 
> That was already discussed when this first came up in my last submission
> If I recall correctly, Kame pointed out that this would be needed
> for proper OOM-scoring and killing.

Can we have at least a comment in the code that explain the reasons of taking the
owner rather than the task? It's not going to be very obvious to future reviewers.

> Now of course we won't oom kernel threads or anything like that.

Seems we are not even accounting them anyway.

> But since this is also accounted towards memcg, it should at least be
> consistent with each memcg it accounts to.
> 
> We can't account kmem for the thread's memcg, and mem to the process'.

Don't know. This goes a bit against cgroups semantics which group at the task
level and not process. But I personally don't mind much, as long as it's
documented.
