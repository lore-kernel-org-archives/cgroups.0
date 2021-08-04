From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Disable task obj_stock for PREEMPT_RT
Date: Wed, 4 Aug 2021 09:39:23 +0200
Message-ID: <93dfe0d4-c687-93f8-da75-c5d3c9bd0ac7@suse.cz>
References: <20210803175519.22298-1-longman@redhat.com> <87h7g62jxm.ffs@tglx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628062763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvd9pPr9EanKWBW5cDt9Sg5pvM2uTEKHOrqxlKqLhuE=;
        b=UzHHJ65hvzZkwrhUytOaNbHvEDJs+m6w9AqJrpSN6Eu7Fk+tWYzFaysfAMgWLxPAXRKsK5
        WgC5cerdwOJLCAD+Yad0uXurjc6hwK/zhAl5uAC5zbuB/OBcUpIK7RFkkHtnosVMYVepM2
        V7ivdH+N7LSHpj0BA9Q4M6aMZRESDds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628062763;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvd9pPr9EanKWBW5cDt9Sg5pvM2uTEKHOrqxlKqLhuE=;
        b=l4IOXECy3nbKl00pW05d5t9CIG9R796gBwYSXRuZBE5IUbxcGEybBzu45/vZBwug9NuH04
        XOt3qwD29AbYVVDg==
In-Reply-To: <87h7g62jxm.ffs@tglx>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Luis Goncalves <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/4/21 1:21 AM, Thomas Gleixner wrote:
> 	/*
> 	 * The only protection from memory hotplug vs. drain_stock races is
> 	 * that we always operate on local CPU stock here with IRQ disabled
> 	 */
> -	local_irq_save(flags);
> +	local_lock_irqsave(memcg_stock_lock, flags);
>         ...
> 	if (use_task_obj_stock())
>   		drain_obj_stock(&stock->task_obj);
> 
> which is incomprehensible garbage.
> 
> The comment above the existing local_irq_save() is garbage w/o any local
> lock conversion already today (and even before the commit which
> introduced stock::task_obj) simply because that comment does not explain
> the why.

Michal, this seems to be your comment from commit 72f0184c8a00 ("mm, memcg:
remove hotplug locking from try_charge"). Was "memory hotplug" a mistake,
because the rest of the commit is about cpu hotplug, and I don't really see a
memory hotplug connection there?
