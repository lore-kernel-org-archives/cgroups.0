From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 2/2] cpuset: Add cpuset.sched_load_balance to v2
Date: Tue, 27 Mar 2018 07:02:59 -0700
Message-ID: <20180327140259.GN1840639@devbig577.frc2.facebook.com>
References: <1521649309-26690-1-git-send-email-longman@redhat.com>
 <1521649309-26690-3-git-send-email-longman@redhat.com>
 <20180322084120.GE7231@localhost.localdomain>
 <e754e128-0a93-800e-e71b-2c8dc316ba8a@redhat.com>
 <20180323075952.GA4763@localhost.localdomain>
 <a8860a42-31b5-4620-7b23-b7515ee11d7d@redhat.com>
 <20180326124711.GE5942@localhost.localdomain>
 <bf79b45e-7716-65af-03ca-7112dc367371@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J1NhkEotXjjRMdSvuv5xiYSu5+7HaTdTU3p4TqolSe8=;
        b=REvfRjz83EVbTkwjkT61kFYHFPeXYIexiPk9UXqqxDbR1tIsi59yUgZFaXa+lM7Wsl
         R2vkkbhT9zgOObHApc6rTttrED0ccnwfDyEJ5Qu93OPJD3kBk/5qmXebZP/f0qgW0jYf
         9OyjkMbz0XlkK/+RLpFmXj880h4g1Bbyy8gE1t+Add+TnerjWkXNFsqaay+wgR+4ospy
         Ijc6LKzwPa5RZpOIbtAGDJhOQqDpmTBowQYbF56Rno3H0Dwjsb9FImSpMcUMZnQFb64Y
         yH63+QNHuOsDKwiCgWPgpQpmomsR7zbI31TzGPrOz9vVcAiTVs4+Imcz21M4nfnJvVZ/
         CRqA==
Content-Disposition: inline
In-Reply-To: <bf79b45e-7716-65af-03ca-7112dc367371@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hello,

On Mon, Mar 26, 2018 at 04:28:49PM -0400, Waiman Long wrote:
> Maybe we can have a different root level flag, say,
> sched_partition_domain that is equivalent to !sched_load_balnace.
> However, I am still not sure if we should enforce that no task should be
> in the root cgroup when the flag is set.
> 
> Tejun and Peter, what are your thoughts on this?

I haven't looked into the other issues too much but we for sure cannot
empty the root cgroup.

Thanks.

-- 
tejun
