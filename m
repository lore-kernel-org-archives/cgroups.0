From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Mon, 27 Nov 2017 13:42:32 -0800
Message-ID: <20171127214232.GT983427@devbig577.frc2.facebook.com>
References: <1507324230-22996-1-git-send-email-longman@redhat.com>
 <20171127210411.GS983427@devbig577.frc2.facebook.com>
 <8a5ba419-2b02-5b6a-462f-34106cc575ab@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gHVxHiJY601bd6HmUO34IkNz8Ij/tanYzsoyferH/k0=;
        b=gCivkxNHMPGWZDiQWDotQGQ2RXz/JnbBnVyoBBVaYSaj2TOCzJ3NITUdKHuBO2sk2p
         XYRlXq6OEib3pH9FK/u0KuPXdZw0fKyQtlLr5pMyg2phgVxGb6/cgRqIHM2FAj1zJmpD
         c1cu4u9h68BcWzEtF+1jw5262X/irmHIt5g5dwny2IlkJf0t7275BJ85wBEkmYHz0TsA
         8699/wqIdQvnnIfzzTcbU6VvWkRYE9KNLSWi7m8+iXJ7ks66JBOLC3yqi7xYY54mc6et
         fYZpDE1YwTUf0Gol4DSV5ZQoEQWdZMojC7tYgZLXa1p8+DO1W2yDLqn4J5Rgo4vDi/vY
         6row==
Content-Disposition: inline
In-Reply-To: <8a5ba419-2b02-5b6a-462f-34106cc575ab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Christian Brauner <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

Hello, Waiman.

On Mon, Nov 27, 2017 at 04:19:57PM -0500, Waiman Long wrote:
> > Let's start just with [e]cpus and [e]mems.  The flags interface looks
> > fine but the implementations of these features are really bad and
> > cgroup2 doesn't migrate resources for other controllers either anyway.
> 
> That is added because the mem_migrate feature is used in libvirt, I
> think. I am thinking of add a "[EXPERIMENTAL]" tag to the flags to
> indicate that it is subject to change.

I see.  Do you happen to know what it's used for and why that's
necessary just so that we can evaluate it better?  I'm not quite sure
what adding [EXPERIMENTAL] tag would achieve.  If we expose the
feature and people use it, we just have to keep it anyway.

Thanks.

-- 
tejun
