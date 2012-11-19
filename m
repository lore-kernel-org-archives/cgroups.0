From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup: allow ->post_create() to fail
Date: Mon, 19 Nov 2012 08:34:45 -0800
Message-ID: <20121119163445.GE15971@htj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <50A9F3B3.2010607@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=w8RkAaeceSPGBWUvGblDN6i2jpQ43rT56KUfmKAMjjc=;
        b=BWkqvmpnAkQZPFfpQg7gCnzEnH2jVzO9H6jtofJRw+Ng5o5Xb9+uDgNoFaLN+7dyhP
         YZTjfRjp4OXYhXnki4fdfxGFsIB8I5QQavOHQBaCz+lbi+JhsS1fXdlsGsJWwBNylpmC
         wnHm1zm7g89pNQ+jNUHyd+YBCRYMmSC5q16ZENqnOClrt0ZfjhUyNHeXW3PH2EoAT2Es
         8qNZsN6hBnlqoj+RhAoZSlczUmUgDtQeTg+gdwTUk9rFXDCddUibRr9yFfWA0dHl3oER
         /cfuGMdyMoqSdjRgglmZhicMoBPOOCyh+WSX4Bh5haCupOV1lN5IYxD7GZt2x2MjsfHe
         Qiwg==
Content-Disposition: inline
In-Reply-To: <50A9F3B3.2010607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org

On Mon, Nov 19, 2012 at 04:54:11PM +0800, Li Zefan wrote:
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> except 0006-cgroup-remove-duplicate-RCU-free-on-struct-cgroup.patch

Patchset applied to cgroup/for-3.8 sans 0006.

Thanks.

-- 
tejun
