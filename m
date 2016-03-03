From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 3 Mar 2016 09:51:51 +0200
Message-ID: <56D7ED17.30800@mellanox.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
 <1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
 <20160302173949.GG29826@mtj.duckdns.org>
 <CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
 <CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=eku82eni2PfEvYSw1susLMPsIVE1MP+XUK9OScTnEcg=;
 b=mLwoe69iV+A6Dlv2avBQYnzZ0lyVukQ0lPt+7c7tONT2eO+4rUCZfG02gVRswObJYCCVHH/2JlB6cMEf++qVvfK7BMQH9sGuQjGHyfD1OrpBBDFMd34pWlO0v9Wj1gVwouBI+nzYia9p03e/0Vnk15BOtptfqntw5jUU1wcFurw=
In-Reply-To: <CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>

On 03/03/2016 04:49, Parav Pandit wrote:
> Hi Tejun, Haggai,
> 
> On Thu, Mar 3, 2016 at 1:28 AM, Parav Pandit <pandit.parav@gmail.com> wrote:
>>>> +     rpool->refcnt--;
>>>> +     if (rpool->refcnt == 0 && rpool->num_max_cnt == pool_info->table_len) {
>>>
>>> If the caller charges 2 and then uncharges 1 two times, the refcnt
>>> underflows?  Why not just track how many usages are zero?
>>>
>> This is certainly must fix bug. Changed refcnt to usage_sum and changed to do
>> usage_sum -= num during uncharging
>> and
>> usage_sum += num during charing.
> 
> This is not sufficient as css_get() and put are done only once per
> call, which leads to similar problem as of refcnt.
Are css_get_many() and css_put_many() relevant here?

> As I think more, I realised that this particular test is missing that
> resulted in this related bug, I realize that we don't have use case to
> have "num" field from the IB stack side.
> For bulk free IB stack will have to keep track of different or same
> rdmacg returned values to call uncharge() with right number of
> resources, all of that complexity just doesn't make sense and not
> required.
> So as first step to further simplify this, I am removing "num" input
> field from charge and uncharge API.

IIRC there are no instances in the RDMA subsystem today where userspace
allocates more than one resource at a time.

Yishai, in your proposed RSS patchset did you have a verb to allocate
multiple work queues at once?

Haggai

