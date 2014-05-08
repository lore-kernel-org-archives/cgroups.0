From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 4/9] mm: memcontrol: catch root bypass in move precharge
Date: Thu, 8 May 2014 14:30:04 -0400
Message-ID: <20140508183004.GQ19914@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-5-git-send-email-hannes@cmpxchg.org>
 <20140507145553.GJ9489@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=lyMgtrFFeOW4nLeZJ2Qjt4LWOkHm9cp4358PaWSUxeM=;
	b=ULS4+kniGErty/PWisPC9AWX4Kg15o9qF1Wdm3FXsUGAM+KYflx1TeNd0D4hL19w3U0yqExjFg/iJzz5r86Nc1zIF8JHaggIImOTdzeqQg7J1uLKZG9wGHKXYVai9kfRlyEhp6Sxbxp4i8V7MdUq2SUJIQxWfD6yLXZIAm/NJIA=;
Content-Disposition: inline
In-Reply-To: <20140507145553.GJ9489@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 04:55:53PM +0200, Michal Hocko wrote:
> On Wed 30-04-14 16:25:38, Johannes Weiner wrote:
> [...]
> > @@ -6546,8 +6546,9 @@ one_by_one:
> >  			cond_resched();
> >  		}
> >  		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
> > +		if (ret == -EINTR)
> > +			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
> >  		if (ret)
> > -			/* mem_cgroup_clear_mc() will do uncharge later */
> 
> I would prefer to keep the comment and explain that we will loose return
> code on the way and that is why cancel on root has to be done here.

That makes sense, I'll add an explanation of who is (un)charged when
and where.  Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
