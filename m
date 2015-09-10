From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Thu, 10 Sep 2015 17:48:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A903A0EC@ORSMSX109.amr.corp.intel.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150910164946.GH8114@mtj.duckdns.org>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Parav Pandit <pandit.parav@gmail.com>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>

> > In past there has been similar comment to have dedicated cgroup
> > controller for RDMA instead of merging with device cgroup.
> > I am ok with both the approach, however I prefer to utilize device
> > controller instead of spinning of new controller for new devices
> > category.
> > I anticipate more such need would arise and for new device category,
> > it might not be worth to have new cgroup controller.
> > RapidIO though very less popular and upcoming PCIe are on horizon to
> > offer similar benefits as that of RDMA and in future having one
> > controller for each of them again would not be right approach.
> >
> > I certainly seek your and others inputs in this email thread here
> whether
> > (a) to continue to extend device cgroup (which support character,
> > block devices white list) and now RDMA devices
> > or
> > (b) to spin of new controller, if so what are the compelling reasons
> > that it can provide compare to extension.
> 
> I'm doubtful that these things are gonna be mainstream w/o building up
> higher level abstractions on top and if we ever get there we won't be
> talking about MR or CQ or whatever.  Also, whatever next-gen is
> unlikely to have enough commonalities when the proposed resource knobs
> are this low level, so let's please keep it separate, so that if/when
> this goes out of fashion for one reason or another, the controller can
> silently wither away too.

As an attempt to abstract the hardware resources only, what these devices are exposing to apps can be viewed as command queues (RDMA QPs and SRQs), notification queues (RDMA CQs and EQs), and space in the device cache and allocated memory (RDMA MRs and AHs, maybe PDs).

If one wanted a higher level of abstraction, associations exist between these resources.  For example, command queues feed into notification queues.  Address handles are required resources to use an unconnected queue pair.

- Sean
