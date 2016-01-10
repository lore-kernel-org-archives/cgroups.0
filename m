From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix a typo.
Date: Sun, 10 Jan 2016 12:28:28 -0500
Message-ID: <20160110172828.GJ3660@htj.duckdns.org>
References: <1452375186-2673-1-git-send-email-rami.rosen@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gxih2+EIMzFX6B+YkDxV5B9xqrU6SIC20hKu0Rfv550=;
        b=DGffokJG46Er1PmfY0c7XO5lribaS0yMvFvDbgvkRSQ6gzz/uLHVz41xRs2caCpjMX
         +Eq/WqqUITN98wDiYtqKLF9s+4R2sB87Tv7ZjiW1wjyNk5bd1J8dD/Yq1ZnkhDEjSnlJ
         Of2lpk1iDdxxeQlTTnyvTHvF0Quvrj+rrL6wuHZWLdhLnnnBcVeYuiaecGvchL7EvXqj
         Ae8A+UUZ43SetOhsCl0/O82+UFGGqi72TiY21aIhWXTEWVenSzmYMWvwqo114hWFBrHn
         I77o0m8haBOc2EukC0L8cKxXOz/CKm8Hyd0HF1kQs3/UVTUUF0nTMbPGREDLhKVgyqqm
         qD8w==
Content-Disposition: inline
In-Reply-To: <1452375186-2673-1-git-send-email-rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Sat, Jan 09, 2016 at 11:33:06PM +0200, Rami Rosen wrote:
> This patch fixes a typo in a comment in cgroup.c.
> 
> Signed-off-by: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-4.5.

Thanks.

-- 
tejun
