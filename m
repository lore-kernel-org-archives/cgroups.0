From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 7/8] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Mon, 1 Jul 2019 21:11:41 +0200
Message-ID: <20190701191141.GD3402@hirez.programming.kicks-ass.net>
References: <20190628080618.522-1-juri.lelli@redhat.com>
 <20190628080618.522-8-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0htxnIK1Wduic/JIKCNlUJk+0wwHKgV99WAuI//uAS4=; b=eU/iOVhJKXcr8fi85AGcX1pY0
        NK0W9Vf632ZZzWS3+uVfZHCOuWraFnZqUiMSLdsB+yZP3coujr95WDGbyehXOn12VDCiSHkS9BT98
        vL1LUFqKKaDBsBzcCoKCxgDz23AlcvkBWW8UIamqfDzzlsC8F8UjCal71OW9/wfrm2rPTSgUD9Fgn
        k5SOfS2/YiWiRAfzJjljIEmKgPqu9DK7PQmLuq6vj+ZJMEzE0w/CjD/2Zs2Xc6/kcXuBlB3xUriWL
        2CwXWDAAhf7TMX49hYAjonRDY0Lu2jV4cUErlgH6Qu8HFEmHeiRqqNyRMBf4E5Ag+cRwzeD2P+NMa
Content-Disposition: inline
In-Reply-To: <20190628080618.522-8-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Fri, Jun 28, 2019 at 10:06:17AM +0200, Juri Lelli wrote:
> No synchronisation mechanism exists between the cpuset subsystem and
> calls to function __sched_setscheduler(). As such, it is possible that
> new root domains are created on the cpuset side while a deadline
> acceptance test is carried out in __sched_setscheduler(), leading to a
> potential oversell of CPU bandwidth.
> 
> Grab cpuset_rwsem read lock from core scheduler, so to prevent
> situations such as the one described above from happening.
> 

ISTR there being a funny vs normalize_rt_tasks(); maybe mention that?
