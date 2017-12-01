From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm, oom: simplify alloc_pages_before_oomkill handling
Date: Fri, 1 Dec 2017 13:32:15 +0000
Message-ID: <20171201133214.GB7741@castle.DHCP.thefacebook.com>
References: <20171130152824.1591-1-guro@fb.com>
 <20171201091425.ekrpxsmkwcusozua@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=EPo+xXh/kdMTH+eK/nBSONwzFWIU7NuIMJEOHGBWAB0=;
 b=Wn5/B4IqjKH82naiI78Gs4/EpLeD82jQurdLvPyOPi1JyQnkCOJcNqlglrY7wRLs1s1B
 gFeaPiQQ5A8g+sDapP3a1Q4QKbv86ebxp9KalCFiIQVYCoENHkyEtHwgd/pUDkLbYIjd
 /1q2M1XWPzGiGW0lM1qTxU1DJ7m40BFVA+k= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EPo+xXh/kdMTH+eK/nBSONwzFWIU7NuIMJEOHGBWAB0=;
 b=eqhYQrmKAjJQF6K1Is5JJuxw045GAE2LypL9NLZWyvaq6V0PmEeHLu6JMmn4dTL3mx3cHvAu2L2CzHltvTF6CzHhTAgu1ndge3jxvujrqc7XgWDbNR9Lbmhpsq+yFc9pMZJh+hyDdjNSnnIarqrGi2iOAQYxoaguAPeeewDIHBo=
Content-Disposition: inline
In-Reply-To: <20171201091425.ekrpxsmkwcusozua-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi, Michal!

I totally agree that out_of_memory() function deserves some refactoring.

But I think there is an issue with your patch (see below):

On Fri, Dec 01, 2017 at 10:14:25AM +0100, Michal Hocko wrote:
> Recently added alloc_pages_before_oomkill gained new caller with this
> patchset and I think it just grown to deserve a simpler code flow.
> What do you think about this on top of the series?
> 
> ---
> From f1f6035ea0df65e7619860b013f2fabdda65233e Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Date: Fri, 1 Dec 2017 10:05:25 +0100
> Subject: [PATCH] mm, oom: simplify alloc_pages_before_oomkill handling
> 
> alloc_pages_before_oomkill is the last attempt to allocate memory before
> we go and try to kill a process or a memcg. It's success path always has
> to properly clean up the oc state (namely victim reference count). Let's
> pull this into alloc_pages_before_oomkill directly rather than risk
> somebody will forget to do it in future. Also document that we _know_
> alloc_pages_before_oomkill violates proper layering and that is a
> pragmatic decision.
> 
> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> ---
>  include/linux/oom.h |  2 +-
>  mm/oom_kill.c       | 21 +++------------------
>  mm/page_alloc.c     | 24 ++++++++++++++++++++++--
>  3 files changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 10f495c8454d..7052e0a20e13 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -121,7 +121,7 @@ extern void oom_killer_enable(void);
>  
>  extern struct task_struct *find_lock_task_mm(struct task_struct *p);
>  
> -extern struct page *alloc_pages_before_oomkill(const struct oom_control *oc);
> +extern bool alloc_pages_before_oomkill(struct oom_control *oc);
>  
>  extern int oom_evaluate_task(struct task_struct *task, void *arg);
>  
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4678468bae17..5c2cd299757b 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1102,8 +1102,7 @@ bool out_of_memory(struct oom_control *oc)
>  	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
>  	    current->mm && !oom_unkillable_task(current, NULL, oc->nodemask) &&
>  	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
> -		oc->page = alloc_pages_before_oomkill(oc);
> -		if (oc->page)
> +		if (alloc_pages_before_oomkill(oc))
>  			return true;
>  		get_task_struct(current);
>  		oc->chosen_task = current;
> @@ -1112,13 +1111,8 @@ bool out_of_memory(struct oom_control *oc)
>  	}
>  
>  	if (mem_cgroup_select_oom_victim(oc)) {
> -		oc->page = alloc_pages_before_oomkill(oc);
> -		if (oc->page) {
> -			if (oc->chosen_memcg &&
> -			    oc->chosen_memcg != INFLIGHT_VICTIM)
> -				mem_cgroup_put(oc->chosen_memcg);

You're removing chosen_memcg releasing here, but I don't see where you
do this instead. And I'm not sure that putting mem_cgroup_put() into
alloc_pages_before_oomkill() is a way towards simpler code.

I was thinking about a bit larger refactoring: splitting out_of_memory()
into the following parts (defined as separate functions): victim selection
(per-process, memcg-aware or just allocating task), last allocation attempt,
OOM action (kill process, kill memcg, panic). Hopefully it can simplify the things,
but I don't have code yet.

Thanks!
