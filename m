From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Tue, 29 May 2018 14:16:16 -0400
Message-ID: <20180529181616.GB28689@cmpxchg.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <CAJuCfpF4q+1aSg4WQn_p-1-zEDhh-iqST6dc1DkxnDofSPBKGw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=whWvLs0+hrwq+rOR/CziIi4kC9JeSbwYxZfV4UMdwLY=; b=AneIPeL2W1AMXQjHxUgk/mkbUb
        cgpSYr4omCrAHw1KL88QgzYAV1GjA2MUR5j/fCE5rhpq0j0uLDJOPsnlNcBFrGqIeCCO/4UJ7oqnn
        GEFZQkj7GxVo7SdqWfmUQQFtDvdENJ0IXmselJY2u7UdHJM66M0/I7kI8b7AS9aPeMKU=;
Content-Disposition: inline
In-Reply-To: <CAJuCfpF4q+1aSg4WQn_p-1-zEDhh-iqST6dc1DkxnDofSPBKGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

Hi Suren,

On Fri, May 25, 2018 at 05:29:30PM -0700, Suren Baghdasaryan wrote:
> Hi Johannes,
> I tried your previous memdelay patches before this new set was posted
> and results were promising for predicting when Android system is close
> to OOM. I'm definitely going to try this one after I backport it to
> 4.9.

I'm happy to hear that!

> Would it make sense to split CONFIG_PSI into CONFIG_PSI_CPU,
> CONFIG_PSI_MEM and CONFIG_PSI_IO since one might need only specific
> subset of this feature?

Yes, that should be doable. I'll split them out in the next version.

> > The total= value gives the absolute stall time in microseconds. This
> > allows detecting latency spikes that might be too short to sway the
> > running averages. It also allows custom time averaging in case the
> > 10s/1m/5m windows aren't adequate for the usecase (or are too coarse
> > with future hardware).
> 
> Any reasons these specific windows were chosen (empirical
> data/historical reasons)? I'm worried that with the smallest window
> being 10s the signal might be too inert to detect fast memory pressure
> buildup before OOM kill happens. I'll have to experiment with that
> first, however if you have some insights into this already please
> share them.

They were chosen empirically. We started out with the loadavg window
sizes, but had to reduce them for exactly the reason you mention -
they're way too coarse to detect acute pressure buildup.

10s has been working well for us. We could make it smaller, but there
is some worry that we don't have enough samples then and the average
becomes too erratic - whereas monitoring total= directly would allow
you to detect accute spikes and handle this erraticness explicitly.

Let me know how it works out in your tests.

Thanks for your feedback.
