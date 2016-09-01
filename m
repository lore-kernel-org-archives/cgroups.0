From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 1 Sep 2016 10:44:06 +0200
Message-ID: <20160901084406.GA4115@lst.de>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com> <1472632647-1525-2-git-send-email-pandit.parav@gmail.com> <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com> <20160831211618.GA12660@htj.duckdns.org> <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matan Barak <matanb@mellanox.com>
Cc: Tejun Heo <tj@kernel.org>, Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Thu, Sep 01, 2016 at 10:25:40AM +0300, Matan Barak wrote:
> Well, if I recall, the reason doing so last time was in order to allow 
> flexible updating of ib_core independently, which is obviously not a good 
> reason (to say the least).
>
> Since the new ABI will probably define new object types (all recent 
> proposals go this way), the current approach could lead to either trying to 
> map new objects to existing cgroup resource types, which could lead to some 
> weird non 1:1 mapping, or having a split definitions - such that each 
> driver will declare its objects both in the cgroups mechanism and in its 
> driver dispatch table.
> Even worse than that, drivers could simply ignore the cgroups support while 
> implementing their own resource types and get a very broken containers 
> support.

Sorry guys, but arbitrary extensibility for something not finished is the
worst idea ever.  We have two options here:

 a) delay cgroups support until the grand rewrite is done
 b) add it now and deal with the consequences later

That being said, adding random non-Verbs hardwasre to the RDMA core is
the second worst idea ever.  Guess I need to catch up with the
discussion and start using the flame thrower.
