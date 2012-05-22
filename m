From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Tue, 22 May 2012 15:31:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com>
 <alpine.DEB.2.00.1205221216050.17721@router.home>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=pyPpT/H48Jm8MMCcuygsv+ZjfUmPWnXoEgZ6ZU0W7ho=;
        b=LxZ3cew77aSq1gcIdGV0a4nx0ryIMVZg1F8qD9QGznXGRSvPaf962YBx2DzuqNmD48
         L5d1Trbp40eOHALmXpjEsOy1k6Ew9KVbLUheMejIXoMoU6lGoYNdlGCEfKjU3aMzAssM
         fTWVW8DzZP6GmBsZWKAVC+TYC87/Gt/teA0vLwLSCFb0DpbkcXwj+n/Gfg0BwZxGXrh/
         nlgLt6uN7G2MRd2zTey1JhgEqNHsqoWKVao05XNBUmZn+1ioE4rh6DrJfZEyO0XFa4ne
         JskrVPzh7LrR+gBQ6OpJwWapQXOQJ3w25EmuWSuMqJQc5i7qv6F4xjPJHhGWN4Bz/PoV
         DKvw==
In-Reply-To: <alpine.DEB.2.00.1205221216050.17721@router.home>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Tue, 22 May 2012, Christoph Lameter wrote:

> > I think that's precisely David's point: that we might want to destroy them
> > eventually.
> 
> Cannot imagine why.
> 

We can't predict how slab will be extended in the future and this affects 
anything created before g_cpucache_cpu <= EARLY.  This would introduce the 
first problem with destroying such caches and is unnecessary if a 
workaround exists.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
