From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/10] cgroup: introduce struct cfent
Date: Tue, 20 Mar 2012 09:02:28 -0700
Message-ID: <20120320160228.GD5684@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <1331940963-15756-10-git-send-email-tj@kernel.org>
 <4F688EA9.8050905@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=b70B1nqgrLejGIibwI8W34y3OYUUAwQTmkn3zYS0x7U=;
        b=SOrungKHEzmumwBVdYzw7skNTO9WslTqMPNB9nVxD+95/G+BsT0xqwQI+JGiWSrbi2
         nxjecvA1WFbxo6JEY6X+0iikVNvkTVzQpmZlC9Y4QlKS5uEomlCVmr3JYsqBTDExn1bK
         qKEEj1L+x+L0wTJElBIorvauR+qcc4qhp9DS+IjNZDKH4WBmQPSzHL97ET4jdijHqOMK
         zOOwym1ezxoZO68XAu3rHvHwpXtS2W6LnD+lPVpCsyZLj0KqotN9CH11xeImf5s2VUNr
         zYotwNOug4NLBdsCMvWxvr3tKFPcIhiLi3F0NCfSLizMSZMc6ufvaSIOTHWW3mquR584
         hcIw==
Content-Disposition: inline
In-Reply-To: <4F688EA9.8050905-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Tue, Mar 20, 2012 at 06:05:29PM +0400, Glauber Costa wrote:
> On 03/17/2012 03:36 AM, Tejun Heo wrote:
> >+static void cgroup_clear_directory(struct dentry *dir)
> >+{
> >+	struct cgroup *cgrp = __d_cgrp(dir);
> >+
> >+	while (!list_empty(&cgrp->files))
> >+		cgroup_rm_file(cgrp, NULL);
> >+	WARN_ON_ONCE(!list_empty(&dir->d_subdirs));
> >  }
> 
> 
> I am hitting this warning here under pretty much normal conditions.
> You forgot to account for trivial directories like "."
> 
> I'll send a patch ontop of what you have.

Heh, yeah, I hit that yesterday too and was gonna look into that
today.  Is the patch coming? :)

Thanks.

-- 
tejun
