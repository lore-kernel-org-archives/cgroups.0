From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface
Date: Mon, 19 Mar 2012 09:05:32 -0700
Message-ID: <20120319160532.GB11069@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <4F6708F4.4000604@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Dib/0Ly49Kb9H2anxO0uDMBdr5mGWBRA2CK63a4+/RY=;
        b=Ku5gkINJ+tZ7Iqox+WbPe4okVLk9eXHpOxrlf6fqSpEou+akFml+8+XJ/nZVHMMsz0
         EkvtoC0VTuj/OTrf0Hn55LvWPB08ggEV52sddcQz5Z2gVuLDQVqOzCldHvWg7qiKecCh
         1ZPq+bM/EZxk5K0VBDFqn7hANEW38ix7R3q5H8VTln+EfDG/cC4Ke2bgCsQHBMjlxii3
         FWwGDlyUw6YNVtnF+hrP5BumVyzu5Iiubb1MvpAA5BXK3FWZiK8BxNjV9uAdxApFGTL4
         /UW77aLLjlGbIzfWZ6IeAHHIlX2C+7t/IvzYO4yVIakJpO49Y5ITfDGkWBCn+ebX50xJ
         dY3Q==
Content-Disposition: inline
In-Reply-To: <4F6708F4.4000604-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello, Glauber.

On Mon, Mar 19, 2012 at 02:22:44PM +0400, Glauber Costa wrote:
> >Glauber, can you please try to move net kmem stuff out of
> >->populate().  If ->create() doesn't work for whatever reason, can you
> >please explain it to me so that we can find a proper solution?
> 
> The main reason is twofold:
> 
> It first had to do with the order in which registerings take place
> at the kernel. But this matter most for the root cgroup. For the
> children, it should be all initialized anyway. So we can special
> case whatever is needed.

I see.

> Another point was not to bloat the socket structures with more
> function calls, for populate and create. But we can possibly be able
> to store some data ourselves, and figure it out.
>
> How should I do it? Do you want me to provide a patch ontop of your tree ?

Yeah, that would be great.

Thanks.

-- 
tejun
