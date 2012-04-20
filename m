From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] block: per-queue policy activation, take#2
Date: Fri, 20 Apr 2012 10:17:42 -0700
Message-ID: <20120420171742.GC32324@google.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <20120420080943.GG7505@kernel.dk>
 <4F91503D.2060402@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QWwDzg6qRfSMe14GP0MCUS6nOovx/qQROt4mH0UGj3g=;
        b=IngpYjFiLoiaoojAPCFuyeT2q0cuapZ2om0mwkduj7ttQyELxATMvANqps+NXdbDxS
         wGszyV+zemgKX7ixWBfO5qZN3+eJZXO0WofzkwAILfxIhkz2kGeCi67FqloBvPZN9PeO
         JhLxibKyw/37KTklEvD5KBVBUDTN59qgvf4dnrs7418yoJ26WdAp0dob+EOpfEpPXDf+
         4HnOEoE4FX4+ZTONSPf3Xqhdqbpd91abaz7CP1JGE3K9lHFJ28WAdcM06Ytp9H1FBxp7
         DemnrT4+N8zYfS4x1s8QL/jnlYwgM64LgNoQNIjhYyzSSM4yryquXQybx3XFMRCDqq+8
         1k+Q==
Content-Disposition: inline
In-Reply-To: <4F91503D.2060402-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Jens.

On Fri, Apr 20, 2012 at 02:02:05PM +0200, Jens Axboe wrote:
> Tejun, everything merged in cleanly. A boot test didn't not go so well,
> I'm afraid. It complains about stuck RCU. Even with extra RCU
> debugging/info turned on, it doesn't give my any extra info.
> 
> Config is attached. I can try and debug this on Monday, for now I've
> pulled it out of for-next again.

Hmmm... it works fine with the same config here (qemu w/ 4 cpus
configured).  Doesn't stuck RCU usually come from unbalanced RCU
lock/unlocking?  That should trigger context or RCU warnings before
anything else, weird.  Anyways, it would be great if you can provide
more info on how to reproduce the problem.

Thanks.

-- 
tejun
