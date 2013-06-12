From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Wed, 12 Jun 2013 14:27:05 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1306121408490.24902@chino.kir.corp.google.com>
References: <20130601102058.GA19474@dhcp22.suse.cz> <alpine.DEB.2.02.1306031102480.7956@chino.kir.corp.google.com> <20130603193147.GC23659@dhcp22.suse.cz> <alpine.DEB.2.02.1306031411380.22083@chino.kir.corp.google.com> <20130604095514.GC31242@dhcp22.suse.cz>
 <alpine.DEB.2.02.1306042329320.20610@chino.kir.corp.google.com> <20130605093937.GK15997@dhcp22.suse.cz> <alpine.DEB.2.02.1306051657001.29626@chino.kir.corp.google.com> <20130610142321.GE5138@dhcp22.suse.cz> <alpine.DEB.2.02.1306111321360.32688@chino.kir.corp.google.com>
 <20130612202348.GA17282@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=QWdQqBEQbACxa+Vh1D5Xy/LTt0t71KBv1BBRXyVLiz8=;
        b=OAOeK78k08mxP1eKaUXT061a5UU5584mRdbiytrFIUG90OQkEFyyL6iFwm2Fw90C/Z
         jzRJiFG8cqrNSgcJfpMYVO82v68KXC0D27QwOjmpbKTTmJFfrVt+GDxtQfQNh/ciKyRD
         5bsOhEU7mCC3ija593GDfXWMdtIoA+MqLv3U/7N8463tjyOPVIb5roVQxoLP/jYtbPZR
         CKoWjwK/NtdQ1v7QkZwLkiLy7GMhj/DnqNsw33UStlyqSIhX8IwCe24i4SW6jJN/S3aY
         Z/i8xyddCxdiKnz4g1ndQItjxVGDuiOovjjCvAa3Zx7JikHaxQ3WiRa4xfMKuGOE5rte
         ZhjA==
In-Reply-To: <20130612202348.GA17282@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Wed, 12 Jun 2013, Michal Hocko wrote:

> But the objective is to handle oom deadlocks gracefully and you cannot
> possibly miss those as they are, well, _deadlocks_.

That's not at all the objective, the changelog quite explicitly states 
this is a deadlock as the result of userspace having disabled the oom 
killer so that its userspace oom handler can resolve the condition and it 
being unresponsive or unable to perform its job.

When you allow users to create their own memcgs, which we do and is 
possible by chowning the user's root to be owned by it, and implement 
their own userspace oom notifier, you must then rely on their 
implementation to work 100% of the time, otherwise all those gigabytes of 
memory go unfreed forever.  What you're insisting on is that this 
userspace is perfect and there is never any memory allocated (otherwise it 
may oom its own user root memcg where the notifier is hosted) and it is 
always responsive and able to handle the situation.  This is not reality.

This is why the kernel has its own oom killer and doesn't wait for a user 
to go to kill something.  There's no option to disable the kernel oom 
killer.  It's because we don't want to leave the system in a state where 
no progress can be made.  The same intention is for memcgs to not be left 
in a state where no progress can be made even if userspace has the best 
intentions.

Your solution of a global entity to prevent these situations doesn't work 
for the same reason we can't implement the kernel oom killer in userspace.  
It's the exact same reason.  We also want to push patches that allow 
global oom conditions to trigger an eventfd notification on the root memcg 
with the exact same semantics of a memcg oom: allow it time to respond but 
step in and kill something if it fails to respond.  Memcg happens to be 
the perfect place to implement such a userspace policy and we want to have 
a priority-based killing mechanism that is hierarchical and different from 
oom_score_adj.

For that to work properly, it cannot possibly allocate memory even on page 
fault so it must be mlocked in memory and have enough buffers to store the 
priorities of top-level memcgs.  Asking a global watchdog to sit there 
mlocked in memory to store thousands of memcgs, their priorities, their 
last oom, their timeouts, etc, is a non-starter.

I don't buy your argument that we're pushing any interface to an extreme.  
Users having the ability to manipulate their own memcgs and subcontainers 
isn't extreme, it's explicitly allowed by cgroups!  What we're asking for 
is that level of control for memcg is sane and that if userspace is 
unresponsive that we don't lose gigabytes of memory forever.  And since 
we've supported this type of functionality even before memcg was created 
for cpusets and have used and supported it for six years, I have no 
problem supporting such a thing upstream.

I do understand that we're the largest user of memcg and use it unlike you 
or others on this thread do, but that doesn't mean our usecase is any less 
important or that we should aim for the most robust behavior possible.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
