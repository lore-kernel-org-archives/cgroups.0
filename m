From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 11 Sep 2016 11:52:35 -0600
Message-ID: <20160911175235.GB13442@obsidianresearch.com>
References: <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
 <20160901084406.GA4115@lst.de>
 <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de>
 <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu>
 <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=obsidianresearch.com; s=rsa1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=HMFZ6kuGejTxkcjrT+Fi+/XahPZNuOzvpqT8YS3xGNE=;
        b=u2Ew+0O1l7OHbrvfPCJuaoqEPOLpczDu3ZaT73L+D96lHp/izNxyD3MPDkfpqH7VNBCgaT9LdkdsFzEBUDxbSHeVleN684V08lBdOpE+lyYbvWy9caBpT6mYNRFW9TkRyp0dst2BD6jUPfQagFPFq2f/E6GC5gUoYP25puxObiY=;
Content-Disposition: inline
In-Reply-To: <20160911172445.GA25953@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>, Matan Barak <matanb@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Sun, Sep 11, 2016 at 07:24:45PM +0200, Christoph Hellwig wrote:
> > > > I've posted some initial work toward a) a while ago, and once we
> > 
> > Did it get merged? Do you have a pointer?
> 
> http://www.spinics.net/lists/linux-rdma/msg31958.html

Right, I remember that. Certainly the right direction

> > However, everything under verbs is not straightforward. The files in
> > userspace are not copies...
> > 
> > user:
> > 
> > struct ibv_query_device {
> >        __u32 command;
> >        __u16 in_words;
> >        __u16 out_words;
> >        __u64 response;
> >        __u64 driver_data[0];
> > };
> > 
> > kernel:
> > 
> > struct ib_uverbs_query_device {
> >         __u64 response;
> >         __u64 driver_data[0];
> > };
> 
> We'll obviously need different strutures for the libibvers API
> and the kernel interface in this case, and we'll need to figure out
> how to properly translate them.  I think a cast, plus compile time
> type checking ala BUILD_BUG_ON is the way to go.

I'm not sure I follow, which would I cast?

BUILD_BUG_ON(sizeof(ibv_query_device) == sizeof(ib_uverbs_cmd_hdr) +
             sizeof(ib_uverbs_query_device))

?

> > I'm thinking the best way forward might be to use a script and
> > transform userspace into:
> > 
> > struct ibv_query_device {
> > 	struct ib_uverbs_cmd_hdr hdr;
> > 	struct ib_uverbs_query_device cmd;
> > };
> 
> That would break the users of the interface.

Sorry, I mean doing this inside rdma-plumbing. Since the change is ABI
identical the modified libibverbs would still be binary compatible
with all providers but not source compatible. Since all kernel
supported providers are in rdma-plumbing we can add the '.cmd.' at the
same time.

The kernel uapi header would stay the same.

> However automatically generating the user ABI from the kernel one
> might still be a good idea in the long run.

My preference would be to try and use the kernel headers directly.

Jason
