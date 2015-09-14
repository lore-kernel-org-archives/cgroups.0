From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Mon, 14 Sep 2015 15:45:05 +0530
Message-ID: <CAG53R5Vpc_D03sPTHEGd0Z_P7yF-y-GNh5xPPVX+Z4ZjECkOSg@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<20150908152340.GA13749@mtj.duckdns.org>
	<CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
	<20150910164946.GH8114@mtj.duckdns.org>
	<CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
	<20150910202210.GL8114@mtj.duckdns.org>
	<CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
	<20150911040413.GA18850@htj.duckdns.org>
	<55F25781.20308@redhat.com>
	<20150911145213.GQ8114@mtj.duckdns.org>
	<1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=KM25GW7JIups2rWAKOs8SL4ZaBXj4cmRfyixOsiMQVU=;
        b=xM0A6Z3c4xHsL6M6Oyp//JQVtEpm6RpsRzGJYBI7G0dRG7iR4Q83IQpcnzqZmxAP3s
         26BrxsXivL55+Y8ciJA8tBitipGFZ42Q+d3D9Zu+ZT//Vq2GEn6ORsJGF+3DnAzjl8up
         6ySJOd3UWGp3B3kWaPovZ+1MWj879xM7/0x/d0O5uztBlCONBJ0X96yXTZDBvENhDHzL
         sgwR2BweSRrH0jA26BAPAWF/ryp1gbwR9AtatTQZ3zA5psV18EY7CJ48tkEbaOa5N9s4
         c62VG1gun/EE1sdfcvqwgfW9iCHeeCUrsCPiCc6RDgKCGXPwO9eh9lM3kdmkuE+4PhOy
         1WZw==
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>

On Sat, Sep 12, 2015 at 12:52 AM, Hefty, Sean <sean.hefty@intel.com> wrote:
>> So, the existence of resource limitations is fine.  That's what we
>> deal with all the time.  The problem usually with this sort of
>> interfaces which expose implementation details to users directly is
>> that it severely limits engineering manuevering space.  You usually
>> want your users to express their intentions and a mechanism to
>> arbitrate resources to satisfy those intentions (and in a way more
>> graceful than "we can't, maybe try later?"); otherwise, implementing
>> any sort of high level resource distribution scheme becomes painful
>> and usually the only thing possible is preventing runaway disasters -
>> you don't wanna pin unused resource permanently if there actually is
>> contention around it, so usually all you can do with hard limits is
>> overcommiting limits so that it at least prevents disasters.
>
> I agree with Tejun that this proposal is at the wrong level of abstraction.
>
> If you look at just trying to limit QPs, it's not clear what that attempts to accomplish.  Conceptually, a QP is little more than an addressable endpoint.  It may or may not map to HW resources (for Intel NICs it does not).  Even when HW resources do back the QP, the hardware is limited by how many QPs can realistically be active at any one time, based on how much caching is available in the NIC.
>

cgroups as it stands today provides resource controls in effective
manner of existing defined resource, such as cpu cycles, memory in
user and kernel space, tcp bytes, IOPS etc.
Similarly RDMA programming model defines its own set of resources
which is used by applications which accesses those resources directly.

What we are debating here is that, RDMA exposing hardware resources is
not correct, and therefore whether a cgroup controller is needed or
not.
There are two points here.
1. Whether RDMA programming model is correct or not which works on
defined resources of IB spec.
2. Assuming that programming model is fine, (because we have actively
maintained IB stack in kernel and adoption of user space components in
OS),
whether we need to control those resources or not via cgroup.

Tejun trying to say that because point_1 is doesn't seem to be right
way to solve problem, point_2 should not be done or done at different
level of abstraction.
More questions/comments in Jason and Sean thread.

Sean,
Even though there is no one to one map of verb-QP to hw-QP, in order
for driver or lower layer to effectively map the right verb-QP to
hw-QP, such vendor specific layer needs to know how is it going to be
used. Otherwise two contending applications for a QP may not get the
right number of hw-QPs to use.

> Trying to limit the number of QPs that an app can allocate, therefore, just limits how much of the address space an app can use.  There's no clear link between QP limits and HW resource limits, unless you assume a very specific underlying implementation.
>
> - Sean
