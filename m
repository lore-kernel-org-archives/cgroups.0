From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: fix a race condition in
 __cpuset_node_allowed_softwall()
Date: Thu, 27 Feb 2014 09:40:56 -0500
Message-ID: <20140227144056.GB19178@htj.dyndns.org>
References: <530F1117.1020605@huawei.com>
 <530F1138.2090903@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pUat+W5Cu7XT+6/oIel7x8NsKcWn3C7IS1eyA0sbOrA=;
        b=rO5LR6JKu9JYOZbkISwaFmQtec6hsuyFKIT/yfpUUcBngSlLw50pQP6rte1+sCppr9
         CNWDznHfAbAbI+uotRD2ibSGR3Gg8img8RU637jjk+/sZVkbMtILZNXiHDvdu+Emr02a
         09l3WrdpTe1Pb9eikaOYwiK7BXGr3viLZn4SGzyXuPWn/xZ84/Db45070Srh0G/syOkV
         qspyDMdd31ELTO57U6/IDADFWnSobAvidzVY7OhcNeT2k6O4/TTilY7PQAsedqwvXUST
         EGMBhqqicCYuW6OC9wZirUM6O9YUblboGAB8qorAv1yyzLmOcNwypwbKyl2Yp4IN4qm/
         kfhQ==
Content-Disposition: inline
In-Reply-To: <530F1138.2090903-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 27, 2014 at 06:19:36PM +0800, Li Zefan wrote:
> It's not safe to access task's cpuset after releasing task_lock().
> Holding callback_mutex won't help.
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.14-fixes.

Thanks.

-- 
tejun
