From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 00/11] kmem controller for memcg: stripped down version
Date: Tue, 26 Jun 2012 18:08:13 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206261804160.11287@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <20120625162745.eabe4f03.akpm@linux-foundation.org> <4FE9621D.2050002@parallels.com> <20120626145539.eeeab909.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=kqYf94TO9vpyB3OX6ugnp4UpRScKgmJQjACNVYEBJ7k=;
        b=mtVrtMlfuvovmUBY01tvng69nQ12ZdRVMdZRomCCe1YyzyuKiDH6m7JfSqQYOIRLxT
         bJQzYpjaHMMRDCGRyPqrDB5T429vMFiZwBBjIUF6xfeF4fngTn2r6VL+tM8J4GMTHtGC
         IkNavthhBiJryvrwnIAC5mMtAClNghlVmjN5AyjY4tUGrMNOtRbNr7zb+Tyul0qe0ExS
         u042oyZYNvw4wNOXGFnC7VHR4ngbRoOuhdfP+2114P5r8HEFzRb/Xbn3KYWyxzwzguJd
         /r9GE/YD7V5W5qSe1v+Uyd6td6xNoZLcKrURAaupPHRROEJvCEITVvEWjpJII0W2qZW/
         JdTQ==
In-Reply-To: <20120626145539.eeeab909.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>

On Tue, 26 Jun 2012, Andrew Morton wrote:

> mm, maybe.  Kernel developers tend to look at code from the point of
> view "does it work as designed", "is it clean", "is it efficient", "do
> I understand it", etc.  We often forget to step back and really
> consider whether or not it should be merged at all.
> 

It's appropriate for true memory isolation so that applications cannot 
cause an excess of slab to be consumed.  This allows other applications to 
have higher reservations without the risk of incurring a global oom 
condition as the result of the usage of other memcgs.

I'm not sure whether it would ever be appropriate to limit the amount of 
slab for an individual slab cache, however, instead of limiting the sum of 
all slab for a set of processes.  With cache merging in slub this would 
seem to be difficult to do correctly.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
