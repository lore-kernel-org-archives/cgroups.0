From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Mon, 28 Jan 2019 07:41:50 -0800
Message-ID: <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
References: <20190124182328.GA10820@cmpxchg.org>
 <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
 <20190128142816.GM50184@devbig004.ftw2.facebook.com>
 <20190128145210.GM18811@dhcp22.suse.cz>
 <20190128145407.GP50184@devbig004.ftw2.facebook.com>
 <20190128151859.GO18811@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wPBPoBOwIobapi6oC16zq6H6TFfwJ/3I28jXaGw7G7E=;
        b=u2H/PyOQXKHj3iK3PpnDcwvm6ncSmV+EqOAB3hUtcVKQdikPGsRkySFxZP/Ndmf/7r
         ubxpAytZAOZ4sbfd2Zwo4w1DwKJufOrluB98Eq03/6O8+a3SBvf4kJw4LbPD7oift2uK
         4eWzC4te3BWZvtS33vhNSitykED9QWq/zHWOkrC4aO+NJGY9RwfpHcA87AWSQkP8uxOx
         qLwB7xRdKYlmYE0kpTooNI0oi+jmc2KuWbVo/rUBHLnjWEDqUHcKfb/AYm6Yh5JkhJst
         90t9UPeKLs6HXbN4iJY0JPQB8PlJVJyBS0CpqXqslaBbAB9veaL8WCt3uBIbVBMviRgA
         TeAA==
Content-Disposition: inline
In-Reply-To: <20190128151859.GO18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello, Michal.

On Mon, Jan 28, 2019 at 04:18:59PM +0100, Michal Hocko wrote:
> How do you make an atomic snapshot of the hierarchy state? Or you do
> not need it because event counters are monotonic and you are willing to
> sacrifice some lost or misinterpreted events? For example, you receive
> an oom event while the two children increase the oom event counter. How
> do you tell which one was the source of the event and which one is still
> pending? Or is the ordering unimportant in general?

Hmm... This is straightforward stateful notification.  Imagine the
following hierarchy.  The numbers are the notification counters.

     A:0
   /   \
  B:0  C:0

Let's say B generates an event, soon followed by C.  If A's counter is
read after both B and C's events, nothing is missed.

Let's say it ends up generating two notifications and we end up
walking down inbetween B and C's events.  It would look like the
following.

     A:1
   /   \
  B:1  C:0

We first see A's 0 -> 1 and then start scanning the subtrees to find
out the origin.  We will notice B but let's say we visit C before C's
event gets registered (otherwise, nothing is missed).

But, no matter where you put C's event and notification, the
followings hold.

1. A's count will be different from what was seen before.
2. There will be another notification queued on A.

IOW, it's guaranteed that we'll notice and re-scan if we don't see C's
event this time.  The worst that can happen is scanning spuriously but
that's true even for local events.

This isn't a novel thing.  It's how aggregated stateful notifications
usually work (e.g. a lot of hardware interrupts behave this way).  The
notification is just saying "something might have changed here, please
take a look" and the interlocking is achieved by following specific
orders when propagating and reading the events.

> I can imagine you can live with this model, but having a hierarchical
> reporting without a source of the event just sounds too clumsy from my
> POV. But I guess this is getting tangent to the original patch.

It seems like your opinion is mostly based on misunderstanding.  Let's
keep the discussion focused on API stability.

Thanks.

-- 
tejun
