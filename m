From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Wed, 23 May 2012 09:48:51 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205230947490.30940@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home>
 <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com> <4FBCD328.6060406@parallels.com> <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1337784533; bh=HNhXJRxJ4ASzbW+Ht0mL8v5kBUVCxEBUHQ1rNNsXYzM=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=0WlEX04wMcn0tsoRj4xjk1Qq2cPWjXYO6fO1gqfa5mZrez3TktML6NUbe1P5TIFJqxc9sMFV/D2oyS5qsgC8/h/4KmfLJWeHxJ26G+cDO3HxrURKHTNL0YMhY6eiczasW7dpYHlGGvGhanFtDkwW5lZm2b3+j6v62s32Bku8vFc=
In-Reply-To: <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Glauber Costa <glommer@parallels.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Wed, 23 May 2012, James Bottomley wrote:

> > > So, why not simply patch slab to rely on the string lifetime being the
> > > cache lifetime (or beyond) and therefore not having it take a copy?

Well thats they way it was for a long time. There must be some reason that
someone started to add this copying business....  Pekka?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
