From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Wed, 28 Oct 2015 13:44:12 +0530
Message-ID: <CAG53R5XEvOn3atF3VS=QEbpVs6VD8ABve7h6R-t5ghHZjoRF=A@mail.gmail.com>
References: <55F25781.20308@redhat.com>
	<20150911145213.GQ8114@mtj.duckdns.org>
	<1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
	<20150911194311.GA18755@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A82373A903A5DB@ORSMSX109.amr.corp.intel.com>
	<CAG53R5XsMwnLK7L4q1mQx3_wEJNv1qthOr5TsX0o43kRWaiWrg@mail.gmail.com>
	<20150914172832.GA21652@obsidianresearch.com>
	<CAG53R5XHTv-o+pGHdw+hGgtv4N3ZkH0WTs6o_W3zK_6jAnVsNA@mail.gmail.com>
	<20150914201840.GA8764@obsidianresearch.com>
	<CAG53R5XY1q+AqJvgtK_Qd4Sai2kZX9vhDKD_2dNXpw4Gf=nz0A@mail.gmail.com>
	<20150915034549.GA27847@obsidianresearch.com>
	<55FE8C06.8010504@mellanox.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=hxEpjnYLuX0clPyLTpxOh9F29beRtfoZ6HSx65589KA=;
        b=G55sDBfrnHONdD5rR9Zxtkj2g1IE1S5A4xjTbrw4PcuOTboLvvy9hHPhLYL7/k7+HP
         Q9L3gjyL8fH7O2PFw5Au+dfblZB/zkBRN7UZzUA1luwFgFm9zhRT9i2QC0yaonMP0CCa
         Ek6T5ngMEHrJnqT3tAAGH3sgLo7CyQqYZpyE9+WvyMQnU5V83RgVBFfKMcwlPGD1DEx8
         L1qphhrx1XojhaKGFJnln94Xe1+3kOnAwKFuRqOWHGBtNBw/fLO4jtUxxr+9Zq6oge9H
         XP3i8x+9iLwTnpVyHhQ3OnDlpskUoDlGRDRNe6jjfy916Am/fUQct9u+qQFQoxBKS4oj
         CCcQ==
In-Reply-To: <55FE8C06.8010504-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

I finally got some chance and progress on redesigning rdma cgroup
controller for the most use cases that we discussed in this email
chain.
I am posting RFC and soon code in new email.

Parav


On Sun, Sep 20, 2015 at 4:05 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 15/09/2015 06:45, Jason Gunthorpe wrote:
>> No, I'm saying the resource pool is *well defined* and *fixed* by each
>> hardware.
>>
>> The only question is how do we expose the N resource limits, the list
>> of which is totally vendor specific.
>
> I don't see why you say the limits are vendor specific. It is true that
> different RDMA devices have different implementations and capabilities,
> but they all use the expose the same set of RDMA objects with their
> limitations. Whether those limitations come from hardware limitations,
> from the driver, or just because the address space is limited, they can
> still be exhausted.
>
>> Yes, using a % scheme fixes the ratios, 1% is going to be a certain
>> number of PD's, QP's, MRs, CQ's, etc at a ratio fixed by the driver
>> configuration. That is the trade off for API simplicity.
>>
>>
>> Yes, this results in some resources being over provisioned.
>
> I agree that such a scheme will be easy to configure, but I don't think
> it can work well in all situations. Imagine you want to let one
> container use almost all RC QPs as you want it to connect to the entire
> cluster through RC. Other containers can still use a single datagram QP
> to connect to the entire cluster, but they would require many address
> handles. If you force a fixed ratio of resources given to each container
> it would be hard to describe such a partitioning.
>
> I think it would be better to expose different controls for the
> different RDMA resources.
>
> Regards,
> Haggai
