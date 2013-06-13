From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/7] cpuset: implement sane hierarchy behaviors
Date: Thu, 13 Jun 2013 10:49:36 -0700
Message-ID: <20130613174936.GA10799@mtj.dyndns.org>
References: <51B4475A.8030509@huawei.com>
 <20130609160353.GE2835@htj.dyndns.org>
 <51B96F04.30803@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FV/rruqTRI6yrcn9PYO8rw4PG8Y5pAZkpqAIZdxRr0I=;
        b=Vsy4DI+Dx3p1gJJB9wDDjkIlJOAM6CJRFYzx8L/Kye7gXXR17t56+8PEKm2c0du9WF
         /h2gSZj9CJ05/wAZUEAtao/LzUUYDjgpX5kH37cPy8rvncKx98nQbm2wwTE80WjhHdvf
         JniTD1Mk3tKXn3AY2WAo1hnCSiGtf+DRQnY4BcMlXJ5cbM2K2zhj1Vq8KmcMBB2HEMdq
         yi7eaXb4zmvHAEZQYA2fO7OVq26vn6emPxqIx99Y0mMVbIqNyuWNExzKL5CNS4gzPiX5
         D/mKfND0ERNd873Ks5B9Q/x7Zf1X6qwT17ZGyU8V2cyqggF6mG3zmdycrgiqTvFenJSA
         bO4g==
Content-Disposition: inline
In-Reply-To: <51B96F04.30803-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Thu, Jun 13, 2013 at 03:04:36PM +0800, Li Zefan wrote:
> I would prefer those patches are applied first, as the new changes can
> be based on this patchset, and the changes should be quite straightforward,
> and also I don't have to rebase those patches again.

Aye aye, applied the rest of the series to cgroup/for-3.11-cpuset.
Thanks!

-- 
tejun
