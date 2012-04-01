From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Date: Sun, 1 Apr 2012 14:22:58 -0700
Message-ID: <20120401212258.GA12359@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <1332975091-10950-19-git-send-email-tj@kernel.org>
 <20120401210955.GE6116@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jcwz0xjWSu2Irz1xPlfvpjNCBcjlKV3UCtd37BMpQ8U=;
        b=uMDnLc92VBYtBqrwQgPUw0U1Q4RUSS8rDbzSsejZ0xhGaBG4BAkb5dcTKyrk4KHwCv
         vKw7IlDwUhWBrgZmSZuZ356XLYMtOECG4LMk/kUPltQ22yDxCEAxyslimiz8ONZ383n/
         eBtXNPP6VrVNaSOSSY90UKDglvR/n9qsYYzrBRtk65UpB1L+LyWqxgWjAsrxK/X+pJeG
         1XrG2fnCaxOAC693Vfcj3MuVUxBlwGxl5WSZGDX5wB6zx6KoDx6dWc0/EodSexdPtydn
         IwN17D9YhE8armPZ/hldEWm4vJ+7iWd1DOuUu4mxagT8G3uQ8mthgoD1JcpNX2R/rdDI
         US+g==
Content-Disposition: inline
In-Reply-To: <20120401210955.GE6116-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello, Vivek.

On Sun, Apr 01, 2012 at 05:09:56PM -0400, Vivek Goyal wrote:
> blkio_cgroup->weight can be thought of in a more generic manner and that
> is sytem wide cgroup weight. And more than one policy should be allowed
> to make use of it. That's a differnt thing that currently only CFQ makes
> use of it.
> 
> For example, Fengguang posted RFC patches to try to make use of blkcg->weight
> and differentiate between buffered write bandwidth.
> 
> https://lkml.org/lkml/2012/3/28/275

I don't think that's a good idea.  It makes it fuzzy which knob
controls what.  If we're gonna have single set of controls followed by
all controllers, fine, but I really don't think we should be mixing
different layers of configurations.  I mean, what about blkcg.read_bps
then?  Let's just give this one to cfq.  If someone else wants weight,
let it use its own weight config.

Thanks.

-- 
tejun
