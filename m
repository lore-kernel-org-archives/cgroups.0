From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: iterate cgroup_subsys_states
 directly
Date: Wed, 14 May 2014 09:07:22 -0400
Message-ID: <20140514130722.GE28815@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <5372EF45.8060701@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YzUpGz0a5XU2pm2hq3GRC0g2ojAtSr7SvYa72U5h38A=;
        b=vR+Pu5IhrMGXoLUFyCwxUjpcWvUMZJ60BGoJ+DdcfSGM6J0RtqskBHcFLs3z/14Lm3
         yswwsnm0HiP3YPI3Y6BoJNCJKsRCMfgz8NLvu3q5T+Ol1KV+Xke7H0d+KDGgQm9PJdYE
         iw7jiViVT+hS5soJ29lNjIyQIwZPK3yjI+MivxOPZ2uv6HB2uLOv32/5b8B+4Xa0787k
         y3EL+v4Qia8hmlIAF3t4RA4EFNp4d14XeCaMDgPrssdmsEkzW3VDDU2bYtF/PfnuB6sl
         PeuZdllRBZ7DPzDfoc/u+SetvAi6CD6Qu5wNUrxwUCC3bUKmq6mqcj6Lat2FPJ1wU2JG
         TLCw==
Content-Disposition: inline
In-Reply-To: <5372EF45.8060701-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

Hello, Li.

On Wed, May 14, 2014 at 12:21:25PM +0800, Li Zefan wrote:
> > There are now use cases where controllers need to iterate through
> > csses regardless of their online state as long as they have positive
> 
> What use cases are we talking about here?

memcg wants to be able to iterate all csses whose refcnts haven't
reached zero yet so that it can treat offline csses the same way as
online ones in terms of memory reclaim.  They don't contain new tasks
so new charges won't be created but offlining won't try to transfer
all charges to the parent but just leave the offline child attached
until all charges are eventually reclaimed from the pressure from the
parent.

I'm not too familiar with the details but this makes sense in generic
sense too.  Offline marks an object starting its draining phase and
release marks the actual destruction point.  For controllers with
persistent states like memcg, it's a lot more natural to deal offlined
csses as "active but draining following the usual hierarchical
operation" rather than trying to explicitly update the states from
offline to move them to the parent especially as the effort there
essentially is a waste as most of those moved charges aren't gonna be
used in the parent and will be released eventually.

Guaranteeing iteration of offline but not-released csses allow
controllers to treat the draining stage between offline and release
more or less identically to online state which in turn can make
->css_offline() significantly simpler and lighter.

Thanks.

-- 
tejun
