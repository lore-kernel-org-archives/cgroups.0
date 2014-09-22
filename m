From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Mon, 22 Sep 2014 19:28:00 +0200
Message-ID: <20140922172800.GA4343@dhcp22.suse.cz>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144436.GG336@dhcp22.suse.cz>
 <20140922155049.GA6630@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iVRCLHsG3p4FOt8/k229Zy4F4Y3PUVNVQOl+K/O9bsY=;
        b=WpEeMsRGGAe2ccq0yXt9ZM4QnyGspG9gQkoD3iUqiRO/2Y6esIRHRQ5uXVyRRRUcU8
         0thlprUjQA9e/JwsKsZab9p6SikxMukBrJJvrOZKeBIEXIzS7NrFm4DILTkhA2+5JMPI
         YBjyl13osF1yGay+cOuBSs9CkD/SdjYIRii/ep+EGnga+/R+034jwLv6Kggg7emqUvDf
         zQ13pxwWjeR3S8Nd5GNUrdpF/Pk/eku/XCBD4f5uaxM9vsIBd/1e2IDn+wZDDyGPsJ1I
         eUm5LWjPQSA/R3I3CYeNayBjyNJZmNlvRZDSvNvhhXbIWX5XJCCv2obh5TVbCnx+rMvL
         0x2A==
Content-Disposition: inline
In-Reply-To: <20140922155049.GA6630@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon 22-09-14 11:50:49, Johannes Weiner wrote:
> On Mon, Sep 22, 2014 at 04:44:36PM +0200, Michal Hocko wrote:
> > On Fri 19-09-14 09:22:08, Johannes Weiner wrote:
[...]
> > Nevertheless I think that the counter should live outside of memcg (it
> > is ugly and bad in general to make HUGETLB controller depend on MEMCG
> > just to have a counter). If you made kernel/page_counter.c and led both
> > containers select CONFIG_PAGE_COUNTER then you do not need a dependency
> > on MEMCG and I would find it cleaner in general.
> 
> The reason I did it this way is because the hugetlb controller simply
> accounts and limits a certain type of memory and in the future I would
> like to make it a memcg extension, just like kmem and swap.

I am not sure this is the right way to go. Hugetlb has always been
"special" and I do not see any advantage to pull its specialness into
memcg proper. It would just make the code more complicated. I can also
imagine users who simply do not want to pay memcg overhead and use only
hugetlb controller.

Besides that it is not like a separate page_counter with a clear
interface would cause more maintenance overhead so I really do not see
any reason to pull it into memcg.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
