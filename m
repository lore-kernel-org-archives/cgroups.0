From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
Date: Thu, 18 Oct 2012 15:06:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210181502270.30894@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <20121017151214.e3d2aa3b.akpm@linux-foundation.org> <507FC8E3.8020006@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=UJJOe1TQV4udxQ0sqE9VzrjGrr67pADSSHtP5ehby8o=;
        b=DFCJLCL2BDmvUx2P66fAO2NX0OC/yHhQ/NhWqVRZGZu9KiZpsWYBTqDTyjWt4sQhgf
         h4eqxBJ6AeOiAsMsUloA0KseXkJtdaULxjKQnSTIJM2WIWzLWVD0GQfe5BMDI9RwEnnH
         7jhHLRq/AFPJMuhkCjX2J8hNC3sZ7SLa2E7Sj3qo46F1Gz/9jZiNCNBnF2UZzrQJUvUf
         7Lt5aJGAgSWGGB2ncn+h2bVbXs2MkpTjLjQZOI8rnlUCEsWx3tnezv24dGGhVjpZb0x1
         6/T37kiXHLRtaQ2sYM9CNx7dPNN9jC1wuhJ7W591d4bMDqlzivZ8Hc4dNGfarY+wKfyw
         Sdvw==
In-Reply-To: <507FC8E3.8020006@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Thu, 18 Oct 2012, Glauber Costa wrote:

> > Do we actually need to test PF_KTHREAD when current->mm == NULL? 
> > Perhaps because of aio threads whcih temporarily adopt a userspace mm?
> 
> I believe so. I remember I discussed this in the past with David
> Rientjes and he advised me to test for both.
> 

PF_KTHREAD can do use_mm() to assume an ->mm but hopefully they aren't 
allocating slab while doing so.  Have you considered actually charging 
current->mm->owner for that memory, though, since the kthread will have 
freed the memory before unuse_mm() or otherwise have charged it on behalf 
of a user process, i.e. only exempting PF_KTHREAD?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
