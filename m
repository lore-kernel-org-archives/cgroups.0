From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Clean up cpuset_task_status_allowed
Date: Mon, 28 Nov 2022 07:07:10 -1000
Message-ID: <Y4TqvlOmXqY/CBEc@slm.duckdns.org>
References: <20221125075133.12718-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t/jS1zRSpC+P8xp144xwnS5feegCHv0w8ewtLrv0nf8=;
        b=kaWfxhV6xf7mJFYhLrtFv1cSXD99yiQq0KYir1cgs5srtEL5R5EtlBW4JHsDgXOPVF
         uxOAQ5sIrXTK7K9lkqSt/uwFo3SL9OnzltOhtizenHqUIottvCisHR3+tV+1neXnj2bp
         OuWqD5GjQWfsUGuYn1LlZJZ6wzMTIhsF/xJkpP+uIuEF15E8jnoTlFtby0SCGqPiYJo4
         JPMCjV9UKJwC8PsvwzfZVOJmhLdX0Li7oU4xVPQ3jMcizLjiMy5YPiE1JGZWl8D//bwS
         rjHVPWYCxC2I3HgTOW1TA8ntXVwsZm9IG+b47NRZ5u9t4f2joIgPZpkDRFN+Iqa6peyh
         3YxA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221125075133.12718-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 25, 2022 at 07:51:33AM +0000, haifeng.xu wrote:
> cpuset_task_status_allowed just shows mems_allowed status, so
> rename it to task_mems_allowed. Moreover, it's only used in
> proc_pid_status, so move it to fs/proc/array.c. There is no
> intentional function change.
> 
> Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

mems_allowed being a very much cpuset feature, I don't see how this is an
improvement. The new code is different and can be another way of doing it,
sure, but there's no inherent benefit to it. What's the point of the churn?

Thanks.

-- 
tejun
