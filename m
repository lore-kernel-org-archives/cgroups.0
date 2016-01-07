From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 2/6] IB/core: Added members to support rdma cgroup
Date: Thu, 7 Jan 2016 10:07:56 -0500
Message-ID: <20160107150756.GD29797@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-3-git-send-email-pandit.parav@gmail.com>
 <20160105215656.GI5995@mtj.duckdns.org>
 <CAG53R5VVK4jhyXJT9XLFdjz-amzkLGhugvozWzoYNcBua-KsNg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3NFIt0CDSlKFCOjmN/UI2TXf/Va3yYMC9mrFujd2WtA=;
        b=dSb8d8taE0BP6fi4D0iGFsNdbPFgX42dljxMFSbF6swPQNiMNA7jvh6X/iPj4Dc9NR
         DF0N2hSHG1lknPrwpSyPXbut0G2ai0RwS7yR8xHkK9fxK6KxeNybSFPKae+ZEWW2XX9M
         /EmNcbhhoLrZkcmpBsV515nP+91Uq5+Yy1wB60/SYiGBtbeUOo3kMKkUwiGVSQ/QOhFq
         tgKAROOcI1ZpTZiJliGd2KbvVT6ZpWdyHqlP4VOwnk7YutTethyJ9jnS4igB1RpbFPsQ
         bnkoATrBGy1114/Nkis6Tc1h62CnBQmEMcv4qWAieituZAqmVLqPPwMwxoX9SsWxxZaN
         KRmg==
Content-Disposition: inline
In-Reply-To: <CAG53R5VVK4jhyXJT9XLFdjz-amzkLGhugvozWzoYNcBua-KsNg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Thu, Jan 07, 2016 at 04:46:19AM +0530, Parav Pandit wrote:
> On Wed, Jan 6, 2016 at 3:26 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Wed, Jan 06, 2016 at 12:28:02AM +0530, Parav Pandit wrote:
> >> Added function pointer table to store resource pool specific
> >> operation for each resource type (verb and hw).
> >> Added list node to link device to rdma cgroup so that it can
> >> participate in resource accounting and limit configuration.
> >
> > Is there any point in splitting patches 1 and 2 from 3?
> >
> Patch 2 is in IB stack, so I separated that patch out from 1. That
> makes it 3 patches.
> If you think single patch is easier to review, let me know, I can
> respin to have one patch for these 3 smaller patches.

They don't do anything by themselves.  I think putting them into a
single patch would be easier to review.

Thanks.

-- 
tejun
