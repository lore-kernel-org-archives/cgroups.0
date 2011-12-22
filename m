From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] cgroup: only need to check oldcgrp==newgrp once
Date: Thu, 22 Dec 2011 07:38:22 -0800
Message-ID: <20111222153822.GB17084@google.com>
References: <1324527518-24461-1-git-send-email-msb@chromium.org>
 <1324527518-24461-3-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=m/vY7xsSzmLrFoY+vmVc5/THXzGFFGGWJ0OLFKciErY=;
        b=uAtUchbfw3sDYEbu+9wqnB0KrvjlqQA4b1u73/X7d6BxZuT3vNBu6kwJABqO3cQqOA
         jbqHwlZaHRl15IUxM79m2QWG6sEffp+sizjYxNjyFsXcj4Zqg+WaEYoFm0cwy55voqWr
         D+FEqgn4+xIpYiLdPsA5w+KCxSMWrXCgoT1uI=
Content-Disposition: inline
In-Reply-To: <1324527518-24461-3-git-send-email-msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

On Wed, Dec 21, 2011 at 08:18:37PM -0800, Mandeep Singh Baines wrote:
> In cgroup_attach_proc it is now sufficient to only check that
> oldcgrp==newcgrp once. Now that we are using threadgroup_lock()
> during the migrations, oldcgrp will not change.
> 
> Signed-off-by: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Reviewed-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Applied 1-3 to cgroup/for-3.3.  I edited out mention of check_fetched
rename in the commit description of the first patch and applied
Acked-by from Li to all three.  Li, let's stick to ack/nack.

Thanks.

-- 
tejun
