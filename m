From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: remove a NULL check in cgroup_exit()
Date: Thu, 24 Jan 2013 10:20:04 -0800
Message-ID: <20130124182004.GL2373@mtj.dyndns.org>
References: <5100D810.5020406@huawei.com>
 <5100D827.20807@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=V1tSwo67D7dSaO2r0PyS0dg8s0Zk+tDM2Bk4iTdjgZc=;
        b=bxaxr9tqzFzAxRIMRtQq5Y1AxM4TJv+Bk/Gck1+ML2SP3nBhDnfkcl1ZInDbr8fJ8E
         pZtdAK4H2KPGucdzNP+YIiERsLlbxUcstpG2UkJvaKS/ILHLlvWzxhYrvD7NeyY6Bwin
         NcP4IiHLQEn0b/1yoLSy7AwIvo3wI/kojV9ZZ6SipcQ3BEjvJyUVlsW5zFJpJehEhvIb
         lA3zqn2XfoUNPkcfNlVrS5pnv96H6pWRf3o+43WyEhg1bk8Wn6AD1++kOFZoO743EjlE
         KeuIGw8QRnqUq4ACdCk9wAgUzQK1S30H9pYYhfQjmXOuf6tSMZLcvaTpJ1BuPaDWssvt
         X0RQ==
Content-Disposition: inline
In-Reply-To: <5100D827.20807-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jan 24, 2013 at 02:43:51PM +0800, Li Zefan wrote:
> init_task.cgroups is initialized at boot phase, and whenver a ask
> is forked, it's cgroups pointer is inherited from its parent, and
> it's never set to NULL afterwards.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun
