From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 17/24] blkcg: implement blkcg_policy->on/offline_pd_fn()
 and blkcg_gq->online
Date: Wed, 2 Jan 2013 15:37:18 -0500
Message-ID: <20130102203718.GE11220@mtj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-18-git-send-email-tj@kernel.org>
 <20130102193828.GE4306@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=+vjXLyusovHOO0NxJEGvPumeqpfS7MtL9f93hpSl0VU=;
        b=X0bHWH/0XCISEWSjJh8anHh0wOynmV+dvVmG1M61kkig2lXr3lewj6nK51W189U2wk
         8l6RUnk8QQ87xh96Pt6wtvr4ArQ2ZeQPMc8ISGTwxq8i58YVUb258i9eDK7H9ItfgTpU
         xRjYrkQ/c1MXrDkZgMKUuITykdyPFUilnu0+G6D2Kreh6oGaT++i5SOpsE7epmwmi/zJ
         JRgny/09n+IuKFA76rmn0+nVW6o7FfGhf38a9Ik0IVNws86AMo5WdRcUQPzESCtho9uQ
         Wlpm127ODircEECaVGdr8QIol/wv9chfml1xnKr7/OblX/njGNa6f2TaJaKreId9SrmF
         OoZQ==
Content-Disposition: inline
In-Reply-To: <20130102193828.GE4306-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed, Jan 02, 2013 at 02:38:28PM -0500, Vivek Goyal wrote:
> On Fri, Dec 28, 2012 at 12:35:39PM -0800, Tejun Heo wrote:
> 
> [..]
> > diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> > index 40f5b97..678e89e 100644
> > --- a/block/blk-cgroup.h
> > +++ b/block/blk-cgroup.h
> > @@ -106,12 +106,17 @@ struct blkcg_gq {
> >  	/* reference count */
> >  	int				refcnt;
> >  
> > +	/* is this blkg online? protected by both blkcg and q locks */
> > +	bool				online;
> > +
> 
> Hi Tejun,
> 
> What does above mean? One needs to take one lock or both the locks to
> check/modify blkg->online.

Needs both locks to modify, so either lock is enough for checking.

-- 
tejun
