From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] docs: cgroup-v1/cpusets: update libcgroup project link
Date: Fri, 14 Apr 2023 06:56:33 -1000
Message-ID: <ZDmFwYUmVUyKEjQE@slm.duckdns.org>
References: <20230414054849.320414-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681491396; x=1684083396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=28gmcAD8PpsVn0NwYwDOiW5yvJVzcaxRIYUggc0qigE=;
        b=p89rqc7JEr8KC8lByaaP0wofLPfeCULMVuVP7rIrDf7Bx2RMx3fHLJUANRpxiDTpjE
         SB7B2GuIkm85rEwraw3xvRmWMLsggNJFeJT6gue9xZ5iiWXB/I4pO+YKtLQNYb3QcI0K
         CMaebrdPWnZv2Fdi45ddcvE/7RSg6HzKjgdQSe8TG5pYoB8/TRyHSPjjKUUselaneY7y
         Fzsgbv79qyr+VQr8YgSO4ifpqmXNeiyY5VML9raEAkqZhKGPIKJdhOIASvrhSv8swE8T
         dOTpF69gWN9lih0IcxfB4MCkhiSue3Y2kPDYQlLK+7Y1mYWuUQmGUKMhbKC6MCqu+2Hu
         8x7g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230414054849.320414-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Apr 14, 2023 at 11:18:49AM +0530, Kamalesh Babulal wrote:
> Update the libcgroup project link, in the cgroup v1/cpusets
> documentation.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.4.

Thanks.

-- 
tejun
