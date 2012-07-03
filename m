From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Date: Tue, 3 Jul 2012 10:10:33 -0700
Message-ID: <20120703171033.GC555@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
 <20120630064724.GC14083@ZenIV.linux.org.uk>
 <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
 <20120630083421.GD14083@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CLMyt3Ivv8l6zL6jwwO9hhGkhqo6nIYHW32oxo59XVY=;
        b=n2WmdPgEQeIlThEBU1GS34ZPmwiwPEzKpwCxkYrR2vDSCtFvEsJ/SLCKXeQTKa3FOP
         zIv6oHklOkmsi/Ll/NGxUq0dyFYxD4En9nMRcUDzoR3G6mLBegl1O3ruXhRr1vQYhJzL
         Q4sP/ZFI8qV56xyb0jYOF2Z63R2uW2Ph82qfupFCldESIf10qebCfMnjNSzwyeZBfm3Y
         MMdG/D5RhinRyGJqbV630fUKIATMMq0s+NNW1olhY8lbQqxIquQ9VMc3dbGGyqpi26hf
         BqwMIuGQ9jy2FzKhQWJNkG5m4LEcvqerhq3kK0DZR75vbLwFqEQSojzMXuAmWR84XeuX
         Rpzw==
Content-Disposition: inline
In-Reply-To: <20120630083421.GD14083-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Al.

On Sat, Jun 30, 2012 at 09:34:21AM +0100, Al Viro wrote:
> Now that I've looked at that code again...  What's the story with
>                 simple_unlink(d->d_inode, d);
> in cgroup_rm_file()?  Wrong parent inode, at the very least...

Yeah, indeed.  My mistake while refactoring the code.  Will fix.

> While we are at it, what the hell is going on in
> static void cgroup_clear_directory(struct dentry *dir)
> {
>         struct cgroup *cgrp = __d_cgrp(dir);
> 
>         while (!list_empty(&cgrp->files))
>                 cgroup_rm_file(cgrp, NULL);
> }
> Are you fighting some kind of race against somebody adding stuff
> there?  Unless I'm seriously misreading cgroup_rm_file(), it'll
> do all the work on the first call...

cgroup_rm_file() finds the file matching @cft, deletes that one file
and returns.  Passing in %NULL @cft makes it deletes the first file
but it still returns after deleting one.  Maybe breaking up
list_for_each_entry() so that deletion and returning is outside the
loop would make that clearer.

Thanks.

-- 
tejun
