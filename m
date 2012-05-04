From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Fri, 4 May 2012 10:04:12 -0700
Message-ID: <20120504170412.GD24639@google.com>
References: <4F98E4E5.6020602@samsung.com>
 <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com>
 <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org>
 <4FA24E07.1010206@samsung.com>
 <1336075511.2320.2.camel@localhost>
 <4FA36818.9010409@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7012jC/mWiUU2H9BcBgdgRE+NcBjFE8QWn8u7kx6f8g=;
        b=bE2DdrjKPOksoz/AujVt8NpAh891Jj//VUswWU4tQQCqx2fXluKfZAfIrhwhEVrBvA
         ZY6/a3oE4IedHutV7G9xHfo0Kga85vPA69RY8t5t5v8106jxB+w8W008iIybN4PfFyqn
         WiCX2H4j/54G8UQNbRm5yHVQhTNAHFBhu3+82Rji8Wxe56bKPC2QMKNrJ88QoLaBfNn8
         qh1lgnrmI6hX3m2jXLO7NQfF9acfXnVEwiQ6S4HpHFQQuiRysSilhn/nnR7tH87b8KFg
         Z80S8KVrviNOXSf43PssoAXngV9U/ycjg6BRGDSQaCREFayWpl86DwgY0xVxrUEeEpiz
         Tb6w==
Content-Disposition: inline
In-Reply-To: <4FA36818.9010409-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Fri, May 04, 2012 at 09:24:40AM +0400, Alexander Nikiforov wrote:
> Hi Eric,
> 
> I had try to implement with FSNOTIFY_EVENT_PATH. But it's pretty
> hard to obtain struct path without full chain of the sys_open()
> or may be I don't know some simple way. I'll spend some more time on
> this, but for now I have no idea how to do it. If you have some
> please share them.

Hmm... we have dentry from cfe->dentry and we can either use the first
vfsmount from sb->s_mounts or all of them (ie. generate event on each
vfsmount).  It's kinda silly either way tho.  Eric, it might be a good
idea to provide generic helper for virtual filesystems which want to
generate superblock-wide events?

Thanks.

-- 
tejun
