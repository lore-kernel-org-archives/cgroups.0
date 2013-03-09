From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Fri, 8 Mar 2013 19:29:36 -0800
Message-ID: <20130309032936.GT14556@mtj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
 <20130307180332.GE29601@htj.dyndns.org>
 <20130307191242.GA18265@redhat.com>
 <20130307193820.GB3209@htj.dyndns.org>
 <513A9A67.60909@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=6P67LbpMiJ9FUVX4yWbGAFwTj7nUF0pHmSiZhMzw5zc=;
        b=CxIYsNRJDR0sMzBNlhL7yPGFtw0roUOilj2IfIIp+h5odaCE2MmvcCSHXJNdeO7q3H
         ABdetKNK47q9Ge+EiRebmCzJ9x1KQ1hC5D/q2RxGVWRZcUIlM1OV52k4by6s0u2FvDUT
         JaEwV5TPPg4NmCOn2rP9y28PnfDEloSeOPBEXHZ5K7uCrnZ8ILBWm07DAyzN9OC/OEbB
         OCthSQWeV5UNW3eBHzyL3i2DwNyYYezFcX43mVHA5vfyGo3Nz2xL/xmukCmQHvECJwz7
         gNHu4dPOLjSdCV9JhOHkxeRWqyK8IRlBbgig2k9FX0fHylwwJCHjCcJAkXvKBrvNmTi9
         7Avg==
Content-Disposition: inline
In-Reply-To: <513A9A67.60909-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Li.

On Sat, Mar 09, 2013 at 10:11:51AM +0800, Li Zefan wrote:
> On 2013/3/8 3:38, Tejun Heo wrote:
> > On Thu, Mar 07, 2013 at 08:12:42PM +0100, Oleg Nesterov wrote:
> >> Well yes, I agree. I think that perfomance-wise threadgroup_change_begin()
> >> in de_thread() is fine, and perhaps it is even more clean because we are
> >> going to do the thread-group change. The scope of cred_guard_mutex is huge,
> >> it doesn't look very nice in threadgroup_lock().
> >>
> >> But we should avoid the cgroup-specific hooks as much as possible, so I
> >> like your patch more.
> > 
> > I don't really mind how it's done but while my approach seems to limit
> > itself to cgroup proper, threadgroup locking is actually more invasive
> > by meddling with cred_mutex.  As you said, yours is the cleaner and
> > probably more permanent one here.
> > 
> 
> Agreed.
> 
> Now we need that patch to be resent with SOB and proper changelog.

Now that I think more about it, I think I want both patches.  It is
bothering that threadgroup lock is nested inside cgroup_lock.  It
always has.  I just couldn't do anything about that until recently.
Li, can you be persuaded into getting the lock reordering patch into a
useable shape?  :)

Thanks.

-- 
tejun
