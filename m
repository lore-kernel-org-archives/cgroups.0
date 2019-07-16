From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 6/8] cgroup/cpuset: Change cpuset_rwsem and hotplug
 lock order
Date: Tue, 16 Jul 2019 08:36:33 -0700
Message-ID: <20190716153633.GA696309@devbig004.ftw2.facebook.com>
References: <20190628080618.522-1-juri.lelli@redhat.com>
 <20190628080618.522-7-juri.lelli@redhat.com>
 <20190628130308.GU3419@hirez.programming.kicks-ass.net>
 <20190701065233.GA26005@localhost.localdomain>
 <20190701082731.GP3402@hirez.programming.kicks-ass.net>
 <20190701145107.GY657710@devbig004.ftw2.facebook.com>
 <20190704084924.GC9099@localhost.localdomain>
 <20190712140409.GB13885@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Rkr1cM2tkiVjVeg3QaVTaa27A8PkbBvry/gW4kLkkZo=;
        b=QPXD/nW75d/To43UoaPRd46yJMqyRqYx84yCkV48ArLvUhJsr81fCDsaOReW/mntY4
         RoUEInISzJzFjjgiiNXOa/dFxR7Hzb8s9QWuJEXbDpAjuUW8qLSOa3vp4DB2Du7ikDQx
         kdo3OcgremMaklw/9W7tJleL438pee+faQN3g7CyoM/kHu0ijiYHegsvSSzASOp2/+LL
         bHrQXIPE9qoKfDbqjX+9GC1V1nPuLxGcNXYcNTRg892CVHTum+xRz/WOyDmpD9br0oYT
         o8XwOp8uuAu3ggxnWxmjeLqw+A7zojyphIG3Z2MqJ6olNNctQKECDqK4AOufZ0WUHwvf
         ANng==
Content-Disposition: inline
In-Reply-To: <20190712140409.GB13885@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Prateek Sood <prsood@codeaurora.org>

On Fri, Jul 12, 2019 at 04:04:09PM +0200, Juri Lelli wrote:
> > Should I take this as an indication that you had a look at the set and
> > (apart from Peter's comments) you are OK with them?
> > 
> > If that's the case I will send a v9 out soon. Otherwise I'd kindly ask
> > you to please have a look.
> 
> Gentle ping.

Sorry about the late response.  Yes, I have no objection to the change
but can you please cc Waiman Long on the next round?

Thanks.

-- 
tejun
