From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Fri, 28 Aug 2015 12:48:19 -0400
Message-ID: <20150828164819.GL26785@mtj.duckdns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828163611.GI9610@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hNCTXQcNnc/Lus9n1t0406U2nJym2Pg1NUGGby5+C+g=;
        b=l9anfSX+P1Jb1We2Cy5kcC3Mzvxk4IMmnpAJMamk7SE7XkbW14owypdVX5kQkySeGr
         8yJQcqp/6Ylj8pYKNd1UsQb1UHPUVS8k/P79D28jAdLNKI+NK11ArE560fkc4Q8t732Q
         jaEGUfAPNhojDB3bcSAq0uRE3W6+nTx1iqrObbOCGhLiTwB3jzF4S2jFzRXqsW9r+aUZ
         TFLNFcECHW0S7xkTvGq1Ds1e3XqdExhSmXlxpc4LV/zOfLdbNovZnVt10SfPdBl6IHaR
         1HUT7T+9OCvxuD5S4uQ8k+E1BDIyIi0VNrgFyFk9/wUAmNwAmwWj4rw5u/LLayCNW1s4
         WoCw==
Content-Disposition: inline
In-Reply-To: <20150828163611.GI9610@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Vladimir.

On Fri, Aug 28, 2015 at 07:36:11PM +0300, Vladimir Davydov wrote:
> > * try_charge() can be invoked from any in-kernel allocation site and
> >   reclaim path may use considerable amount of stack.  This can lead to
> >   stack overflows which are extremely difficult to reproduce.
> 
> IMO this paragraph does not justify this patch at all, because one will
> still invoke direct reclaim from try_charge() on hitting the hard limit.

Ah... right, and we can't defer direct reclaim for hard limit.

> > * If the allocation doesn't have __GFP_WAIT, direct reclaim is
> >   skipped.  If a process performs only speculative allocations, it can
> >   blow way past the high limit.  This is actually easily reproducible
> >   by simply doing "find /".  VFS tries speculative !__GFP_WAIT
> >   allocations first, so as long as there's memory which can be
> >   consumed without blocking, it can keep allocating memory regardless
> >   of the high limit.
> 
> I think there shouldn't normally occur a lot of !__GFP_WAIT allocations
> in a row - they should still alternate with normal __GFP_WAIT
> allocations. Yes, that means we can breach memory.high threshold for a
> short period of time, but it isn't a hard limit, so it looks perfectly
> fine to me.
> 
> I tried to run `find /` over ext4 in a cgroup with memory.high set to
> 32M and kmem accounting enabled. With such a setup memory.current never
> got higher than 33152K, which is only 384K greater than the memory.high.
> Which FS did you use?

ext4.  Here, it goes onto happily consuming hundreds of megabytes with
limit set at 32M.  We have quite a few places where !__GFP_WAIT
allocations are performed speculatively in hot paths with fallback
slow paths, so this is bound to happen somewhere.

Thanks.

-- 
tejun
