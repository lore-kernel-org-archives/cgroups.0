From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Tue, 22 May 2012 12:16:18 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205221216050.17721@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1337706980; bh=CmbX9qSZrO0l4EkEx/Be3daGDkg9epbRjpJJU8oJgoE=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=M6Ia6YPbAPGeWOieOwRp7PHEI0Cr19HOE7qn4jheTkMPtPQdmS0Gnl6NuUzhZ2WKP7f/lw8W5d8QBNi34rsuToD9Do4umdS+ACKu3W4H5KS3kiwH8TYyTjdjMkx56Q/tIfxizajXwpnmObSj2qwFa/CR4QqjHggZvwX2CuaAoD8=
In-Reply-To: <4FBBAE95.6080608-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, 22 May 2012, Glauber Costa wrote:

> I think that's precisely David's point: that we might want to destroy them
> eventually.

Cannot imagine why.
