From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Mon, 18 Nov 2013 17:22:16 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311181719390.4292@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org> <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com> <20131113233419.GJ707@cmpxchg.org> <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <20131118154115.GA3556@cmpxchg.org> <20131118165110.GE32623@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=40/EVcRG8lll+qXE5Eq1dnPlFDmG1XjiRC02uz7pTcU=;
        b=gr2B2QPoE9oyn3jcqzATDV89nCZf/OiOIHO0ZtaO1hyghGsKrtQl8fnUifCzegVzbE
         7/3opThsiC++FUvFcs8OUvYx4WedXJOwGfcEXWeF4XS2wJxjGcz2eVJm3axANkkH6wZ5
         J9dY9OY4cyFSmDErrm/RezUvC2INogrHeMzwaa0HTmeTp1y53G+Erk7R+8BtoalsKjoh
         zV9/qWeSsac0Db/jQKUZGOVAAHl4GYxlxqpbPe/W3oWKDj1Q82k0y+O5fYrkbDedSfc+
         yes3qVtOdshwFdqzoyF6BVcYkWnzSTQOTRHvjP4kaMxtTHadn7Bpq6GwnKjfHY/PoGx6
         LASA==
In-Reply-To: <20131118165110.GE32623@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, 18 Nov 2013, Michal Hocko wrote:

> > Even though the situation may not require a kill, the user still wants
> > to know that the memory hard limit was breached and the isolation
> > broken in order to prevent a kill.  We just came really close and the
> 
> You can observe that you are getting into troubles from fail counter
> already. The usability without more reclaim statistics is a bit
> questionable but you get a rough impression that something is wrong at
> least.
> 

Agreed, but it seems like the appropriate mechanism for this is through 
the memory.{,memsw.}usage_in_bytes notifiers which already exist.

> > fact that current is exiting is coincidental.  Not everybody is having
> > OOM situations on a frequent basis and they might want to know when
> > they are redlining the system and that the same workload might blow up
> > the next time it's run.
> 
> I am just concerned that signaling temporal OOM conditions which do not
> require any OOM killer action (user or kernel space) might be confusing.
> Userspace would have harder times to tell whether any action is required
> or not.
> 

Completely agreed, in fact there is no reliable and non-racy way in 
userspace to determine "is this a real oom condition that I must act upon 
or can the kernel handle it?"

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
