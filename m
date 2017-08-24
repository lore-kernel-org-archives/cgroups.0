From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v6 2/4] mm, oom: cgroup-aware OOM killer
Date: Thu, 24 Aug 2017 14:58:42 +0100
Message-ID: <20170824135842.GA21167@castle.DHCP.thefacebook.com>
References: <20170823165201.24086-1-guro@fb.com>
 <20170823165201.24086-3-guro@fb.com>
 <20170824114706.GG5943@dhcp22.suse.cz>
 <20170824122846.GA15916@castle.DHCP.thefacebook.com>
 <20170824125811.GK5943@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Vp0LA3RM9z4yREQ9fG6CH8tyP7LBA2f9IIkEI8xlt8I=;
 b=c6rE/R++0xdNxGEXdy4G7EGRc/E1KnhKfjDG0+kEHpkOuG5IADDXxXyRpW+dwzSK2CZm
 syai23uyD/NpXEI80CbWM7MlV5EdnC2GCe9V/waPBIXdeqdonfCvaNpEgUjJhaokVqOJ
 9uLh6Qsf+lDAxd26jpphe8NKlV9+QMH3y70= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Vp0LA3RM9z4yREQ9fG6CH8tyP7LBA2f9IIkEI8xlt8I=;
 b=RlmKo4HlGpG4JbW6hjlkWcYqA8tJRILGtQR8F95odrvVz4DlzD0Zy/z4MfgCi3idirQCgel6+CBGkwI2AKjRh2JYHFNvCeYT97V6U+mcs7DORmBVh8sykltLiqTbKMYmHfIQ+UkN1QILfZN3Yz5CHHWSga2GViSBxwyH1ynSLrs=
Content-Disposition: inline
In-Reply-To: <20170824125811.GK5943-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 24, 2017 at 02:58:11PM +0200, Michal Hocko wrote:
> On Thu 24-08-17 13:28:46, Roman Gushchin wrote:
> > Hi Michal!
> > 
> There is nothing like a "better victim". We are pretty much in a
> catastrophic situation when we try to survive by killing a userspace.

Not necessary, it can be a cgroup OOM.

> We try to kill the largest because that assumes that we return the
> most memory from it. Now I do understand that you want to treat the
> memcg as a single killable entity but I find it really questionable
> to do a per-memcg metric and then do not treat it like that and kill
> only a single task. Just imagine a single memcg with zillions of taks
> each very small and you select it as the largest while a small taks
> itself doesn't help to help to get us out of the OOM.

I don't think it's different from a non-containerized state: if you
have a zillion of small tasks in the system, you'll meet the same issues.

> > > I guess I have asked already and we haven't reached any consensus. I do
> > > not like how you treat memcgs and tasks differently. Why cannot we have
> > > a memcg score a sum of all its tasks?
> > 
> > It sounds like a more expensive way to get almost the same with less accuracy.
> > Why it's better?
> 
> because then you are comparing apples to apples?

Well, I can say that I compare some number of pages against some other number
of pages. And the relation between a page and memcg is more obvious, than a
relation between a page and a process.

Both ways are not ideal, and sum of the processes is not ideal too.
Especially, if you take oom_score_adj into account. Will you respect it?

I've started actually with such approach, but then found it weird.

> Besides that you have
> to check each task for over-killing anyway. So I do not see any
> performance merits here.

It's an implementation detail, and we can hopefully get rid of it at some point.

> 
> > > How do you want to compare memcg score with tasks score?
> > 
> > I have to do it for tasks in root cgroups, but it shouldn't be a common case.
> 
> How come? I can easily imagine a setup where only some memcgs which
> really do need a kill-all semantic while all others can live with single
> task killed perfectly fine.

I mean taking a unified cgroup hierarchy into an account, there should not
be lot of tasks in the root cgroup, if any.
