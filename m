From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 15:25:17 -0400
Message-ID: <20150911192517.GU8114@mtj.duckdns.org>
References: <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
 <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org>
 <55F25781.20308@redhat.com>
 <20150911145213.GQ8114@mtj.duckdns.org>
 <CAG53R5X5z-H15f1FzCFFqao=taYeHyJnXAZT2mPzAHYOkyq-_Q@mail.gmail.com>
 <20150911163449.GS8114@mtj.duckdns.org>
 <CAG53R5WTK8qWrL+CPJKuKHAsR31_E18rbny1PEfLQLqU5A9hEA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=C9c0VnhkJdCFcGj4WeEPuvhHS4bHkeDYiaQAx4NZlGg=;
        b=UuDVqYuP7bF9409DN4o2E/VpTv/WbMoMBkQ9bMrNhByuzpdoz5JYnIeYfeUNN5VpQN
         oiU7H/YXbr6LPk2NSi23lM/0ZdCdZzhQQ/4EeEjKn4xLsYWbI354nvxJ2agqpRXnuEIO
         GK0uALJvtQm//Agd+dUyUHBRgrf2Y9skT9dTM95rXcN7x4PAIT6p4bT+EQ1Hx82ZXiaJ
         eRWcyj/terTl2Kq/BSAlT/+3PJnyfQ4UKvMmoB0+VWEovghpsSH37rkmEsrjqr5tHnFP
         u3UrIIyNm7pPCZAPV3Clc+zrntIUxrLP5M9k3jQKJvLdt1yIi+IPpZA4avE4EWK2BZQR
         vAvg==
Content-Disposition: inline
In-Reply-To: <CAG53R5WTK8qWrL+CPJKuKHAsR31_E18rbny1PEfLQLqU5A9hEA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

On Fri, Sep 11, 2015 at 10:09:48PM +0530, Parav Pandit wrote:
> > If you're planning on following what the existing memcg did in this
> > area, it's unlikely to go well.  Would you mind sharing what you have
> > on mind in the long term?  Where do you see this going?
>
> At least current thoughts are: central entity authority monitors fail
> count and new threashold count.
> Fail count - as similar to other indicates how many time resource
> failure occured
> threshold count - indicates upto what this resource has gone upto in
> usage. (application might not be able to poll on thousands of such
> resources entries).
> So based on fail count and threshold count, it can tune it further.

So, regardless of the specific resource in question, implementing
adaptive resource distribution requires more than simple thresholds
and failcnts.  The very minimum would be a way to exert reclaim
pressure and then a way to measure how much lack of a given resource
is affecting the workload.  Maybe it can adaptively lower the limits
and then watch how often allocation fails but that's highly unlikely
to be an effective measure as it can't do anything to hoarders and the
frequency of allocation failure doesn't necessarily correlate with the
amount of impact the workload is getting (it's not a measure of
usage).

This is what I'm awry about.  The kernel-userland interface here is
cut pretty low in the stack leaving most of arbitration and management
logic in the userland, which seems to be what people wanted and that's
fine, but then you're trying to implement an intelligent resource
control layer which straddles across kernel and userland with those
low level primitives which inevitably would increase the required
interface surface as nobody has enough information.

Just to illustrate the point, please think of the alsa interface.  We
expose hardware capabilities pretty much as-is leaving management and
multiplexing to userland and there's nothing wrong with it.  It fits
better that way; however, we don't then go try to implement cgroup
controller for PCM channels.  To do any high-level resource
management, you gotta do it where the said resource is actually
managed and arbitrated.

What's the allocation frequency you're expecting?  It might be better
to just let allocations themselves go through the agent that you're
planning.  You sure can use cgroup membership to identify who's asking
tho.  Given how the whole thing is architectured, I'd suggest thinking
more about how the whole thing should turn out eventually.

Thanks.

-- 
tejun
