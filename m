From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: cgroup-v1: clean up kernel-doc notation
Date: Wed, 11 Aug 2021 07:58:02 -1000
Message-ID: <YRQPqk8YrsSLB1tk@slm.duckdns.org>
References: <20210811000349.32645-1-rdunlap@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rk1BWpuiJ39JmRSvLcCw9Ka+QLQwce0JveS233i7okU=;
        b=hXnfg+THbnp0MKwZoNSddpaouYeIdGFdgzY/kWmV1W0dFINKA6zmdPGuCd61wUNmsW
         3cVCn2qhEFihFcbfDwynXSVL7bP//tFXHdBEBve6IlBr4wuvMMaoM7pjo0m0ct+U+5wG
         eBvOe/8osuVPBGFwBQP8SBu6GUCRZn5k+mU6JjrQH4pjmYt0F9lZuejHR3ZJuw76ZoNw
         JzMI8IelJtmcqVDpay4LUvfNH6Iw1Ejsq8zqRnFzmmkbYhOdHdjLsgL+5lEqjcjHewZh
         pUnNqfVA7PBFh/pE7amqpUtEGSblnSQL0buFL/irH8vtxiKXPsHGbcIEBrOncOeVt87Q
         hW0g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210811000349.32645-1-rdunlap@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On Tue, Aug 10, 2021 at 05:03:49PM -0700, Randy Dunlap wrote:
> Fix kernel-doc warnings found in cgroup-v1.c:
> 
> kernel/cgroup/cgroup-v1.c:55: warning: No description found for return value of 'cgroup_attach_task_all'
> kernel/cgroup/cgroup-v1.c:94: warning: expecting prototype for cgroup_trasnsfer_tasks(). Prototype was for cgroup_transfer_tasks() instead
> cgroup-v1.c:96: warning: No description found for return value of 'cgroup_transfer_tasks'
> kernel/cgroup/cgroup-v1.c:687: warning: No description found for return value of 'cgroupstats_build'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Zefan Li <lizefan.x@bytedance.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: cgroups@vger.kernel.org

Applied to cgroup/for-5.15.

Thanks.

-- 
tejun
