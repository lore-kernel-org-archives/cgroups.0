From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: add tracepoints for basic operations
Date: Wed, 10 Aug 2016 11:25:52 -0400
Message-ID: <20160810152552.GL25053@mtj.duckdns.org>
References: <20160809052703.GA4906@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QDXYm99nxtUU2LmClZDi2kAYfXqHF7jwgEcKsNEIr4E=;
        b=JZcLTnpqNhJq1sJtoSlytQBWuSnm7dGbu9Vdyqtwrg628zQxHPOLeazU64YQM18xmG
         B4C09PFmHu8B4iUvWZX94aP/G6RoKeJijB1R+J/8dWzHEPpftHa0XXXZZujzmZkcgzNY
         dIX0T0xSvcZvGjFvcYNixrGJNdk3+fpx8WkUEY+Xg2rDqD3Lf1Yqq6wHar3YmVy9hvnC
         NTzRyFE5UhrnFpP7OkX0ghkUhdaDQtlgaU0XZ1ZavXMc+lDLh6fOIZJZDsr8QS7tGyFZ
         IB46k/GCsHVMIUax4/hW2pc320yzsktY2h7VLC/NKF0egr3oaFLbaR1/GQanp63YSXu4
         ICEg==
Content-Disposition: inline
In-Reply-To: <20160809052703.GA4906@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Aug 09, 2016 at 01:27:03AM -0400, Tejun Heo wrote:
> From 471f89b317a21a78dacaee85957984b9f11e79e4 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 9 Aug 2016 01:11:13 -0400
> 
> Debugging what goes wrong with cgroup setup can get hairy.  Add
> tracepoints for cgroup hierarchy mount, cgroup creation/destruction
> and task migration operations for better visibility.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied to cgroup/for-4.9.

Thanks.

-- 
tejun
