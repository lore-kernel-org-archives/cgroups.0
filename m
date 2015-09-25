From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: PIDs Controller Limit
Date: Sat, 26 Sep 2015 09:11:02 +1000
Message-ID: <CAOviyagSDkNWY1X7d=nAhgqkOz2fE+ck+rS9Fn_hfMbCZHRyKw@mail.gmail.com>
References: <CAOviyajLPivBQLauYHWTW71PHyvF15X=Ocu8JDc-92s0k3XRwA@mail.gmail.com>
	<20150925153912.GG4449@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150925153912.GG4449@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

> On Thu, Sep 24, 2015 at 09:42:38AM +1000, Aleksa Sarai wrote:
>> Does it make sense for the PIDs controller to allow a user to set a
>> limit of 0? Since we don't cancel attaches, a limit of 0 doesn't
>> affect anything (nothing stops attaches, and you need to have a
>> process in the PIDs cgroup in order for fork()s to be affected by the
>> limit). So I think that attempting to set pid.limit to 0 should return
>> an -EINVAL.
>
> I don't know.  Why does it matter?

Well, it might be confusing that a limit of `0` is not different from
a limit of `1`. Especially since someone might think that a limit of
`0` means "no processes AT ALL", which is wrong. Although, I guess
they should've just RTFM'd in that case.

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
