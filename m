From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Tue, 26 Nov 2013 19:33:12 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=TRbecZlCtuy7HhLo1RF+qCKUl6L1he32Ymms1ujH1NE=;
        b=jSICYfDNpe668uHQHf60+NB+B7ixrikAiil3HOgLfB5HJS06nYtofhtWUXjq12PU7k
         UzpoXl4L28sLVvy82Cp245u21gdFRkrC/pnHssHu82PrsM1T6gHHZ87KpBq9I0ZzRIJ5
         j6ftAHdSmrEImZeoD0/6ASTmgUhxyql5SFezz45yMgBgXKlBaKr3R4zRVEFzF6wyf1I4
         4nBmEmqlbu3tdy8H2QBfUJcQ6ix+rZycfFS8QMwRLKpWfosMYTUu3DYkyiD1ev/Bdfqs
         gfFeQ4dl2lHKU8Wq51q7ONcYCmxIAu4EOuerAOx/VYDynnVGIxfhQQycxf2MZjFMcQ8C
         TSfA==
In-Reply-To: <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013, David Rientjes wrote:

> On Fri, 22 Nov 2013, Johannes Weiner wrote:
> 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 13b9d0f..cc4f9cb 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2677,6 +2677,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >  	if (unlikely(task_in_memcg_oom(current)))
> >  		goto bypass;
> >  
> > +	if (gfp_mask & __GFP_NOFAIL)
> > +		oom = false;
> > +
> >  	/*
> >  	 * We always charge the cgroup the mm_struct belongs to.
> >  	 * The mm_struct's mem_cgroup changes on task migration if the
> 
> Sorry, I don't understand this.  What happens in the following scenario:
> 
>  - memory.usage_in_bytes == memory.limit_in_bytes,
> 
>  - memcg reclaim fails to reclaim memory, and
> 
>  - all processes (perhaps only one) attached to the memcg are doing one of
>    the over dozen __GFP_NOFAIL allocations in the kernel?
> 
> How do we make forward progress if you cannot oom kill something?
> 

Ah, this is because of 3168ecbe1c04 ("mm: memcg: use proper memcg in limit 
bypass") which just bypasses all of these allocations and charges the root 
memcg.  So if allocations want to bypass memcg isolation they just have to 
be __GFP_NOFAIL?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
