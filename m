From: 'Tejun Heo' <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Thu, 20 Jul 2023 10:06:54 -1000
Message-ID: <ZLmT3mXuDlYY61w0@slm.duckdns.org>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
 <ZLWNHuTGk0fy8pjE@slm.duckdns.org>
 <2b4540aadc3c4449a192aeed6211f232@AcuMS.aculab.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689883617; x=1690488417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zRzMPL6a/BSNtiQ7PJzND7IfnG5RjjKshq+ayDJRwvE=;
        b=kZIq9ybemRD+z70zrt95FXrBHFPHV9z/ZL6uhkUy+NMiMeb1ftSsvyQesVG3rung/8
         StKvGhzKm87e0EmDAArGi/OpQRYaBX+ijkyxRDwREw4WO3X3HDnALsNzYZqcx5Sd6QOc
         iWEVrUthWYQCvOKLAo3ODL8Pl9vUglt3E4qiHVwNbLXnFmj8aJCwpmZaaWZLoKn/mJiB
         Ovi+Zy45y62uqB0h4m29zNjzHs7UitPpt+kYNHyLYVEIJAvO3JuTUzbjSB/BaEeodbnI
         Zj/AeMIOXUGtWYEs/nE8rLZUXzAEfnHm7xpk1IuVAsdG5NsWCk5BwlL0fo+ioKeQuWY5
         1yYw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2b4540aadc3c4449a192aeed6211f232-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>
Cc: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>, "josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org" <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>

On Wed, Jul 19, 2023 at 08:57:32AM +0000, David Laight wrote:
> From: Tejun Heo
> > Sent: 17 July 2023 19:49
> > 
> > On Mon, Jul 17, 2023 at 09:18:52AM -0500, Carlos Bilbao wrote:
> > > From: amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
> > >
> > > Fix two type mismatch errors encountered while compiling blk-iocost.c with
> > > GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
> > > result of the division operation to (unsigned int) to match the expected
> > > format specifier %u in two seq_printf invocations.
> > 
> > Can you detail the warnings? Was that on 32bit compiles?
> 
> The problem is caused by gcc 13 changing the types of the
> constants inside an enum to be all the same.
> 
> The best fix is (probably) to replace all the enum used to
> define unrelated constants with #defines.

Yeah, but then you end up without any way to read that value from outside
the kernel for BPF, drgn or any other tools which use debug info. That
actually matters.

Thanks.

-- 
tejun
