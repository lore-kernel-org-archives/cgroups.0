From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v6 2/4] mm, oom: cgroup-aware OOM killer
Date: Wed, 30 Aug 2017 12:22:40 +0100
Message-ID: <20170830112240.GA4751@castle.dhcp.TheFacebook.com>
References: <20170823165201.24086-1-guro@fb.com>
 <20170823165201.24086-3-guro@fb.com>
 <20170824114706.GG5943@dhcp22.suse.cz>
 <20170824122846.GA15916@castle.DHCP.thefacebook.com>
 <20170824125811.GK5943@dhcp22.suse.cz>
 <20170824135842.GA21167@castle.DHCP.thefacebook.com>
 <20170824141336.GP5943@dhcp22.suse.cz>
 <20170824145801.GA23457@castle.DHCP.thefacebook.com>
 <20170825081402.GG25498@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=1vFRQVaP3mHk9tHF1E9neb9toNj7zrdK9HpQHNyfoKw=;
 b=VSHz/YbaE3DhmOw8mB1h7ton6glSpCNnO9P8f9MQJblyjgrw+X9B2EyF4kYBsP76AecQ
 T4czfrIaoyRO/QPy3gWC87kTHIj+FpOy7ID6jqTYzE9qkT5us2OJs4rMH6G8Luscjold
 VRVjT6xR6SwiHwJt4uKDmGYlJnKKHx0FA0U= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1vFRQVaP3mHk9tHF1E9neb9toNj7zrdK9HpQHNyfoKw=;
 b=Bawb1ozCa6c3hjnkJZxlac6qSejxuUArAP2jJfC9EFUfCBKeJpwz8ogrqmECbgPEIW93jh2ZFNdVd84DnrgquGuhNMxKA3xgWZDYxtE7qQNfQlW5JCcKSsOUMdCVAXvUAu/D3vs8y7+qcKHVeptKDT5Wz8hiM6z9jmI+aE4vDD8=
Content-Disposition: inline
In-Reply-To: <20170825081402.GG25498-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 25, 2017 at 10:14:03AM +0200, Michal Hocko wrote:
> On Thu 24-08-17 15:58:01, Roman Gushchin wrote:
> > On Thu, Aug 24, 2017 at 04:13:37PM +0200, Michal Hocko wrote:
> > > On Thu 24-08-17 14:58:42, Roman Gushchin wrote:
> [...]
> > > > Both ways are not ideal, and sum of the processes is not ideal too.
> > > > Especially, if you take oom_score_adj into account. Will you respect it?
> > > 
> > > Yes, and I do not see any reason why we shouldn't.
> > 
> > It makes things even more complicated.
> > Right now task's oom_score can be in (~ -total_memory, ~ +2*total_memory) range,
> > and it you're starting summing it, it can be multiplied by number of tasks...
> > Weird.
> 
> oom_score_adj is just a normalized bias so if tasks inside oom will use
> it the whole memcg will get accumulated bias from all such tasks so it
> is not completely off. I agree that the more tasks use the bias the more
> biased the whole memcg will be. This might or might not be a problem.
> As you are trying to reimplement the existing oom killer implementation
> I do not think we cannot simply ignore API which people are used to.
> 
> If this was a configurable oom policy then I could see how ignoring
> oom_score_adj is acceptable because it would be an explicit opt-in.
> 
> > It also will be different in case of system and memcg-wide OOM.
> 
> Why, we do honor oom_score_adj for the memcg OOM now and in fact the
> kernel memcg OOM killer shouldn't be very much different from the global
> one except for the tasks scope.
> 
> > > > I've started actually with such approach, but then found it weird.
> > > > 
> > > > > Besides that you have
> > > > > to check each task for over-killing anyway. So I do not see any
> > > > > performance merits here.
> > > > 
> > > > It's an implementation detail, and we can hopefully get rid of it at some point.
> > > 
> > > Well, we might do some estimations and ignore oom scopes but I that
> > > sounds really complicated and error prone. Unless we have anything like
> > > that then I would start from tasks and build up the necessary to make a
> > > decision at the higher level.
> > 
> > Seriously speaking, do you have an example, when summing per-process
> > oom_score will work better?
> 
> The primary reason I am pushing for this is to have the common iterator
> code path (which we have since Vladimir has unified memcg and global oom
> paths) and only parametrize the value calculation and victim selection.
> 
> > Especially, if we're talking about customizing oom_score calculation,
> > it makes no sence to me. How you will sum process timestamps?
> 
> Well, I meant you could sum oom_badness for your particular
> implementation. If we need some other policy then this wouldn't work and
> that's why I've said that I would like to preserve the current common
> code and only parametrize value calculation and victim selection...

I've spent some time to implement such a version.

It really became shorter and more existing code were reused,
howewer I've met a couple of serious issues:

1) Simple summing of per-task oom_score doesn't make sense.
   First, we calculate oom_score per-task, while should sum per-process values,
   or, better, per-mm struct. We can take only threa-group leader's score
   into account, but it's also not 100% accurate.
   And, again, we have a question what to do with per-task oom_score_adj,
   if we don't task the task's oom_score into account.

   Using memcg stats still looks to me as a more accurate and consistent
   way of estimating memcg memory footprint.

2) If we're treating tasks from not-kill-all cgroups as separate oom entities,
   and compare them with memcgs with kill-all flag, we definitely need
   per-task oom_priority to provide a clear way to compare entities.

   Otherwise we need per-memcg size-based oom_score_adj, which is not
   the best idea, as we agreed earlier.

Thanks!

Roman
