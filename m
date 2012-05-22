From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Tue, 22 May 2012 08:56:47 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205220855470.17600@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1337695009; bh=t9j54Bg8PbjYXLQAIYt4Vz1PIwhT4WnRuhcTf5pRjpA=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=0aNJDqynB/uGoc6+WwlGPvhY68oQ6u3hDD5/wYR+7PkZHjx6iK3ZQ1Ojb2D5XjY6vXkrAiZVDitiuBkenymWEedW7+CyS5OBcuSCNCayeL1UdpJyfhp7EIwt08quyyQ/5r9JCrxffat7VrRw/vvKPXugUt2XSBfcVsprPLUI5Xw=
In-Reply-To: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Mon, 21 May 2012, David Rientjes wrote:

> This doesn't work if you kmem_cache_destroy() a cache that was created
> when g_cpucache_cpu <= EARLY, the kfree() will explode.  That never
> happens for any existing cache created in kmem_cache_init(), but this
> would introduce the first roadblock in doing so.  So you'll need some
> magic to determine whether the cache was allocated statically and suppress
> the kfree() in such a case.

Nope. Only slab management caches will be created that early. The patch is
fine as is.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
