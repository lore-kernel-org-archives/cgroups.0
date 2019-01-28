From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Mon, 28 Jan 2019 09:49:05 -0800
Message-ID: <20190128174905.GU50184@devbig004.ftw2.facebook.com>
References: <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
 <20190128142816.GM50184@devbig004.ftw2.facebook.com>
 <20190128145210.GM18811@dhcp22.suse.cz>
 <20190128145407.GP50184@devbig004.ftw2.facebook.com>
 <20190128151859.GO18811@dhcp22.suse.cz>
 <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RDoi/eLjxnbObU8/lFllv41Z8VtANrIPfKdXbpygwCE=;
        b=lVQH1nAeTUapo+A78necDxJ89EsWzDvsbvfeD3DQE7e36L5IebWuxztHjBVoiEnB3H
         JeYQjUy2zp7nWDkKEDHWbhMsmEV1MFDjEeVeJ8VygkmA3LoR71R+X5dLBG4+lqqUOaWi
         02xvs+8jBWBa+6eYq8LBoIGsolX6zO1GdwGD3IFAMWM8PbB4KrSsY+KxY9yeJ7jCBhY1
         0UCJptuXx2QuyCQjU/AzkD5lNtgIKEWL2Qosqrg5N6HL8+iL2cLg8oWv6QbP1rznpvTm
         cFlCvSg7b/VQb0x4QHr+rmpIWzqsN5L/045u6n82TWmN4rcvRTAXhNjm1X1Hcwgj+I2M
         YJUg==
Content-Disposition: inline
In-Reply-To: <20190128170526.GQ18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello, Michal.

On Mon, Jan 28, 2019 at 06:05:26PM +0100, Michal Hocko wrote:
> Yeah, that is quite clear. But it also assumes that the hierarchy is
> pretty stable but cgroups might go away at any time. I am not saying
> that the aggregated events are not useful I am just saying that it is
> quite non-trivial to use and catch all potential corner cases. Maybe I

It really isn't complicated and doesn't require stable subtree.

> am overcomplicating it but one thing is quite clear to me. The existing
> semantic is really useful to watch for the reclaim behavior at the
> current level of the tree. You really do not have to care what is
> happening in the subtree when it is clear that the workload itself
> is underprovisioned etc. Considering that such a semantic already
> existis, somebody might depend on it and we likely want also aggregated
> semantic then I really do not see why to risk regressions rather than
> add a new memory.hierarchy_events and have both.

The problem then is that most other things are hierarchical including
some fields in .events files, so if we try to add local stats and
events, there's no good way to add them.

Thanks.

-- 
tejun
