From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 0/6] cgroup, blkcg: prevent dirty inodes to pin dying
 memory cgroups
Date: Fri, 4 Jun 2021 11:53:02 -0400
Message-ID: <YLpMXmWvPsIK97ZE@slm.duckdns.org>
References: <20210604013159.3126180-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BFNJl7w5MoErGTGxa0e9M8jpquhBhJupY2y4JLWlRpA=;
        b=ndbmBpyRMTLo5CTZFU0wHBaAV8AcbKUUW3wG9R46rMAh3CrQ1hVUUPP25ttvbRpN5o
         tzg1EVk7iJYeWLL9TkNIKhnL68/IuJUA8JefbrY+j5Yr+gY+PkxpC73fwdZxDTl39brw
         8VW6u1tyl9X8HLTnoUG9+DAxVN9btvcDVIFIvPX9yH9JaMAvif1QtFm7fgJOZUSJ/G7z
         jtDqjiWbOCcSGpQV6exeuZ7PKG5nlr5tdEj2NZJaDwDpmf2yLpkYSiEtIAHa2ia0nuTp
         5seoXqQ4jqBpSjrtbSX1eEsbSnhajLDfiC3QmTj+A/RSwe+Shj4BWgpBNYpOsJmCXAWI
         PX/g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210604013159.3126180-1-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 03, 2021 at 06:31:53PM -0700, Roman Gushchin wrote:
> To solve the problem inodes should be eventually detached from the
> corresponding writeback structure. It's inefficient to do it after
> every writeback completion. Instead it can be done whenever the
> original memory cgroup is offlined and writeback structure is getting
> killed. Scanning over a (potentially long) list of inodes and detach
> them from the writeback structure can take quite some time. To avoid
> scanning all inodes, attached inodes are kept on a new list (b_attached).
> To make it less noticeable to a user, the scanning and switching is performed
> from a work context.

Sorry for chiming in late but the series looks great to me and the only
comment I have is the migration target on the last patch, which isn't a
critical issue. Please feel free to add

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
