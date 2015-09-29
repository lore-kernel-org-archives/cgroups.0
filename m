From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: PIDs Controller Limit
Date: Tue, 29 Sep 2015 09:13:34 +0300
Message-ID: <560A2C0E.40007@kyup.com>
References: <CAOviyajLPivBQLauYHWTW71PHyvF15X=Ocu8JDc-92s0k3XRwA@mail.gmail.com>
 <20150925153912.GG4449@mtj.duckdns.org>
 <CAOviyagSDkNWY1X7d=nAhgqkOz2fE+ck+rS9Fn_hfMbCZHRyKw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOviyagSDkNWY1X7d=nAhgqkOz2fE+ck+rS9Fn_hfMbCZHRyKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 09/26/2015 02:11 AM, Aleksa Sarai wrote:
>> On Thu, Sep 24, 2015 at 09:42:38AM +1000, Aleksa Sarai wrote:
>>> Does it make sense for the PIDs controller to allow a user to set a
>>> limit of 0? Since we don't cancel attaches, a limit of 0 doesn't
>>> affect anything (nothing stops attaches, and you need to have a
>>> process in the PIDs cgroup in order for fork()s to be affected by the
>>> limit). So I think that attempting to set pid.limit to 0 should return
>>> an -EINVAL.
>>
>> I don't know.  Why does it matter?
> 
> Well, it might be confusing that a limit of `0` is not different from
> a limit of `1`. Especially since someone might think that a limit of
> `0` means "no processes AT ALL", which is wrong. Although, I guess
> they should've just RTFM'd in that case.

I personally would have parsed a value of 0 as "unlimited"
