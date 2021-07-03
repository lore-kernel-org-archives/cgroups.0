From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Question] Do we need remote charging for cpu and cpuacct subsys?
Date: Sun, 4 Jul 2021 00:20:19 +0800
Message-ID: <CA+PpKPkau-b0df5i4kpJ_RTXW1Fje4Ms0T2hGJCOE31u+BU7zg@mail.gmail.com>
References: <60decdb6.1c69fb81.6130e.7642@mx.google.com> <YN+Sne76dhKBzV/R@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1fwH/bw6YM2VK2ZtZ+qfS4I4lbDV6J5Z7VDXRCzZF+8=;
        b=kjom6xz7C8co4aNRq3MLNCpCMu8G68k59CdktcehnAQmR/Hcb85++xJt7nxZC60RZO
         RS5hUu8jzwKfthYPb1XR7t2+H/49WiYqU0UxIIP50cdZzl/D2ISQmNO22d+u0RSqPHzP
         HP+J8431QOFBmlNCNy/XkPMg3hqVqSRi51ZJbpdEm6gCjkMsXSBnyolRceavcIqh73ZS
         vU/DCTjfSEmvztJ4DEEuq9zARLU6MpQ4d/QEQEic2LJ5/xbJgd5njXMAJRvkKKsie48W
         tH28MCMX0cFMm9NDlDU05S2Yy84KBuU79Y++ZSJ6/JW3QCaX86mhStPVg4gARRTOrT1V
         piGg==
In-Reply-To: <YN+Sne76dhKBzV/R@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jul 3, 2021 at 6:26 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Jul 02, 2021 at 08:26:27AM -0000, Hao Lee wrote:
> > memcg currently has a remote charging mechanism that can charge usage to other
> > memcg instead of the one the task belongs to.
> >
> > In our environment, we need to account the cpu usage consumed by some kworkers
> > to a specific cgroup. Thus, we want to introduce a remote-charging mechanism to
> > cpu and cpuacct subsys in our kernel.
> >
> > I want to know if the community has a plan to do this?
> > What will the community approach look like?
>
> Yeah, we need sth like this to account for cpu cycles spent in commont path
> but caused by specific cgroups - e.g. memory reclaim, net packet rx and so
> on. There were some mentions of needing somthing like that but haven't been
> any patchsets or concrete efforts that I know of.

Thanks for this reply. I am interested in this area because this feature
would be very useful in our containerized environment. I will track related
discussions and want to do some work related to remote charging.

>
> Thanks.
>
> --
> tejun
