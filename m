From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/10] memcg: Introduce __GFP_NOACCOUNT.
Date: Wed, 29 Feb 2012 11:09:50 -0800
Message-ID: <CABCjUKBHjLHKUmW6_r0SOyw42WfV0zNO7Kd7FhhRQTT6jZdyeQ@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-5-git-send-email-ssouhlal@FreeBSD.org>
	<20120229150041.62c1feeb.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=BFmY3lDZ8MWgBwViTgcye0FYsjfOe10cksbXuXOEXVs=;
        b=UZDJdeB66jbK+stg1utw/TxBPZ201k5FN0WqnJCx4bfsqcjgtHONUT9U96WCxt1a2U
         3Pr2YdWCh26NjQXnsB1ftxMoTogVzm+QAAH4psszwEnKVpLlkFAJ52YvGyMbiNAh3eip
         ZZ+R8lNkN4cIw3QSJwGtwJzFYRE72tg7Zrz96X/2+OMLRlqOdWy+f9rt+pEMcovo9BgO
         PpVxCAXZEYQ2Dbg8zgfvnAGSyIk5YnazNPrRmwJMWUvPnfZhCuycML8bBlmGS8/m5d0H
         l9u4mYsVLpPSnoLbAkjRsgMZnNr7yuLRozVl7zk5fnRgFEW8zIIA/t6+9NEjUdzasfbA
         35Mg==
In-Reply-To: <20120229150041.62c1feeb.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, Feb 28, 2012 at 10:00 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> On Mon, 27 Feb 2012 14:58:47 -0800
> Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org> wrote:
>
>> This is used to indicate that we don't want an allocation to be acco=
unted
>> to the current cgroup.
>>
>> Signed-off-by: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> I don't like this.
>
> Please add
>
> ___GFP_ACCOUNT =A0"account this allocation to memcg"
>
> Or make this as slab's flag if this work is for slab allocation.

We would like to account for all the slab allocations that happen in
process context.

Manually marking every single allocation or kmem_cache with a GFP flag
really doesn't seem like the right thing to do..

Can you explain why you don't like this flag?

-- Suleiman
