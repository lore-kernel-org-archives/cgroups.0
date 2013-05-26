From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: enabled xattr on root hierarchy if required
Date: Sun, 26 May 2013 13:10:07 +0900
Message-ID: <20130526041007.GD13771@mtj.dyndns.org>
References: <519F8F40.3040601@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Z7VFVYSMJZdfhqhX2JMJzxf7YKFE/U6Is0ol4bEAXWU=;
        b=sa2ZhUxltVsgC5qjZTmNOlAnMqYO2jJ8D70+UY6pi7afv4RAvzf8HMeo6z83XTxSyc
         9qEILdPe9JFfAsBmx53GEg+WHZpf6ThvHz6FIal5EGlWfTiL7pSlWDyuSlriOfSrLNSx
         ZUm6WetfMqW+hYIvMy1g+mkRRbm0oDUHgVr0KAaUaX0n8Cp6ntuvDdn1Q9dMlSdTNRS+
         nNPmL8lbtjI18Pwfx5Z60i9nEVppyurl71/QkqPF9i1FPjCfHBIw3oCnMtdcm8miverO
         QtM+5uuvctYXRK4vOnjyXTXNL5s7NyLddXQS4MOtbwv7HTYSLyV1kstlh3qP9555x6/g
         iSwA==
Content-Disposition: inline
In-Reply-To: <519F8F40.3040601-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Sat, May 25, 2013 at 12:03:12AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> If the root cgroup is alive without xattr, set extended
> attributes on a new cgroup with xattr enabled will failed
> with ENOTSUPP. e.g.
> 
> # mount -t cgroup -o cpu none /cgroup1
> # mount -t cgroup -o cpu,xattr none /cgroup2
> # mkdir /cgroup2/test
> # setfattr -n trusted.name -v test /cgroup2/test
> setfattr: /cgroup2/test: Operation not supported
> 
> This patch fix it by checking ROOT_XATTR against the new
> mount and turn it up on the existing root hierarchy if needed.
> 
> With this fix:
> # mount | grep cgroup
> none on /cgroup1 type cgroup (rw,cpu)
> none on /cgroup2 type cgroup (rw,xattr,cpu)
> 
> # mkdir /cgroup2/test
> # setfattr -n trusted.name -v test /cgroup2/test
> # getfattr -d -m - /cgroup2/test
> getfattr: Removing leading '/' from absolute path names
> trusted.name="test"
> 
> Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported-by: Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index a32f943..46e8cbb 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1687,6 +1687,13 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  		cgroup_drop_root(opts.new_root);
>  		/* no subsys rebinding, so refcounts don't change */
>  		drop_parsed_module_refcounts(opts.subsys_mask);
> +
> +		/*
> +		 * Enable xattr on the existing root hierarchy if it is
> +		 * specified on new mount.
> +		 */
> +		if (test_bit(ROOT_XATTR, &opts.flags))
> +			test_and_set_bit(ROOT_XATTR, &root->flags);

So, while I recognize that this is broken.  This is a part of larger
breakage - cgroup silently ignores mount option changes when
remounted.  That's why when sane_behavior is specified, mount is
rejected if it doesn't match the existing mount options.

I don't think fixing only this part is meaningful.  Maybe what we can
do is adding a warning message if the mount options mismatch?

Thanks.

-- 
tejun
