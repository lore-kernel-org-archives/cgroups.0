From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 03/12] cpuset: update cs->effective_{cpus,mems} when
 config changes
Date: Wed, 9 Jul 2014 15:57:26 -0400
Message-ID: <20140709195726.GB21090@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD01A1.2060302@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=E3F90vokytXetq+55u6X9dOjthlIMH2aNEYey4raBws=;
        b=KBVmwRaQtQ49j1F3P69xAo6GifuXBfYGxqBxygjsJT3QFxsn9g75YagQqTNklKulHR
         G1QOmHUwqPqsAsiYkvbBuQk8AvCAh3/9fYfSiH84x++2Tzjxwy5z5AJBeDpUcgOAuQ0+
         v+I+6m98XZzIHmC7babgnZvI+KPpjFO2x74J7f/ayuvOU5kWX5g9XT41thfQi4SAWY5I
         rfqlXf0MmJfbzx62UuFuTboCr/PXn8oImUuD01YsdlljAUFmqMO0+GDl4q6xXXrpsbYu
         1BoSNH58iIjqTkdZxYfrEwMK1LABkJeEGBazCEKucpbO/RXAlDm5Ndt8ZwW5zltuYliz
         qVmg==
Content-Disposition: inline
In-Reply-To: <53BD01A1.2060302-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 09, 2014 at 04:47:29PM +0800, Li Zefan wrote:
> +static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)

Let's please use a variable name which clearly indicates that it's a
temp place.  Something like @cpus_buf?  Ditto with mems.

Thanks.

-- 
tejun
