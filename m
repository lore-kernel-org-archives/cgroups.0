From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
Date: Fri, 20 Jun 2014 17:01:37 -0400
Message-ID: <20140620210137.GA2059@mtj.dyndns.org>
References: <53902A44.50005@cn.fujitsu.com>
 <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org>
 <539192F1.7050308@cn.fujitsu.com>
 <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com>
 <539574F1.2060701@cn.fujitsu.com>
 <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com>
 <53967465.7070908@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=g4Ny76HiT475upywSE7A56amUdbjPyO2JjiGY8XDvx4=;
        b=HDAlIkrXljbrdj9Zwxb3qBa4s2xxsbE1QOqbdvLR++H0fQUEpaTovdwvIUWI7DzQWK
         t1RS39jehbOH2ZZcszw57NPkoCkYf2S3B3QP/2lVm1w+iCB77w7sFQuN0EMev1aCBJmk
         dgLbnHqWbzXQFpL4Jk3egqjtEjEjPiqDMD2mucbeht4jYvCLzdruZFXYKEDKtdKpr9cH
         miU/k8BIsmSAuICDpQFfTqgkEzF5xD4IF0LVtJu8vxZkTO6mJ9resP66BYITlEUP0M1A
         jCQti5RAcucHv/mhPU0IVOX53o0oAbeu5+4YJcGmCF+O5/YONPPiuRqgZ99pPO/+HNqH
         BF3A==
Content-Disposition: inline
In-Reply-To: <53967465.7070908@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: David Rientjes <rientjes@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>, stable@vger.kernel.org

Hello, Li.

Sorry about the long delay.

On Tue, Jun 10, 2014 at 10:58:45AM +0800, Li Zefan wrote:
> Yes, this is a long-standing issue. Besides the race you described, the child
> task's mems_allowed can be wrong if the cpuset's nodemask changes before the
> child has been added to the cgroup's tasklist.
> 
> I remember Tejun once said he wanted to disallow task migration between
> cgroups during fork, and that should fix this problem.

I'm having trouble remembering but yeah enforcing stricter behavior
across fork could be beneficial.  Hmmm... the problem with making
forks exclusive against migrations is that we'll end up adding more
locking to the fork path which isn't too nice.

Hmmm... other controllers (cgroup_freezer) can reliably synchronize
the child's state to the cgroup it belongs to.  Why can't cpuset?  Is
there something fundamentally missing in the cgroup API?

> > It needs to be slightly rewritten to work properly without negatively 
> > impacting the latency of fork().  Do you have the cycles to do it?
> > 
> 
> Sounds you have other idea?

I don't think the suggested patch breaks anything more than it was
broken before and we should probably apply it for the time being.  Li?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
