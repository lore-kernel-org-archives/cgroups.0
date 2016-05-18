From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v4 03/21] fs: Allow sysfs and cgroupfs to share super
 blocks between user namespaces
Date: Wed, 18 May 2016 11:16:18 -0500
Message-ID: <20160518161618.GC129218@ubuntu-hedt>
References: <1461699046-30485-1-git-send-email-seth.forshee@canonical.com>
 <1461699046-30485-4-git-send-email-seth.forshee@canonical.com>
 <87shxgxqai.fsf@x220.int.ebiederm.org>
 <20160517235834.GA104031@ubuntu-hedt>
 <8760ubs738.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ncvXOjc53DEHQl+6qNHw1p3HtUuQOfymqNjz3uxRuiQ=;
        b=l4vT6twqiLQ7912uJB9qG8ryddB68diae6LOJsj6VlBLYG635KPbm0Fj+6MBUa3qqW
         TAgEZo7ecTuaEfAiYEmKJ7xIQWk3mHXODke74btRcTyKR7DAvdEcuHflYb0XypoHuxNZ
         bo28JhDrfgwtJQ7JMyYVEstHMrpEJY61RyrW2EX9V87TH3ifus7B960lbDfxWJwu1aAi
         T7xmENlDWhmVk1/ji2wr6YqO7OaVXxYSxfCVwPC/q2sPTFCgjXg/HkeEYLU4ll+XjGB1
         215HGFNG/sBHTQeMqOsvZw7pSBPU1COYDqAv6/yjT+luTXeN4UKjbzcDE3SD4vz7erug
         jtaA==
Content-Disposition: inline
In-Reply-To: <8760ubs738.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 18, 2016 at 10:45:31AM -0500, Eric W. Biederman wrote:
> > But if we do that it violates some of the assumptions of the patch to
> > rework MNT_NODEV on your testing branch (and also those behind patch 2
> > in this series). Something will need to be changed there to prevent a
> > regression in mount behavior when a user ns tries to mount without
> > MNT_NODEV when the mount inherited from its parent has it set.
> 
> Thank you for pointing that out.  I will look into that.
> 
> I believe I know exactly what you are talking about.  Of the choices I
> think it is better to a minor localized change in the fs_fully_visible
> logic than it is to cause problems elsewhere.

Agreed.

> >> Apologies for not catching this earlier.
> >
> > Actually this is a more recent patch, so you possibly hadn't seen it
> > before.
> >
> >> I am looking at folding all of this into the patch that introduces
> >> sget_userns so that even bisects won't have regresssions.
> >
> > That's fine with me.
> 
> And thank you for keeping everything as separate patches.  That is at
> least helping me catch up.  Even if I don't agree that these things
> should be separate come merge time.

Honestly I probably would have squashed some of them into that first
patch myself if you hadn't already applied it to your testing branch, so
that's all just luck.

Keep in mind that I also have that patch for mqueue that isn't in this
series, and I haven't yet checked to see if the 4.7 merges introduce
anything which is going to require updating these patches. I was
planning to wait and send out updates after -rc1, but if you want that
stuff sooner just let me know.

Thanks,
Seth
