From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: bpf: use cgroup_lock()/cgroup_unlock() wrappers
Date: Wed, 8 Mar 2023 10:23:53 +0100
Message-ID: <20230308092353.xpaa6syh4yteg57c@wittgenstein>
References: <20230303095310.238553-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678267439;
        bh=18GSiD8dZEkkLpIuRHOIMVhuJHmIcKeYx02x8hjIYPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bS9mbeaMxFembCuwEUxj/0X38+AT4DfIn8MmYSZCnEi/IDmiEgVTa9Irqz3Ed+ftw
         MuAfDTr1S/vJyPLKhTkA0sg5zkhFaJaccKV83kxwcWx574XTcc2V+MKB1H5Qbdft1q
         uI7PsyOxJXWpRgmA/WhPLlakZjUi4rewZ/QMK7nUj/cGTjN2X4uRdGrxSpi7CFy8yM
         5HWHllWIsdxyZ4+uqvdQpyI4KeMGGcreKJnoiPFCeORO3M4gPGB5rx2leLsQZid0IQ
         xa726yOZapZfTH967/wf8n/Q1p9uhHXm0TZ4oLWmTdef27WbMLMvu0agNJJmpMNftX
         FjIs+cTI3ay3Q==
Content-Disposition: inline
In-Reply-To: <20230303095310.238553-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 03, 2023 at 03:23:10PM +0530, Kamalesh Babulal wrote:
> Replace mutex_[un]lock() with cgroup_[un]lock() wrappers to stay
> consistent across cgroup core and other subsystem code, while
> operating on the cgroup_mutex.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---

Looks good,
Reviewed-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
