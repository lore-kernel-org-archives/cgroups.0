From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Mon, 14 Sep 2015 15:48:51 +0530
Message-ID: <CAG53R5VuBHLud0bXQmhHsDZ9oPdaEgK4P9MCKV9ARA0vrqOhsA@mail.gmail.com>
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
	<20150911192517.GU8114@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=73Kf2z/fUp/+maNHDAyCnS7RP797O7Sana/BT7BqU18=;
        b=fiXUFldHkfHzOtx50bt23rxEEt6irrGGzs0a7IJu4Hech9MR9ECR4MWE+kV0BCHerX
         yrxUZA/pJq5EdVMu7gze8F99E2QpeEU4kMqZCXASodl686MeGgUHCCz4xkuvc9c2EAyx
         k6ypzHSkcxAZc1nP3MZ2bTjmzqh6eduYD5Zf1o/1wiOHXhzWFQJLLv+RraVEB0Af978e
         GjtoO3eLwzFELADyF+oQJHPc6lPpJKsh2wJ65gF8JpXuYYnsyAyKnG/dH0utu8b6lBLu
         uAvhtUWRSoNL6wIKyTBu7fD2mnb/LgyXmxeVkMolSpIIRRF8eWjUsivTmjlRyVLr1XxX
         T+ZA==
In-Reply-To: <20150911192517.GU8114-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Sep 12, 2015 at 12:55 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Fri, Sep 11, 2015 at 10:09:48PM +0530, Parav Pandit wrote:
>> > If you're planning on following what the existing memcg did in this
>> > area, it's unlikely to go well.  Would you mind sharing what you have
>> > on mind in the long term?  Where do you see this going?
>>
>> At least current thoughts are: central entity authority monitors fail
>> count and new threashold count.
>> Fail count - as similar to other indicates how many time resource
>> failure occured
>> threshold count - indicates upto what this resource has gone upto in
>> usage. (application might not be able to poll on thousands of such
>> resources entries).
>> So based on fail count and threshold count, it can tune it further.
>
> So, regardless of the specific resource in question, implementing
> adaptive resource distribution requires more than simple thresholds
> and failcnts.

May be yes. Buts in difficult to go through the whole design to shape
up right now.
This is the infrastructure getting build with few capabilities.
I see this as starting point instead of end point.

> The very minimum would be a way to exert reclaim
> pressure and then a way to measure how much lack of a given resource
> is affecting the workload.  Maybe it can adaptively lower the limits
> and then watch how often allocation fails but that's highly unlikely
> to be an effective measure as it can't do anything to hoarders and the
> frequency of allocation failure doesn't necessarily correlate with the
> amount of impact the workload is getting (it's not a measure of
> usage).

It can always kill the hoarding process(es), which is holding up the
resources without using it.
Such processes will eventually will get restarted but will not be able
to hoard so much because its been on the radar for hoarding and its
limits have been reduced.

>
> This is what I'm awry about.  The kernel-userland interface here is
> cut pretty low in the stack leaving most of arbitration and management
> logic in the userland, which seems to be what people wanted and that's
> fine, but then you're trying to implement an intelligent resource
> control layer which straddles across kernel and userland with those
> low level primitives which inevitably would increase the required
> interface surface as nobody has enough information.
>
We might be able to get the information as we go along.
Such arbitration and management layer outside (instead of inside) has
more visibility into multiple systems which are part of single cluster
and processes are spreaded across cgroup in each such system.
While a logic inside can manage just a manage a process of single node
which are using multiple cgroups.

> Just to illustrate the point, please think of the alsa interface.  We
> expose hardware capabilities pretty much as-is leaving management and
> multiplexing to userland and there's nothing wrong with it.  It fits
> better that way; however, we don't then go try to implement cgroup
> controller for PCM channels.  To do any high-level resource
> management, you gotta do it where the said resource is actually
> managed and arbitrated.
>
> What's the allocation frequency you're expecting?  It might be better
> to just let allocations themselves go through the agent that you're
> planning.
In that case we might need to build FUSE style infrastructure.
Frequency for RDMA resource allocation is certainly less than read/write calls.

> You sure can use cgroup membership to identify who's asking
> tho.  Given how the whole thing is architectured, I'd suggest thinking
> more about how the whole thing should turn out eventually.
>
Yes, I agree.
At this point, its software solution to provide resource isolation in
simple manner which has scope to become adaptive in future.

> Thanks.
>
> --
> tejun
