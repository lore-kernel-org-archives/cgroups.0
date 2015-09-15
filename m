From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Mon, 14 Sep 2015 21:45:49 -0600
Message-ID: <20150915034549.GA27847@obsidianresearch.com>
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
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=obsidianresearch.com; s=rsa1;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=qtb7c9eVgL4NbR1AVI2AKkOVEV35ao9/5PfyV8hJSow=;
	b=vgSO5NqLwKbiyKT/8MWsKfaIW/E+JojFWwkY6GR5U+JPfkgyBX80bBuwxU6FrgZv8LX6B7P0dvgBgYQv4xFDjRWV3CYFY82FfdjjlGe/hNe3bEWqcNc1dwJ/Z6LzCUedTC5SB0Y37wgq4iU7xp09MXOJxMBR3dt22alqqfw9j9A=;
Content-Disposition: inline
In-Reply-To: <CAG53R5XY1q+AqJvgtK_Qd4Sai2kZX9vhDKD_2dNXpw4Gf=nz0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Sep 15, 2015 at 08:38:54AM +0530, Parav Pandit wrote:

> As you precisely described, about wild ratio,
> we are asking vendor driver (bottom most layer) to statically define
> what the resource pool is, without telling him which application are
> we going to run to use those pool.
> Therefore vendor layer cannot ever define "right" resource pool.

No, I'm saying the resource pool is *well defined* and *fixed* by each
hardware.

The only question is how do we expose the N resource limits, the list
of which is totally vendor specific.

Yes, using a % scheme fixes the ratios, 1% is going to be a certain
number of PD's, QP's, MRs, CQ's, etc at a ratio fixed by the driver
configuration. That is the trade off for API simplicity.

Yes, this results in some resources being over provisioned.

I have no idea if that is usable for the workloads people want to run..

But *there is no middle option*. Either each and every single hardware
limited resources has a dedicated per-container limit, or they are
*somehow* bundled and the ratios become fixed.

If Tejun says we can't have something so emphemeral as a vendor
specific list of hardware resource pools - then what choice is
left?

> Instead of bringing such complex solution, that affecting all the
> layers which solves the same problem as this patch,
> its better to keep definition of "bundle" in the user
> library/application deployment engine.
> where bundle is set of those resources.

The kernel has to do the restriction, so at some point you are telling
the kernel to limit each and every unique resource the HW has, which
is back to the original patch set, munging how the data is passed
makes no difference to the basic objection, IMHO.

> rdma cgroup will allow us to run post 512 or 1024 containers without
> using PCIe SR-IOV, without creating any vendor specific resource
> pools.

If you ignore any vendor specific resource limits then you've just
left open a hole, a wayward container can exhaust all others - so what
was the point of doing all this work?

Jason
