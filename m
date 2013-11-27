From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Wed, 27 Nov 2013 15:34:24 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com> <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com> <20131127163916.GB3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com> <20131127225340.GE3556@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=Gb9YZyot38sSsni2ouiJaUhNPC1GupM/3nyymjy33lw=;
        b=OvVxUX/lQkU3Y0r98S5EQ9cO1JvBp8jAB7rm6GniSOXFK3kCRJWMvBWXnzxqrQlbij
         2ASQqkbIHVo3ehxQLXULntpp71dgflx6lGaeJL9Jtqij+bufiAhfZR2SV7juVrjxuaMr
         nqcLSSunRlDR+BA3ic+cbtaLzKYg7/RIPOGShrZWy3xy4N37KuLGUAtwgQFl+VOgtBgK
         hwYiJYWtx8FvGwk2zJLkkF3eCzhktqyWUtwyCkbtP2GhtsFxPtFOXrkzbYqvAydE7ptw
         em8R3ccvAjx6ItmAziAeT9J/7vVv9W70j0jhkgvn+0gAw7Azq95xiQVmLHHYVsn7yS8T
         XLMw==
In-Reply-To: <20131127225340.GE3556@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Johannes Weiner wrote:

> > We don't give __GFP_NOFAIL allocations access to memory reserves in the 
> > page allocator and we do call the oom killer for them so that a process is 
> > killed so that memory is freed.  Why do we have a different policy for 
> > memcg?
> 
> Oh boy, that's the epic story we dealt with all throughout the last
> merge window... ;-)
> 
> __GFP_NOFAIL allocations might come in with various filesystem locks
> held that could prevent an OOM victim from exiting, so a loop around
> the OOM killer in an allocation context is prone to loop endlessly.
> 

Ok, so let's forget about GFP_KERNEL | __GFP_NOFAIL since anything doing 
__GFP_FS should not be holding such locks, we have some of those in the 
drivers code and that makes sense that they are doing GFP_KERNEL.

Focusing on the GFP_NOFS | __GFP_NOFAIL allocations in the filesystem 
code, the kernel oom killer independent of memcg never gets called because 
!__GFP_FS and they'll simply loop around the page allocator forever.

In the past, Andrew has expressed the desire to get rid of __GFP_NOFAIL 
entirely since it's flawed when combined with GFP_NOFS (and GFP_KERNEL | 
__GFP_NOFAIL could simply be reimplemented in the caller) because of the 
reason you point out in addition to making it very difficult in the page 
allocator to free memory independent of memcg.

So I'm wondering if we should just disable the oom killer in memcg for 
__GFP_NOFAIL as you've done here, but not bypass to the root memcg and 
just allow them to spin?  I think we should be focused on the fixing the 
callers rather than breaking memcg isolation.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
