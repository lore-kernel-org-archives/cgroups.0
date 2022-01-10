From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/2] blk-cgroup: stop using seq_get_buf
Date: Mon, 10 Jan 2022 17:39:06 +0100
Message-ID: <20220110163906.GA6775@lst.de>
References: <20210810152623.1796144-1-hch@lst.de> <20210810152623.1796144-2-hch@lst.de> <20220107092023.iaz57fai5kj47fqf@olga.proxmox.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220107092023.iaz57fai5kj47fqf-s3XsXwYL7y0UH/FJlhLpNw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wolfgang Bumiller <w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 07, 2022 at 10:20:23AM +0100, Wolfgang Bumiller wrote:
>     253:10 253:5 rbytes=0 wbytes=0 rios=0 wios=1 dbytes=0 dios=0
>     ^~~~~~ ^~~~~
> 
> I'm not sure if a separate temporary buffer would make more sense or
> switching back to seq_get_buf?
> Figuring out `has_stats` first doesn't seem to be trivial due to the
> `pd_stat_fn` calls.
> 
> Or of course, just include the newlines unconditionally?
> 
> Unless seq_file has/gets another way to roll back the buffer?

No, there is no good way to roll back the buffer.
