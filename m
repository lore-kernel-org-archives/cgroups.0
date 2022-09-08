From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] memcg: reduce size of memcg vmstats structures
Date: Thu, 8 Sep 2022 15:37:31 -0700
Message-ID: <20220908153731.d6ec2095c9d1f42ff5e8ec5c@linux-foundation.org>
References: <20220907043537.3457014-1-shakeelb@google.com>
        <20220907043537.3457014-4-shakeelb@google.com>
        <CALvZod70Mvxr+Nzb6k0yiU2RFYjTD=0NFhKK-Eyp+5ejd1PSFw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662676652;
        bh=RXI/S2LYORA9kdbqhda/3YzOj4NudTqOLXCZh8OTpgA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kEGJQpMHSP1rHh5cA53z/rhx151d3iEmV8c26u8Jrn1nf4Kgqkaa6XyFChHpEBi1o
         d43NY62xfwL1k6fVhmHe4a2c33akdSyIzFagezUlm27G68VxZa5J3sRBmijWQ2aOQb
         khq3koVe/u7B5k3QTDiG97mC9VF1/RwV+PrikHkA=
In-Reply-To: <CALvZod70Mvxr+Nzb6k0yiU2RFYjTD=0NFhKK-Eyp+5ejd1PSFw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, 7 Sep 2022 19:35:10 -0700 Shakeel Butt <shakeelb@google.com> wrote:

> On Tue, Sep 6, 2022 at 9:36 PM Shakeel Butt <shakeelb@google.com> wrote:
> >
> [...]
> >
> >  static unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
> >  {
> >         long x = 0;
> >         int cpu;
> > +       int index = memcg_events_index(event);
> > +
> > +       if (index < 0)
> > +               return 0;
> >
> >         for_each_possible_cpu(cpu)
> >                 x += per_cpu(memcg->vmstats_percpu->events[event], cpu);
> 
> Andrew, can you please replace 'event' in the above line with 'index'?
> I had this correct in the original single patch but messed up while
> breaking up that patch into three patches for easier review.

No probs.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-reduce-size-of-memcg-vmstats-structures-fix
Date: Thu Sep  8 03:35:53 PM PDT 2022

fix memcg_events_local() array index, per Shakeel

Link: https://lkml.kernel.org/r/CALvZod70Mvxr+Nzb6k0yiU2RFYjTD=0NFhKK-Eyp+5ejd1PSFw@mail.gmail.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-reduce-size-of-memcg-vmstats-structures-fix
+++ a/mm/memcontrol.c
@@ -921,7 +921,7 @@ static unsigned long memcg_events_local(
 		return 0;
 
 	for_each_possible_cpu(cpu)
-		x += per_cpu(memcg->vmstats_percpu->events[event], cpu);
+		x += per_cpu(memcg->vmstats_percpu->events[index], cpu);
 	return x;
 }
 
_

