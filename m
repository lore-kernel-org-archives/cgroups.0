From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sat, 10 Sep 2016 11:01:51 -0600
Message-ID: <20160910170151.GA5230@obsidianresearch.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
 <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
 <20160831211618.GA12660@htj.duckdns.org>
 <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
 <20160901084406.GA4115@lst.de>
 <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=obsidianresearch.com; s=rsa1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=Kf5vI3QADi4DXBuWcjvE6XhGVQPwuq6Rqf+9Dk3dBsQ=;
        b=5WCEBpHiM8SdtlgFh8A/rCfH8GVRlgjzczQxHk9/ZWSdluIpxLxTTJEbTAyYSqpQfj5uVhi7BSulT9YNqr0g/ArlnQnVOrBlLoUiR1Os2nbw/H0E5eEPN5nBoWYU2HuZU3UvT6anZWh/P4xGf6qHzyhhKTTjqTrKG6nRdmt8FyQ=;
Content-Disposition: inline
In-Reply-To: <20160910161442.GC29259@lst.de>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Matan Barak <matanb@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Sat, Sep 10, 2016 at 06:14:42PM +0200, Christoph Hellwig wrote:
> OFVWG meetings have absolutely zero relevance for Linux development.

Well, to be fair there are a fair number of kernel developers on that
particular call..

> More "flexibility" for drivers just means giving up on designing a
> coherent API and leaving it to drivers authors to add crap to their
> own drivers.  That's a major step backwards.

Sadly, it isn't a step backwards, it is status quo - at least as far
as the uapi is concerned.

Every single user space driver has its own private abi file, carefully
hidden in their driver, and dutifully copied over to user space:

providers/cxgb3/iwch-abi.h
providers/cxgb4/cxgb4-abi.h
providers/hfi1verbs/hfi-abi.h
providers/i40iw/i40iw-abi.h
providers/ipathverbs/ipath-abi.h
providers/mlx4/mlx4-abi.h
providers/mlx5/mlx5-abi.h
providers/mthca/mthca-abi.h
providers/nes/nes-abi.h
providers/ocrdma/ocrdma_abi.h
providers/rxe/rxe-abi.h

Just to pick two random examples:

struct mlx5_create_cq {
        struct ibv_create_cq            ibv_cmd;
        __u64                           buf_addr;
        __u64                           db_addr;
        __u32				cqe_size;
};

struct iwch_create_cq {
        struct ibv_create_cq ibv_cmd;
        uint64_t user_rptr_addr;
};

Love to hear ideas on a way forward that doesn't involve rewriting
everything :(

> They should not be using the code in drivers/infiniband.  usnic is such
> an example of a driver that should never have been added in it's current
> form.

+1

Jason
