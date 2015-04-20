From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/49] writeback: move backing_dev_info->bdi_stat[] into
 bdi_writeback
Date: Mon, 20 Apr 2015 13:56:26 -0400
Message-ID: <20150420175626.GB4206@htj.duckdns.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-13-git-send-email-tj@kernel.org>
 <20150420150231.GA17020@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LYVP/qKdX4kEnGMT/A2JAyaK59qlyjpwdMB6IqCORlw=;
        b=rlHSsfXRZywMd+ctVcnX2XtmLUYgLjYA0i3u0NqqSchUwHRJVRxpRHeSBfFmLRlrl+
         sR4eaN4NVS0NpS7YU02AEz0qt6tYf3CT9y9T/XqvCtUkjB+mlonsdiJO9A+Tfe6kwYEF
         foGyhr2CR2ZvkcAm8FLC6E1uBBe1MP+eyr2gs19FL6Vnfo7ZB9ME1YM71COu0B2ib6PU
         0AIqEJI4n6Pwn+Q07XQtiE5ubtEERftX+nZG4H9w0v4hW86QPT7PBTHFduSmY/MR727R
         /R1TzN7C00WL29Qtu9zyULGTrgoNMlA6VTyBNb+qStl6T3y2OenUkoq8V1cI86kYDUeH
         +nhQ==
Content-Disposition: inline
In-Reply-To: <20150420150231.GA17020-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

On Mon, Apr 20, 2015 at 05:02:31PM +0200, Jan Kara wrote:
>   Maybe bdi_wb_destroy() would be somewhat more descriptive than
> bdi_wb_exit()? Otherwise the patch looks good to me. You can add:
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Hmmm... maybe, I don't know.  I feel weird matching up destroy with
init instead of create.  Why is exit weird?

Thanks.

-- 
tejun
