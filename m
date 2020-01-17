From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/3] clone3: allow spawning processes into cgroups
Date: Fri, 17 Jan 2020 08:53:11 -0800
Message-ID: <20200117165311.GH2677547@devbig004.ftw2.facebook.com>
References: <20191223061504.28716-1-christian.brauner@ubuntu.com>
 <20191223061504.28716-3-christian.brauner@ubuntu.com>
 <20200107163204.GB2677547@devbig004.ftw2.facebook.com>
 <20200108180906.l4mvtdmh7nm2z7sc@wittgenstein>
 <20200116122944.nj3e66eusxu6sb44@wittgenstein>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yuUv1OXPdVXWCIetDO046G9cCpe5yN5/7bZ6LwPz4B0=;
        b=qejqoYN8Ckgk98zDdvv5t54CTIJkmQNW8KtQRyuyEU5uMhUYYKKdT62/lehyI7sVJm
         qDJZ79DuRMyEyQ5o4Sh/7vvL5aHNSe/eGoS0al+CWlnzItuoZmCOirDYyqSxEDCMdULT
         KMOPWsJfXCxADqkxSg3zY36dU/UpJqlnGRoyFbac5jbYRQUByodAZngML6pRT7ATH01E
         VQnhvcD0HAZSbw7aP5UlTlCFkCxiR7SbsQkQHmQ0s5TuN0SBNFPHY6A/V0/y9Uscci6n
         EeCF2xh5jqi4sRdsIwmsa6b0NditLe5KWesqcI88MZv6SzbmERB6gu6sNYB3BpWuVxhb
         SKHA==
Content-Disposition: inline
In-Reply-To: <20200116122944.nj3e66eusxu6sb44@wittgenstein>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Christian.

Sorry about late reply.

On Thu, Jan 16, 2020 at 01:29:44PM +0100, Christian Brauner wrote:
> Could it be that you misread cgroup_attach_permissions()? Because it
> does check for write permissions on the destination cgroup.procs file.
> That's why I've added the cgroup_get_from_file() helper. :) See:
> 
> static int cgroup_attach_permissions(struct cgroup *src_cgrp,
> 				     struct cgroup *dst_cgrp,
> 				     struct super_block *sb, bool thread)
> {
> 	int ret = 0;
> 
> 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb);
> 	if (ret)
> 		return ret;

So, if you look at cgroup_procs_write_permission(), it's only checking
the write perm of the common ancestor, not the destination because it
assumes that the destination is already checked by the vfs layer, and
we need to check both.

Thanks.

-- 
tejun
