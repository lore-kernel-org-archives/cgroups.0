From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] blk-cgroup: always terminate io.stat lines
Date: Wed, 12 Jan 2022 10:14:36 -1000
Message-ID: <Yd82rHFwf9XQ9Gwu@slm.duckdns.org>
References: <20220111083159.42340-1-w.bumiller@proxmox.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rmc9nZh5Lq0NuEYLrcILVtw0HQa1oGMKkH5BAZ9bgf0=;
        b=HVXOgy3P/tNrTaSec1EwDq6ftH01QJGPUkpDBvb/XQxYHgT2/zL/fmJCQahK0JFQDQ
         20A2ZBj9n2jTrv7KuepLM9ZCuXF0UcxiLIVkuMey1CPpYK+vJNjTKSmhhb5hwEWI4XRZ
         nn8zAh/Iea/Bw/+9isy3jE3PVZsq+Naj8r1OMI0dKcaYIkPv1eKzGXL+JYGaPTcTzM3P
         qexr5+fySbDPqSQuqaoxCsXdsRig+QXmamZtpeNLhHTKqOKdiquiWstCUaagrZLlqM1o
         d7MTfA8y6mqu+yRx6Yp6y8QFcDT3jq83sTsNVHNg2h/yD+3s6c0vUjpe0wKZZA1pWTRD
         uWpg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220111083159.42340-1-w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wolfgang Bumiller <w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Thomas Lamprecht <t.lamprecht-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org>

On Tue, Jan 11, 2022 at 09:31:59AM +0100, Wolfgang Bumiller wrote:
> With the removal of seq_get_buf in blkcg_print_one_stat, we
> cannot make adding the newline conditional on there being
> relevant stats because the name was already written out
> unconditionally.
> Otherwise we may end up with multiple device names in one
> line which is confusing and doesn't follow the nested-keyed
> file format.
> 
> Signed-off-by: Wolfgang Bumiller <w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org>
> Fixes: 252c651a4c85 ("blk-cgroup: stop using seq_get_buf")

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
