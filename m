From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Mon, 04 May 2015 05:13:56 +0200
Message-ID: <1430709236.3129.42.camel@gmail.com>
References: <5546C34C.7050202@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=dLcygHD0Sap1N27Xd01bDxsbE5srqvQZsYATI5XXqV4=;
        b=0E67MQLEFmc8d27XITH2pJQu/qjlZW5Mpcyj2RY7ZRkYlQPy3/bfc5ZO/LoF9LqYKu
         9vFQUYpHF/DqbuR1UtteD4axFPmnmSlU+w2IIZSokWTaruROUZsLUQHEbhSGrt2WLN/r
         EsOAyu1/inbwgXA9HACxE0qVBGf7fwQHThdaPwqIpQkZqjz0DTnLS93y5ATAI/VJGTzz
         w9E4GwuJ9FZ+FfQOWywyPziXOMQLFbhumrAL1bARZVuaXmI4jVgtw3n7OkmSLG9RyX1P
         wSPqg0xPh3cpUn4d/gjMuY1K3lgSqNFzBRZSzR+7BZ0VeZ+v6wNWYtzbw1YQNoYh28RH
         secg==
In-Reply-To: <5546C34C.7050202-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, 2015-05-04 at 08:54 +0800, Zefan Li wrote:
> It's allowed to promote a task from normal to realtime after it has been
> attached to a non-root cgroup, but it will fail if the attaching happens
> after it has become realtime. I don't see how this restriction is useful.

In the CONFIG_RT_GROUP_SCHED case, promotion will fail is there is no
bandwidth allocated.

> We are moving toward unified hierarchy where all the cgroup controllers
> are bound together, so it would make cgroups easier to use if we have less
> restrictions on attaching tasks between cgroups.

Forcing group scheduling overhead on users if they want cpuset or memory
cgroup functionality would be far from wonderful.  Am I interpreting the
implications of this unification/binding properly?

(I hope not, surely the plan is not to utterly _destroy_ cgroup utility)

	-Mike
