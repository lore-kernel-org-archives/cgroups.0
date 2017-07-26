From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm, memcg: reset low limit during memcg offlining
Date: Wed, 26 Jul 2017 08:06:46 -0400
Message-ID: <20170726120646.GA742618@devbig577.frc2.facebook.com>
References: <20170725114047.4073-1-guro@fb.com>
 <20170725120537.o4kgzjhcjcjmopzc@esperanza>
 <20170725123113.GB12635@castle.DHCP.thefacebook.com>
 <20170726083017.3yzeucmi7lcj46qd@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9w8ozCQ8h5ETqEHpsPYv8HC+W0qbBcxq/ibKWPo2Zag=;
        b=YAJ1pWZK5ndfSa+CA8Z9fUoTc1j3SsRcwYlWBpOBad93X3f3+gowTzgi1IRA4qVZa0
         WXpEWbhpf4tP+Fq9n2JRaoCVPjYLsF2bTDp+S6lef8vxBpnG+1wbuZXI721ZxkHziqlX
         VRZ2vZGfVXb43YQHXtkoXV2pOagmdLWgj9t5ykSt+El4bMRDqBP8p9ykDhFORkafexVf
         HRBXkXskLPfqnhy9/2mSMEMz+CTZNJpLahNDzqCKu7xGQt5eYvZ98d2HN7uZtFE5PtvR
         WpYRTUiYqboaSvvGbKcH50j+GSUZvD0C5qyI2n94wCoVfvqktD4TMbLju5CUtJ9EzQ26
         h46w==
Content-Disposition: inline
In-Reply-To: <20170726083017.3yzeucmi7lcj46qd@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Vladimir.

On Wed, Jul 26, 2017 at 11:30:17AM +0300, Vladimir Davydov wrote:
> > As I understand, css_reset() callback is intended to _completely_ disable all
> > limits, as if there were no cgroup at all.
> 
> But that's exactly what cgroup offline is: deletion of a cgroup as if it
> never existed. The fact that we leave the zombie dangling until all
> pages charged to the cgroup are gone is an implementation detail. IIRC
> we would "reparent" those charges and delete the mem_cgroup right away
> if it were not inherently racy.

That may be true for memcg but not in general.  Think about writeback
IOs servicing dirty pages of a removed cgroup.  Removing a cgroup
shouldn't grant it more resources than when it was alive and changing
the membership to the parent will break that.  For memcg, they seem
the same just because no new major consumption can be generated after
removal.

> The user can't tweak limits of an offline cgroup, because the cgroup
> directory no longer exist. So IMHO resetting all limits is reasonable.
> If you want to keep the cgroup limits effective, you shouldn't have
> deleted it in the first place, I suppose.

I don't think that's the direction we wanna go.  Granting more
resources on removal is surprising.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
