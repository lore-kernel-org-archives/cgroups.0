From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 6/6] cgroup: make cgroup subsystem masks u16
Date: Mon, 22 Feb 2016 17:33:35 -0800
Message-ID: <20160223013335.GA30067@cmpxchg.org>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
 <1456182349-18156-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456182349-18156-7-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Feb 22, 2016 at 06:05:49PM -0500, Tejun Heo wrote:
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -184,7 +184,7 @@ static bool cgrp_dfl_root_visible;
>  static unsigned long cgroup_no_v1_mask;

^ This one can be turned into a u16 too.
