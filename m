From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Date: Fri, 6 Dec 2013 11:13:12 -0500
Message-ID: <20131206161312.GC13373@htj.dyndns.org>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com>
 <20131205211814.GA29598@mtj.dyndns.org>
 <52A1766F.5090808@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5D8NZ+OWgs8mNVF10ks2NuJY66YNTJmNPH6Zi5VPzAI=;
        b=bX5ROYvfBJFmUUW/hK8lUQo1hu1rgG3lUsn4zD7Dy0zvdhPTDigl8N/LfLvhcPaAUB
         xDGBWUqRSxScGmZe+tsCuO+pdo120M50NkWhnOsOolCmrSP/iv0OVDHlXSjKFYqUooXo
         WPlqZ4WGbg4N/V0Yyn9CJCb8zApUEGAP59rhamCvqYgHrgSb+gYqwVCOlweFVmlDOl8U
         gB0KqCMTVLIG2sGd1OOstJL4kvrzzJm51NunDr5pZsvpjwj6iTjBLE2rk+/6/SJ6+NUU
         GVQAiSYNcYYqdRuTDOlgZ0DX8y6Q1XekX/mxemsiH78AdfFiu4sLHLlJLS8Rzl9QUEvD
         d39Q==
Content-Disposition: inline
In-Reply-To: <52A1766F.5090808-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Hello, Vladimir.

On Fri, Dec 06, 2013 at 11:02:07AM +0400, Vladimir Davydov wrote:
> This patch fixes this bug, but I have a couple of questions regarding it.
> 
> First, cgroup_load_subsys() also calls css_online(), and if it fails, it
> calls cgroup_unload_subsys() to rollback. The latter function executes
> the following command:
> 
>     offline_css(cgroup_css(cgroup_dummy_top, ss));
> 
> But since we failed to online_css(), cgroup_css() will return NULL
> resulting in another oops.

I don't think the root css onlining fails for any existing controllers
but yeah that looks wrong.  Can you please send a patch?

> Second, it's not clear to me why we need the CSS_ONLINE flag at all if
> we never assign css's that we fail to online to a cgroup. AFAIU we will
> never see such css's, because in all places we call offline_css(),
> namely cgroup_destroy_locked() (via kill_css()) and
> cgroup_unload_subsys(), we use cgroup_css() which will return NULL for them.

The whole thing is in flux and will look very different in near
future.  I actually had patches queued which deal with the issue you
spotted but they are being blocked on other changes ATM.  So, yeah,
there are some spurious stuff now.

> Before we get here, we call
> 
>     /* each css holds a ref to the cgroup's dentry and the parent css */
>     for_each_root_subsys(root, ss) {
>         struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
> 
>         dget(dentry);
>         css_get(css->parent);
>     }
> 
> If we fail to online a css, we will only call
> 
>     ss->css_free(css);
> 
> on it skipping css_put() on parent.
> 
> css_put() is called on parent in css_release() on normal destroy path.

You're right.  I'll revise the patch.

Thanks.

-- 
tejun
