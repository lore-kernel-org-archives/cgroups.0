From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Wed, 16 Sep 2015 10:11:01 +0530
Message-ID: <CAG53R5VsFW+h9gU0SgidPwS7nQbyiMdShqNopbFX0=MwaFAYFw@mail.gmail.com>
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
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=eJHKJKibabAbVar64bg9VChuq8PueTWWUu2G7N8YJCQ=;
        b=K+Wxmzigz2SyRJp7m70AKOQHKW30V+AHbEHCULBzf4cliUyKGMiyJHPRVdJJ4NRdbJ
         5u+rLdN/T+HeYsvIVhJdKy/OkZDC0rp8lBRK3U5sR/GFhuXiZasfdz916GWPhodMeoQx
         2lYFTD2QxziNXCQiJQkQoERwwc5mxaAiUJiXz+1/swA3QRpNy159yUeCyabW7sX3mbyH
         8SOhkk6pwIRxx7983HfomsRvXmMevaQ7WgA2bLxFnLDC4ZMO+wGAZetnlfhybYOrKovu
         zI1MKWXQQziC6Y9IOneXhJC061Fyf4BsdRUA2uaLvj2Frb2sbSXchASfrZvJPRiMoP29
         p1uA==
In-Reply-To: <20150915034549.GA27847-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Jason, Sean, Tejun,

I am in process of defining new approach, design based on the feedback
given here for new RDMA cgroup from all of you.
I have also collected feedback from Liran yesterday and ORNL folks too.

Soon I will post the new approach, high level APIs and functionality
for review before submitting actual implementation.

Regards,
Parav Pandit

On Tue, Sep 15, 2015 at 9:15 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Sep 15, 2015 at 08:38:54AM +0530, Parav Pandit wrote:
>
>> As you precisely described, about wild ratio,
>> we are asking vendor driver (bottom most layer) to statically define
>> what the resource pool is, without telling him which application are
>> we going to run to use those pool.
>> Therefore vendor layer cannot ever define "right" resource pool.
>
> No, I'm saying the resource pool is *well defined* and *fixed* by each
> hardware.
>
> The only question is how do we expose the N resource limits, the list
> of which is totally vendor specific.
>


>> rdma cgroup will allow us to run post 512 or 1024 containers without
>> using PCIe SR-IOV, without creating any vendor specific resource
>> pools.
>
> If you ignore any vendor specific resource limits then you've just
> left open a hole, a wayward container can exhaust all others - so what
> was the point of doing all this work?
>
> Jason
