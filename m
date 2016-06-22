From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next 1/4] cgroup: Add cgroup_get_from_fd
Date: Wed, 22 Jun 2016 11:35:07 -0400
Message-ID: <20160622153507.GW3262@mtj.duckdns.org>
References: <1466555002-1316296-1-git-send-email-kafai@fb.com>
 <1466555002-1316296-2-git-send-email-kafai@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xSezKpZRCZZf8qfROB7uIa8OV2VW6psEHWWUs89v8iE=;
        b=gGPViCEwxt5DCUcat/YTwsdTAMuyx01F/XKklepxk7tjMhwdYythUIWYJu09/FopzF
         RoLvdaWFZOTkH6IalNyC9uur38Jmb5JNid91mjgx8kg+h1VlzJcvTKr3BoNyA27Y8llY
         9mvJYkDiA1jDrxtQo/jYg2p0GvYslg3aGyKMQkGHFZpt8HQpFJ+FeRu4n1Np6TGnZ3vl
         9o4uj4bjn3UiM6eRMDbVNIYd5x8X4G+D8GRzob1u3gIjo3569F9BlFEueD5fKQd1BhIK
         J61MmjQwT8M0a/aQInwZzbDqk+VYBZsR3FugQUoe1MiUJXkw5oTo0ca8UoEJBh5xD+Dm
         ymGQ==
Content-Disposition: inline
In-Reply-To: <1466555002-1316296-2-git-send-email-kafai@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martin KaFai Lau <kafai@fb.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com

Hello, Martin.

On Tue, Jun 21, 2016 at 05:23:19PM -0700, Martin KaFai Lau wrote:
> @@ -6205,6 +6206,31 @@ struct cgroup *cgroup_get_from_path(const char *path)
>  }
>  EXPORT_SYMBOL_GPL(cgroup_get_from_path);

Proper function comment would be nice.

> +struct cgroup *cgroup_get_from_fd(int fd)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cgroup *cgrp;
> +	struct file *f;
> +
> +	f = fget_raw(fd);
> +	if (!f)
> +		return NULL;

It returns NULL here.

> +	css = css_tryget_online_from_dir(f->f_path.dentry, NULL);
> +	fput(f);
> +	if (IS_ERR(css))
> +		return ERR_CAST(css);
> +
> +	cgrp = css->cgroup;
> +	if (!cgroup_on_dfl(cgrp)) {
> +		cgroup_put(cgrp);
> +		return ERR_PTR(-EINVAL);

But an ERR_PTR value here.  Is this intentional?  Also, wouldn't it
make more sense to return -EBADF here, given that that's what
css_tryget_online_from_dir() would return if the filesystem type is
wrong?

Thanks!

-- 
tejun
