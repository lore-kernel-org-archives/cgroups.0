From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 11 Sep 2016 15:34:21 +0200
Message-ID: <20160911133421.GA23384@lst.de>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com> <1472632647-1525-2-git-send-email-pandit.parav@gmail.com> <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com> <20160831211618.GA12660@htj.duckdns.org> <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com> <20160901084406.GA4115@lst.de> <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com> <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com> <20160910161442.GC29259@lst.de> <20160910170151.GA5230@obsidianresearch.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160910170151.GA5230@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Christoph Hellwig <hch@lst.de>, Matan Barak <matanb@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Sat, Sep 10, 2016 at 11:01:51AM -0600, Jason Gunthorpe wrote:
> Sadly, it isn't a step backwards, it is status quo - at least as far
> as the uapi is concerned.

Sort of, see below:

> struct mlx5_create_cq {
>         struct ibv_create_cq            ibv_cmd;
>         __u64                           buf_addr;
>         __u64                           db_addr;
>         __u32				cqe_size;
> };
> 
> struct iwch_create_cq {
>         struct ibv_create_cq ibv_cmd;
>         uint64_t user_rptr_addr;
> };
> 
> Love to hear ideas on a way forward that doesn't involve rewriting
> everything :(

We stil always have the common structure first.  And at least for
cgroups supports that's what matters.

Re the actual structures - we'll really need to make sure we

 a) expose proper userspace abi headers in the kernel for all code
    in the RDMA subsystem
 b) actually use that in the userspace components

I've posted some initial work toward a) a while ago, and once we
agree on adopting your common repo I'd really like to start through
with that work.  I think it's a pre-requisite for any major new
userspace ABI work.
