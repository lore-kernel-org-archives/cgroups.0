From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Sat, 5 Mar 2016 07:52:15 -0500
Message-ID: <20160305125215.GC3567@htj.duckdns.org>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
 <1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
 <20160302173949.GG29826@mtj.duckdns.org>
 <CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
 <CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
 <CAG53R5Wwr41Ma4AbTG==4VcOGvdO=t=be8z0Lkfq0YukuBtCzg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TX4avEmPp6oPs8kplQyDMr6vI+smnReiQ1/0BqcGnAQ=;
        b=FqbY3QK3Fmi9QuIgWR5Lglrla1fB99E90I1hdYKVbUSKSSu8aNNLPKQ5XQx6+wWszn
         b6AQD1ztIJ4IgW6GJOB/BtJg+8R8cJGJgEeHVrr08+kSshoRMQ60EnP29TZH87xOA8CX
         8in2zFHCQz8+ezQBwNUFlwhROpOEsfCK+rNT3zv7Afh0TqWQARvL0qW9cFDf+KpdBYAw
         8MQWBf6F32CR8Y+7G0+JOSTFr4WkQCiO5ckxIKMoFgYoJqheGFu0l08wQ8qrtrSXdtav
         5C6ZLY7FRhtHL8CZE1/slx6QZHnBuhUC7Xeo71W/GR8pAVR9crhmIq2Yth2yBZQGaI5N
         150Q==
Content-Disposition: inline
In-Reply-To: <CAG53R5Wwr41Ma4AbTG==4VcOGvdO=t=be8z0Lkfq0YukuBtCzg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

On Sat, Mar 05, 2016 at 04:45:09PM +0530, Parav Pandit wrote:
> Design that remains same from v6 to v10.
>   * spin lock is still fine grained at cgroup level instead of one
> global shared lock among all cgroups.
>      In future it can be optimized further to do per cpu or using
> single lock if required.
>   * file type enums are still present for max and current, as
> read/write call to those files is already taken care by common
> functions with required if/else.
>   * Resource limit setting is as it is, because number of devices are
> in range of 1 to 4 count in most use cases (as explained in
> documentation), and its not hot path.

1 and 2 are not okay.  3 is fine but resource [un]charging is not hot
path?

Thanks.

-- 
tejun
