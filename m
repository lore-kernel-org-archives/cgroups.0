From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove bind() method from cgroup_subsys.
Date: Thu, 11 Apr 2013 11:49:08 -0700
Message-ID: <20130411184908.GL17641@mtj.dyndns.org>
References: <1365594077-17655-1-git-send-email-ramirose@gmail.com>
 <20130410175035.GA17641@mtj.dyndns.org>
 <5166199F.7090104@huawei.com>
 <CAOS58YP8V=GNrkRJN1G3EJrdVgK6NPcvm+30SW_xjC1Sq2QBng@mail.gmail.com>
 <5166600F.3090303@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=3tU42Aevw33dBIx5mvM//KUhcSMUO8b6W4dXSiEqLZs=;
        b=v6nOjApRj/NaHbT7OOUfsW3AQg6X31gEKrUDXFebn084WC3JQBj2VTaoT7ywS4GvGL
         mjlITQiHwmPbZgDD80VyEUMwlIQJU76vvBYM3trKudkUEOybulsJPTCDSJLxsqja030a
         y+LuKbqaZHxvjB0Sj416iE2Q81105hDi3YWqQnfdSmareavCix15By8nWCCUHoWUxhQh
         ju1hI68skiIRBUyeQKVRYNt2qd2Nd4ZCE2AZ5au44Nahq/hPxUL25dop4QPBD/wgvuG9
         epFhUALyior8HPpmNsh01Q0FdEnzGhQNO3gqbuka6zss8t8UyHZlfj8RMw9NJVfkyy19
         h5AQ==
Content-Disposition: inline
In-Reply-To: <5166600F.3090303-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 11, 2013 at 11:02:39AM +0400, Glauber Costa wrote:
> The patch didn't suffer any change in its last 2 iteractions, so I was
> just waiting for someone to apply =p (or well, say something)
> 
> It re-uses the infrastructure that you built in cgroup.c to detect
> comounting, so it does not use bind.

Peter is pretty responsive these days.  Can you please rebase the
patches and repost soonish or maybe after 3.10-rc1 opens?

Thanks.

-- 
tejun
