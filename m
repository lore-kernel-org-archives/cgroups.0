From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix a typo in comment.
Date: Mon, 25 Aug 2014 10:50:35 -0400
Message-ID: <20140825145035.GB21688@htj.dyndns.org>
References: <1408966072-2142-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vS9/UxY7aI5YPBnPutQ8vbB79EzEof65SPwtgeOfLEs=;
        b=KXmqESn1xDtzpFau7C/h5Zm5n2OY/grupnKucZEy7EPaZuzuCSqWs0bw/JZzYHSyWn
         a6y9LEVyYBfADEZVee/5Yd81ZedexoR0cbfjPtijFodjZLQ6EQkvq8d+/7Vp+qzIuFr2
         tJ948qdJG9/UScfenkoGjUe3SpU7z9IwYfvxQIb/9OIYHUYNk9Osx+tJHMLsMP0QKu7i
         /0XN7ueHECOs9anEcriR1aAIs8OLionLmc7R0bfLgForBC0tkxSKFBCb/fKmwiPq605O
         r0Gg/doKurnMAJMYEpaVsXiFLNqNmEi1hkqmx9Tvygo1FORR2QlZLRMB9Uz5/pG4u7pb
         h0pw==
Content-Disposition: inline
In-Reply-To: <1408966072-2142-1-git-send-email-yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 25, 2014 at 07:27:52PM +0800, Dongsheng Yang wrote:
> There is no function named cgroup_enable_task_cg_links().
> Instead, the correct function name in this comment should
> be cgroup_enabled_task_cg_lists().
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
