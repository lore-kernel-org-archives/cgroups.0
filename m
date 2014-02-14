From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: update
 cgroup_enable_task_cg_lists() to grab siglock
Date: Fri, 14 Feb 2014 11:50:19 -0500
Message-ID: <20140214165019.GI31544@htj.dyndns.org>
References: <20140213182931.GB17608@htj.dyndns.org>
 <52FD9256.1080801@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LLq3DTihYXye7WIAKTWVoU2luo+6LGubaJBuyKV/uVg=;
        b=h6h2qYwWVcmcA9GT3mVEDmKmcXEVlV+HNPjgBczwsKwohKnURpO5ReGHOnWNTnvhX9
         ogRIlf5YHuAxTf8QntTfRS2k4eTMGWTVHn0g5ui5FWezOKc4ZNIg8wm/V6Bwp51Rl3LV
         SldPvddgJ+i1SuBsHhNwZp/OoM5I4J+uPHi9PmAVvJEv/iO/tmfY3dWcwbnVJsjEYBmx
         c0V8RDdrnSq/dg5c3fBKbBCQM4Xd5ASjLHlfzdhKEOuRajgal+fDsEQoHYLhXAAm3bCf
         0UMq2vSd9XOyzNpsTR8UMh6wi8pDCI/+6FNXeZNQNtCPZove36a+2TCb72+ObkUW8vS/
         Hodg==
Content-Disposition: inline
In-Reply-To: <52FD9256.1080801@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 14, 2014 at 11:49:42AM +0800, Li Zefan wrote:
> Now the only race I see is caused by checking tsk->cg_list without locking
> in cgroup_exit():

Yeah, that's the one I was trying to fix.

> Your patch can fix this race, but after diving into the code I don't think
> the race exists, because exit_mm() locks&unlocks task_lock, and exit_mm()
> is called after exit_signal() and before cgroup_exit(), and task_lock is
> also taken by cgroup_enable_task_cg_lists().

Ah, okay, so there's a task_lock somewhere in the exit path.
Extremely fragile, but not broken.

> I totally agree the code is fragile and we should take your patch. I just
> want to make it clear if the bug exists in real life or not, and then we
> can write better changelog and decide to queue the patch for 3.14 or 3.15
> and decide to mark it for stable or not.

Yeap, no reason to mark it for -stable if it doesn't actually happen.
I'll update the description and respin it for for-3.15.

Thanks!

-- 
tejun
