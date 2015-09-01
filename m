From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] memcg: fix over-high reclaim amount
Date: Tue, 1 Sep 2015 14:33:07 -0400
Message-ID: <20150901183307.GC18956@htj.dyndns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-2-git-send-email-tj@kernel.org>
 <20150828170612.GA21463@dhcp22.suse.cz>
 <20150828183209.GA9423@mtj.duckdns.org>
 <20150831075133.GA29723@dhcp22.suse.cz>
 <20150831133840.GA2271@mtj.duckdns.org>
 <20150901125149.GD8810@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ik5vwOdH+heXCfdcuwCemLviUa+Ivs5BBfeOi3NTP+Y=;
        b=RXl1wHpZ5KDbn3oRXJ8tF58eCAJQN1Qny+Rxv0QqQ1OJCZc2PeP8l0jvH8Tx4oS0iS
         KtK0kD7AT2pLXow7c19RxYGHMR/5OPr+/vINujEkfqVj1EIHdQjAdW8lWVFXDtVuOdgw
         HH1AL5IZElZ/uJ9EQDEpMKYo9tTuwKdIpICRoEJdTyw/Vy5JRgiH3LTNxg6ya9kwhoQy
         PsFqte2geKiTBvuHjpOMhJWhuYI7La9iqDucHEVHidqYqi6DRITg7rmMzGfGEf3Jek83
         ivvtzFmwYtRgken3swW/UwLVvSXCZE46l2tpBcgO1os47UiOO5CCE7SxK0zOpa+NDn4j
         7dgg==
Content-Disposition: inline
In-Reply-To: <20150901125149.GD8810-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, Sep 01, 2015 at 02:51:50PM +0200, Michal Hocko wrote:
> > Is reclaim throughput as determined by CPU cycle bandwidth a
> > meaningful metric? 
> 
> Well, considering it has a direct effect on the latency I would consider
> it quite meaningful.
>
> > I'm having a bit of trouble imagining that this
> > actually would matter especially given that writeback is single
> > threaded per bdi_writeback.
> 
> Sure, if the LRU contains a lot of dirty pages then the writeback will be
> a bottleneck. But LRUs are quite often full of the clean pagecache pages
> which can be reclaimed quickly and efficiently.

I see.  Hmmm... I can imagine the scheduling latencies from
synchronization being a factor.  Alright, if we decide to do this
return-path reclaiming, I'll update the patch to accumulate nr_pages.

Thanks.

-- 
tejun
