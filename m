From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix rootcg cpu.stat guest double counting
Date: Mon, 1 Nov 2021 06:48:25 -1000
Message-ID: <YYAaWaYzyqloDRQY@slm.duckdns.org>
References: <20211028221528.2174284-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GAN7ragUqS7RMyIM/xoW1/S5P0b0rrl0CPmGeTnWNKg=;
        b=dBaz1vcEakAvLA+FtkUZ3pk4iNqiTCPVjL0p0ykkOk2pQ5Ty6DlmoIn6QArcNogoCg
         wTOD38PSesJAYljs/IvVMdBV51rdupL3RmFqbR/CMUOTu0kfCl9fN+GOAIlRqo+NwO1S
         zuQ878JLLuo9/BhRdq1zRgAjfELemeraLEUYY8pjEwcsSuj3zRvgzpSkT4LGE/Qa1Gjg
         +j2vpD6q4olXtmIoAcEKcRpi6eXDPZd1GRlv2IhTdVKcqP6spRZitb5qHc5Wt6UALv7N
         BgG46iX6l4TokTG0+H5XdQAxV1nKduBlDyTgqFwMX34Uhh1Xpgf/A14LI46A2rev+Trl
         hg5Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211028221528.2174284-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Oct 28, 2021 at 03:15:27PM -0700, Dan Schatzberg wrote:
> In account_guest_time in kernel/sched/cputime.c guest time is
> attributed to both CPUTIME_NICE and CPUTIME_USER in addition to
> CPUTIME_GUEST_NICE and CPUTIME_GUEST respectively. Therefore, adding
> both to calculate usage results in double counting any guest time at
> the rootcg.
> 
> Fixes: 936f2a70f207 ("cgroup: add cpu.stat file to root cgroup")
> Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applying to cgroup/for-5.16.

Thanks.

-- 
tejun
