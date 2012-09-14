From: Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] cgroup TODOs
Date: Fri, 14 Sep 2012 18:03:16 -0400
Message-ID: <CAPhKKr8wDLrcWHLTRq1M7gU_6CGNxzzF83zJo2WZ5vrY7h8Qyw@mail.gmail.com>
References: <20120913205827.GO7677@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=S2uS3UsXSHB4/F6LH4+5niWmP3a3oNCwinoYUL6XbkM=;
        b=RYGo6z8xw2utvbZpx5bQArrpTjH39o6LOOh5pbGaJf1oWZElpvdFXPDrTAu9MbBxDT
         jdZoWAYqI76smUQtfkQ5TjgsCg7UzzINle+Xo31gecO6mxGv/DQ9aR9q52OOYqLx/lgc
         N2zmjagcIKt4PryyaXOToS52OwiulgsCRGiMPNsQFc5G6/XoMiMydGfliJgJsFnLwVtj
         KGN3Y0yZZJZOkALsjx2UvFawSJd6cOp5WzAzl24Je9uBB7sGG8akQiHCuaiqEZ77QPGC
         XDnVa+f6Eqj53TPsYuiqOXk2TXnGB4M92qP37Z9zCwvczvhchiJdMpVCyxmHmOjI7j4Y
         fEiw==
In-Reply-To: <20120913205827.GO7677-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

>
>   * Sort & unique when listing tasks.  Even the documentation says it
>     doesn't happen but we have a good hunk of code doing it in
>     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
>     don't like it, scream.
>

I think some userspace tools do assume the uniq bit. So if we can
preserve that, great!

Thanks
Dhaval
