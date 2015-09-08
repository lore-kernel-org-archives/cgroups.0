From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Tue, 8 Sep 2015 11:23:40 -0400
Message-ID: <20150908152340.GA13749@mtj.duckdns.org>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6ip2/mReoDc+9dB1oUeJWZslj5qpAsHPB4INxzLSCbQ=;
        b=bUos+oeWvaKplggzbIE3eJQJPZdwoWwpGoUYdc1vC2UGkVZetd6pqcjdJK81ULPcPJ
         TJEuYysKIDHQn8U3dhRsq7YqUSZqNyUbJ7iJRpozYzjZpXLniIlErnwWcjKPxWVWNOJm
         iKSRKTP/knUhmxNIGA5+XM7mL1tTza3Q03HM2q2pJMjkKGlrHD3BSQ+bdTHrREu4IzJa
         Y5DqUNqlHriUEN5rPZr4KUG0b4LArmANUY73vJbXPuJVraj6jLNBYYR/QkrIC7JGf8uf
         NPxikj5PgnTy1vK2zXvcmk6GHXVPY/r2uq5EbyjPu97Cv9+xH8r7xIHKkkixq+2V+Dmq
         NJVQ==
Content-Disposition: inline
In-Reply-To: <1441658303-18081-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

On Tue, Sep 08, 2015 at 02:08:16AM +0530, Parav Pandit wrote:
> Currently user space applications can easily take away all the rdma
> device specific resources such as AH, CQ, QP, MR etc. Due to which other
> applications in other cgroup or kernel space ULPs may not even get chance
> to allocate any rdma resources.

Is there something simple I can read up on what each resource is?
What's the usual access control mechanism?

> This patch-set allows limiting rdma resources to set of processes.
> It extend device cgroup controller for limiting rdma device limits.

I don't think this belongs to devcg.  If these make sense as a set of
resources to be controlled via cgroup, the right way prolly would be a
separate controller.

Thanks.

-- 
tejun
