From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Date: Wed, 30 May 2012 15:37:39 +0200
Message-ID: <20120530133736.GF25094@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
 <20120530130416.GD25094@somewhere.redhat.com>
 <4FC61B4E.2060206@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mJu/jrwWrf8XqdQfM8AQ0PlHfIGEkFoKXPsnAvpSbE8=;
        b=g4FYTtLsmEPqq1+8DyfeEfwLYODb8FmWtgERfqeUdfHnJUIhMX6bkH8jYuLW4MWHvu
         wi6/Nd/Z/LyQ9/GaHTU8ln5Ivx/WjFtbdRbq8jSVxVcMcTCRz056BpjkafPM8VfPPd7L
         oj9N1SbyNVxULBKWFw9ZoPIzp2Xe0Mq3eGtn6fMXIwmIdFYqj0Rh2LSbD260H+oN67l0
         5EOV9tkUKvg+WT1M/NEMdi0LkrZOvYDhokRxcRDAOMP+fHDiNQ759TE14gb0GNyLrtIH
         qlUV2tQ1JX99Z3IOzDcyFfAgmj2llwaCC2erMdHZsNYdXFWLOWw8/EQL8h8N4++MXpJM
         O5Gg==
Content-Disposition: inline
In-Reply-To: <4FC61B4E.2060206@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Wed, May 30, 2012 at 05:06:22PM +0400, Glauber Costa wrote:
> On 05/30/2012 05:04 PM, Frederic Weisbecker wrote:
> >Do you think it's possible that this memcg can be destroyed (like ss->destroy())
> >concurrently?
> >
> >Probably not because there is a synchronize_rcu() in cgroup_diput() so as long
> >as we are in rcu_read_lock() we are fine.
> >
> >OTOH current->mm->owner can exit() right after we fetched its memcg and thus the css_set
> >can be freed concurrently? And then the cgroup itself after we call rcu_read_unlock()
> >due to cgroup_diput().
> >And yet we are doing the mem_cgroup_get() below unconditionally assuming it's
> >always fine to get a reference to it.
> >
> >May be I'm missing something?
> When a cache is created, we grab a reference to the memcg. So after
> the cache is created, no.
> 
> When destroy is called, we flush the create queue, so if the cache
> is not created yet, it will just disappear.
> 
> I think the only problem that might happen is in the following scenario:
> 
> * cache gets created, but ref count is not yet taken
> * memcg disappears
> * we try to inc refcount for a non-existent memcg, and crash.
> 
> This would be trivially solvable by grabing the reference earlier.
> But even then, I need to audit this further to make sure it is
> really an issue.

Right. __mem_cgroup_get_kmem_cache() fetches the memcg of the owner
and calls memcg_create_cache_enqueue() which does css_tryget(&memcg->css).
After this tryget I think you're fine. And in-between you're safe against
css_set removal due to rcu_read_lock().

I'm less clear with __mem_cgroup_new_kmem_page() though...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
