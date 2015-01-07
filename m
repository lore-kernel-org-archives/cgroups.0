From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 1/2 cgroup/for-3.20] cgroup: reorder SUBSYS(blkio) in
 cgroup_subsys.h
Date: Wed, 7 Jan 2015 11:57:01 +0800
Message-ID: <54ACAE8D.4030807@huawei.com>
References: <20150106165720.GI3077@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150106165720.GI3077@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2015/1/7 0:57, Tejun Heo wrote:
> The scheduled cgroup writeback support requires blkio to be
> initialized before memcg as memcg needs to provide certain blkcg
> related functionalities.  Relocate blkio so that it's right above
> memory.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Hello,
> 
> These are two trivial patches to prepare for the cgroup writeback
> support.  Applying to cgroup/for-3.20.
> 

Acked-by: Zefan Li <lizefan@huawei.com>
