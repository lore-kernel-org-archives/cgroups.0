From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 11 Sep 2016 11:14:09 -0600
Message-ID: <20160911171409.GA13442@obsidianresearch.com>
References: <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
 <20160831211618.GA12660@htj.duckdns.org>
 <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
 <20160901084406.GA4115@lst.de>
 <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de>
 <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=obsidianresearch.com; s=rsa1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=Ielgf79jhG+O0lu4IrkEgAoZKtj64Du7qbun/8dZeek=;
        b=pjQihxiGHoFIgZf8RH+kMIJ7dN0/dI4wfYXUexQLT28FClB1VemkJzPHPJolt8D6q/5s/5bSUA3T2NmbLCMKQaDlL4LzYwKaMLwQ1mvhBOt0CACiYyVgoVuaEIA+nzCAgwPrBwiag1ztdm4mI/IlPVplC3Bpyy43UoWwkzbRURc=;
Content-Disposition: inline
In-Reply-To: <20160911143522.GL6415@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Matan Barak <matanb@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Sun, Sep 11, 2016 at 05:35:22PM +0300, Leon Romanovsky wrote:

> > We stil always have the common structure first.  And at least for
> > cgroups supports that's what matters.
> >
> > Re the actual structures - we'll really need to make sure we
> >
> >  a) expose proper userspace abi headers in the kernel for all code
> >     in the RDMA subsystem
> >  b) actually use that in the userspace components
> >
> > I've posted some initial work toward a) a while ago, and once we

Did it get merged? Do you have a pointer?

> > agree on adopting your common repo I'd really like to start through
> > with that work.  I think it's a pre-requisite for any major new
> > userspace ABI work.
> 
> I started to work on it over weekend and it is worth do not do same work twice.

Yes, I also agree that it is important before we tackle the uapi
conversion to get this fully sorted.

I've already done several cases working with the existing uapi headers:

https://github.com/jgunthorpe/rdma-plumbing/commit/f4f40689440dbc9c57b55548b04b15fe808a1767
https://github.com/jgunthorpe/rdma-plumbing/commit/0cf1893dce4791dafa035bcb6ee045a6ce0ff3c3
https://github.com/jgunthorpe/rdma-plumbing/commit/0522fc42aac4a5e8fc888dcca4341c9bc1dc58ca

[.. and this is a strong argument why we need the common repo, doing
this without it would be very hard, as everything is cross-linked, I
couldnn't unwind libibcm until I fixed a bit of verbs, and rdmacm can't
even include its uapi header until the duplicate definitions in the
verbs copy are delt with .. and I've also learned we are making
changing to the kernel uapi header and since nothing uses them we never even
compile test :( :( eg
https://github.com/torvalds/linux/commit/b493d91d333e867a043f7ff1397bcba6e2d0dda2]

However, everything under verbs is not straightforward. The files in
userspace are not copies...

user:

struct ibv_query_device {
       __u32 command;
       __u16 in_words;
       __u16 out_words;
       __u64 response;
       __u64 driver_data[0];
};

kernel:

struct ib_uverbs_query_device {
        __u64 response;
        __u64 driver_data[0];
};

eg the userspace version stuffs the header into the struct and the
kernel version does not. Presumably this is for efficiency so that no
copies are required when marshaling. This impacts everything :(

I'm thinking the best way forward might be to use a script and
transform userspace into:

struct ibv_query_device {
	struct ib_uverbs_cmd_hdr hdr;
	struct ib_uverbs_query_device cmd;
};

Jason
