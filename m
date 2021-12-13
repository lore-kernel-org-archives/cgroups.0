From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: return early if it is already on preloaded list
Date: Mon, 13 Dec 2021 09:27:12 -1000
Message-ID: <YbeekNeegXoP6F93@slm.duckdns.org>
References: <20211211161729.10581-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tkb2nbDXtPOec8/Noy7yyiSFcbbuYZLt8x46YEAcE80=;
        b=qV/ClPQ9N3qauD6jekXldd4W9yCBqK/X09z27WBFoOIoGL3y7aQY2otAcLaPExw6+W
         hzPGJEPsRfeCOyY8KOojTKQ7XFWtpt/y2AoPMz5VxeMu4kP9GI744HwWfKs5xquGzTGk
         MWWsDsKPuGHVKk+lPj/GpgWdqQmVUmmhUWLIdcVSlNu5t8sTyw9oZzZH9PpS1auaSGr1
         n8UnuAt+TlLznUb+wO6AKAcS7s3ym6qRhcezGwwBtxj1R8zS6P6Xlbo0/Pgpq4V2xsSW
         NBL6nh70Vq0w4+YAw2bQHODDk8WDv/ZeX1x9VD1xbU4Ypx4Ri2r0VlY++xA9PgxM9UJB
         Hudg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211211161729.10581-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 11, 2021 at 04:17:29PM +0000, Wei Yang wrote:
> If it is already on preloaded list, this means we have already setup
> this cset properly for migration.
> 
> Let's skip this cset on this condition.

The patch looks fine but I think description can be improved. Can you just
say that it's just relocating the root cgrp lookup which isn't used anyway
when the cset is already on the preloaded list?

Thanks.

-- 
tejun
