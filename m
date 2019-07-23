From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v9 2/8] sched/core: Streamlining calls to task_rq_unlock()
Date: Tue, 23 Jul 2019 12:31:31 +0200
Message-ID: <20190723103131.GB3402@hirez.programming.kicks-ass.net>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-3-juri.lelli@redhat.com>
 <50f00347-ffb3-285c-5a7d-3a9c5f813950@arm.com>
 <20190722083214.GF25636@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MnT833q43OKgOeGMbkNl4vZ1Sr0chNDr5cIKxrka6/s=; b=guRZ1+tUYg9jhJ2PD2PsuUIT1
        4QBkAklWJMBjR8UXnloAdUN4bhNaFSBjKNDfGAUGWOD5iKniBRB+YfV+0UkW3CDtuLIkLlSjLK/Ed
        Z6vwQ1qxWmwY3EusrIZ5611r4vWuXwo+3a0omOSXASgptn1A6WiWz0+UPBCKEgE+K3SACKHbYjDzJ
        LH7ooWwzv5hNYYxpsrYRd6bnroTm5z9n5eeMxrcOTAQvI7WNDS5OwNGQh03Ds/dpR6FBMVtf2sq6l
        VVsL4ORpmJCl39/ulpHCNLeKHvDfXwygOLirPh0lzboT5Dju9JgC5S9bVnmLh76+mI0Y2LElUF1F/
Content-Disposition: inline
In-Reply-To: <20190722083214.GF25636@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, cgroups@vger.kernel.org

On Mon, Jul 22, 2019 at 10:32:14AM +0200, Juri Lelli wrote:

> Thanks for reporting. The set is based on cgroup/for-next (as of last
> week), though. I can of course rebase on tip/sched/core or mainline if
> needed.

TJ; I would like to take these patches through the scheduler tree if you
don't mind. Afaict there's no real conflict vs cgroup/for-next (I
applied the patches and then did a pull of cgroup/for-next which
finished without complaints).

