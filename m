From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix cgroup_get_from_id
Date: Fri, 23 Sep 2022 07:29:52 -1000
Message-ID: <Yy3tEKSV+vg6swOd@slm.duckdns.org>
References: <20220923115119.2035603-1-ming.lei@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=No+zB8N8/I6uv9gE3yfw5UXtcRDIM1VBhtQdkeHbVVQ=;
        b=IQsFLvu+KTdRASYHh2un+r7HH3He23RjO0OQhdDgZDlzm1pSH8ryafMC7XEzlvf+mY
         hZ++BIKCaXXGlw9bP/2M1pT8z4HIzkXddki+Xmcr0WWZl9sJfHFLKMjOniqI+pn31F3l
         G3llMF+POQvXkxCcSOnQOL/5MQefl1o9ZIQO6+Nh6HteoQKPjI/Vh3I7vrvy7ImnIXK+
         VCnOdqjngEXm4DYGFXZTp02xZ1lIg2T+XYRMuIOrcNm1imtM+N3FKy28jWxHQi7ZqmNq
         2lUpwouatFNzlk/8Is3d3so9D8USBa5J4/2LdMcJGPnUL1vqeVkHSo6gZOlnBrib+9OE
         f29A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220923115119.2035603-1-ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marco Patalano <mpatalan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Muneendra <muneendra.kumar-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Fri, Sep 23, 2022 at 07:51:19PM +0800, Ming Lei wrote:
> cgroup has to be one kernfs dir, otherwise kernel panic is caused,
> especially cgroup id is provide from userspace.
> 
> Reported-by: Marco Patalano <mpatalan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Fixes: 6b658c4863c1 ("scsi: cgroup: Add cgroup_get_from_id()")
> Cc: Muneendra <muneendra.kumar-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.0-fixes with the subject changed to "cgroup:
cgroup_get_from_id() must check the looked-up kn is a directory" and stable
cc'd.

Thanks.

-- 
tejun
