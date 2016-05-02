From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs_path_from_node_locked: don't overwrite nlen
Date: Mon, 2 May 2016 12:32:56 -0400
Message-ID: <20160502163256.GT7822@mtj.duckdns.org>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
 <1460923472-29370-2-git-send-email-serge.hallyn@ubuntu.com>
 <20160420194313.GA4775@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JNYccuUFA1rnaISo0yzIcGBENOLyQwYF4RWUYGCR8Rs=;
        b=pGNZ6JFB+u1FCrGA+MqdBZKDxhigTvhKyYq3groyIg42Tjc3f3FToT/uo9JRKW4oqm
         9ojYjx11vWTaHStk/7Zetc/b7nc87ubhs8BV/SRKSqGqnNAZSYn8gBoAl8p8LzBOc3pw
         tx30FQh8qPUPH2OTJFm+j7pIh/msnzZogLY5HuXdcEFZpGtIFjb0j1aXigfDXZqCZnWg
         foD/cZ6d4B3PPLVq1qkEit8kq0ckLoBYA8CP5sXoMoI1W2UirBrcU8X3CsIrPDW7HOxy
         6wyyuwAOXVLB67jG9FgiJ5MJDIPhWG8UbPAotb+kTl8fDp+zrsiGbc2Y0sp5EN9To+I7
         DTcA==
Content-Disposition: inline
In-Reply-To: <20160420194313.GA4775-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Wed, Apr 20, 2016 at 03:43:13PM -0400, Tejun Heo wrote:
> On Sun, Apr 17, 2016 at 03:04:31PM -0500, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> > From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> > 
> > We've calculated @len to be the bytes we need for '/..' entries from
> > @kn_from to the common ancestor, and calculated @nlen to be the extra
> > bytes we need to get from the common ancestor to @kn_to.  We use them
> > as such at the end.  But in the loop copying the actual entries, we
> > overwrite @nlen.  Use a temporary variable for that instead.
> > 
> > Without this, the return length, when the buffer is large enough, is
> > wrong.  (When the buffer is NULL or too small, the returned value is
> > correct. The buffer contents are also correct.)
> > 
> > Interestingly, no callers of this function are affected by this as of
> > yet.  However the upcoming cgroup_show_path() will be.
> > 
> > Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Greg, can you please pick this one up for v4.6?

Looks like Greg missed this one.  Greg, I'll route this through
cgroup/for-4.6-fixes.

Thanks.

-- 
tejun
