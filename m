From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm/oom_kill: count global and memory cgroup oom kills
Date: Tue, 23 May 2017 00:49:30 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1705230044590.50796@chino.kir.corp.google.com>
References: <149520375057.74196.2843113275800730971.stgit@buzz> <CALo0P1123MROxgveCdX6YFpWDwG4qrAyHu3Xd1F+ckaFBnF4dQ@mail.gmail.com> <ecd4a7ea-06c0-f549-a1bf-6d2d3c0af719@yandex-team.ru>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=UyOM9H/jRD3dEdwCRXyA2/AHTRDwWqUHlXbjlTT4gRc=;
        b=qLNFmmuRvGpJrij48uaBslEOXziLiiSNod488QFg0OTt5BJMES5Qw4420q8HDlzMUW
         jSBtQcQabpjKoFRceHUwUK7B8o8lNX43Fun/wZg7/T4/VNMkv7j24Ef7H6yayuKDm+At
         5aNG18JhF40VG/4BbPBalKIistMMQ2n4klPVq+skssS9bIDbxgPV/CFEhZSxs2zAhob0
         kjG7CT3NbZizV2m/VvouhZvmgv0Cos6TTG300e9NUEzIF7eU50PJz/b4edbHRMd/n5tW
         VMxMQZQs3Z+YLHYOtnrW7qdUFHw+76fup7Cpg8TAUm3dS1ieJvGr2lP3SL/N7xHQm3hb
         193A==
In-Reply-To: <ecd4a7ea-06c0-f549-a1bf-6d2d3c0af719@yandex-team.ru>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Roman Guschin <guroan@gmail.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, hannes@cmpxchg.org

On Mon, 22 May 2017, Konstantin Khlebnikov wrote:

> Nope, they are different. I think we should rephase documentation somehow
> 
> low - count of reclaims below low level
> high - count of post-allocation reclaims above high level
> max - count of direct reclaims
> oom - count of failed direct reclaims
> oom_kill - count of oom killer invocations and killed processes
> 

In our kernel, we've maintained counts of oom kills per memcg for years as 
part of memory.oom_control for memcg v1, but we've also found it helpful 
to complement that with another count that specifies the number of 
processes oom killed that were attached to that exact memcg.

In your patch, oom_kill in memory.oom_control specifies that number of oom 
events that resulted in an oom kill of a process from that hierarchy, but 
not the number of processes killed from a specific memcg (the difference 
between oc->memcg and mem_cgroup_from_task(victim)).  Not sure if you 
would also find it helpful.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
