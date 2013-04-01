From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: implement boost mode
Date: Mon, 1 Apr 2013 11:37:40 +0200
Message-ID: <20130401093740.GA30749@dhcp22.suse.cz>
References: <1364801670-10241-1-git-send-email-glommer@parallels.com>
 <51595311.7070509@jp.fujitsu.com>
 <515953AE.3000403@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=jdrRU/fXZl9pd0hEIcbTZzdM1XxE7FquecPo/EaNOtY=;
        b=VkLCQLF9hP2rBW9p77jMCDq0ctNBB8ewepxdDdbr3x/cHWjrWYN0Kd9A9xuEy17wjp
         fVI4kRLzkIdL/tl5dcjkaJvsGDnZKiFSSk/5nEw/nL0bxdi7bN/AV87t+9YUSpbmBX+C
         5xyg45n9ZFB1b5HerWrcVO4haXCrcJcNY1ksfdO7noI3dFJ2HczJP65/vfSPFbkZwNsK
         /YQg75t4Lz1jpcmFjatKs2o6uxQFh+S0Azv1oA4O688E8Eoim29zUqaPnahgtVaZaD3T
         fDKkUaIjySDjG1NFVYdQTUCJBRVp4tyDVQGZDIMV1ddMG48Szj9vFZMUoEVKRLbwNf9v
         KNTQ==
Content-Disposition: inline
In-Reply-To: <515953AE.3000403-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon 01-04-13 13:30:22, Glauber Costa wrote:
> On 04/01/2013 01:27 PM, Kamezawa Hiroyuki wrote:
> > (2013/04/01 16:34), Glauber Costa wrote:
> >> There are scenarios in which we would like our programs to run faster.
> >> It is a hassle, when they are contained in memcg, that some of its
> >> allocations will fail and start triggering reclaim. This is not good
> >> for the program, that will now be slower.
> >>
> >> This patch implements boost mode for memcg. It exposes a u64 file
> >> "memcg boost". Every time you write anything to it, it will reduce the
> >> counters by ~20 %. Note that we don't want to actually reclaim pages,
> >> which would defeat the very goal of boost mode. We just make the
> >> res_counters able to accomodate more.
> >>
> >> This file is also available in the root cgroup. But with a slightly
> >> different effect. Writing to it will make more memory physically
> >> available so our programs can profit.
> >>
> >> Please ack and apply.
> >>
> > Nack.
> > 
> >> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > 
> > Please update limit temporary. If you need call-shrink-explicitly-by-user, 
> > I think you can add it.
> > 
> 
> I don't want to shrink memory because that will make applications
> slower. I want them to be faster, so they need to have more memory.
> There is solid research backing up my approach:
> http://www.dilbert.com/fast/2008-05-08/

:)

-- 
Michal Hocko
SUSE Labs
