From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv1 3/6] rdmacg: implements rdma cgroup
Date: Fri, 8 Jan 2016 02:09:23 +0530
Message-ID: <CAG53R5UuCNwCKWAuub=n3FkJR6Z5oyF6cVPeW=5nk-JrURY=jw@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
	<20160105220128.GJ5995@mtj.duckdns.org>
	<CAG53R5UjsDa+JK_afrQ5pMpiDPrc+a+yCOOH3X105pTmU_a53A@mail.gmail.com>
	<20160107152936.GE29797@mtj.duckdns.org>
	<CAG53R5Vg9jULp9EU23yd+iUqMDyTMNmUycD8ygX_j98O=JUDmA@mail.gmail.com>
	<20160107202818.GF1898@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=IiZe/aUar3Y6I0sDuz6XhQ+9TTDvzWIXA07+uWWXSw0=;
        b=NwGvtdL7lYmqRrbYkYmZvURRD9D63GXkPaUPIWrn57A8xRO8QX3WUZqhTN/O1bJOlH
         iDQAA3B2dduGG2mvygrt2rSbD0yFMgUf2XpucmBQ8yL65GqpWwTfvn7Eyp8FGR1UcLat
         85W0FsAdmvYS04xlV8AaxgJsGzEYF21JMlH99ZLz8fQlXMaXZ6O9ADrRZ/vKjsJI7WdR
         2sEKkT7DAsAfxYhczxGP2nJ0Bt/GJQ6Y74Zd/tpPK3mReHUESdgfI+R46TZvDTG6wmTa
         /L5BzZb1BAvVkXrGWpTXmMW5LoWr7cmHo5z5ih5ncMJg9HJPaAsrhmR+ea4lxoW8fLYT
         1BgQ==
In-Reply-To: <20160107202818.GF1898@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Fri, Jan 8, 2016 at 1:58 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Parav.
>
> On Fri, Jan 08, 2016 at 01:55:09AM +0530, Parav Pandit wrote:
> ...
>> Above functionality is achieved, by maintaining the map this tgid and
>> associated original cgroup at try_charge(), uncharge() time.
>
> Hmmm, what happens after the following?
>
> 1. A process allocates some rdma resources and get registered on the
>    hash table.
>
> 2. The process gets migrated to a different cgroup.
>
> 3. The process allocates more rdma resources.
>
> Which cgroup would the resources from #3 be attributed to?

Since the pid/tgid of the process doesn't change in step_3, it
allocates from original cgroup of step_1.

However in next patch V2, as described below, since IB resource will
store rdma_cg pointer,
in step_3, new resource will be allocated from new cgroup.
old resource will be freed from older cgroup.
This is what you are expecting, right?


>
>> In alternate method,
>> Its simple to store the pointer of rdma_cgroup structure in the IB
>> resource structure and hold on reference count to rdma_cgroup.
>> so that when its freed, uncharge_resource can accept rdma_cgroup
>> structure pointer.
>
> That'd be a lot more in line with how other controllers behave.
>

> Thanks.
>
> --
> tejun
