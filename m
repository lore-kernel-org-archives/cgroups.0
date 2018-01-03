From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] Documentation/cgroup-v1: fix outdated programming
 details
Date: Tue, 2 Jan 2018 16:37:08 -0800
Message-ID: <20180103003708.GH3668920@devbig577.frc2.facebook.com>
References: <20171229200200.18873-1-matthew.d.roper@intel.com>
 <20171229203449.GS5820@mdroper-desk.amr.corp.intel.com>
 <20180102150502.GC3668920@devbig577.frc2.facebook.com>
 <20180103001202.GX5820@mdroper-desk.amr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EEi7eazaFqrkDF0nJvy1cYESEshXmxn2ZJw3U+K/C3M=;
        b=DAXQ2j08XFWMjkUnZgC29nEFkE6VjkiAPIfPhj5+UaE8dZ96prZNlhiY/KGgfZXJVS
         R8rczNBsNiKMN48+XPD2xpPEMuzYwmTj4XnAXtNvUJc5/lr2JANr56WGsyaz/ZMC1+ev
         c8Ie/I4LrMAFwbh7sofV9c+EPkwT8UD0hjNb/30qhdRrjZ/0T4LwoA2PN6L2llTn2/IZ
         6FXjZQD6hMAnOPLAo+mc9g5Ivps0BJxsjbulGYKZ3qs/2h1MdbqI3Q2fCOpWfbiCfFD3
         0nIrgtrWPd04OBmf3883usliXjlG+eWO+4InKocDFHu0tQrlbtvyPaxDYtyvQZNka15X
         3vkg==
Content-Disposition: inline
In-Reply-To: <20180103001202.GX5820-b/RNqDZ/lqH1fpGqjiHozbKMmGWinSIL2HeeBUIffwg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Matt.

On Tue, Jan 02, 2018 at 04:12:02PM -0800, Matt Roper wrote:
> To make sure I'm understanding correctly --- you're suggesting that
> instead of using a cgroup controller to add values (priority, vram,
> etc.) as directly-accessible file nodes under a cgroup's kernfs
> directory that I instead add new driver-specific ioctls (e.g.,
> DRM_IOCTL_SET_CGROUP_PRIORITY) to programmatically update a driver
> internal cgroup=>priority mapping table?  I think that roughly matches
> what I see the bpf code doing with BPF_PROG_ATTACH in the bpf syscall.

Yes, something along that line.

> I was originally hoping for some way that a driver could add entries to
> the cgroup directory since that's easy to configure with something as
> simple as a sysv-init script (and matches how other system policy values
> will be updated).  But I guess we can write a simple userland tool to go
> with our driver that can be called from such a script.
>
> I guess the other alternative would be to try to mirror the cgroup
> hierarchy in a driver-specific sysfs or debugfs tree where we'd add our
> own value files, but that's probably more hassle than it's worth.

It really depends on whether it needs to be full-fledged resource
controller or not.  The reason bpf is that way is because it can't be
delegated and thus fits better when treated as a bpf mechanism which
also matches cgroup membership rather than the other way around.  On
the other hand, rdma is a full controller because it does fit the
resource controller model.

I have no idea what your requirements are, so I can't tell what'd fit
your use case better.  It'd be great if you can ELI5 what you have on
mind.

Thanks.

-- 
tejun
