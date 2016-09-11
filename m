From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 11 Sep 2016 19:24:45 +0200
Message-ID: <20160911172445.GA25953@lst.de>
References: <20160831211618.GA12660@htj.duckdns.org> <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com> <20160901084406.GA4115@lst.de> <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com> <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com> <20160910161442.GC29259@lst.de> <20160910170151.GA5230@obsidianresearch.com> <20160911133421.GA23384@lst.de> <20160911143522.GL6415@leon.nu> <20160911171409.GA13442@obsidianresearch.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160911171409.GA13442@obsidianresearch.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>, Matan Barak <matanb@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Sun, Sep 11, 2016 at 11:14:09AM -0600, Jason Gunthorpe wrote:
> > > We stil always have the common structure first.  And at least for
> > > cgroups supports that's what matters.
> > >
> > > Re the actual structures - we'll really need to make sure we
> > >
> > >  a) expose proper userspace abi headers in the kernel for all code
> > >     in the RDMA subsystem
> > >  b) actually use that in the userspace components
> > >
> > > I've posted some initial work toward a) a while ago, and once we
> 
> Did it get merged? Do you have a pointer?

http://www.spinics.net/lists/linux-rdma/msg31958.html

> this without it would be very hard, as everything is cross-linked, I
> couldnn't unwind libibcm until I fixed a bit of verbs, and rdmacm can't
> even include its uapi header until the duplicate definitions in the
> verbs copy are delt with .. and I've also learned we are making
> changing to the kernel uapi header and since nothing uses them we never even
> compile test :( :( eg
> https://github.com/torvalds/linux/commit/b493d91d333e867a043f7ff1397bcba6e2d0dda2]

> However, everything under verbs is not straightforward. The files in
> userspace are not copies...
> 
> user:
> 
> struct ibv_query_device {
>        __u32 command;
>        __u16 in_words;
>        __u16 out_words;
>        __u64 response;
>        __u64 driver_data[0];
> };
> 
> kernel:
> 
> struct ib_uverbs_query_device {
>         __u64 response;
>         __u64 driver_data[0];
> };

We'll obviously need different strutures for the libibvers API
and the kernel interface in this case, and we'll need to figure out
how to properly translate them.  I think a cast, plus compile time
type checking ala BUILD_BUG_ON is the way to go.

> eg the userspace version stuffs the header into the struct and the
> kernel version does not. Presumably this is for efficiency so that no
> copies are required when marshaling. This impacts everything :(
> 
> I'm thinking the best way forward might be to use a script and
> transform userspace into:
> 
> struct ibv_query_device {
> 	struct ib_uverbs_cmd_hdr hdr;
> 	struct ib_uverbs_query_device cmd;
> };

That would break the users of the interface.  However automatically
generating the user ABI from the kernel one might still be a good idea
in the long run.
