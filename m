From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2] slab+slob: dup name string
Date: Wed, 23 May 2012 18:01:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205231759460.28167@chino.kir.corp.google.com>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home> <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com> <alpine.DEB.2.00.1205230849410.29893@router.home>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=jcLY6SxqZ9qGOYeUNu9GljUbH0o+TJKVashsXacHflE=;
        b=MbyQB+APvvRSk70XZC6XT+iD7hK0vJN0L8QQqjZ73s9vt6cRGYQWQ1Qcb3jhq77lJc
         Z3tunT3XrcOt+phDw2bPFnThr0rVIXFbFkWe8mf7zlfd8iK30JZ4I6OWAfcY0FuLtprM
         +RDfsJTPk91/flaZv/1AWSHYtPOiGyLpwnKV6kuldp//rPKL2Rg6+ch8LRnkHK01WEqj
         1a9gZvtPqnr4Dqdz+Xf8BfslvXUeBDCDKlBLu8W1Q8SX3ESKZ2QDeVJjGAvpTNU1dRcN
         dCc8Tpit19tn2+ZKBGYMF8CaKJQzpgudkFcZFTdXjbh2GIuOkoxFEojauPCJVsWm5Lka
         Y5ow==
In-Reply-To: <alpine.DEB.2.00.1205230849410.29893@router.home>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Wed, 23 May 2012, Christoph Lameter wrote:

> > No, it's not, there's no reason to prevent caches created before
> > g_cpucache_up <= EARLY to be destroyed because it makes a patch easier to
> > implement and then leave that little gotcha as an undocumented treasure
> > for someone to find when they try it later on.
> 
> g_cpucache_up <= EARLY is slab bootstrap code and the system is in a
> pretty fragile state. Plus the the kmalloc logic *depends* on these
> caches being present. Removing those is not a good idea. The other caches
> that are created at that point are needed to create more caches.
> 
> There is no reason to remove these caches.
> 

Yes, we know that we don't want to remove the caches that are currently 
created in kmem_cache_init(), it would be a pretty stupid thing to do.  
I'm talking about the possibility of creating additional caches while 
g_cpucache_up <= EARLY in the future and then finding that you can't 
destroy them because of this string allocation.  I don't think it's too 
difficult to statically allocate space for these names and then test for 
it before doing kfree() in kmem_cache_destroy(), it's not performance 
critical.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
