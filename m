From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4 0/7] loop: cleanup charging io to mem/blkcg
Date: Sat, 14 Aug 2021 17:12:46 +0800
Message-ID: <YReJDkp8kswVdvBj@T590>
References: <20210806080302.298297-1-ming.lei@redhat.com>
 <20210809064159.GA19070@lst.de>
 <YRHx/qaKgEqWdXOP@T590>
 <20210812090037.GE2867@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628932385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AgM9wQjlbA+g1qn4Zgr5hjXwUSBX0Df22ncvONuM9No=;
        b=a7RZ+QL86dAfNveU91m7HL8yrbpuqQyAMpl5KqFcYTonlzUK9b9knUAvmQbRr+h9obM3n6
        5fmb5PvQJZodDZ1CBj/5gRtRrbaBkkbFdnrLbX7jbeMl+jl3P2XJvR6DRla73FEt3Gos/K
        3e4QdQJNDE7QCcD1KKDnXUbpksWz3WI=
Content-Disposition: inline
In-Reply-To: <20210812090037.GE2867@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Dan Schatzberg <schatzberg.dan@gmail.com>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

Hi Christoph,

On Thu, Aug 12, 2021 at 11:00:37AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 10, 2021 at 11:26:54AM +0800, Ming Lei wrote:
> > Can you share us what your expectations are in the re-write? Such as:
> > 
> > 1) no impact on normal non-cgroup path
> > 2) ...
> > 3) ...
> 
> Get the call cgroup mess out of this driver entirely?
 
Firstly the patch 2/7 in this series cleans up cgroup references by
killing unnecessary #ifdef and moving cgroup references into common
helpers, and the cgroup uses have been cleaned a lot.

Secondly the issue is that we need to wire proper cgroups(blkcg & memcg) for
loop's IO because loop uses wq or kthread for handling IO, and IMO it isn't
possible to moving cgroup references out of loop entirely if we want to
support this cgroup's function for loop driver.

Finally the current cgroup reference is actually very simple: retrieve
blkcg from bio_blkcg(bio) and memcg from the the blkcg. Then applies
the two in the single function of loop_workfn() only.


Thanks,
Ming

