From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Thu, 7 Sep 2017 12:14:57 -0400
Message-ID: <20170907161457.GA1728@cmpxchg.org>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-6-guro@fb.com>
 <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
 <20170905215344.GA27427@cmpxchg.org>
 <20170906082859.qlqenftxuib64j35@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eSgNZn4xPsPh3LcJB3M9CZdDYZGREr/Wc4WtkOKp+/A=; b=kfRJ4vXGJuos+kp1EcF+k4p9/8
        XU/MQoOSh3i617gSI9VoC+Q9vqnEvGnpmniYvbhUb6iwy4RPYi7eEyU7HB3cUAwmTUR/XKmX+SLaZ
        5uta6O5QuGA/EWJ4NdwdgyL2YHC6LoNfnZvKCriQyYWJTbG8l9fxMEBVw1WkIeZaLSoE=;
Content-Disposition: inline
In-Reply-To: <20170906082859.qlqenftxuib64j35@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 06, 2017 at 10:28:59AM +0200, Michal Hocko wrote:
> On Tue 05-09-17 17:53:44, Johannes Weiner wrote:
> > The cgroup-awareness in the OOM killer is exactly the same thing. It
> > should have been the default from the beginning, because the user
> > configures a group of tasks to be an interdependent, terminal unit of
> > memory consumption, and it's undesirable for the OOM killer to ignore
> > this intention and compare members across these boundaries.
> 
> I would agree if that was true in general. I can completely see how the
> cgroup awareness is useful in e.g. containerized environments (especially
> with kill-all enabled) but memcgs are used in a large variety of
> usecases and I cannot really say all of them really demand the new
> semantic. Say I have a workload which doesn't want to see reclaim
> interference from others on the same machine. Why should I kill a
> process from that particular memcg just because it is the largest one
> when there is a memory hog/leak outside of this memcg?

Sure, it's always possible to come up with a config for which this
isn't the optimal behavior. But this is about picking a default that
makes sense to most users, and that type of cgroup usage just isn't
the common case.

> From my point of view the safest (in a sense of the least surprise)
> way to go with opt-in for the new heuristic. I am pretty sure all who
> would benefit from the new behavior will enable it while others will not
> regress in unexpected way.

This thinking simply needs to be balanced against the need to make an
unsurprising and consistent final interface.

The current behavior breaks isolation by letting tasks in different
cgroups compete with each other during an OOM kill. While you can
rightfully argue that it's possible for usecases to rely on this, you
cannot tell me that this is the least-surprising thing we can offer
users; certainly not new users, but also not many/most existing ones.

> We can talk about the way _how_ to control these oom strategies, of
> course. But I would be really reluctant to change the default which is
> used for years and people got used to it.

I really doubt there are many cgroup users that rely on that
particular global OOM behavior.

We have to agree to disagree, I guess.
