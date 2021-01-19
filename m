From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] cgroup: fix psi monitor for root cgroup
Date: Tue, 19 Jan 2021 12:00:51 -0500
Message-ID: <YAcQQ15WE8RcgzrE@mtj.duckdns.org>
References: <20210116173634.1615875-1-odin@uged.al>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d9RwYmgW6Bw/x+i8K3b7UwUNrT1DO+cCS+WHqV/0mmg=;
        b=lc2Rzc4LbffJJrRScBksiaMNyeypxLTvWPLOHTedfhonvrLr4slh8hatcq6SyLaEZX
         xTu9+xDJH8IgDmnipEuaYXRc1rBmFtmxyXRGzjDuzsKq38rjPVFQ2pmQNDSXvtA3GMAy
         yLnyIteFNXL+SP+j6w2TbKzOtgt/hMLP8VYEuQSP6YTy5l1cUR/f5kmsaM/pbiP/2xeg
         R2kphuB0YUpqzaFBkCbWGd3snDK24IwcnOEkaHFKS5HkDH+ez9CspTJzMNhqS8qBv4z0
         PlrKg1+n1sZAO+ozqj6NjZzuIHevfbzGl3Hg5TlcZvnwOhVCdZXrs/jsnTEpW0MQrmac
         s3IA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210116173634.1615875-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dschatzberg-b10kYP2dOMg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Sat, Jan 16, 2021 at 06:36:32PM +0100, Odin Ugedal wrote:
> This patchset fixes PSI monitors on the root cgroup, as they currently
> only works on the non-root cgroups. Reading works for all, since that
> was fixed when adding support for the root PSI files. It also contains
> a doc update to reflect the current implementation.

Applied to cgroup/for-5.11-fixes with acks and stable tag added.

Thanks.

-- 
tejun
