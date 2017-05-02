From: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix wrong unlock order when parse per blkg
 config
Date: Tue, 2 May 2017 08:41:48 +0800
Message-ID: <c39a752d-034e-02a0-3c46-892e42c6616a@gmail.com>
References: <be8d9709-84fe-d2df-f294-a12701675e27@gmail.com>
 <20170428212233.GE22354@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=KAztRAlihrq6EDnd1nqvuKZz/w62W2pV+vG4ITAv4Tc=;
        b=SDOToqW06nx5Mw6Mtp9qa6onhGLXvPUbGfiZj2kAx+bhOgKNpg9emhDjU7+EqYwjUH
         GsDZtZW86E52HVs6NDKBIZnFDynrJ7sR4hpQxlRlsxpJzsEotlt4VzwUIAfz8eJCXR7N
         IsTg1uZQopj/ILgpnB+b8VYCz+MhrCL1obdrxb7TYqOpHeAKpWcdj6PvqhzniiZ+WAeX
         rdOZoEXHIG3ymvWc92QpoUAkgGO1T620qt4/VFAN3EvthlIRQXj2ezQa3AKD9pgFwa3J
         2T1XdIrihmXvyEt4lzIxXEsxyqtRr+S/ZikIRm6NEGcXTYYOuxM4BurICXUASq6u7rTg
         VB6Q==
In-Reply-To: <20170428212233.GE22354-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wenqing.lz-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, boyu.mt-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org

Fine, I will explain so and resend it later.

Thanks,
Joseph

On 17/4/29 05:22, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 24, 2017 at 06:52:05PM +0800, Joseph Qi wrote:
>> From: Joseph Qi <qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
>>
>> In case of error blkg in blkg_conf_prep, we should unlock
>> queue->queue_lock first and then rcu, just like blkg_conf_finish.
> 
> I get that this is inconsistent but why is this wrong?  If this is for
> consistency, can you please explain so in the commit so that people
> don't confuse it for an actual bug fix?
> 
> Thanks.
> 
