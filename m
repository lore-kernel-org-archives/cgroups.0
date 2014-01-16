From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm] mm, oom: prefer thread group leaders for display
 purposes
Date: Wed, 15 Jan 2014 23:45:22 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401152344560.14407@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com> <20140116070549.GL6963@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=hIPvN5il+v2Eisi1NX2PVo4gcq9VLjnzpItE/lCA8yY=;
        b=ET7Mn6mD40ochuJbudifY6dQmaBJMHvZFxucB0bD6yTnnbsyP0FKHa907Y8dINx9iR
         qviJChAwScY3GxvHZasVF2PBW+adDCfWcoqaOIYN2tXVcUQSCs8n8WAojexeYRxfIprv
         eIyOS7333dMStkdT0MLwYNQnb6unDXByGyp4As/V8Czmrs0NtIdRDmDmW0znIcgY8y0L
         F5ZM8q/83Ab6EP2KtWg56juPh9l5UUGIYvxseaHn5EYPbqWckq8NgHHolNyMmkf5bb8X
         OmNnqNvgsiPqFYIJJY1qfHm7T4faL3Y50BO5y/wAv7BGCoTFJvDKqWJo8PYPGw8wL25W
         fKmg==
In-Reply-To: <20140116070549.GL6963@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Johannes Weiner wrote:

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a815686..b482f49 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1841,13 +1841,17 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  				break;
> >  			};
> >  			points = oom_badness(task, memcg, NULL, totalpages);
> > -			if (points > chosen_points) {
> > -				if (chosen)
> > -					put_task_struct(chosen);
> > -				chosen = task;
> > -				chosen_points = points;
> > -				get_task_struct(chosen);
> 
> Where did that GET go?
> 

No idea, good catch!  This patch was doomed from the GET-go.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
