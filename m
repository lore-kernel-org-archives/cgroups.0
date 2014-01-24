From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Date: Fri, 24 Jan 2014 05:27:58 -0500
Message-ID: <20140124102758.GA4101@htj.dyndns.org>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
 <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
 <52E1C8BD.2010500@huawei.com>
 <CAKohpomn_wgQExfhJL6=MB9LrRhR4=+7t3ehy0d6vEq9duzr8Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fQ410ZNczJOAZkFRyIpQnJkk2zfcvrwUPubQvCxQtUU=;
        b=uN+FPPxkm8DI8D01wwtNuGlOQd/l8Q+QjE6OJd1zgflJiu+CDGK+LZPhhlWGZNBcCV
         RELYC6msUADCUnBWTsXG4OYi1xWcvDSMsGNWzPtt/kZ06AVKYIl0LxQO/IskkF9SQRsV
         tseOVRX2lXtysrdtuxObbEj0zVAxPF8LnK+avRTstVMk4Hu+4RFziLkw69f7l/hpRz0N
         mvO8A42M0/c8SVLjslObsvM0T0u5QWZGWW3LCXf1MZTcBf3QgsG24fwiCl+ncIcF2jfJ
         pSsBpxe1qeXQnCJLi3xmBbBS0uGi9lr6lPufHfni/3WnEIb9+llJK22atBlVPn2AMNBg
         zpXw==
Content-Disposition: inline
In-Reply-To: <CAKohpomn_wgQExfhJL6=MB9LrRhR4=+7t3ehy0d6vEq9duzr8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jan 24, 2014 at 10:27:34AM +0530, Viresh Kumar wrote:
> On 24 January 2014 07:28, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> >> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Thanks..
> 
> > I would like this patch be picked up by Tejun. I'll send out a patchset
> > for cpuset which may have confliction with this one.
> 
> Its already applied by Andrew Morton..

Ummm... so, the original posting forgot to cc Li (the maintainer), me
or cgroups mailing list.  Please don't do this in the future.

Thanks.

-- 
tejun
