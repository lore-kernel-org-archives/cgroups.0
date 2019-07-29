From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC] mm/memcontrol: reclaim severe usage over high limit
 in get_user_pages loop
Date: Mon, 29 Jul 2019 20:55:09 +0200
Message-ID: <20190729185509.GI9330@dhcp22.suse.cz>
References: <156431697805.3170.6377599347542228221.stgit@buzz>
 <20190729154952.GC21958@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190729154952.GC21958@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>

On Mon 29-07-19 11:49:52, Johannes Weiner wrote:
> On Sun, Jul 28, 2019 at 03:29:38PM +0300, Konstantin Khlebnikov wrote:
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -847,8 +847,11 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
> >  			ret = -ERESTARTSYS;
> >  			goto out;
> >  		}
> > -		cond_resched();
> >  
> > +		/* Reclaim memory over high limit before stocking too much */
> > +		mem_cgroup_handle_over_high(true);
> 
> I'd rather this remained part of the try_charge() call. The code
> comment in try_charge says this:
> 
> 	 * We can perform reclaim here if __GFP_RECLAIM but let's
> 	 * always punt for simplicity and so that GFP_KERNEL can
> 	 * consistently be used during reclaim.
> 
> The simplicity argument doesn't hold true anymore once we have to add
> manual calls into allocation sites. We should instead fix try_charge()
> to do synchronous reclaim for __GFP_RECLAIM and only punt to userspace
> return when actually needed.

Agreed. If we want to do direct reclaim on the high limit breach then it
should go into try_charge same way we do hard limit reclaim there. I am
not yet sure about how/whether to scale the excess. The only reason to
move reclaim to return-to-userspace path was GFP_NOWAIT charges. As you
say, maybe we should start by always performing the reclaim for
sleepable contexts first and only defer for non-sleeping requests.

-- 
Michal Hocko
SUSE Labs
