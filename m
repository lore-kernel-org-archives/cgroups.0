From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove bind() method from cgroup_subsys.
Date: Wed, 10 Apr 2013 19:06:41 -0700
Message-ID: <CAOS58YP8V=GNrkRJN1G3EJrdVgK6NPcvm+30SW_xjC1Sq2QBng@mail.gmail.com>
References: <1365594077-17655-1-git-send-email-ramirose@gmail.com>
	<20130410175035.GA17641@mtj.dyndns.org>
	<5166199F.7090104@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=FktEpRBfaTiVwQmHqb5cRw3uTI7wgHPflm6LgiG+vWM=;
        b=DTH5QQKWDsszfMk+x9l18f0ce1FYxBOJyHOI4kRTn0xM/NgCxjc9XCaxHgKImauMox
         yX7ci0w7qEqFvcnlEejfmpKYeWhUX4QNBC48HzR24mbhxXsPQ0pjb/Wpl+UgdNnTQdg8
         ZiJEjv9Jq5pB8wJj6NmdV5HcXqbMkNpsVsQTkXuaFTTgZ9opCyikz5C2aDdIxT/RbXom
         B7FOlWNhiXwIq+nsWCT1NUHc1ECdZMoxojSj9F0prx4juc061AoVIW+Z1uhbCNw6RKJ9
         RCmmllExORYv+7nF7iwaLVTko3mKn+dYPcTwmy/kcaC93aLILmQb/kzj5T4KzBzAEZF+
         re8Q==
In-Reply-To: <5166199F.7090104-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hello, Li.

On Wed, Apr 10, 2013 at 7:02 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> I remember Glauber once used the bind() callback to detect if cpuacct and
> cpu are mounted together and if so do some optimization.
>
> Then he gave up on it and just deprecated cpuacct, but then it was decided
> that it can't be decprecated and removed as that will break userspace.
>
> So mayber Glauber will want to use this callback again?

There was a patchset which made cpu provide the same stats as cpuacct
if mounted together, which bitrotted while Peter was away. We probably
should resurrect those patches. I don't recall whether it used ->bind
or not. Glauber?

Thanks.

--
tejun
