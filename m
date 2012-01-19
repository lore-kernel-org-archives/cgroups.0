From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] splitting cgroup.c
Date: Wed, 18 Jan 2012 18:24:01 -0800
Message-ID: <20120119022401.GH21533@google.com>
References: <4F177C67.6070907@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Id1D5n7ny3GWLmqjpHXAVD7I00fX3Eb+bsSlxQlPts8=;
        b=iq3UmyzCG94QuhhcDw3as/j4mBR+rKw6vwmSCR5h+BdN+fOf1NCdF/Yr8NhKlGr/EH
         BSg2FDXN1wMzqb8dXI2sKu4zwEcc0j8Utt/uovWJ+06xCHTE37/W/vWOMKu5VFY84SG8
         Fqx1sEXKsDX12EPZY70Pc2VmbSRM1aEBRczyE=
Content-Disposition: inline
In-Reply-To: <4F177C67.6070907-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Thu, Jan 19, 2012 at 10:13:59AM +0800, Li Zefan wrote:
> While working on cgroup xattr, it appeared to me it's better to
> create a cgroup_xattr.c instead of stuffing things into cgroup.c.
> 
> Then I took a look at how big it is.
> 
>     $ ls -l -S kernel/*.c
>     -rw-rw-r--  1 lizf lizf 142717 Jan 18 10:15 cgroup.c
>     -rw-rw-r--  1 lizf lizf 106498 Jan 18 10:15 workqueue.c
>     -rw-rw-r--  1 lizf lizf 105206 Jan 18 10:15 lockdep.c
>     -rw-rw-r--  1 lizf lizf  91321 Jan 18 10:16 module.c
>     
>     $ wc -l kernel/*.c | sort -n -r
>       90397 total
>        5289 cgroup.c
>        4206 lockdep.c
>        3840 workqueue.c
>        3507 module.c

Yeah, cgroup.c one giant file.

> So I think for the sake of readability and maintainability, we'd
> better split cgroup.c into smaller pieces:

I agree that splitting is necessary but IMHO splitting usually tends
to go too far.  Maybe we can split it into two and think about further
splitting later on?  e.g. internal logic vs. userland interfacing.

Thanks.

-- 
tejun
