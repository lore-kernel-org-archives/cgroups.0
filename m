From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Wed, 23 May 2012 10:17:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205231012330.30940@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home>
 <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com> <4FBCD328.6060406@parallels.com> <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1205230947490.30940@router.home>
 <4FBCFBE0.2080803@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1337786225; bh=u/k5enIYSC4k78eWBieStU8nLLIA9TrF6rTnueIzLbU=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=QVupEakUdmAamSaf5doUgHtucMwMuBhY4L/RF4K5VNweVjpVw78g3yMq/+QLy0pfD0s74shlM5MvzGsJQiRUCpqoHVbjaSpCbZvoYdFzkndidy0aMP4CekL5Ppyn78asCEN0yZirHDqTTVa35U9NDZJU8pvfiQfVe152Ym7sCR4=
In-Reply-To: <4FBCFBE0.2080803-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Wed, 23 May 2012, Glauber Costa wrote:

> So if I understand it correctly, this is mostly because the name string
> outlives the cache in the slub case, because of merging ?

Well this means we really only need the copying in slub which we already
have.

The problem is that you want to make this behavior uniform over all
allocators so that you do not have to allocate the string on your own.

Could you wait (and not rely on copying) until I am through with the
extraction project for common code for the allocators? At that point we
can resolve this issue consistently for all allocators.


