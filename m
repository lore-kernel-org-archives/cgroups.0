From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv6 3/3] rdmacg: Added documentation for rdmacg
Date: Wed, 24 Feb 2016 20:51:10 +0530
Message-ID: <CAG53R5XApY76+ACGsQvuWnQcPSsUfYqD1zxn=Dq_iFShUOxZYA@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-4-git-send-email-pandit.parav@gmail.com>
	<56CDBD8B.4050503@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=2fWDnIJ7eJe2BGvURZpzhYaxeqeFbSvlDOiXW0/qkcw=;
        b=vhDm2iZup19iTGta4oJgEIeHiZJQBcfx4+wpi62oN2Eo0HCwZevcqg9vQu8aAMljIC
         KDkylDCLJZT7yGoItMWI6MGWdijgUH26J3HxLzG9cV7cs5WiLsU6vqDnoGB0I7Y6Pr7T
         BNGczNQFtjBZ6K0jU+9uNyTwlzANahRTwrSIn+SjLG34tJLRgue0Nzmeuv6qcVxS133d
         xpK0Jqof+3CSn/9/vl/LBd75FZD1DkEWEEmlUKnIF4sVFdNEbCrC/+J9qFwA8y/xaqML
         jEa1XW5fRDWSf5TaKfYhoYfPSkMUYVZpGER5nesEbIXPcfjHzTCfGrwTYO6FWHJpoG/B
         pSTg==
In-Reply-To: <56CDBD8B.4050503@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Wed, Feb 24, 2016 at 7:56 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 20/02/2016 13:00, Parav Pandit wrote:
>> Added documentation for v1 and v2 version describing high
>> level design and usage examples on using rdma controller.
>>
>> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
>
> I think you might want to mention that resource limits are reflected
> in the results returned from ib_uverbs_query_device/ibv_query_device
> or printed from "ibv_devinfo -v".
>
Its valid point.
Since this documentation is for rdma controller, I was wondering
should I have it this documentation or should I add the uverbs_cmds.c?
