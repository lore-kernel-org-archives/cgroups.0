From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
Date: Wed, 27 Jun 2012 12:46:08 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206271239340.22162@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206260210200.16020@chino.kir.corp.google.com> <4FE97E31.3010201@parallels.com>
 <alpine.DEB.2.00.1206262100320.24245@chino.kir.corp.google.com> <4FEAD351.2030203@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=yo893/iIUFbjfpQwc0RjQbg9OEC1/cj9gNBjG/tusWE=;
        b=A7DdW5aGrSEeCRZAf9LEjM5oi6LDSBkJ8lmsfolH3je0CqRqYM0Q4wamBWORI7cNBj
         gTTHUoyjME1PqLj38gHBe/tPxwQYMeryGbANBGPIdxwHmsV+35Jwv335eG84Kzu6OwOA
         VMeU+Y7RD8L557PMVFSuV1pwIQfoBMW93kVFLTh/+ogIF7GxWRgKklJaCrNS6MpkiGhV
         8nijtEr+3wGOFVpg6Rm25TWIBAz4DVARjeXoRAzmu440szMc2txqhC9+8tWqf+VoeJ6y
         Gsumpry9o6l+uwiej2MUXQn4fjWDr96l5e9Kry2CqUHsFwa94fo8iaWFhhF2iTsZlIpQ
         ZbKA==
In-Reply-To: <4FEAD351.2030203@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>

On Wed, 27 Jun 2012, Glauber Costa wrote:

> > > Nothing, but I also don't see how to prevent that.
> > 
> > You can test for current->flags & PF_KTHREAD following the check for
> > in_interrupt() and return true, it's what you were trying to do with the
> > check for !current->mm.
> > 
> 
> am I right to believe that if not in interrupt context - already ruled out -
> and !(current->flags & PF_KTHREAD), I am guaranteed to have a mm context, and
> thus, don't need to test against it ?
> 

No, because an mm may have been detached in the exit path by running 
exit_mm().  We'd certainly hope that there are no slab allocations 
following that point, though, but you'd still need to test current->mm.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
