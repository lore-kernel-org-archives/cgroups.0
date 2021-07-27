From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Tue, 27 Jul 2021 06:32:15 -1000
Message-ID: <YQA1D1GRiF9+px/s@mtj.duckdns.org>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
 <YP8ovYqISzKC43mt@mtj.duckdns.org>
 <b2ff6f80-8ec6-e260-ec42-2113e8ce0a18@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XnS7wGZkaUxUxBZzeIMFzrqtlFgUpVB9JFi7oU+kz1o=;
        b=inkbtFcEAo4u9yojc/TIlxlnH2aBE6NspFb61m++w6vZ7IurjQrC7tNFN79v6tSijC
         xaWgmiXGsYMkgsGBgokfIS1K/GKKgx0wlfPj6D9yFhOqhBkQElMoPOFes37ElCCRLNau
         YCbj234wAO6gg6ftw1DnuhGmqgOFYR8DvZekesH/Oy1KOf0SHI1StnAbuhlFKXazlPeb
         TWVX7epjbQySXXVsipN39I9ZzBMUBnvHjELkRONfj3vK1I3Vd/Dz5vOlTd3rEueUKLhT
         /j7MzAmKWjHFHvKIRwPiMhR42xDYiWVYquRgJnoZ0cjnMH2/oax7x/OLTiKaATysBI6K
         8bmg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b2ff6f80-8ec6-e260-ec42-2113e8ce0a18-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jul 27, 2021 at 11:18:00AM +0800, brookxu wrote:
> According to files_maxfiles_init(), we only allow about 10% of free memory to
> create filps, and each filp occupies about 1K of cache. In this way, on a 16G
> memory machine, the maximum usable filp is about 1,604,644. In general
> scenarios, this may not be a big problem, but if the task is abnormal, it will
> very likely become a bottleneck and affect other modules. 

Yeah but that can be configured trivially through sysfs. The reason why the
default limit is lowered is because we wanna prevent a part of system to
consume all the memory through fds. With cgroups, we already have that
protection and at least some systems already configure file-max to maximum,
so I don't see a point in adding another interface to subdivide the
artificial limit.

Thanks.

-- 
tejun
