From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 00/12] Enable cpuset controller in default hierarchy
Date: Thu, 8 Nov 2018 10:41:33 +0100
Message-ID: <20181108094133.GN9761@hirez.programming.kicks-ass.net>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
 <20181106115335.GQ22431@hirez.programming.kicks-ass.net>
 <20181106115558.GB22485@hirez.programming.kicks-ass.net>
 <8c386375-b801-8adb-602e-40c73a7efedc@redhat.com>
 <20181107213229.GB2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZezUjLDr/j2WA2NJdtNAakJBWQx0nHV5kn7qTWMNssQ=; b=S2AGTRH5xZWc6DN7qLP2ah6Pg
        TpgqWa80wl6fcmQlXGFwqEUv+/TJOmh+VB9pRqtQRy746zoYTunXQO5MfoRc/5n0Hm84q+aRw33Bv
        UDy6Qiwz5n6aVsaQ92/I/uhW1p5UHEwd7E5pwpkZ4GKW++Tf+w+uSwf6hRRhdzFOjXTSsTV7/0pyJ
        QWelvfvbIjamADbggOWGlfBxbyrW7fa3Avlj1wPnVueNUs4gIf3qD/ZPYp7p+IRNJuHLYLQxOnkiN
        QA/wgb21gIghxeb8kEBu722dqQIls8nS49o3mwiBUFbGH5yVNc8xDsi3zzzxvFiQ2a/+WiCpidphK
      
Content-Disposition: inline
In-Reply-To: <20181107213229.GB2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Wed, Nov 07, 2018 at 01:32:29PM -0800, Tejun Heo wrote:

> How about the following?
> 
> Interface file is named "cpuset.cpus.partition" as it's a partition of
> cpus.  The writeable keys are "root" and "member" - a partition root
> and a partition member.  When "root" is requested but can't be
> satisfied it shows "root invalid".  This seems pretty consistent with
> cgroup.type and other cpuset files.

I can live with that, thanks!
