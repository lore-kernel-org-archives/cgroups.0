From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] slab+slob: dup name string
Date: Tue, 22 May 2012 20:55:53 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=eENwQ2rA/G65JLa4S2L31Lj3Mkq75giA8ovbOREXYPI=;
        b=Rz1+rbwSUO05n79oGoA7JIPCPc8kI/fSIW8N7UuC1qdPaQviD6bmXQbdd980Ysw86N
         JpNkvJIN2dGJRcqByN0IDAxV5KNICct47p1buFfWD9Rbl6cQZ6AehzclIJTY5v1Rk7Mp
         zJWw2QI3MpSHDtZNvj1m5coD9ay1Fx/3GafK0zaLNLJA2SVnk5CmnY4PIwUqq+NJDSdm
         3tBBIfN9Hu3ZnWIw+szeXOnh5NsQT/wvZhKdFV0J04VXXFRFdMc+Hg+1K6v9kgme6dgl
         soguBIn2x3QhUYwon18WS6hNrI+Rua2ov6yIJThAaVUQJ6UjMjpZkk6NUSxl/MrbZIgj
         gtYQ==
In-Reply-To: <alpine.DEB.2.00.1205220857380.17600-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, 22 May 2012, Christoph Lameter wrote:

> > [ v2: Also dup string for early caches, requested by David Rientjes ]
> 
> kstrdups that early could cause additional issues. Its better to leave
> things as they were.
> 

No, it's not, there's no reason to prevent caches created before 
g_cpucache_up <= EARLY to be destroyed because it makes a patch easier to 
implement and then leave that little gotcha as an undocumented treasure 
for someone to find when they try it later on.

I hate consistency patches like this because it could potentially fail a 
kmem_cache_create() from a sufficiently long cache name when it wouldn't 
have before, but I'm not really concerned since kmem_cache_create() will 
naturally be followed by kmem_cache_alloc() which is more likely to cause 
the oom anyway.  But it's just another waste of memory for consistency 
sake.

This is much easier to do, just statically allocate the const char *'s 
needed for the boot caches and then set their ->name's manually in 
kmem_cache_init() and then avoid the kfree() in kmem_cache_destroy() if 
the name is between &boot_cache_name[0] and &boot_cache_name[n].
