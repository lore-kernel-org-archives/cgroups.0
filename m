From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 20:06:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A903A5DB@ORSMSX109.amr.corp.intel.com>
References: <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
 <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org> <55F25781.20308@redhat.com>
 <20150911145213.GQ8114@mtj.duckdns.org>
 <1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
 <20150911194311.GA18755@obsidianresearch.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150911194311.GA18755@obsidianresearch.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>, Parav Pandit <pandit.parav@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>

> > Trying to limit the number of QPs that an app can allocate,
> > therefore, just limits how much of the address space an app can use.
> > There's no clear link between QP limits and HW resource limits,
> > unless you assume a very specific underlying implementation.
> 
> Isn't that the point though? We have several vendors with hardware
> that does impose hard limits on specific resources. There is no way to
> avoid that, and ultimately, those exact HW resources need to be
> limited.

My point is that limiting the number of QPs that an app can allocate doesn't necessarily mean anything.  Is allocating 1000 QPs with 1 entry each better or worse than 1 QP with 10,000 entries?  Who knows?

> If we want to talk about abstraction, then I'd suggest something very
> general and simple - two limits:
>  '% of the RDMA hardware resource pool' (per device or per ep?)
>  'bytes of kernel memory for RDMA structures' (all devices)

Yes - this makes more sense to me.

