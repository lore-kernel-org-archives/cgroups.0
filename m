From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: fix cgroup hierarchy umount race
Date: Sat, 14 Jul 2012 13:08:52 +0100
Message-ID: <20120714120852.GK22927@ZenIV.linux.org.uk>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED@mx.google.com>
 <20120707234634.GC16783@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120707234659.GD16783@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120707234659.GD16783-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Tejun Heo' <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shyju PV <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Li Zefan' <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Sanil kumar' <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Masanari Iida' <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Cgroups' <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nagamani.mantha-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, Jul 07, 2012 at 04:46:59PM -0700, 'Tejun Heo' wrote:
> Fix it by holding an extra superblock->s_active reference across
> dput() from css release, which is the dput() path added by 48ddbe1946
> and the only one which doesn't hold an extra s_active ref across the
> final cgroup dput().

> @@ -3883,8 +3883,12 @@ static void css_dput_fn(struct work_struct *work)
>  {
>  	struct cgroup_subsys_state *css =
>  		container_of(work, struct cgroup_subsys_state, dput_work);
> +	struct dentry *dentry = css->cgroup->dentry;
> +	struct super_block *sb = dentry->d_sb;
>  
> -	dput(css->cgroup->dentry);
> +	atomic_inc(&sb->s_active);
> +	dput(dentry);
> +	deactivate_super(sb);
>  }

While we are at it, what guarantees that css->dput_work will complete before
css->cgroup or the object containing css get freed under us?
