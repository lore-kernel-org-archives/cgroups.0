From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Thu, 9 Sep 2021 20:56:16 +0200
Message-ID: <YTpY0G3+IJYmGbdd@blackbook>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz>
 <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631213778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7t8ztgYZsndp44kDdVFUqlrz/Zoxo2W/1YXS7ePODV0=;
        b=RhFaxjaP0kRFSHZmQkLTUH3usxdlgA4J91/Herg20j4L7sLvgpQ3JuSnllPZKyRxRfc+GE
        jUQP2aFo5A7rEO5JhhZx+eP5RNM5w37gbXoODJX03b45gvkpVwvKIF75IbQuFknN/IVq0A
        MbKJUW3joiEwGySf/L0DeqEspo5mdYs=
Content-Disposition: inline
In-Reply-To: <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 09, 2021 at 09:49:56AM -0700, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> We are adding two files in this patch series, misc.events and
> misc.events.local. I think "fail" should go in misc.events.local and
> its name should be changed to "max".

I consider the max vs fail orthogonal to local vs hierarchical. I.e.
both entries can be in both files:

(1) misc.events.local:max	number of times the cgroup's misc.max was hit
(2) misc.events.local:fail	number of times operation failed in the cgroup
(3) misc.events:max		number of times the cgroup's misc.max was hit in the subtree
(4) misc.events:fail		number of times operation failed in the subtree

Is that too many? Admittedly, I assume (1) and (4) will be the more useful ones.
However, I'm afraid overloading "max" as suggested might be (more)
confusing. ('subtree' above := self or descendant)

Michal
