From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 31 Aug 2016 17:16:18 -0400
Message-ID: <20160831211618.GA12660@htj.duckdns.org>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
 <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YXurt5dd+HUYafD8yAE8jYy5yWGR88hbCDJ+CZJYMc4=;
        b=YS+Kg9brg3Zd7rdUdz9JAfjll0kaQQKICO8fx/l8Fb+NTl+6weig9p95+IjEJF+r6d
         j9bKT3uQ5HtWNTyduNKpahkiz+yUsrmXsxxqswgiuEBDRXHWXPkAJk+Je6ingeM9kpAB
         teDF2Yb/PJGBNcUQUFWs9EZUkx87eri7hruyCaB1Rbc7uzi/ZdWcyxhhedhOZXcYR968
         jVgg9USp7mk9nTR+fr/nrWNL7VySe4aWxxCjoINDgKj5yqt3ys6ZYL2iQawV7z6zCAZk
         FLweT7RZL4eICAMo/GEFjsU2eN0HqH+XRCFWStLaUN4JceQpGgHFDBPb1JYdCqjSnvD+
         boBA==
Content-Disposition: inline
In-Reply-To: <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matan Barak <matanb@mellanox.com>
Cc: Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello,

On Wed, Aug 31, 2016 at 06:07:30PM +0300, Matan Barak wrote:
> Currently, there are some discussions regarding the RDMA ABI. The current
> proposed approach (after a lot of discussions in the OFVWG) is to have
> driver dependent object types rather than the fixed set of IB object types
> we have today.
> AFAIK, some vendors might want to use the RDMA subsystem for a different
> fabrics which has a different set of objects.
> You could see RFCs for such concepts both from Mellanox and Intel on the
> linux-rdma mailing list.
> 
> Saying that, maybe we need to make the resource types a bit more flexible
> and dynamic.

That'd be back to square one and Christoph was dead against it too,
so...

Thanks.

-- 
tejun
