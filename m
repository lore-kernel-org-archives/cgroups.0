From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Wed, 18 Jan 2012 18:40:21 -0800
Message-ID: <20120119024021.GI21533@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
 <20120118213638.GA21533@google.com>
 <20120119014727.GG29242@tango.0pointer.de>
 <20120119022005.GG21533@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wfnZ2AkvdkU9xoLDsIjLUEBL6atKAX+zne8qypVei2c=;
        b=bmsQ9eWBaw3RYdPErZGmOv8nK7+7iOm3nAAadzrhwoB6nP/cHukqst85jC/6tYDKNO
         3AgwWy3Nkr4hTnkCAouu3pP0qA7VpMeEuxXWrJTaxE1Cn2y8Spazztc4myS8vwPtVr6N
         W+vhIyFJMuajVMv+vYr554fxVqkuBW1kqaoUo=
Content-Disposition: inline
In-Reply-To: <20120119022005.GG21533-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jan 18, 2012 at 06:20:05PM -0800, Tejun Heo wrote:
> Hello, Lennart, Li.
> 
> Two things.
> 
> * Probably I'm missing something but isn't the systemd cgroup
>   hierarchy already managed by systemd?  If so, I don't see how
>   managing tmpfs on the side would noticeably make things more
>   fragile.  It would take a bit more care after, for example, restart
>   but it shouldn't be too complex, no?
> 
> * FS attributes already being used for userland information seems like
>   a good argument, but we shouldn't add separate specialized xattr
>   implementation to different pseudo filesystems.  For it to be
>   acceptable, it should be a libfs thing easily applicable to any
>   pseudo FS and definitely shouldn't be using kmem for storage.

Also note that tmpfs also implies size limit.  We definitely need some
form of control over the amount of memory xattr may consume.

Thanks.

-- 
tejun
