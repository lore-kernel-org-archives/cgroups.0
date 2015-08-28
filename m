From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Fri, 28 Aug 2015 13:56:28 -0400
Message-ID: <20150828175628.GO26785@mtj.duckdns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828171322.GC21463@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=W0//RzacUeH69PxboVUaYNZ1AhomatCQcs/Jp59pXeA=;
        b=umT09jmC2xMMhYiKAxyLDHj8/uuGJkXU5g/9ud1jd9tD0hH8WlFPJNWg7/kOF8TIfr
         CeYb8pirbE8LB0Ia6Dvo+tGAc2kLcyItZK2WRIQMaqI0WeeZ3iHrX7wxgmeJd5ND6I2+
         zs+lYVPTChK+vrQwPnbmB/+BrposWgd6N13aOBn7pKM9NlbXbFlv+Kjg7+83dyM2ZJ9b
         xTOnpvmwRTb69HlM/iaQ5Op1ucwv2PSvGiz+x/uURgIJrqmTsxKQmzTwG4kASs63t9Yq
         1dVfAuN715yrYLz1OTvhuxmiyOTbECdsSLkv8/bV7IO9wdCnVZUgkylgunKvKOKc14LM
         5/0Q==
Content-Disposition: inline
In-Reply-To: <20150828171322.GC21463-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Fri, Aug 28, 2015 at 07:13:22PM +0200, Michal Hocko wrote:
> On Fri 28-08-15 11:25:29, Tejun Heo wrote:
> > Currently, try_charge() tries to reclaim memory directly when the high
> > limit is breached; however, this has a couple issues.
> > 
> > * try_charge() can be invoked from any in-kernel allocation site and
> >   reclaim path may use considerable amount of stack.  This can lead to
> >   stack overflows which are extremely difficult to reproduce.
> 
> This is true but I haven't seen any reports for the stack overflow for
> quite some time.

So, this didn't really fix it but xfs had to punt things to workqueues
to avoid stack overflows and IIRC it involved direct reclaim.  Maybe
it's too late but it probably is a good idea to punt this from the
source.

> I would just argue that this implementation has the same issue as the
> other patch in the series which performs high-usage reclaim. I think
> that each task should reclaim only its contribution which is trivial
> to account.

Hmm... I'll respond there.

Thanks.

-- 
tejun
