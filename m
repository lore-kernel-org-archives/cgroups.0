From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/10] cgroup: Remove CGROUP_BUILTIN_SUBSYS_COUNT
Date: Fri, 24 Aug 2012 16:28:40 -0700
Message-ID: <20120824232840.GS21325@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-6-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=muduJs3/GKnY974eIZfjFijU9eW0mPbwdDIGene4K7s=;
        b=HszCd0DYL5iAVNYtoWZTYy0ibsIdcdOPcTFREem8H1BWdDqMoXi949KluBKKWb80yO
         GYO4ZbJKLx2Uu49MF1hpLmcKzPDNf2SjGob7/hiCwABEUc330ZgV9LF0KSVqlPjJbIhT
         so/iL6mdzEzGAXI9E9/CRNvVFmN669Ws3F1YUFNMMMS+vn6+mJhypcGkIzLSAj/SiNQ9
         gbok5p2MW7qP8B/qbJT1anismEPwjbgv2vr1XzU2YvYmSt8pA5LXVNKNskpFRncZbtkq
         OMOdPNazZjiSt8K7W9BoMDxUh7MhlTRkbMBktxIijOGicvCR9e1fQ6veGPjPiEFhWho9
         gy5Q==
Content-Disposition: inline
In-Reply-To: <1345816904-21745-6-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

On Fri, Aug 24, 2012 at 04:01:39PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> 
> CGROUP_BUILTIN_SUBSYS_COUNT is used as start or stop point
> when looping over the subsys array. Since the subsys array is
> 64 entries long this is a good thing to do. Though we'd like
> to reduce the array size considerable but we need to get rid
> of CGROUP_BUILTIN_SUBSYS_COUNT to ease up the review process.

Wouldn't it be better to explicitly state that a following patch would
reduce the SUBSYS_COUNT and stop putting builtin and module ones into
different sections?

Thanks.

-- 
tejun
