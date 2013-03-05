From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: remove include of cgroup.h from cpuset.h
Date: Tue, 5 Mar 2013 09:34:36 -0800
Message-ID: <20130305173436.GD12795@htj.dyndns.org>
References: <51356894.9060501@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=TO0IZZ2DVrQQC9D9yhL9zS/2Ff++KA8xCeYmkWb5reQ=;
        b=wy4Dx0W9F3JRGAfbp+uN979a9P/yVcljXXVeHj5tdW9QV7gs3OyJGxehtoxQ8S0fwz
         RzEoTGSXXM1NGZZ5LhM3cfnI2rx0kRx6irmXO1BonoRInzOKu1r67DdDbzNxpLzz5Su4
         9F+VAz6J9A6FtOP42r8wszwlJq+/2gMptKD1YF3MOgRD1PICxzyYWI4wdX4zxnCQVRk3
         MIq8e0Ds6qa+YvSWwxxkCmfYsD5MJ4IkqOiACh5X9whcI0HFrWQfnTw1j9BlTRBltpbp
         pTR1o8qHQmJJKEEIO5xENie7duJ5nFE1sqpoepofbLMERl1FnKuQ6qBt/wIb90MzBNAn
         5W3A==
Content-Disposition: inline
In-Reply-To: <51356894.9060501-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 05, 2013 at 11:37:56AM +0800, Li Zefan wrote:
> We don't need to include cgroup.h in cpuset.h.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
