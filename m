From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Date: Thu, 28 Jun 2012 11:07:12 -0700
Message-ID: <20120628180712.GC22641@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WpTIe/xK6vs53lk/C5dZgBO7HTgjlGDrgBYSFpLKzqo=;
        b=rzQy17Ow2Ot/Z3n8bAV+2C3afnELBMDlHm/2EmTLFwSi0thZoU/TURvRswKsc9C1Qw
         E4SWdd1rgjx8rVvK4G+s+38YN1+tZzusSVt1Aq1ZgoeV1sAOQBl3uQnEACv80Vy1CvLa
         LH4yPdpHkKuY8CSDUw2ASC0bdTsQgdlaBPz5hrFBvguW0qdfdorLWWstFlEqX/NAhOhl
         9lS/U4MiaNUWISwT6LjeQVPbqz/GOXhlbYbZPaIhcxR8SUvJymTacO0iqaJTH8CZtuB5
         KJK6nF3CKrwVMGvTS+nIvvFXDBjLWngkyMaXubYL89wnJ80z7XsR5vyzOvUIUTeYIccl
         CygQ==
Content-Disposition: inline
In-Reply-To: <4FEBF4B7.2070105-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Li.

On Thu, Jun 28, 2012 at 02:07:51PM +0800, Li Zefan wrote:
> > Hmm... fa980ca87d "cgroup: superblock can't be released with active
> > dentries" is supposed to have fixed that.  Looking into it.
> > 
> 
> 
> I think I know what happened here:
> 
> umount
>   deativate_super(sb)
>                        dput(subdir)
>                          subdir->d_count--
>                          d_release(subdir)
>                            deactivate_super(sb)
>                              shrink_dcache_for_umount(sb)
>                                BUG(root->d_count)!!
>                          root->d_count--

Can you please elaborate a bit?  I'm not really following?  Where does
the last root->d_count-- come from?

> I use this script to reproduce the bug:
> 
> mount -t cgroup -o cpu xxx /mnt
> mkdir /mnt/sub
> sleep 100 < /mnt/sub &
> kill $!
> wait $!
> rmdir /mnt/sub
> umount /mnt

Unfortunately, this doesn't reproduce the bug here either. :(

Thanks.

-- 
tejun
