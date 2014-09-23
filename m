From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] cgroup fixes for v3.17-rc6
Date: Tue, 23 Sep 2014 09:05:33 -0400
Message-ID: <20140923130533.GA14905@mtj.dyndns.org>
References: <20140923063353.GK11740@mtj.dyndns.org>
 <54211707.8090604@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DYTm1pf6siwDGKtxFdphaCP5uzkjlWx2jugZCU2PKPU=;
        b=RNvI+bpKAUscQrzBjn9RTDRfKXtfJZn8iEa3rC60WXJ/7OGY4xUN//CYlY9do5hgjh
         axnuDTU/aQ4h0boN4Mov7PcVeYCUcTKZ+DhVafY5VlwxW9LNwnELIXu7re6iX2j0zfZS
         ymOnsew/br2JNB7qNw1DuhngJmwAADmcoDS82dzjWIqv2KivNzcR9tcyhKVeRF7gxIg7
         QFMglRC6HxbjL5biid7KqWqffNltyeWuP9XyKrjrgmiYaUhcspu5deSrQF7DJLDZqAXv
         4CD/LbEPXTlf72a6CXbxPBBpY+4+cr+4SPVzoLcIuzoGPTdo7+RbwzDn3vB/jthyyf9J
         skVQ==
Content-Disposition: inline
In-Reply-To: <54211707.8090604-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 23, 2014 at 02:45:27PM +0800, Zefan Li wrote:
> On 2014/9/23 14:33, Tejun Heo wrote:
> > Hello, Linus.
> > 
> > One late fix for cgroup.  I was waiting for another set of fixes for a
> > long-standing obscure cpuset bug but am not sure whether they'll be
> > ready before v3.17 release.  This one is a simple fix for a mutex
> > unlock balance bug, which is detected by coccinelle and probably won't
> > trigger in the wild, introduced during this devel cycle.
> > 
> 
> It was introduced in 3.14, and it was detected by my eyes, not coccinelle. ;)

Hah, I got it completely mixed up with another patch in my head.  Will
post an updated pull request.  My apologies.

Thanks.

-- 
tejun
