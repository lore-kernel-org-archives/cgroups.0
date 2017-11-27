From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 0/2] Invert cpu_hotplug_lock and cpuset_mutex locking
 order.
Date: Mon, 27 Nov 2017 08:48:55 -0800
Message-ID: <20171127164848.GF983427@devbig577.frc2.facebook.com>
References: <20171115103742.xt7muaq2dfrs2cyd@hirez.programming.kicks-ass.net>
 <1510755615-25906-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4hiLAB6yUoi1a1MdSO1Sn65Te05tuWzpdCFkmYVhkyQ=;
        b=TO27g9tl/dkmoKL1B1vQw5Xkdz1jQpFdqf9wybyqzX2k2karT3v/6SJu3utvaHq3FK
         R6MD1An982nb97nFsCT6nXhscyBM1og1SgLEz77b32cWmJBEA1c8bO6sw639i+bZwmRr
         FBntsdxTtuu8tMmeshpRBGOfWSwQZQ1yyE0ghbx0rIBfmJUDddeINmTTvPkAhWkAX4RK
         9Rn9Lgdh/HlQS5aApJqHZm1XOSInYkJGbyEH3WLjAAOSPdJNICQ3vTHu/qycW87x408s
         SEDwQa+3idARTcxCs0zUVuwQRZ/ix5D920q4whGSDuYCvzdncKHAx39aJrIVzGekM0bh
         LAMA==
Content-Disposition: inline
In-Reply-To: <1510755615-25906-1-git-send-email-prsood@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: peterz@infradead.org, longman@redhat.com, lizefan@huawei.com, mingo@kernel.org, boqun.feng@gmail.com, tglx@linutronix.de, cgroups@vger.kernel.org, sramana@codeaurora.org, linux-kernel@vger.kernel.org, clingutla@codeaurora.org

On Wed, Nov 15, 2017 at 07:50:13PM +0530, Prateek Sood wrote:
> This patch does following
> 	1- Remove circular dependency deadlock by inverting order of
> cpu_hotplug_lock and cpuset_mutex.
> 	2- Make cpuset_hotplug_workfn() synchronous for cpu hotplug path.
> For memory hotplug path it still gets queued as a work item.
> 
> Prateek Sood (2):
>   cgroup/cpuset: remove circular dependency deadlock
>   cpuset: Make cpuset hotplug synchronous

Applied to cgroup/for-4.15-fixes.

Thanks.

-- 
tejun
