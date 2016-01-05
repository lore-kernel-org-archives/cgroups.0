From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Tue, 5 Jan 2016 16:56:23 -0500
Message-ID: <20160105215623.GH5995@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EweKpZwPMMrRePLv2EBaRWdu5nigNCEN89AMvRN6ezA=;
        b=wsItk1Uyute3COFhGmH2ahd7GAzFS5mqwyrkKOL8ToVNQJOtROTDpsHJf03Zi8Wi83
         tv9k+RgXlTPj1Dm7wbgzMjoJSXgsgpElG7xFvuwXxnpRrbU7WabwG+4RKEJXDPXVmlcm
         X7k1uZ+QWNNwiQZ6uYiMjTk+4UNAHL7+nFI4r4r1Dfv/AsFIXyFjbeBQE33nRa5Ac0Iv
         JdEu0ox9QV75PEqHb8PXbqvblahWByZR3MV2nNNFzBvAeogGzML07cee2eBmTI0N5/oq
         d2zDxR9KBIVJrEnFn0bkp8ETjJDRCUEzO06qsys/J7nGBDIPidCOH6L9CN5vfrhudvLs
         mQtA==
Content-Disposition: inline
In-Reply-To: <1452020286-9508-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jan 06, 2016 at 12:28:00AM +0530, Parav Pandit wrote:
> Resources are not defined by the RDMA cgroup. Resources are defined
> by RDMA/IB stack & optionally by HCA vendor device drivers.

As I wrote before, I don't think this is a good idea.  Drivers will
inevitably add non-sensical "resources" which don't make any sense
without much scrutiny.  If different controllers can't agree upon the
same set of resources, which probably is a pretty good sign that this
isn't too well thought out to begin with, at least make all resource
types defined by the controller itself and let the controllers enable
them selectively.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
