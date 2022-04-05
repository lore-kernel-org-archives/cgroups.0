From: Wei Xu <weixugc@google.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Mon, 4 Apr 2022 19:30:21 -0700
Message-ID: <CAAPL-u-7Vnq8tmmRNDOz7Jw1ei_Vw=idJaPzMPoq5=sBrpyrRA@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <CAAPL-u8g2qkhdTQtFtBS3GNYz0WnyahWEXvR4g_OSaKv+7EozA@mail.gmail.com>
 <YkcYq8F6MYlMi+yS@cmpxchg.org> <CAAPL-u-za-TTyyC5uMVev9eQyhxZS7q3pVqaUxCFjqk+Sv9+ig@mail.gmail.com>
 <CALvZod4-fKfv6vbZPZ3nCE=Bue4FUnC+9t27wsznmyd+JKgDbg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JTzIzbrqZyK9WcizVERi7qlxh5xxIEK+9IqWImCqDAY=;
        b=YcMVYnQMKz2NhQbrK0HjGTOXQmTu+Vk9t1j3Nfgnp7gS4pAl9K8ReC7ZTF3NS0ao62
         +k6BganfzYE1RHEvww+e/oOwq6C1n3EDSdgXuZrPrUp/3uVwkyfn+h+4qiNGraccB4KQ
         nIfDzn7o26dbdKpb851QTXPT7ZhljzDSnSko5y404+cDtwPiIHYDokLbazUURxbzDJYf
         0wCUTDsNI802WAuIUoPq6xTRWniX7nxbPjm5nqHr5UFiVd2OkMiVpH3V//O4UytUclaa
         R0jpdX1UgmZmW10eiTYtRmFvTG/l/HJtjLd+9wWEiVF0naJ4VQ9kG+1P5NjKQrF+efCb
         Vk2w==
In-Reply-To: <CALvZod4-fKfv6vbZPZ3nCE=Bue4FUnC+9t27wsznmyd+JKgDbg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Cgroups <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Greg Thelen <gthelen@google.com>

On Mon, Apr 4, 2022 at 10:08 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Fri, Apr 1, 2022 at 1:14 PM Wei Xu <weixugc@google.com> wrote:
> >
> [...]
> >
> > -EAGAIN sounds good, too.  Given that the userspace requests to
> > reclaim a specified number of bytes, I think it is generally better to
> > tell the userspace whether the request has been successfully
> > fulfilled. Ideally, it would be even better to return how many bytes
> > that have been reclaimed, though that is not easy to do through the
> > cgroup interface.
>
> What would be the challenge on returning the number of bytes reclaimed
> through cgroup interface?

write() syscall is used to write the command into memory.reclaim,
which should return either the number of command bytes written or -1
(errno is set to indicate the actual error).  I think we should not
return the number of bytes reclaimed through write().  A new
sys_reclaim() is better in this regard because we can define its
return value, though it would need a cgroup argument, which is not
commonly defined for syscalls.
