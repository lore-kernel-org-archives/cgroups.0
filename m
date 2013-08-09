From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Date: Thu, 8 Aug 2013 20:46:21 -0400
Message-ID: <20130809004621.GD13427@mtj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
 <20130807130836.GB27006@htj.dyndns.org>
 <20130807133746.GI8184@dhcp22.suse.cz>
 <20130807134741.GF27006@htj.dyndns.org>
 <20130807135734.GK8184@dhcp22.suse.cz>
 <20130807144730.GB13279@dhcp22.suse.cz>
 <20130807173051.GD16343@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wpvr0bWrD+v3GyFgdQ1vu4Pmenpeqv2mx/VhWRdQBl8=;
        b=JSrYK4sgWyZEPlMzi+gQ4FJzQ5JUBPtGT9ykdoSIRopLBtI8qVtEhdZTYsC1spKf5l
         QvCeP0jf3OkM64trwQofAq13+N/ehQLcVxC27Vd2Nc8m/fnepp6Fkp4lxQM/WbLD9YQE
         KRuaBk1FeQ/Kpe4CEOuoD/hKUU//piiMdEBBz5keGQUfv9TrLOCC6bYoppest/ffMzsS
         IlKyV+95IBuvLPeZW2BGIpfQl6GvbYcfGX+NG1KCo+Io4IRqjAV/hpFOoWSVkythizkn
         p2l0l2ocd+26Zx1vwR5nJ3e/OTpycMuRElQg8ebDRRHyAKeDmrbL5hvvWFrF+jReoSNy
         udoA==
Content-Disposition: inline
In-Reply-To: <20130807173051.GD16343@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Anton Vorontsov <anton.vorontsov@linaro.org>

Hello, Michal.

On Wed, Aug 07, 2013 at 07:30:51PM +0200, Michal Hocko wrote:
> On Wed 07-08-13 16:47:30, Michal Hocko wrote:
> > On Wed 07-08-13 15:57:34, Michal Hocko wrote:
> > [...]
> > > Hmm, OK so you think that the fd limit is sufficient already?
> > 
> > Hmm, that would need to touch the code as well (the register callback
> > would need to make sure only one event is registered per cfile). But yes
> > this way would be better. I will send a new patch once I have an idle
> > moment.
> 
> What do you think about the following? I am not sure about EINVAL maybe
> there is a better way to tell userspace it is doing something wrong. I
> would appreciate any suggestions. If this looks good I will post a
> similar patch for vmpressure.

I don't think it's a good idea.  Not sure it matters given that this
isn't a very popular interface but adding this sort of rather
arbitrary restrictions can be confusing and lead to issues in userland
which are extremely annoying to track down.

Also, in terms of layering, this is horribly misplaced.  This is low
level event source implementation, which is not the right place to
implement logic to protect from userland abuses / mistakes.

That's the whole thing with this interface.  It's essentially
implementing a new userland-visible notification framework.  It is a
complex userland visible interface which takes a lot of design and
effort to get right and cgroup core or memcg definitely is not the
place to do anything like this.  Collectively, we are not capable
enough to do pull things like this properly by ourselves and even if
we were it is not the right place to do it.

Given how generally broken delegating to !priv users is, I don't think
there's anything we can or should do at this point rather than noting
that it is broken and was a mistake.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
