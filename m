From: Roman Gushchin <guro@fb.com>
Subject: Re: [v4 1/4] mm, oom: refactor the TIF_MEMDIE usage
Date: Wed, 26 Jul 2017 15:06:07 +0100
Message-ID: <20170726140607.GA20062@castle.DHCP.thefacebook.com>
References: <20170726132718.14806-1-guro@fb.com>
 <20170726132718.14806-2-guro@fb.com>
 <20170726135622.GS2981@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Y2qrZ73pddvlw35uwzz8R3O3AMXHWMmv4k5mZ/FVy2w=;
 b=bkYbqLEPxK2uDXZwOSqhpFk8m2yA+ub7hFd16ZEvY5nn2MYijdsbfz+D/o2bz4hHyVyO
 5dyPhNXwk8LSPpPI/SYYt/QY5S6W2k+g91jtT5WjOvKmY4OS9ilCfPGa4W8366oXQ6Br
 P/9Sk2PRlZGnwB2D7gM0lvXnDiqKzDgE1Ts= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Y2qrZ73pddvlw35uwzz8R3O3AMXHWMmv4k5mZ/FVy2w=;
 b=Xm1Sv/oo9k3fvGd2bsBpiztJ1C1m+w70JA7+j/ZBmgzRgWXpI4SpbrwyO3CPfTTLQajw6cCHAUNt8+0I6GvlPFQTxLSz4EXhF654e8Xdss+Kbod6XC2rN2KpKyEvKLvpvY7X9lP7t7dpFG7nsd8v1QojbgDIQ4Q44xIHsUwbONA=
Content-Disposition: inline
In-Reply-To: <20170726135622.GS2981@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 26, 2017 at 03:56:22PM +0200, Michal Hocko wrote:
> On Wed 26-07-17 14:27:15, Roman Gushchin wrote:
> [...]
> > @@ -656,13 +658,24 @@ static void mark_oom_victim(struct task_struct *tsk)
> >  	struct mm_struct *mm = tsk->mm;
> >  
> >  	WARN_ON(oom_killer_disabled);
> > -	/* OOM killer might race with memcg OOM */
> > -	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
> > +
> > +	if (!cmpxchg(&tif_memdie_owner, NULL, current)) {
> > +		struct task_struct *t;
> > +
> > +		rcu_read_lock();
> > +		for_each_thread(current, t)
> > +			set_tsk_thread_flag(t, TIF_MEMDIE);
> > +		rcu_read_unlock();
> > +	}
> 
> I would realy much rather see we limit the amount of memory reserves oom
> victims can consume rather than build on top of the current hackish
> approach of limiting the number of tasks because the fundamental problem
> is still there (a heavy multithreaded process can still deplete the
> reserves completely).
> 
> Is there really any reason to not go with the existing patch I've
> pointed to the last time around? You didn't seem to have any objects
> back then.

Hi Michal!

I had this patch in mind and mentioned in the commit log, that TIF_MEMDIE
as an memory reserves access indicator will probably be eliminated later.

But that patch is not upstream yet, and it's directly related to the theme.
The proposed refactoring of TIF_MEMDIE usage is not against your approach,
and will not make harder to go this way further.

I'm slightly concerned about an idea to give TIF_MEMDIE to all tasks
in case we're killing a really large cgroup. But it's only a theoretical
concern, maybe it's fine.

So, I'd keep the existing approach for this patchset, and then we can follow
your approach and we will have a better test case for it.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
