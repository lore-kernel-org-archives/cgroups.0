From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: make cgroup_is_threaded() and
 cgroup_is_thread_root() static
Date: Mon, 5 Jun 2023 10:31:56 -1000
Message-ID: <ZH5GPHPW0ihSKtNo@slm.duckdns.org>
References: <20230603071304.1077085-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685997118; x=1688589118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/6PHjxXVqGr/anCjyWJ5NzVjZ6+kUpY7d4+0bLn+hMA=;
        b=NK5TWOw6+PRoYhYmwe5WM0uChPHx86tWH1VxaEQlzps5NSc8B0vdDz1cdbIemALTXG
         5yPMWTU9W3imDF86OBSrMJxYzDFZj4Y5fBapiVDvh2EqZgU0uciddeEqByTixhqdIGwX
         KfeTIaaU3G/Ue8Te/+48Ps47QbhMDFq0VvXWBdHea8j5KL9ty0Bjw0P9rwmmINyq6D19
         ItdRglwt6tJKO8tNM1dfbqYWlZpFgThs1oR/8zQqqXL9KSm5srbTnejOedAKhgh/xt2M
         vuwEDr1Saela38h4NnO/7JCJrXaqJ8zGsT5AurllQSOQ2p1YtkOqD8UULaPAzAwcm9K0
         lFAg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230603071304.1077085-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 03, 2023 at 03:13:04PM +0800, Miaohe Lin wrote:
> They're only called inside cgroup.c. Make them static.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
