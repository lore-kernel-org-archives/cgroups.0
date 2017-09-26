From: Roman Gushchin <guro@fb.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Tue, 26 Sep 2017 11:59:25 +0100
Message-ID: <20170926105925.GA23139@castle.dhcp.TheFacebook.com>
References: <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
 <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
 <20170915152301.GA29379@castle>
 <20170918061405.pcrf5vauvul4c2nr@dhcp22.suse.cz>
 <20170920215341.GA5382@castle>
 <20170925122400.4e7jh5zmuzvbggpe@dhcp22.suse.cz>
 <20170925170004.GA22704@cmpxchg.org>
 <20170925181533.GA15918@castle>
 <20170925202442.lmcmvqwy2jj2tr5h@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=HHIHpXmNKLVMxKURNddEtUNIhuvdNuemMSrkwlfToO0=;
 b=ZgAggWYIx4nacLum6fnjYK2/EFgCXV4gciTKZLSdb8mTLg+n25N4wFnklw/nIDWiIKyg
 jNs2h6EBkplIfmUvAibWeWy76aUKPMFgT59YLjy6gUAfSOzvw1e/GcFqNvrWgqlAxGHk
 AEkYb5bvzuUjPS4FoEVQ52oAZsV35mxbnNg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HHIHpXmNKLVMxKURNddEtUNIhuvdNuemMSrkwlfToO0=;
 b=H/iBCHCFC0dO6xepXahwXhBlpXcmLK7Sabb9GPpPbvX/3tuoKjkkkWikNFNeM02nHOI26bYBhyeEotguIiBq/bBQ+tVQYi0ug2HT8GxVKxRiM2/gx1I8OURSlEywsMkGldykkt5bekh8Gk+IpcqYockzoQsVOyWzvaGuW8RHwH8=
Content-Disposition: inline
In-Reply-To: <20170925202442.lmcmvqwy2jj2tr5h@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Sep 25, 2017 at 10:25:21PM +0200, Michal Hocko wrote:
> On Mon 25-09-17 19:15:33, Roman Gushchin wrote:
> [...]
> > I'm not against this model, as I've said before. It feels logical,
> > and will work fine in most cases.
> > 
> > In this case we can drop any mount/boot options, because it preserves
> > the existing behavior in the default configuration. A big advantage.
> 
> I am not sure about this. We still need an opt-in, ragardless, because
> selecting the largest process from the largest memcg != selecting the
> largest task (just consider memcgs with many processes example).

As I understand Johannes, he suggested to compare individual processes with
group_oom mem cgroups. In other words, always select a killable entity with
the biggest memory footprint.

This is slightly different from my v8 approach, where I treat leaf memcgs
as indivisible memory consumers independent on group_oom setting, so
by default I'm selecting the biggest task in the biggest memcg.

While the approach suggested by Johannes looks clear and reasonable,
I'm slightly concerned about possible implementation issues,
which I've described below:

> 
> > The only thing, I'm slightly concerned, that due to the way how we calculate
> > the memory footprint for tasks and memory cgroups, we will have a number
> > of weird edge cases. For instance, when putting a single process into
> > the group_oom memcg will alter the oom_score significantly and result
> > in significantly different chances to be killed. An obvious example will
> > be a task with oom_score_adj set to any non-extreme (other than 0 and -1000)
> > value, but it can also happen in case of constrained alloc, for instance.
> 
> I am not sure I understand. Are you talking about root memcg comparing
> to other memcgs?

Not only, but root memcg in this case will be another complication. We can
also use the same trick for all memcg (define memcg oom_score as maximum oom_score
of the belonging tasks), it will turn group_oom into pure container cleanup
solution, without changing victim selection algorithm

But, again, I'm not against approach suggested by Johannes. I think that overall
it's the best possible semantics, if we're not taking some implementation details
into account.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
