From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Mon, 28 Jan 2019 08:12:01 -0800
Message-ID: <20190128161201.GS50184@devbig004.ftw2.facebook.com>
References: <20190124160009.GA12436@cmpxchg.org>
 <20190124170117.GS4087@dhcp22.suse.cz>
 <20190124182328.GA10820@cmpxchg.org>
 <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <CALvZod6LFY+FYfBcAX0kLxV5KKB1-TX2cU5EDyyyjvHOtuWWbA@mail.gmail.com>
 <20190128160512.GR50184@devbig004.ftw2.facebook.com>
 <CALvZod5Rrr6ENW5yLNzniFeFmGB=mDRH+guNLmcayTX-_xDAGw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7sNEoit16a1lvfySq1HM53gTpeolqrKjGi3YRhbkM6Q=;
        b=N90p1wmW4Un144OHxTHB5bvyZ5q/P+Lb2PmLPmP3xl0nWZc/2QzaTCdkYnYkEDkSjR
         /wVrIvuYPhgsil8RMSYQPfptenZOa4gH322FL6/QQm6MLnhHPKwMvD2oK3LRE0gz4ghx
         LzhQs5Bf74L2OMermppFrL9suvGVTfnVbTtFo9/wY0lCqd7Bi5G7dGkWnDKKawjjd2eg
         c+CFgIeHtz1/fiEOj0dVxBv90ZoFn+XJQu1/1cj2xnAFrhS/SDeO7diQv9pERyfezrfG
         EvA7wPnpUWP7uOjYWjx898TLBGwk7gz/ttcXi/m5IQpgc4yKFv+zulskjicwe8WIA7Na
         ZTLQ==
Content-Disposition: inline
In-Reply-To: <CALvZod5Rrr6ENW5yLNzniFeFmGB=mDRH+guNLmcayTX-_xDAGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, kernel-team@fb.com

Hello,

On Mon, Jan 28, 2019 at 08:08:26AM -0800, Shakeel Butt wrote:
> Do you envision a separate interface/file for recursive and local
> counters? That would make notifications simpler but that is an
> additional interface.

I need to think more about it but my first throught is that a separate
file would make more sense given that separating notifications could
be useful.

Thanks.

-- 
tejun
