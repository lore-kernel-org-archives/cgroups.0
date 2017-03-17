From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup, kthread: close race window where new kthreads
 can be migrated to non-root cgroups
Date: Fri, 17 Mar 2017 10:44:43 -0400
Message-ID: <20170317144443.GE5078@htj.duckdns.org>
References: <20170315231827.GA13656@htj.duckdns.org>
 <20170315231920.GB13656@htj.duckdns.org>
 <20170316205424.GH15810@htj.duckdns.org>
 <20170317135021.GB32763@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4UCSF/vlmI7Q2u9UFWeXDvUETSDUZD5TdmqsxRXaf7c=;
        b=jDptXG+ej+4eb4pqL2POvj3JcM7eq2J/Jzce29BllRuJMT70mEHhFhJsIcPDAKvh0a
         ATbhdNh1LGfj8RX0/toPQmNYAQseklq8guKILwEJ//ta44J3fP0u+VkX+be+vjNInTvi
         mA8jWYCfuvWvsL/NbCifR8WLWf8BzoA98se3VMU+C56o/aOiQ/YkOXTpevdgpSnP1dwX
         0FOZoDcQvWJ8M0gZFKUFA/kgpBcd0J+8RW3OsZrxNtVe+j7TZGXcE7uacp8AXfV0v7hq
         nOupxNaX+hrKMmvf7yK1bupSsXC7xbVbf4DELd2kch4fvvvwApB1IvoZT9NZbGzt19cH
         JWoA==
Content-Disposition: inline
In-Reply-To: <20170317135021.GB32763@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On Fri, Mar 17, 2017 at 02:50:21PM +0100, Oleg Nesterov wrote:
> On 03/16, Tejun Heo wrote:
> >
> > Oleg,
> > if you're okay with the patch, I can route this through
> > cgroup/for-4.11-fixes.
> 
> Thanks, looks good to me.

Applied to cgroup/for-4.11-fixes.

Thanks.

-- 
tejun
