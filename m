From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-5.5] cgroup: remove
 cgroup_enable_task_cg_lists() optimization
Date: Fri, 25 Oct 2019 05:56:06 -0700
Message-ID: <20191025125606.GI3622521@devbig004.ftw2.facebook.com>
References: <0000000000003b1e8005956939f1@google.com>
 <20191021142111.GB1339@redhat.com>
 <20191024190351.GD3622521@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6M7fFvGY7jmVpbseBKiV7Fuq3JlQ40S3dRzyK1LCwic=;
        b=ofhvMK0eXyZxIRpnFwbaLupPkNajdfWMJjYOm0pfMWn6sTd9WNq4luJCSZCk9U32l3
         Qsq7qfUq2cplcYYiZjZCj6rjn4pkAfkZYRVSaV3wZVSeSSOweGFTQ5McsyFuTTaVTnRQ
         79Fk+brR7YFXM51tJGOe3sYWpdJBc2xuYr8V5dFhF3xfBF0sEkEWPYLUQD1Vez4Cxr01
         3VqbU5JK3wcJQ95futpJg1jGR+TWZcqwxZY10nxIKHvqj8VXhJMXidnFv5oOdyVUwCcD
         RxHdC2RjWCruxMKaRAiw9PvnyvkXOHYAtATq9OsbEnjmVT+bmIWYtbPRTpDo3qUKz5sZ
         zTjw==
Content-Disposition: inline
In-Reply-To: <20191024190351.GD3622521@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, arnd@arndb.de, christian@brauner.io, deepa.kernel@gmail.com, ebiederm@xmission.com, elver@google.com, guro@fb.com, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, cgroups@vger.kernel.org, kernel-team@fb.com

On Thu, Oct 24, 2019 at 12:03:51PM -0700, Tejun Heo wrote:
> cgroup_enable_task_cg_lists() is used to lazyily initialize task
> cgroup associations on the first use to reduce fork / exit overheads
> on systems which don't use cgroup.  Unfortunately, locking around it
> has never been actually correct and its value is dubious given how the
> vast majority of systems use cgroup right away from boot.
> 
> This patch removes the optimization.  For now, replace the cg_list
> based branches with WARN_ON_ONCE()'s to be on the safe side.  We can
> simplify the logic further in the future.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Oleg Nesterov <oleg@redhat.com>

Applying to cgroup/for-5.5.

Thanks.

-- 
tejun
