From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/4] mm: memcontrol: fix recursive statistics correctness
 & scalabilty
Date: Fri, 12 Apr 2019 16:10:05 -0400
Message-ID: <20190412201004.GA27187@cmpxchg.org>
References: <20190412151507.2769-1-hannes@cmpxchg.org>
 <20190412151507.2769-4-hannes@cmpxchg.org>
 <CALvZod4xu10+E41YyaamigysZAnDcdA09f5m-hGd72LeJ9VmEg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KL4HVhtEWvgQo7HQOLpi2CSpq8VK+yUMixkba3uKDZg=;
        b=HGtEDNLthqGLuedDvcWcQ1HekO50r/XS7jrtBnh6XFA8NQFzosqhgjcfVaTaVT21+F
         w1q4VXl9ZZ9XnyKnnt0oXaOx+G2HR836hSnHm+9tRa5ftCZLstYd0AmiEW69ToQNXSTT
         UaeyyJp9/M8MV9kQTD8tmlwbXPv2hp1lB+mozU7oDB9/SA4wsWc68mC8tHAWkn5i+TDh
         om6ankdEU3FtXwv7KGCbZuNEApBQdcCi3mxFmA+66xv+wuiLEvVmNfZmkBNj6XwwGz4f
         ehrnYoRllpVANXpOkKs+Ru/sR8PkPWgDKm/CRtFatWXmj7YYDjE7crWKlgGZ7hnywrmM
         XVXA==
Content-Disposition: inline
In-Reply-To: <CALvZod4xu10+E41YyaamigysZAnDcdA09f5m-hGd72LeJ9VmEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On Fri, Apr 12, 2019 at 12:55:10PM -0700, Shakeel Butt wrote:
> We also faced this exact same issue as well and had the similar solution.
> 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Thanks for the review!

> (Unrelated to this patchset) I think there should also a way to get
> the exact memcg stats. As the machines are getting bigger (more cpus
> and larger basic page size) the accuracy of stats are getting worse.
> Internally we have an additional interface memory.stat_exact for that.
> However I am not sure in the upstream kernel will an additional
> interface is better or something like /proc/sys/vm/stat_refresh which
> sync all per-cpu stats.

I was talking to Roman about this earlier as well and he mentioned it
would be nice to have periodic flushing of the per-cpu caches. The
global vmstat has something similar. We might be able to hook into
those workers, but it would likely require some smarts so we don't
walk the entire cgroup tree every couple of seconds.

We haven't had any actual problems with the per-cpu fuzziness, mainly
because the cgroups of interest also grow in size as the machines get
bigger, and so the relative error doesn't increase.

Are your requirements that the error dissipates over time (waiting for
a threshold convergence somewhere?) or do you have automation that
gets decisions wrong due to the error at any given point in time?
