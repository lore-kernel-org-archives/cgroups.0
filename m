From: 'Tejun Heo' <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Fri, 21 Jul 2023 07:58:26 -1000
Message-ID: <ZLrHQgIb8jnm5biX@slm.duckdns.org>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
 <ZLWNHuTGk0fy8pjE@slm.duckdns.org>
 <2b4540aadc3c4449a192aeed6211f232@AcuMS.aculab.com>
 <ZLmT3mXuDlYY61w0@slm.duckdns.org>
 <fd89f72848da4569a19ec8a1ac9ec94e@AcuMS.aculab.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689962308; x=1690567108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MMbeZmEn/swkwXIwhi1G20TJgN07f15MbpFEH7XJldc=;
        b=MZVVaJCSJBESRhr44VQl7fRqn1vS0H3bwcrQB8k9au2IGSxCbBIJeZSaUnZyczg1We
         ceJ9z12LH/pQVCq1gfMKMxVNw7QDr2/EXK8ksWcab4fIbflvH0CYdK4JEUz/lg8UTisF
         tiFLFaTAAy7ddvrVD1Xqb9inzgg5zxAhJ1Rwdmsll7XFF4uPTNd7GoqahY5GwCzcn3YS
         aZacoedWo8fACF6ntfMjyh8skU5gM0mWEwz7hkKZ6PCEs/JjzBIfybibTCnf4qmVmc0j
         0kuSq7AMF4GPNJhMro4tyVSsGyhkHMxNIkFkobQs8pnD2Cz9a3TgWpX2od2nUd7LGafq
         Fjdw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fd89f72848da4569a19ec8a1ac9ec94e-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>
Cc: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>, "josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org" <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>

Hello,

On Fri, Jul 21, 2023 at 08:05:59AM +0000, David Laight wrote:
> In any case it is enough to split the enum.
> If you really need unrelated constants to be defined in an enum
> them maybe use a separate enum for each.
> Using (on one line):
> 	enum { name = constant };

Yeah, I'm hoping it won't come down to that. Hopefully, we can limp along
like this until we can always assume the new behavior. Right now, the
problem is that both gcc<13 and gcc=13 have to supported when the two assign
different types to the same enum definitions.

Thanks.

-- 
tejun
