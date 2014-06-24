From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Date: Tue, 24 Jun 2014 17:01:19 -0400
Message-ID: <20140624210119.GC14909@htj.dyndns.org>
References: <53994943.60703@huawei.com>
 <539949A1.90301@huawei.com>
 <20140620193521.GB28324@mtj.dyndns.org>
 <53A8D2B8.4080107@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=r3EzjXU8VsM6kFHRQSc25KUsMW32iiCHcb2ssS0UXkw=;
        b=luVMlwCj0aoTLfBbBh4USmtldhjuK9PptadMfS+HeX1nzz6NIZhtXLNbCdL0jv8c7r
         5II8Co56fwUtSkBITTOJDdj0w6xISlRLyr3RcpKAyTwOM8zJhZ/lA7YCXalpSR7k/grw
         FtYK0DsPgDgo4fAWFQ57TyeziCcPhrOqJL+2jVzK65Mr5Vp0x5W/kYIYLzYKE/NuN+7z
         FLc7hgP+OuOWUfwPOxO6JG4RcRKJ5D6V14vfnKzoLb9X6ReoNO3lsTukn+ZrMto3Pr7J
         nHgIi+QrPkmS2JUuJv6KqVxL26YSAPJSMtO234QweCxuKvlE7jRzLFuiL/fGr/IvG+hj
         jQ0Q==
Content-Disposition: inline
In-Reply-To: <53A8D2B8.4080107-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Tue, Jun 24, 2014 at 09:22:00AM +0800, Li Zefan wrote:
> > Ah, right.  Gees, I'm really hating the fact that we have ->mount but
> > not ->umount.  However, can't we make it a bit simpler by just
> > introducing a mutex protecting looking up and refing up an existing
> > root and a sb going away?  The only problem is that the refcnt being
> > killed isn't atomic w.r.t. new live ref coming up, right?  Why not
> > just add a mutex around them so that they can't race?
> 
> Well, kill_sb() is called with sb->s_umount held, while kernfs_mount()
> returned with sb->s_umount held, so adding a mutex will lead to ABBA
> deadlock.

Hmmm?  Why does that matter?  The only region in cgroup_mount() which
needs to be put inside such mutex would be root lookup, no?

Thanks.

-- 
tejun
