From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 13:32:18 +0200
Message-ID: <20180720113218.GK2476@hirez.programming.kicks-ass.net>
References: <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <69903192-8711-6a1e-0cd0-fbb249a4204b@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LFKEgGNKGYlBzIjx7OFkg2ppIE+/ozpZvzoWPn6vY+c=; b=iIA/PHJTzRAIh4fdoabJgWFD1
        jrNiqglElPUhxMTN1n7UJmZ2xlmhIEsMMPY3SjY/dCbeg9kxdGgt8iJSAuU4j5e3H43yxWlEretBt
        Jy71FRXqCjnnISPd+xEy7Sy8G9tYW0G3DyO/1TSLtOdHB/+Od/VhHx2299uV8YrmFEllwuwZHslPM
        Tqi6jCo1LCcO71U4OlOCpOAbrSkMPnsTeXHsx43u7cFoezgGBCXJeEh8nboMKUS96aS9gWFG8Mza9
        tUUpmqm3jciUQJKbSMVMBjA+eDPTgids5PP5NoX3vese0Trq55ta6oaqST77HKiu0zu5Fd66I2WE8
    
Content-Disposition: inline
In-Reply-To: <69903192-8711-6a1e-0cd0-fbb249a4204b@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Thu, Jul 19, 2018 at 01:22:36PM -0400, Waiman Long wrote:
> > 1. control which cpus are moved into a partition in all of its
> >    subtree.
> 
> Not at the moment. I do have another idea of adding a "cpus.subpart"
> file, for example, to indicate what CPUs a child sub-partition can use
> in its partition.

ARGH, why more files; this is turning into a right mess to use.
