From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.7-fixes 1/2] Revert "cgroup: Remove
 task_lock() from cgroup_post_fork()"
Date: Fri, 19 Oct 2012 14:07:38 -0700
Message-ID: <20121019210738.GA1180@google.com>
References: <20121008020000.GB2575@localhost>
 <20121019005922.GG13370@google.com>
 <CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
 <20121019193808.GL13370@google.com>
 <CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4O49wvpyhZsiuVl7clhouilHSGks13rTdwSn7K41z+o=;
        b=cFzerI7ZixmXzqPxS8aJ2ERL0E5RCAIBAWGq50Hg0a2Bekj04WK87rU/m6+wv0D0Cg
         tbSJ6nEElZL7py7CAEqfso2U+tmdkDCqf/6iFnbopaBC+983fNkuFrMRR1Cu8BvmpU/Z
         v0xnCq8kwzM9jd84tPg+5ToUlSb+35+4VTxUdpApu2EMvRL1aXXQ6AYcU35mDvij92G6
         Rjt5MykYPPbIqk8k8tuu2UeRvs7lmqvN3ql9ZjSGrFG3pHJ7xCZnnPUfMy6jkqpTSKnF
         xNCQcEI+jA2c29oWM/Nd80xwuXQRqphjI+f5Jw2zYrBq8lt461Re5TeHLAM4xyYp/VFX
         2JFg==
Content-Disposition: inline
In-Reply-To: <CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Frederic.

On Fri, Oct 19, 2012 at 03:44:20PM -0400, Frederic Weisbecker wrote:
> > For -stable, I think it's better to revert.  If you want to remove
> > task_lock, let's do it for 3.8.
> 
> I don't think that a wrong comment justifies a patch to stable.

I'm not really sure whether it's safe or not.  It seems all usages are
protected by write locking css_set_lock but maybe I'm missing
something and as the commit is born out of confusion, I'm very
inclined to revert it by default.  Are you sure this one is safe?

Thanks.

-- 
tejun
