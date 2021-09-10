From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] support cgroup pool in v1
Date: Fri, 10 Sep 2021 08:01:50 +0200
Message-ID: <YTr0zvythCIJk4Xb@kroah.com>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <YTiugxO0cDge47x6@kroah.com>
 <a0c67d71-8045-d8b6-40c2-39f2603ec7c1@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631253733;
        bh=kWhJlIC/1vHbeFhKoaxwk/xnuUNuDuDMWv8UUrP4zwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GKOXggWLy1L4eUBaHMMLpMRIcYzEKuAxNZ96kGhtbWEkketIVT4i+VcUb2tvEfQmq
         /8SEFpiR/3lcdZhmoSCeEkWsx74JVPuFkg6E8bZ7Xu4fBKzz5jPK/HTt6GkMJXJdTL
         vN42zrZNw87OmLaDErMrRv0IPf47T4dVNRQ1N7Ik=
Content-Disposition: inline
In-Reply-To: <a0c67d71-8045-d8b6-40c2-39f2603ec7c1-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "taoyi.ty" <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

On Fri, Sep 10, 2021 at 10:11:53AM +0800, taoyi.ty wrote:
> On 2021/9/8 下午8:37, Greg KH wrote:
> 
> > Perhaps you shouldn't be creating that many containers all at once?
> > What normal workload requires this?
> 
> Thank you for your reply.
> 
> 
> The scenario is the function computing of the public
> 
> cloud. Each instance of function computing will be
> 
> allocated about 0.1 core cpu and 100M memory. On
> 
> a high-end server, for example, 104 cores and 384G,
> 
> it is normal to create hundreds of containers at the
> 
> same time if burst of requests comes.

So it is a resource management issue on your side, right?  Perhaps
stagger the creation of new containers to allow the overall creation
time to be less?

thanks,

greg k-h
