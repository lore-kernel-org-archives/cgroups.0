From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv1 6/6] rdmacg: Added documentation for rdma controller.
Date: Tue, 5 Jan 2016 16:53:09 -0500
Message-ID: <20160105215309.GG5995@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-7-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=D9EMALhqJT/2HSt1mrgiR8/s0UP4o3wZmqrFSEuZ2h0=;
        b=YjywbneEtzZ0G1ZfHFymS/Aa9SSZW7mGdozTqNgx+ahTH0Za6VLBRCIMdJJS2IRo7K
         E099mwwIWEWGw3vMlEdTj3nNjdfWXgtyfpzPqiV7wWKWS3kcQwZdiQaQy+huOW72rviK
         lKpChcWOx635wVXDasK6Crm3Dg1jbDoFl3SXLIBRP5xlzKe2EM4fcG4wiFTtsfVtsRWP
         VnTCLdIiF4aFs8F/Ov/Fx8kurGOjR4EiywC4hY/2RqRENvAW16H2BmB9hBOAyrliIJkL
         d/OgQT+HK877O0x4Pdo04e/rfaDOPju0LN4szvcqCsC2syaV4kB9cFqwhAIB1soXsNgW
         0OSg==
Content-Disposition: inline
In-Reply-To: <1452020286-9508-7-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jan 06, 2016 at 12:28:06AM +0530, Parav Pandit wrote:
> +5-4-1. RDMA Interface Files
> +
> +  rdma.resource.verb.list
> +  rdma.resource.verb.limit
> +  rdma.resource.verb.usage
> +  rdma.resource.verb.failcnt
> +  rdma.resource.hw.list
> +  rdma.resource.hw.limit
> +  rdma.resource.hw.usage
> +  rdma.resource.hw.failcnt

Can you please read the rest of cgroup.txt and put the interface in
line with the common conventions followed by other controllers?

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
