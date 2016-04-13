From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 13 Apr 2016 13:57:36 -0400
Message-ID: <20160413175736.GC3676@htj.duckdns.org>
References: <20160321234133.GA22463@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qPmsJmvK8cy58kYk86qvQy3+SsS16zHa++eiG+qYHG4=;
        b=K9ekbMFqXMIVhNOUoXHqk4f1D253sREpfktRwj1CsRaHLrNLpeHDgPmxhcGZV9zZED
         cevx5X/bOr4Gn4yhTZWXOiYFyJWGWNzvat94HucXycySCv0Dl9hgybKfvdLWflyIJDMK
         qiOAyjSUZ3y1/sn1BynHO9HTQJBCk629//o6I2nOl4BMKsKaiGOu6L4pO+xPLI89+5+x
         La3PJw9q3X6M7tw/mjo/+grjSdLaolgOXUGQ9FbPNPSuFnVMB3vYQj75y/2+K5UvlmCu
         QHUe8/QAaX/OIWbEsobj5Lbpddyx5HHDpRpSRtObgH2A+zdGNp4bkUf0vtofoTPw+QPY
         bFSg==
Content-Disposition: inline
In-Reply-To: <20160321234133.GA22463-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Serge.

Sorry about the delay.

On Mon, Mar 21, 2016 at 06:41:33PM -0500, Serge E. Hallyn wrote:
>  struct kernfs_syscall_ops {
>  	int (*remount_fs)(struct kernfs_root *root, int *flags, char *data);
> -	int (*show_options)(struct seq_file *sf, struct kernfs_root *root);
> +	int (*show_options)(struct seq_file *sf, struct dentry *dentry,
> +			    struct kernfs_root *root);

Wouldn't it make more sense to pass in kernfs_node pointer instead of
dentry pointer?

> +static void cgroup_show_nsroot(struct seq_file *seq, struct dentry *dentry,
> +			       struct kernfs_root *kf_root)
> +{
> +	struct kernfs_node *d_kn = dentry->d_fsdata;
> +	char *nsroot;
> +	int len, ret;
> +
> +	if (!kf_root)
> +		return;
> +	len = kernfs_path_from_node(d_kn, kf_root->kn, NULL, 0);
> +	if (len <= 0)
> +		return;
> +	nsroot = kzalloc(len + 1, GFP_ATOMIC);
> +	if (!nsroot)
> +		return;
> +	ret = kernfs_path_from_node(d_kn, kf_root->kn, nsroot, len + 1);
> +	if (ret <= 0 || ret > len)
> +		goto out;

Hmmm.... does this mean that someone inside cgroup ns would be able to
find out the absolute cgroup path of the ns root from inside?  If so,
wouldn't that be an unnecessary information leak?

Thanks.

-- 
tejun
