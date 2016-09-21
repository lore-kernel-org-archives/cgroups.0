From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 21 Sep 2016 10:26:45 -0400
Message-ID: <20160921142645.GB10734@htj.duckdns.org>
References: <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu>
 <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de>
 <20160911175235.GB13442@obsidianresearch.com>
 <20160912050717.GE8812@leon.nu>
 <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
 <20160915185629.GF26069@leon.nu>
 <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u0VyqJgRV+4qFQid1xMDmofHoAopWjRX8MPAykBr9nw=;
        b=ImnmBKHGzIRPZdmKjO2s0tHV2h4KOu0Lon2JnoKu+nXQIA97gfWNqCl4LhJzYGl4Hv
         26ur0FNrh99Zz+aZSCrEH1SEc3btYMxcY41z/pzoyXjffcd+shOAqZ3vQT5J+3nPdOfv
         OvNF6GyiysfZGAdh6ne31PWoFY6UZLsL1PmwBYGpVtNF8Zs7MjlWMTnkVbHbpb7bLQqX
         Bn+mF6wrg5a6QvoSTrJvGhKY1DlA4bUDmDNzDjdRW6E1nB7O+ZprjrpN7Kp8k84SXvz6
         Z8Slx3gIBJFpXrNlMUlcN3/VkoaJFo3aXzK09QGd/3GRCnR8HVT5GcvAVe7IZIRnA9gG
         Rzkg==
Content-Disposition: inline
In-Reply-To: <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, Matan Barak <matanb@mellanox.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

Hello, Parav.

On Wed, Sep 21, 2016 at 10:13:38AM +0530, Parav Pandit wrote:
> We have completed review from Tejun, Christoph.
> HFI driver folks also provided feedback for Intel drivers.
> Matan's also doesn't have any more comments.
> 
> If possible, if you can also review, it will be helpful.
> 
> I have some more changes unrelated to cgroup in same files in both the git tree.
> Pushing them now either results into merge conflict later on for
> Doug/Tejun, or requires rebase and resending patch.
> If you can review, we can avoid such rework.

My impression of the thread was that there doesn't seem to be enough
of consensus around how rdma resources should be defined.  Is that
part agreed upon now?

Thanks.

-- 
tejun
