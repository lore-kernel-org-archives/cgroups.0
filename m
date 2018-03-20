From: David Rientjes <rientjes@google.com>
Subject: =?UTF-8?Q?Re=3A_=E7=AD=94=E5=A4=8D=3A_=E7=AD=94=E5=A4=8D=3A_=5BPATCH=5D_mm=2Fmemcontrol=2Ec=3A_speed_up_to_force_empty_a_memory_cgroup?=
Date: Tue, 20 Mar 2018 15:45:27 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803201540290.45142@chino.kir.corp.google.com>
References: <1521448170-19482-1-git-send-email-lirongqing@baidu.com> <20180319085355.GQ23100@dhcp22.suse.cz> <2AD939572F25A448A3AE3CAEA61328C23745764B@BC-MAIL-M28.internal.baidu.com> <20180319103756.GV23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C2374589DC@BC-MAIL-M28.internal.baidu.com> <alpine.DEB.2.20.1803191044310.177918@chino.kir.corp.google.com> <20180320083950.GD23100@dhcp22.suse.cz> <alpine.DEB.2.20.1803201327060.167205@chino.kir.corp.google.com>
 <56508bd0-e8d7-55fd-5109-c8dacf26b13e@virtuozzo.com> <alpine.DEB.2.20.1803201514340.14003@chino.kir.corp.google.com> <e265c518-968b-8669-ad22-671c781ad96e@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=NPikiFOK6hIbw8sv4Z0hFwFFiEM+tdmFNMryWQvorQ4=;
        b=FpU6InHvW2aIe+EtX5hwDHfbheX7JKOx8zxLZ/8HgqC6xWYiOol+CgXcKpttGghqfr
         +bP4/kSt9poe1G7V8VdvSIk/tEjn/bmNBcVDQ5wxgxoPLFi4a3tPehaJ8R/TEIGLW/sq
         FvNtaQibnekhMHENcQkZbP2GDzfa7Tau2StSEXncUn2yOqmRJy/r6brkGfSx4dbL48Gk
         YoFjAMZSJLdEiPKHvIRO4EZD7C7zYYxszsnTmFp3ghX2iDm/6fdMYHdtq1ElHw0sWCrY
         j1wCivRH6MLHxrXvr8zskte32yDzP+ELpo6sqF9+F2NTZbSaobFx9ZMoR++onjMrRTpP
         xbjg==
In-Reply-To: <e265c518-968b-8669-ad22-671c781ad96e@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Li,Rongqing" <lirongqing@baidu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>

On Wed, 21 Mar 2018, Andrey Ryabinin wrote:

> > Is SWAP_CLUSTER_MAX the best answer if I'm lowering the limit by 1GB?
> > 
> 
> Absolutely not. I completely on your side here. 
> I've tried to fix this recently - http://lkml.kernel.org/r/20180119132544.19569-2-aryabinin@virtuozzo.com
> I guess that Andrew decided to not take my patch, because Michal wasn't
> happy about it (see mail archives if you want more details).
> 

I unfortunately didn't see this patch in January, it seems very similar to 
what I was suggesting in this thread.  You do a page_counter_read() 
directly in mem_cgroup_resize_limit() where my suggestion was to have 
page_counter_limit() return the difference, but there's nothing 
significantly different about what you proposed and what I suggested.

Perhaps the patch would be better off as a compromise between what you, I, 
and Li RongQing have proposed/suggested: have page_counter_limit() return 
the difference, and clamp it to some value proportional to the new limit.
