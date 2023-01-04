From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: no need to explicitly init a global
 static variable
Date: Wed, 4 Jan 2023 12:21:54 -1000
Message-ID: <Y7X8Asv25sntht6t@slm.duckdns.org>
References: <20221220151415.856093-1-neelx@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B/3ppUmh4bmqybcFcsNaCu/D7XFzMdaZVgO4yNK9uS8=;
        b=m3Sl/7J9Eg2xJBzdmZbdAe60sOL/fthI5hRvSskmpX6OHx15gV3HeMT50kSGqypuOh
         FCbow/o8gEu5cXqV5g56v5bzEP2U6cGZuJNvfRWaO+dLFhB5eKEX571YWfow8VgC0Vfu
         hCngLTiyWszq+yaoa8COFsKDVGPnTZJnNFt3olQhC/dRejvoy6Qh5WUbe+qDJ0YQ/DzM
         8+p2WwcZXk2+nwhC3EcLF0Tw0EClGyI5FwPJSFUoiBXpN5qKRXPQry85sGYRy+4ez/j0
         M17e5MNoHlAmPyA/fHz4Gkh689AVXyJFuGxYRuSEfNg8daWv61TBk/mopeymvSnfm4AR
         pKjQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221220151415.856093-1-neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 20, 2022 at 04:14:15PM +0100, Daniel Vacek wrote:
> cpuset_rwsem is a static variable. It's initialized at build time and so
> there's no need for explicit runtime init leaking one percpu int.
> 
> Signed-off-by: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.2-fixes with the following description:

    cgroup/cpuset: no need to explicitly init a global static variable
    
    cpuset_rwsem is a static variable defined with DEFINE_STATIC_PERCPU_RWSEM().
    It's initialized at build time and so there's no need for explicit runtime
    init leaking one percpu int.
    
    Signed-off-by: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Reviewed-by: Aaron Tomlin <atomlin-OvwSCxsgXNNBDgjK7y7TUQ@public.gmane.org>
    Acked-by: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
    Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
