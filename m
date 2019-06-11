From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 0/5] cgroup-aware unbound workqueues
Date: Tue, 11 Jun 2019 12:52:10 -0700
Message-ID: <20190611195210.GK3341036@devbig004.ftw2.facebook.com>
References: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
 <20190605135319.GK374014@devbig004.ftw2.facebook.com>
 <20190606061525.GD23056@rapoport-lnx>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cHQwQdsrkTpqJAyug+FT0E9rG91BoWa0X7Lnvcu63U0=;
        b=sf4Wv0oOKP6ccpJ9YkQOGUDhSjYMBG+KudnxXTcqLAYPTss2vsI1fbeHmcwPPphcXk
         eATLNIRLct9/VRTkALmNlWMYfZd4ArOl2dDKv2RD398ontULghP25qT50pgbWNv4RPRF
         77gUEK//iTYsdIcrlUK0eU8HjK4D6OkpZM4MQ+WSPhskB0w41UOsJhrx8kG0Sn5KXqpg
         W30qKAytIPB0KJaNA2/a92tHIIvpb7rkfdOzP2u/VtulBlUvKeF5aRsPWlUK4K9CTGn2
         50YrHtyYEwlfXxS0bAkqes8kZlPigVckJQmBPYD/bHVUi4pGGlu4cvhg22lMAOvYaJt0
         lHAw==
Content-Disposition: inline
In-Reply-To: <20190606061525.GD23056@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>, hannes@cmpxchg.org, jiangshanlai@gmail.com, lizefan@huawei.com, bsd@redhat.com, dan.j.williams@intel.com, dave.hansen@intel.com, juri.lelli@redhat.com, mhocko@kernel.org, peterz@infradead.org, steven.sistare@oracle.com, tglx@linutronix.de, tom.hromatka@oracle.com, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello,

On Thu, Jun 06, 2019 at 09:15:26AM +0300, Mike Rapoport wrote:
> > Can you please go into more details on the use cases?
> 
> If I remember correctly, the original Bandan's work was about using
> workqueues instead of kthreads in vhost. 

For vhosts, I think it might be better to stick with kthread or
kthread_worker given that they can consume lots of cpu cycles over a
long period of time and we want to keep persistent track of scheduling
states.

Thanks.

-- 
tejun
