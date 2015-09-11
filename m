From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 19:22:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
 <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org> <55F25781.20308@redhat.com>
 <20150911145213.GQ8114@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150911145213.GQ8114@mtj.duckdns.org>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>
Cc: Parav Pandit <pandit.parav@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>

> So, the existence of resource limitations is fine.  That's what we
> deal with all the time.  The problem usually with this sort of
> interfaces which expose implementation details to users directly is
> that it severely limits engineering manuevering space.  You usually
> want your users to express their intentions and a mechanism to
> arbitrate resources to satisfy those intentions (and in a way more
> graceful than "we can't, maybe try later?"); otherwise, implementing
> any sort of high level resource distribution scheme becomes painful
> and usually the only thing possible is preventing runaway disasters -
> you don't wanna pin unused resource permanently if there actually is
> contention around it, so usually all you can do with hard limits is
> overcommiting limits so that it at least prevents disasters.

I agree with Tejun that this proposal is at the wrong level of abstraction.

If you look at just trying to limit QPs, it's not clear what that attempts to accomplish.  Conceptually, a QP is little more than an addressable endpoint.  It may or may not map to HW resources (for Intel NICs it does not).  Even when HW resources do back the QP, the hardware is limited by how many QPs can realistically be active at any one time, based on how much caching is available in the NIC.

Trying to limit the number of QPs that an app can allocate, therefore, just limits how much of the address space an app can use.  There's no clear link between QP limits and HW resource limits, unless you assume a very specific underlying implementation.

- Sean
