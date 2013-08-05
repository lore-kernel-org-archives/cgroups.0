From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 09/23] cgroup: add subsys backlink pointer to cftype
Date: Mon, 5 Aug 2013 08:49:51 -0400
Message-ID: <20130805124951.GB2274@redhat.com>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-10-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375393801-4817-10-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, Aug 01, 2013 at 05:49:47PM -0400, Tejun Heo wrote:
> cgroup is transitioning to using css (cgroup_subsys_state) instead of
> cgroup as the primary subsystem handle.  The cgroupfs file interface
> will be converted to use css's which requires finding out the
> subsystem from cftype so that the matching css can be determined from
> the cgroup.
> 
> This patch adds cftype->ss which points to the subsystem the file
> belongs to.  The field is initialized while a cftype is being
> registered.  This makes it unnecessary to explicitly specify the
> subsystem for other cftype handling functions.  @ss argument dropped
> from various cftype handling functions.
> 
> This patch shouldn't introduce any behavior differences.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-cgroup.c     |  2 +-

blk-cgroup bits are simple here. Ack for these.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
