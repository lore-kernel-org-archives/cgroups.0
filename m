From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Date: Fri, 29 Jun 2012 09:58:09 -0700
Message-ID: <20120629165809.GB21048@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=08VqMkp1TUDKF/LhbRf3RGujq+ubnGZ8OhK0BrL+EBg=;
        b=hDeL3/HwEiDa/uuPenrW8pupXsailZLDoP1u1stBkJqd6ycYeVcP2voEd4rVFbUKJc
         ++XZEdudb54cYEHCyD3OPA8LGPV4/2MpDpfJPpRgqkE4Q4fCtrvJAYsv3XRJC1RBv/93
         IXsqJRm77OUtPshwTHjsja1TL5akFolWS5M/o/t3ljyJzzuVP1G+VCN8DdtkeBu7j7Vz
         B6BBgFpaEWhrn6a1qoSNecb8xwZ0T79zfhd4DQflUuhRxPP5x7nEY9NctFxjTC7SySTT
         ELagA7KWk+Z6HM1KtJeBJtNZFK93S2VNj1uf3VWmEF7jQpit6SiELJIUG1Z8/2H5CtMW
         wuqw==
Content-Disposition: inline
In-Reply-To: <4FED10DB.7040500-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hey,

On Fri, Jun 29, 2012 at 10:20:11AM +0800, Li Zefan wrote:
> > Can you please elaborate a bit?  I'm not really following?  Where does
> > the last root->d_count-- come from?
> 
> 
> From my limited knowledge about vfs internal, seems the parent's refcnt won't go down
> to 0 before its children. When mkdir, the parent's refcnt will be incremented, and
> after rmdir, dput(subdir) will drop subdir's refcnt and then drop parent's.
> 
> So when dropping the subdir's refcnt and leading the superblock to be killed, the root's
> dentry is still > 0.

Heh, yeah, I thought you found who was holding out on the refcnt. :)

> >> I use this script to reproduce the bug:
> >>
> >> mount -t cgroup -o cpu xxx /mnt
> >> mkdir /mnt/sub
> >> sleep 100 < /mnt/sub &
> >> kill $!
> >> wait $!
> >> rmdir /mnt/sub
> >> umount /mnt
> > Unfortunately, this doesn't reproduce the bug here either. :(
> 
> I can reproduce the bug reliably.. Try s/cpu/perf or s/cpu/net_cls, which have fewer
> cgroup files?

Hmm... weird.  Maybe some debug config option I have is preventing the
race from occurring as reliably?  Can you please attach your .config?

Thanks.

-- 
tejun
