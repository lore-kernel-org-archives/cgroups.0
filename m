From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Thu, 10 Sep 2015 12:49:46 -0400
Message-ID: <20150910164946.GH8114@mtj.duckdns.org>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pO+sjrBHkhhMr59WxeLRaLT7hhRXH4vGbmZQb5z5OOQ=;
        b=Y2kV79wgXZIsZ18zuDCjbBXw6dKbItl1KoB4UUuikRdh3ug3aUSs1bYAktvPQfBYCh
         vGmspfgcXsOLUW8+9MQeUI78D3cUWg5e4tKnIqsRz5VUQfzwCDgMq/tSFEJeHLtey/J5
         rAlVQSmrXKo7H75CPUGNXPp5bvxVQePQ7U3acO5gKo4ZqLOfB6o2S13pAL0uM9PwY+6q
         ZZr4xseu3daxFlNcaNhFhJJaEERA771N1YXsZUnJCzdgR34wKurmJLMACsl37XCn+bYP
         1yrxP93hpqDeL18kjnhVjKkPvEY6MpPXDt2W4iqA5/UW9GeLTvzWtOQ4lfXfcsrDxp6R
         CGvA==
Content-Disposition: inline
In-Reply-To: <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

On Wed, Sep 09, 2015 at 09:27:40AM +0530, Parav Pandit wrote:
> This is one old white paper, but most of the reasoning still holds true on RDMA.
> http://h10032.www1.hp.com/ctg/Manual/c00257031.pdf

Just read it.  Much appreciated.

...
> These resources include are-  QP (queue pair) to transfer data, CQ
> (Completion queue) to indicate completion of data transfer operation,
> MR (memory region) to represent user application memory as source or
> destination for data transfer.
> Common resources are QP, SRQ (shared received queue), CQ, MR, AH
> (Address handle), FLOW, PD (protection domain), user context etc.

It's kinda bothering that all these are disparate resources.  I
suppose that each restriction comes from the underlying hardware and
there's no accepted higher level abstraction for these things?

> >> This patch-set allows limiting rdma resources to set of processes.
> >> It extend device cgroup controller for limiting rdma device limits.
> >
> > I don't think this belongs to devcg.  If these make sense as a set of
> > resources to be controlled via cgroup, the right way prolly would be a
> > separate controller.
> >
> 
> In past there has been similar comment to have dedicated cgroup
> controller for RDMA instead of merging with device cgroup.
> I am ok with both the approach, however I prefer to utilize device
> controller instead of spinning of new controller for new devices
> category.
> I anticipate more such need would arise and for new device category,
> it might not be worth to have new cgroup controller.
> RapidIO though very less popular and upcoming PCIe are on horizon to
> offer similar benefits as that of RDMA and in future having one
> controller for each of them again would not be right approach.
>
> I certainly seek your and others inputs in this email thread here whether
> (a) to continue to extend device cgroup (which support character,
> block devices white list) and now RDMA devices
> or
> (b) to spin of new controller, if so what are the compelling reasons
> that it can provide compare to extension.

I'm doubtful that these things are gonna be mainstream w/o building up
higher level abstractions on top and if we ever get there we won't be
talking about MR or CQ or whatever.  Also, whatever next-gen is
unlikely to have enough commonalities when the proposed resource knobs
are this low level, so let's please keep it separate, so that if/when
this goes out of fashion for one reason or another, the controller can
silently wither away too.

> Current scope of the patch is limited to RDMA resources as first
> patch, but for fact I am sure that there are more functionality in
> pipe to support via this cgroup by me and others.
> So keeping atleast these two aspects in mind, I need input on
> direction of dedicated controller or new one.
> 
> In future, I anticipate that we might have sub directory to device
> cgroup for individual device class to control.
> such as,
> <sys/fs/cgroup/devices/
>      /char
>      /block
>      /rdma
>      /pcie
>      /child_cgroup..1..N
> Each controllers cgroup access files would remain within their own
> scope. We are not there yet from base infrastructure but something to
> be done as it matures and users start using it.

I don't think that jives with the rest of cgroup and what generic
block or pcie attributes are directly exposed to applications and need
to be hierarchically controlled via cgroup?

Thanks.

-- 
tejun
