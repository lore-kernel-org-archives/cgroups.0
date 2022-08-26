From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/2] Introduce cgroup.top interface
Date: Thu, 25 Aug 2022 17:17:09 -1000
Message-ID: <Ywg7NcHtfjDKjwXR@slm.duckdns.org>
References: <20220826011503.103894-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=MB6QLwte6A+FfeHZ7hhIAgqBcop3yV3R8qqmPiooMZw=;
        b=kN4iQW7K22uT8HSAzCzZpNIGqTuTTg1AfRP4nSREd9XS7uXUVq/dVbFd/MvU4f+a3i
         iSOIKmwEkNINjdmevNcLolUMggi9tuS6AbI9CAskuTUfzapjO9tZdbbMWFeyRBU9Ftyr
         73akbvzVVGO1ZzhAtmDlv4RGK4oorSM97X+xKGrO2NPWU40UDk7ipTP005DdalS7QQ9Q
         Shw90PYt66tMBnLYnjnRHI2xIqGaTVkMzlM5vN9fL+6RF8JY1lSS87GNd9SuplsLecUH
         H1QSaIX7JbxLwxYtIEeeT8pNUEQmvpFT3jEQPUZmrngZePX2OC16YZSviQMBahljZcRR
         9BWA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220826011503.103894-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello,

On Fri, Aug 26, 2022 at 09:15:01AM +0800, Lu Jialin wrote:
> Cgroup is used to organize and manage resource available processes.
> Currently there are no handy tool for gathering reousrce usage
> information for each and every child cgroups, makes it hard to detect
> resource outage and debug resource issues.
> 
> To overcome this, we present the cgroup.top interface. Just like the
> top command, user is able to easily gather resource usage information
> , allowing user to detect and respond to resource outage in child
> cgroups

I don't think this is something we want build into the kernel. Maybe what
you want is something similar to below?

  https://github.com/facebookincubator/below

Thanks.

-- 
tejun
