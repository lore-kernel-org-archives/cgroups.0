From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Tue, 18 Jul 2017 13:10:34 -0400
Message-ID: <20170718171034.GE585283@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <825f2eaa-568a-a156-f04d-9235b20e2614@redhat.com>
 <5fa00590-551f-85d2-511b-ef4033781228@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wix5oRxOT7UTIq0OWF0oJAbxLQxfObzvoRutSpKH/8E=;
        b=CH7HS3UIn58XqJjg+lM19P0dxAmKTAkexFiA8XvkAv/Fe3HBzbUbY4VXzaxhLVLU3c
         qfARroZoqwVstTwZLqE76WHKC0Crxwa5VUBVs17Wdcv3lmPx1eSf0/s9aZ47Hdw3NCGi
         rxZAS3uf3dbB9sb+Zc/2S1sTRmhXiEXc3jPu13DANbXr2N7gyI8ilQ1VCWJO1EDQA52D
         ku+za0pkp2x2wVik9i/6BogA+GByN3bUtyTgIWIrt1KjmTfj81n1+UCAK6jwfCKO4k9j
         7rIZv8fumW4WrPoYJe2DKQZ7Gm9xOST4S03PoHgPOLPW2bbX3emkbz08TcHe10oaGm6r
         /fOw==
Content-Disposition: inline
In-Reply-To: <5fa00590-551f-85d2-511b-ef4033781228-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Waiman.

On Tue, Jul 18, 2017 at 10:37:41AM -0400, Waiman Long wrote:
> Thinking about it some more. There is a place for invalid domain. It is
> not the child of a threaded cgroup. It is the siblings of a threaded
> cgroup whose parent is not root.
> 
>        Root - A (domain) - B (domain)
>                          \ C (domain)
> 
> With "echo threaded > B/cgroup.type":
> 
>        Root - A (threaded domain) - B (threaded)
>                                   \ C (domain, invalid)

Yes, I noted that when I was replying to Peter.

> Any children of a threaded cgroup should be threaded.

It's really difficult to discuss if you just declare that something
should be a certain way without giving rationale for thinking so.

If we could get rid of the invalid state completely that way, I'd
completely agree with you but that isn't the case here as you noted
yourself, so the choice between the two isn't something trivially
clear.  Both choices come with their pros and cons.  We can absoultely
discuss them comparing the pros and cons.

Thanks.

-- 
tejun
