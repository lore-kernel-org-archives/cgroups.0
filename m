From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] memcg: fix over-high reclaim amount
Date: Fri, 28 Aug 2015 14:32:09 -0400
Message-ID: <20150828183209.GA9423@mtj.duckdns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-2-git-send-email-tj@kernel.org>
 <20150828170612.GA21463@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Rfr6r7wrEojRd89Wocb95qOedw5nS+Egz4iGyzqllks=;
        b=Pc8Dm6UBZE3hetWRrsCL4KFvJuvgtSMIXaC8/JGoncny2sRaXnaJQ9tP3umd9zs+7e
         KdYHihzNwLFJvWYBnoa57WmlFXjiihRAJCrKODAlR+bfUKQ+yJYWDdndfCUNN/hoYk56
         eQUNGOnMfqihUaadjrCB7ShLivseahY4sjDlLiOg0zvFnvXiS85RWdwYMEEGhoan7dar
         lWlhUjv/7Ujj1PYecCS3oaxOwWBWwp1TW/w3XZrbyVQz8+/VOdxnn3MHa99wIuV1phWY
         hsz1c7+Nqy/ne7oBIllwJbYMc5/HM7XMw/57sE/3EldqgPyXHPBVILtPACgpsqq7UjPB
         kshw==
Content-Disposition: inline
In-Reply-To: <20150828170612.GA21463-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Fri, Aug 28, 2015 at 07:06:13PM +0200, Michal Hocko wrote:
> I do not think this a better behavior. If you have parallel charges to
> the same memcg then you can easilly over-reclaim  because everybody
> will reclaim the maximum rather than its contribution.
> 
> Sure we can fail to reclaim the target and slowly grow over high limit
> but that is to be expected. This is not the max limit which cannot be
> breached and external memory pressure/reclaim is there to mitigate that.

Ah, I see, yeah, over-reclaim can happen.  How about just wrapping the
over-high reclaim with a per-memcg mutex?  Do we gain anything by
putting multiple tasks into the reclaim path?

Thanks.

-- 
tejun
