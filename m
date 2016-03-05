From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Sat, 5 Mar 2016 22:50:31 +0530
Message-ID: <CAG53R5V-fhbVqZWroAkvDpgjNWchnO87G47-iXqSGg41sY1A5Q@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
	<20160302173949.GG29826@mtj.duckdns.org>
	<CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
	<CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
	<CAG53R5Wwr41Ma4AbTG==4VcOGvdO=t=be8z0Lkfq0YukuBtCzg@mail.gmail.com>
	<20160305125215.GC3567@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=OoMC/mtoPnWofxK9+Rm2XA7nTmqKZNOl4nLgS4OZkE0=;
        b=SpZ4TQTy71vIDFYn0Ymj1d7NZRooOKG2DxsgJjADS/fRbmBwHhNsTTrf9/piDPpS2E
         vw+3varBkfHTmBOrscXVui2nMe+fysP8A50FR9Q8Pnn/1yF6nud2001WdkCXZvokhuRV
         NIuPmDnwTb6+N3JRJn+rvDRasTkFSlbZKIYHFsE0iV+bvvwjRdLmttVpKHAzjEuR841G
         0v/Reusg/hZOMJB401UVzpYBwvV5zp+ZASrNzdZ290lZflE+Uro6BQBJXTUXM4UJOtqc
         keX5+lf/9b+xu1xDckzKC8c17+NJEgcbhA2u+V8Wb/Oj1dfDbS7kl4wdkCKmZMoIZSWB
         Z5UA==
In-Reply-To: <20160305125215.GC3567@htj.duckdns.org>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Tejun,

On Sat, Mar 5, 2016 at 6:22 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Parav.
>
> On Sat, Mar 05, 2016 at 04:45:09PM +0530, Parav Pandit wrote:
>> Design that remains same from v6 to v10.
>>   * spin lock is still fine grained at cgroup level instead of one
>> global shared lock among all cgroups.
>>      In future it can be optimized further to do per cpu or using
>> single lock if required.
>>   * file type enums are still present for max and current, as
>> read/write call to those files is already taken care by common
>> functions with required if/else.
>>   * Resource limit setting is as it is, because number of devices are
>> in range of 1 to 4 count in most use cases (as explained in
>> documentation), and its not hot path.
>
> 1 and 2 are not okay.
For (1) shall I have one spin lock that is uses across multiple
hierarchy and multiple cgroup.
Essentially one global lock among all cgroup. During hierarchical
charging, continue to use same lock it at each level.
Would that work in this first release?

Can you please review the code for (2), I cannot think of any further
helper functions that I can write.
For both the file types, all the code is already common.
file types are used only to find out whether to reference max variable
or usage variable in structure.
Which can also be made as array, but I do not want to lose the code
readability for that little gain.
What exactly is the issue in current implementation? You just
mentioned that "its not good sign".
Its readable, simple and serves the purpose, what am I missing?

> 3 is fine but resource [un]charging is not hot path?
charge/uncharge is hot path from cgroup perspective.
Considering 1 to 4 devices in system rpool list would grow upto 4
entry deep at each cgroup level.
I believe this is good enough to start with. O complexity wise its
O(N). where N is number of devices in system.


>
> Thanks.
>
> --
> tejun
