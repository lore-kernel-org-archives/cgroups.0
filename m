From: 'Tejun Heo' <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: fix cgroup hierarchy umount race
Date: Mon, 16 Jul 2012 09:44:45 -0700
Message-ID: <20120716164445.GA30872@google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED@mx.google.com>
 <20120707234634.GC16783@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120707234659.GD16783@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120714120852.GK22927@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PNdkR9xiOpx5Fr7zY4cxQT7xhCTItpq3PmDthScKmK8=;
        b=o2Fytrud9mY10s9kjNOxLs2qRJqE47lcQXxwaz9fwG7SVzpPH0Pmi1Lh/bnS2PRVrC
         7lEyQK9vCxfLolN5On2QwypM32YsQxgzJlklXiLPTQpgJ1B/JosMYJjc3/jgQigVZY/a
         t3YWo+Sf7xY3wSWV4wPPadviuQDgSDhjVv5WVdqCjyPK23C8BQ9qLuhstYlwQKA53HCq
         FPFXzhSWIcZ9x+gCBVxSHj16AOFEXjcVV/MNzPk0y/EtZy+UXzxIGjY4fqI3/YURRIWa
         5XhAu4/8BPRMlCzXT6bKP5CQ1tIhUVkXfXf5a7mZ9h0roAJC0jrBGo+eaBhpLavEBZlc
         S/rQ==
Content-Disposition: inline
In-Reply-To: <20120714120852.GK22927-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Shyju PV <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Li Zefan' <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Sanil kumar' <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Masanari Iida' <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Cgroups' <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nagamani.mantha-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello, Al.

On Sat, Jul 14, 2012 at 01:08:52PM +0100, Al Viro wrote:
> On Sat, Jul 07, 2012 at 04:46:59PM -0700, 'Tejun Heo' wrote:
> > Fix it by holding an extra superblock->s_active reference across
> > dput() from css release, which is the dput() path added by 48ddbe1946
> > and the only one which doesn't hold an extra s_active ref across the
> > final cgroup dput().
> 
> > @@ -3883,8 +3883,12 @@ static void css_dput_fn(struct work_struct *work)
> >  {
> >  	struct cgroup_subsys_state *css =
> >  		container_of(work, struct cgroup_subsys_state, dput_work);
> > +	struct dentry *dentry = css->cgroup->dentry;
> > +	struct super_block *sb = dentry->d_sb;
> >  
> > -	dput(css->cgroup->dentry);
> > +	atomic_inc(&sb->s_active);
> > +	dput(dentry);
> > +	deactivate_super(sb);
> >  }
> 
> While we are at it, what guarantees that css->dput_work will complete before
> css->cgroup or the object containing css get freed under us?

css's are tied to the cgroup.  They are created on cgroup creation and
destroyed together with cgroup, which is controlled by the dentry
refcnt.  css refcnts are relaying reference to cgroup dentry refcnt.

The reason why css needs this finer grained refcnts instead of
directly using cgroup dentry refcnt is that for some subsystems cgroup
removal tries to drain all css refcnts before proceeding with removal.

Thanks.

-- 
tejun
