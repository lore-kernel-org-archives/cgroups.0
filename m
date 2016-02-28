From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCHv6 3/3] rdmacg: Added documentation for rdmacg
Date: Sun, 28 Feb 2016 10:55:06 +0200
Message-ID: <56D2B5EA.5090701@mellanox.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
 <1455966006-13774-4-git-send-email-pandit.parav@gmail.com>
 <56CDBD8B.4050503@mellanox.com>
 <CAG53R5XApY76+ACGsQvuWnQcPSsUfYqD1zxn=Dq_iFShUOxZYA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tLS3sHkUQETk+xlxknydMo0VVxO3S5pNz/hLRqCui3Y=;
 b=yOuo2eZWvZ3bJr3ldNXDRFvKRoNOGGeTu0w1WabsqKL9f0FHXGo2H9kSeTsAl1FE6W+6yo7hVlJq6BvSz2NegbKr+QUggq5R70kS2pKvJr7WcUwq7DdhN1i2Kmbk0QalZ8xEmTP3i/lI+d+vKDMOIkDQ5TF05gqhd0+BMgyMA9g=
In-Reply-To: <CAG53R5XApY76+ACGsQvuWnQcPSsUfYqD1zxn=Dq_iFShUOxZYA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On 24/02/2016 17:21, Parav Pandit wrote:
> On Wed, Feb 24, 2016 at 7:56 PM, Haggai Eran <haggaie@mellanox.com> wrote:
>> On 20/02/2016 13:00, Parav Pandit wrote:
>>> Added documentation for v1 and v2 version describing high
>>> level design and usage examples on using rdma controller.
>>>
>>> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
>>
>> I think you might want to mention that resource limits are reflected
>> in the results returned from ib_uverbs_query_device/ibv_query_device
>> or printed from "ibv_devinfo -v".
>>
> Its valid point.
> Since this documentation is for rdma controller, I was wondering
> should I have it this documentation or should I add the uverbs_cmds.c?

I was thinking it should be in the documentation because an application
developer might look there first, without reading uverbs_cmd.c.

Haggai

