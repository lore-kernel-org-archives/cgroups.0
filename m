From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] cpuset: export effective masks to userspace
Date: Wed, 21 Aug 2013 10:20:01 -0400
Message-ID: <20130821142001.GK19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FFC.4080701@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=u17/LoznK8w/HgKPd4y0+9cFFRRxOhtauRyWIrn4+xI=;
        b=Bzi/7l/ECqDBh3+xd8XeX3LxTKsK+vBvSx7cIqHRO3O5Zhc8A2I14HTWgInF4mNLXq
         jEifeho9duFr4xZsPzVdkMGaG5LGxVuLXj7ajbgGQ6uiBom8hUAt9tjY2yZdG7uU8EUt
         pujsD5dBOLyQyBC9s8iX4iXfGiXuTYmORVH7jNnaiFqnKeE4jpUeg+LOAvpLRfe9pK19
         d2ydLr7QBy3RkQ7VAL2YE+ojW9N9sKOj600HY5+VifIJnWfgDh4/6A1Zx3d5YUyQwC6O
         MFg7KSxFztTPnAeqQfBC/hTKpJHuuOuS7ffJeQmUchjUGYb+xZydGXtXzYVUpbXY9IT3
         tEmA==
Content-Disposition: inline
In-Reply-To: <52148FFC.4080701-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Wed, Aug 21, 2013 at 06:01:32PM +0800, Li Zefan wrote:
>  	{
> +		.name = "effective_cpus",
> +		.flags = CFTYPE_SANE,
> +		.read = cpuset_common_file_read,
> +		.max_write_len = (100U + 6 * NR_CPUS),
> +		.private = FILE_EFFECTIVE_CPULIST,

I don't think we need CFTYPE_SANE.  We can just expose these
unconditionally, right?  It still means the same thing when !sane.

Thanks.

-- 
tejun
