From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2] slab+slob: dup name string
Date: Tue, 22 May 2012 12:18:29 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205221216590.17721@router.home>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home> <4FBBB059.1060903@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1337707111; bh=7DTDr/ZNQmFhWHGxmeB3tJq5aOyqEAJsEb6cMsR/FR8=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=LTIYBDSIsfPeVlbdSl3xYaXwnpuRJc25/aEahR0UHDMzkp8P0yiB86GCiyWMHppt25owXWWXbH4laxg2/M+29tNV/Skme74S9UyH7CBuIr595u3gx3rlpsTrWAIvVeuYdqh+NUW0f6nFwVTVExHHrlWWf7mgzTw69M4WKFtWY7E=
In-Reply-To: <4FBBB059.1060903@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>, David Rientjes <rientjes@google.com>

On Tue, 22 May 2012, Glauber Costa wrote:

> On 05/22/2012 05:58 PM, Christoph Lameter wrote:
> > On Tue, 22 May 2012, Glauber Costa wrote:
> >
> > > [ v2: Also dup string for early caches, requested by David Rientjes ]
> >
> > kstrdups that early could cause additional issues. Its better to leave
> > things as they were.
> >
>
> For me is really all the same. But note that before those kstrdups, we do a
> bunch of kmallocs as well already. (ex:

We check carefully and make sure those caches are present before doing
these kmallocs. See the slab bootup code. A kstrdup may take a variously
sized string and explode because the required kmalloc cache is not
present.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
