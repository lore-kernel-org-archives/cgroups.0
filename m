From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 0/6] cgroup, blkcg: prevent dirty inodes to pin dying
 memory cgroups
Date: Fri, 4 Jun 2021 19:31:25 -0400
Message-ID: <YLq3zb4saO9AMYCi@slm.duckdns.org>
References: <20210604013159.3126180-1-guro@fb.com>
 <YLpMXmWvPsIK97ZE@slm.duckdns.org>
 <YLqoJn/FmyqjQs0M@carbon.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PBin/z5hDFW5Ve3aQTiLIRlzSaeQ8qcQu0zCFdQd6Xk=;
        b=dcMTWnaxBb8HqPgSlERDybmkGVPSERJa5XsZkRkOJKVXEv7XdwyKi3DzPZpyNf40Xo
         quGAkBPx8ZVc/3Bcx+BMyWV9rZJFbs2z/GavWxo2d+THJ78dWVz4nv7KMA/0qgPFYI2P
         dcMn3Lan262LT0207JXa8/U5/tKFy+lFDCb1KwTiFE+sAaWrgHMCHETBkmjJAjOxGQxG
         M5giSsIIVthqiY9y4C/sdi3JoPcugXqpLjEblEM7GCVbADPvNplLK31nWXTs7dN692vV
         mKsjabRpe9KFGbw6Sf+FjBv61ldBmvMN89MN3rxr0vRNv2mDrtahiVuwUAEYQ9RskaB3
         ATiw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YLqoJn/FmyqjQs0M-esYZh5BkUNV+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Jun 04, 2021 at 03:24:38PM -0700, Roman Gushchin wrote:
> I agree that switching to the nearest ancestor makes sense. If I remember
> correctly, I was doing this in v1 (or at least planned to do), but then
> switched to zeroing the pointer and then to bdi's wb.
>
> I fixed it in v8 and pushed it here: https://github.com/rgushchin/linux/tree/cgwb.8 .
> I'll wait a bit for Jan's and others feedback and will post v8 on Monday.
> Hopefully, it will be the final version.

Sounds great.

> Btw, how are such patches usually routed? Through Jens's tree?

I think the past writeback patches went through -mm.

Thanks.

-- 
tejun
