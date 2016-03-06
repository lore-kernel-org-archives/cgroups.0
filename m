From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 6 Mar 2016 10:37:56 +0200
Message-ID: <56DBEC64.6090805@mellanox.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
 <1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
 <20160302173949.GG29826@mtj.duckdns.org>
 <CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
 <CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
 <CAG53R5Wwr41Ma4AbTG==4VcOGvdO=t=be8z0Lkfq0YukuBtCzg@mail.gmail.com>
 <20160305125215.GC3567@htj.duckdns.org>
 <CAG53R5V-fhbVqZWroAkvDpgjNWchnO87G47-iXqSGg41sY1A5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NLLaneLpiRlHUWKrYsW8gOgWDZ9exCwNUW+V+e+PfSM=;
 b=FJAD6YZQr3rQGhoh2Vf/yVi2iSsRGhizHuTCMaagbLh/KOAr1qa2pEFFgjOLkCkSym8j9V/YYQwPBLEW8yNWqI1ld9HUMAN8HES/zyHjWnepyw5pA0jb2ljkBPNWgAlzN98CVL4onLUTVXf90YNllXbiG+LPGVkSoFeHvTH12+g=
In-Reply-To: <CAG53R5V-fhbVqZWroAkvDpgjNWchnO87G47-iXqSGg41sY1A5Q@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On 05/03/2016 19:20, Parav Pandit wrote:
>> > 3 is fine but resource [un]charging is not hot path?
> charge/uncharge is hot path from cgroup perspective.

Most of the resources the RDMA cgroup handles are only allocated at
the beginning of the application. The RDMA subsystem allows direct
user-space access to the devices, so most of the hot path operations
don't go through the kernel at all.

It is true though that for some applications MR registration and 
de-registration is in the hot path.

Haggai
