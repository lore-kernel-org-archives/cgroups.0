From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: remove redundant kernfs_activate in
 cgroup_setup_root()
Date: Wed, 30 Sep 2020 12:03:24 -0400
Message-ID: <20200930160324.GD4441@mtj.duckdns.org>
References: <20200925091110.17189-1-richard.weiyang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qq54/nTErxi0RFH786s9sI+Dgv5bltXrwyKiIEnYNfw=;
        b=arKX5oW7pd33EJ5Cl2u/Ne1vMb9nMCv5Ys1X66cp96FJiTOEdRzKGfWfUm2SZd9FKf
         jkGdGXaSX4KL7lVTu71skCNWvTsgeE0zxCj3DUeJW5DYYHtqyMoMDjg0wBth0CEYpQTq
         JUNMjupuAzHYSyImMMMtX87Id4XFz+qQbLBmNUD8izu+6iTQa41ZFUQtT2aTq7BFn7+w
         i24gfA3zfz8boF/AlUL8cSc+szkaciIS63foOp+RqmJ0lNHrswpxhi1tQKNH/Cr9PApR
         4VI36IjJxLT/WMSBZQnXKiYMzULHayFZBz1sM0qc6lKsr8Feo2Y98B2+QuZezXIPqAEu
         fCIQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20200925091110.17189-1-richard.weiyang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 25, 2020 at 05:11:10PM +0800, Wei Yang wrote:
> This step is already done in rebind_subsystems().
> 
> Not necessary to do it again.
> 
> Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>

Applied to cgroup/for-5.10.

Thanks.

-- 
tejun
