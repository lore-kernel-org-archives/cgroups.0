From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] memcg: close the race window between OOM detection
 and killing
Date: Sat, 6 Jun 2015 09:56:06 +0900
Message-ID: <20150606005606.GA12744@mtj.duckdns.org>
References: <20150603031544.GC7579@mtj.duckdns.org>
 <20150603144414.GG16201@dhcp22.suse.cz>
 <20150603193639.GH20091@mtj.duckdns.org>
 <20150604093031.GB4806@dhcp22.suse.cz>
 <20150604192936.GR20091@mtj.duckdns.org>
 <20150605143534.GD26113@dhcp22.suse.cz>
 <20150605145759.GA5946@mtj.duckdns.org>
 <20150605152135.GE26113@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=40MUFnrZ8D5ybWhxLboVJGcs0k5SFDj28gu+AxPS/o8=;
        b=UNSJbvl0uV3OY53zNNNgvqF+DHSwRr7F84uHMe+sU+cDaspGUpeuEMv9qimwXaGj4d
         AHCdD+uRoi5ZtChBmRJYRZ24d2INaEuX/LWbucdlhjY7u7xYMqpe5U7nhLdfsZkGSIZb
         w3ydhivzZTDh9LuhBddVOv5wNY2H7S3Byxtfg/Jqkq3+BrB4L1QyD6LvPyGglWB4n0QI
         2+2+GbcdHJu4XqpqJPvVqTrNsPB9NXwHozed1On+2+CCdFojEmuCvCkGi3XbQHg0sSu+
         78JTxArZd/xZfBY4/9tgZVbpUkkVYJb9j7FXEkwYMLGWMMUyt1TXaFG1+OWCptVkyRq6
         R7GQ==
Content-Disposition: inline
In-Reply-To: <20150605152135.GE26113@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

Hello, Michal.

On Fri, Jun 05, 2015 at 05:21:35PM +0200, Michal Hocko wrote:
...
> > > TIF_MEMDIE but the allocation path hasn't noticed that because it's passed
> > >         /*
> > >          * Go through the zonelist yet one more time, keep very high watermark
> > >          * here, this is only to catch a parallel oom killing, we must fail if
> > >          * we're still under heavy pressure.
> > >          */
> > >         page = get_page_from_freelist(gfp_mask | __GFP_HARDWALL, order,
> > >                                         ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
> > > 
> > > and goes on to kill another task because there is no TIF_MEMDIE
> > > anymore.
> > 
> > Why would this be an issue if we disallow parallel killing?
> 
> I am confused. The whole thread has started by fixing a race in memcg
> and I was asking about the global case which is racy currently as well.

Ah, okay, I thought we were still talking about issues w/ making
things synchronous, but anyways, the above isn't a synchronization
race per-se which is what the original patch was trying to address for
memcg OOM path, right?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
