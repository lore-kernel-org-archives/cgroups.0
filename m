From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix use-after-free when umounting cgroupfs
Date: Fri, 26 Apr 2013 11:59:23 -0700
Message-ID: <20130426185923.GA1433@mtj.dyndns.org>
References: <5179EC53.6080006@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=FerW7iIamGnnkZUmZnRbC+0aFErwtsSRmZiNhuJVOts=;
        b=qA795ijyVtYuBERJAx1zfVguufTPz4vOMBwmnSLtyZTZtB/NryE4Wt4xv0LhDzAEMF
         xZmVWfhmbtPB3aUtYfFX6f/w+O2ZWXuyEODwYllWSLrYkDA23xAiPkY2foNTzie+2vix
         dHttEnUoo+WM6cxLmjsB/4YI8YwiXNEGEMeZzcV59KB4MdqBoy9s/n0jcAcQtNnvima2
         5TwniJYMr/+d1bo06TAaNakQ0P+B8Eu3GJ72dntN9s4mZGbAWf8Yq/0etDlVaoR2JOtA
         UCws0vHq25BBjObhkiCB95J9wsvO651ulzb8Q07iQFXI5csww6L7N9L001O1XXfdyKO5
         b4/Q==
Content-Disposition: inline
In-Reply-To: <5179EC53.6080006-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 26, 2013 at 10:54:11AM +0800, Li Zefan wrote:
> Try:
>   # mount -t cgroup xxx /cgroup
>   # mkdir /cgroup/sub && rmdir /cgroup/sub && umount /cgroup
> 
> And you might see this:
> 
> ida_remove called for id=1 which is not allocated.
> 
> It's because cgroup_kill_sb() is called to destroy root->cgroup_ida
> and free cgrp->root before ida_simple_removed() is called. What's
> worse is we're accessing cgrp->root while it has been freed.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
