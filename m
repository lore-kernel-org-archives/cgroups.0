From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Sat, 5 Mar 2016 16:45:09 +0530
Message-ID: <CAG53R5Wwr41Ma4AbTG==4VcOGvdO=t=be8z0Lkfq0YukuBtCzg@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
	<20160302173949.GG29826@mtj.duckdns.org>
	<CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
	<CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=0watGImZKn24F+BP4As8yxCDBTG8Dv8BZyV0F+vjhM8=;
        b=Sjurdtw1kDP+x1V3vb3ODNCpn7NfQe45ybzGK3HOziAABgZEPiteonYtrxWjTyxgKI
         +fBc2IcHGsrvorjvyi/UQWGMLH5ehyr2l/fjfL4a0C8U098kthIekGjpITryAXjGoRoe
         rarRnD3wsrYsw/B/ZGpI6okN/TsFPhvU5gSnSE3YBSa3M7nXMLSkam3+jbpa1ckBaWwd
         M+VhWIl6UpwtuubZRIYa0hMXn1TSJPAPRbYRxUO0GKFmu3s41u/B7daxdrFFyMve/vMg
         sSCr5DvgoUVtUOHDX+93XIMS4Bnb6Pd8BDMSVhIPD1djjRbWQRtEWVc3JGbex5k9nV+v
         XUnw==
In-Reply-To: <CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Tejun,

I would like to submit patch v10.
Can you please confirm that you are ok (or not) with the current
design and below changes should be good enough?
I am ok if you directly want to jump to review v10 too.

Changes from v9:
  * Included documentation of resources in v2.txt and v1.txt
  * Fixed issue of race condition of process migration during charging stage.
  * Fixed comments and code to adhere to CodingStyle.
  * Simplified and removed support to charge/uncharge multiple resource.
  * Fixed removed refcnt with usage_num that tracks how many
    resources are unused to trigger freeing the object.
  * Removed inline for query_limit and other function as its not necessary.

Design that remains same from v6 to v10.
  * spin lock is still fine grained at cgroup level instead of one
global shared lock among all cgroups.
     In future it can be optimized further to do per cpu or using
single lock if required.
  * file type enums are still present for max and current, as
read/write call to those files is already taken care by common
functions with required if/else.
  * Resource limit setting is as it is, because number of devices are
in range of 1 to 4 count in most use cases (as explained in
documentation), and its not hot path.

Parav



On Thu, Mar 3, 2016 at 8:19 AM, Parav Pandit <pandit.parav@gmail.com> wrote:
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
> As I think more, I realised that this particular test is missing that
> resulted in this related bug, I realize that we don't have use case to
> have "num" field from the IB stack side.
> For bulk free IB stack will have to keep track of different or same
> rdmacg returned values to call uncharge() with right number of
> resources, all of that complexity just doesn't make sense and not
> required.
> So as first step to further simplify this, I am removing "num" input
> field from charge and uncharge API.
