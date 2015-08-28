From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] memcg: always enable kmemcg on the default hierarchy
Date: Fri, 28 Aug 2015 12:56:04 -0400
Message-ID: <20150828165604.GM26785@mtj.duckdns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-5-git-send-email-tj@kernel.org>
 <20150828164918.GJ9610@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5AmY7HU3nwZqwACW0F2X6KUbf3klj+HSwbmZkBZ3mO0=;
        b=f4tZv9IXKz8/ZY/KvFQTVKb3LrnvMT6VXNkZaagLcCzvf032EaZh3MPxJEcJENIJfZ
         mFYzUFG3z9eTn2oLgdU5otuCzZEpIWMyG5Xwio2cWqr5OY0z6cAg2DQsN2JDHAzPrjG8
         GW2Np6R7Aqeuug23VkVcRQlEz5imsxv2GpURuHbRnVcPDdpENEPNmF4rgsHJpYs2xLhs
         vOCJaJC7kuIs93q1Fvjbi0vq0UfZW0ZPIdayXn/kimFi0S51s4lCbQ80nAqSX5j8nrXn
         W3X25yJhfV0vWzA1I9Puu5WS+QVt903lub+yzj5GZNxRZ9J2sGvOwN/pS2WxFeS9xkFB
         6iKg==
Content-Disposition: inline
In-Reply-To: <20150828164918.GJ9610@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello,

On Fri, Aug 28, 2015 at 07:49:18PM +0300, Vladimir Davydov wrote:
> On Fri, Aug 28, 2015 at 11:25:30AM -0400, Tejun Heo wrote:
> > On the default hierarchy, all memory consumption will be accounted
> > together and controlled by the same set of limits.  Always enable
> > kmemcg on the default hierarchy.
> 
> IMO we should introduce a boot time knob for disabling it, because kmem
> accounting is still not perfect, besides some users might prefer to go
> w/o it for performance reasons.

Yeah, fair enough.

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c94b686..8a5dd01 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4362,6 +4362,13 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
> >  	if (ret)
> >  		return ret;
> >  
> > +	/* kmem is always accounted together on the default hierarchy */
> > +	if (cgroup_on_dfl(css->cgroup)) {
> > +		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> 
> This is a wrong place for this. The kernel will panic on an attempt to
> create a sub memcg, because memcg_init_kmem already enables kmem
> accounting in this case. I guess we should add this hunk to
> memcg_propagate_kmem instead.

Yeap, bypassing "parent is active" test in memcg_propagate_kmem()
seems like the right thing to do.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
