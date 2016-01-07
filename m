From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 2/6] IB/core: Added members to support rdma cgroup
Date: Fri, 8 Jan 2016 01:10:59 +0530
Message-ID: <CAG53R5XXqkd1Xk-dQxEACc+RB_rdiwhT0bbn5GK5Aek5=9=EtA@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-3-git-send-email-pandit.parav@gmail.com>
	<20160105215656.GI5995@mtj.duckdns.org>
	<CAG53R5VVK4jhyXJT9XLFdjz-amzkLGhugvozWzoYNcBua-KsNg@mail.gmail.com>
	<20160107150756.GD29797@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=v72982kABtpMwd2srKu1cgbjkyQADSeQzQyCgxVhVqg=;
        b=osVCLidPpxW05K3IDrrvyDcBWhNCE7XXs7wa0imFoucmczlaw+cB50WecFkUsVRf1e
         L8vSKTKpA6Gd8mlQFj325Dlq8ThV3v3L6x28eZVz5n9S6Ou1JwoWsHGmTizZJZuzQUT/
         JBPcOz/+PmfBJYBviIge39ZR5oQf6lnlXLspRxAM+e3ecDBLwJOh0WsRTsZlTkszyUSs
         TCcezcFs8qalYmDQoKBOp+BsbvGBv1y2LprUVIq3UyRyViHMVOfP4XQ0RGovWuhEIpPm
         ogON7cCtDzXRkK+gIywZGF+T1wn5VBlQ4fb87FM/GogQ36iNfSeR7TXvPdUsc8B0+c82
         C0yg==
In-Reply-To: <20160107150756.GD29797-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 7, 2016 at 8:37 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Jan 07, 2016 at 04:46:19AM +0530, Parav Pandit wrote:
>> On Wed, Jan 6, 2016 at 3:26 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > On Wed, Jan 06, 2016 at 12:28:02AM +0530, Parav Pandit wrote:
>> >> Added function pointer table to store resource pool specific
>> >> operation for each resource type (verb and hw).
>> >> Added list node to link device to rdma cgroup so that it can
>> >> participate in resource accounting and limit configuration.
>> >
>> > Is there any point in splitting patches 1 and 2 from 3?
>> >
>> Patch 2 is in IB stack, so I separated that patch out from 1. That
>> makes it 3 patches.
>> If you think single patch is easier to review, let me know, I can
>> respin to have one patch for these 3 smaller patches.
>
> They don't do anything by themselves.  I think putting them into a
> single patch would be easier to review.

o.k. I will put them in single patch.

>
> Thanks.
>
> --
> tejun
