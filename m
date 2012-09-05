From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 02:14:56 -0700
Message-ID: <20120905091456.GI3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471379.3060603@parallels.com>
 <20120905090744.GG3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047161F.60503@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6SWLZ13zYnJxvrM4JhUPij+DGMhIiz8tMIFylO+XhDU=;
        b=KVCP5X0MQ4Wss94tGk/WD3ipkZFkJXVBjQw+zN+dHTAaGiLtEdojClHyc/92Vo0W8u
         N299dX0LKbmsrO4P2dqsov0aLOBPhHKJ0uyXG1XaG4kZLfmDi1OqaxrdNOHSkyaZpewU
         pMuUs6FD0GGGSJMIitPrf7QEu36psAdudNAbG2XSOEn7qcX3GXTJUPUIRGJcMKPW6QIe
         6mL09KVjWmjvUi15rKYJ1Us0fYjh6Ua+SU03mlyi+BTTjOEAYnJjDnvP6v3GEJXurz5J
         BrqZyT13sNiyJGFRPKktbQLnCIVP5oMY4eRWUOxqIbiuciIXvDmAmx/2z/u1SPoVosB+
         7OrQ==
Content-Disposition: inline
In-Reply-To: <5047161F.60503-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

On Wed, Sep 05, 2012 at 01:06:39PM +0400, Glauber Costa wrote:
> > Heh, this is tricky to describe and I'm not really following what you
> > mean. 
> 
> Do we really want to start cleaning up all this by changing the
> interface to something that is described as "tricky" ?

The concept is not tricky.  I just can't find the appropriate words.
I *suspect* this can mostly re-use the existing css_set thing.  It
mostly becomes that css_set belongs to the unified hierarchy rather
than each task.  The user interface part isn't trivial and maybe
"don't nest beyond this level" is the only thing reasonable.  Not sure
yet whether that would be enough tho.  Need to think more about it.

Thanks.

-- 
tejun
