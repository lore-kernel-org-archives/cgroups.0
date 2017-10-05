From: Roman Gushchin <guro@fb.com>
Subject: Re: [v10 5/6] mm, oom: add cgroup v2 mount option for cgroup-aware
 OOM killer
Date: Thu, 5 Oct 2017 14:41:13 +0100
Message-ID: <20171005134113.GA912@castle.dhcp.TheFacebook.com>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-6-guro@fb.com>
 <20171004200453.GE1501@cmpxchg.org>
 <20171005131419.4o6qynsl2qxomekb@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Uuv2j0wfyyXgQKJ6l5niOAfeBaxHQ4xRqUMI2Qtf17s=;
 b=V5ayA9Yq8ToeVuANpe5hvBSozddbFFB+xXKD6Bg4YoXXslst4GnsSXYTe8y7N90z297/
 gk7yvVKldBs72hyfCeflTw4Vh5FryzZgG34OHCCuP5XrP0MMiZVqGnNz3f7aXFH4UviG
 9FqZY0MFjnl4wikJ05k72XG6Rfn+34j9Tbg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Uuv2j0wfyyXgQKJ6l5niOAfeBaxHQ4xRqUMI2Qtf17s=;
 b=Go2Boq7bCBaUxYajAn/oHccB0obyy6KOJsD5NIIP8edCFUZKrkMv/bPhl8QHnzq+AxI/5d+RwTTh2yTvTUI7T33G1fj9G8viUpKCqS0HB/X7I2UkNOKBZ8co+P37Q0xH/dVEvpxoVuzE6oFaewIpADJ/Bmwwyed23xqvHdfr2UQ=
Content-Disposition: inline
In-Reply-To: <20171005131419.4o6qynsl2qxomekb@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Oct 05, 2017 at 03:14:19PM +0200, Michal Hocko wrote:
> On Wed 04-10-17 16:04:53, Johannes Weiner wrote:
> [...]
> > That will silently ignore what the user writes to the memory.oom_group
> > control files across the system's cgroup tree.
> > 
> > We'll have a knob that lets the workload declare itself an indivisible
> > memory consumer, that it would like to get killed in one piece, and
> > it's silently ignored because of a mount option they forgot to pass.
> > 
> > That's not good from an interface perspective.
> 
> Yes and that is why I think a boot time knob would be the most simple
> way. It will also open doors for more oom policies in future which I
> believe come sooner or later.

So, we would rely on grub config to set up OOM policy? Sounds weird.

We use boot options, when it's hard to implement on the fly switching
(like turning on/off socket memory accounting), but here is not this case.

> 
> > On the other hand, the only benefit of this patch is to shield users
> > from changes to the OOM killing heuristics. Yet, it's really hard to
> > imagine that modifying the victim selection process slightly could be
> > called a regression in any way. We have done that many times over,
> > without a second thought on backwards compatibility:
> > 
> > 5e9d834a0e0c oom: sacrifice child with highest badness score for parent
> > a63d83f427fb oom: badness heuristic rewrite
> > 778c14affaf9 mm, oom: base root bonus on current usage
> 
> yes we have changed that without a deeper considerations. Some of those
> changes are arguable (e.g. child scarification). The oom badness
> heuristic rewrite has triggered quite some complains AFAIR (I remember
> Kosaki has made several attempts to revert it). I think that we are
> trying to be more careful about user visible changes than we used to be.
> 
> More importantly I do not think that the current (non-memcg aware) OOM
> policy is somehow obsolete and many people expect it to behave
> consistently. As I've said already, I have seen many complains that the
> OOM killer doesn't kill the right task. Most of them were just NUMA
> related issues where the oom report was not clear enough. I do not want
> to repeat that again now. Memcg awareness is certainly a useful
> heuristic but I do not see it universally applicable to all workloads.
> 
> > Let's not make the userspace interface crap because of some misguided
> > idea that the OOM heuristic is a hard promise to userspace. It's never
> > been, and nobody has complained about changes in the past.
> > 
> > This case is doubly silly, as the behavior change only applies to
> > cgroup2, which doesn't exactly have a large base of legacy users yet.
> 
> I agree on the interface part but I disagree with making it default just
> because v2 is not largerly adopted yet.

I believe that the only real regression can be caused by active using of
oom_score_adj. I really don't know how many cgroup v2 users are relying
on it (hopefully, 0).

So, personally I would prefer to have an opt-out cgroup v2 mount option
(sane new behavior for most users, 100% backward compatibility for rare
strange setups), but I don't have a very strong opinion here.

Thanks!
