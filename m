From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 10 Oct 2016 18:43:59 +0530
Message-ID: <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu> <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu> <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=nymoVVQGP0+GVgSNZKDNGKUufGWUZu4VOIkSbTfXKHE=;
        b=NXlHqGHpdKWPmo9h4wmmLsA7OYp1WgGGKvBlQleGdta7zNNKnyxeJnnSE53U5mzdym
         KsnCCCNV7atj70XI8yp2WXImc8QnEqwTFdomchu+yp+7oryxA3AT/TJodzDlOQb4S3HP
         ylsneo/WQqxVfZT2lwl8D9Di3+056KmirKYrMzbXdydC5oNssLauhUrafZ67PRNxwpJ1
         /9zBDyo8jCLxb4CDbQjiGBwn6yyGs63VdAxSqLRjNC3kdCQsJLXtjO9U/h5vqrbsrXoI
         trmxxUEChMoL5zpusHYRP+HZGHeFPtvcoWolQts0CSvQ14oNiNG3Q1558OzmmfByO+oT
         eA4Q==
In-Reply-To: <20161010122545.GA27360-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Tejun,

On Mon, Oct 10, 2016 at 5:55 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Mon, Oct 10, 2016 at 11:59:45AM +0530, Parav Pandit wrote:
>> >> Weight can be in range of 1 to 10,000 similar to cpu cgroup.
>> >
>> > This is exactly what I don't like, the percentage will remove from the
>> > user the translation needs between weight and actual limitation.
>> >
>> > IMHO CPU used weights because everything there is in weights :).
>>
>> I admit weight are not very intuitive, I was aligning to the existing
>> other cgroup interfaces which achieves similar functionality.
>> I will let Tejun approve the "percentage" or "ratio" new file
>> interface as its little different than weight.
>
> So, if there is gonna be a proportional control mechanism, it should
> use the same interface convention as other proportional controls.
Thats what I was suggesting to Leon.

> Also, I don't get what you mean by using percentage and when people
> brought up this idea, it always has been stemming from
> misunderstanding.  Can you please elaborate how percentage based
> proportional control would work?  What would 100% mean when cgroups
> can come and go?
When 100% is given to one cgroup, all resources of all type can be
charged by processes of that cgroup.
Resources are stateful resource. So when cgroup goes away, they go
back to global pool (or hw).
Giving 100% to two cgroups is configuration error anyway (or without config).

>
> If you're suggesting expressing absolute limits in terms of
> percentage, that is not proportional control.  That's just using a
> different unit for absolute resource limits and it must not be called
> weight.
>
>> weight or percentage helps in abstracting as starting point. So I like
>> to add it too.
>
> Way back, when rdmacg was proposed first, I asked the same question -
> whether there can be a higher level abstraction for rdma resources,
> and, IIRC, the collective answer was that the there can be no
> universal measure of resources in the kernel because a large part of
> resource management actually takes place in userspace.
>
Yes. This still holds true. I don't think anything changed.
proportional knob by kernel provides constrained know of equally
distribute all type of resources.
This works only on one class of application. Thats the primary reason
we had knob for verb level well defined resource.

(Which is subset of what patchv12 had to offer, where such
configuration can be done by the user space).

What is not part of patchv12 is - currently max limit is configured as
"max", instead of real max value.
Due to which user space tool is unable to configure exact value to
program to achieve functionality of ratio.
This new functionality can be done post this patch as this is
incremental functionality for user space tools.

As you know weight configuration allows automatic increase/decrease of
resource to other cgroups when one of them go away, as opposed to
absolute value. How this is going to work in exact terms for stateful
resource, we don't know yet. I haven't though through the design
either from kernel side. So just started exploring if weight interface
can be leveraged.

> If I misunderstood, please correct me but what's being suggested here
> seems to be implementing the knob in rdamcg and letting the specific
> drivers worry about the actual resource provisioning and even then
> there doesn't seem to be a clear way of semantically defining what
> ratios would mean.

Nop. Thats not true.
(a) Every new resource has to be defined in cgroup_rdma.h
(b) charge()/uncharge() has to happen by the cgroup for each.
(c) Letting drivers do will make things fall apart. There are no APIs
exposed either to let drivers know process cgroup either. There is no
intention either.

(d) ratio means -if adapter has
100 resources of type - A,
80 resource of type - B,

10% for cgroup-1 means,
10 resource of type - A
8 resource of type - B

>
> Let's please first establish what the resource control would exactly
> mean.
>
> Thanks.
>
> --
> tejun
