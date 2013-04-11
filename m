From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove bind() method from cgroup_subsys.
Date: Thu, 11 Apr 2013 17:30:03 +0800
Message-ID: <5166829B.9040509@huawei.com>
References: <1365594077-17655-1-git-send-email-ramirose@gmail.com> <20130410175035.GA17641@mtj.dyndns.org> <5166199F.7090104@huawei.com> <CAOS58YP8V=GNrkRJN1G3EJrdVgK6NPcvm+30SW_xjC1Sq2QBng@mail.gmail.com> <5166600F.3090303@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5166600F.3090303-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/4/11 15:02, Glauber Costa wrote:
> On 04/11/2013 06:06 AM, Tejun Heo wrote:
>> Hello, Li.
>>
>> On Wed, Apr 10, 2013 at 7:02 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>> I remember Glauber once used the bind() callback to detect if cpuacct and
>>> cpu are mounted together and if so do some optimization.
>>>
>>> Then he gave up on it and just deprecated cpuacct, but then it was decided
>>> that it can't be decprecated and removed as that will break userspace.
>>>
>>> So mayber Glauber will want to use this callback again?
>>
>> There was a patchset which made cpu provide the same stats as cpuacct
>> if mounted together, which bitrotted while Peter was away. We probably
>> should resurrect those patches. I don't recall whether it used ->bind
>> or not. Glauber?
>>
> 
> The patch didn't suffer any change in its last 2 iteractions, so I was
> just waiting for someone to apply =p (or well, say something)
> 
> It re-uses the infrastructure that you built in cgroup.c to detect
> comounting, so it does not use bind.
> 
> I must add that I used bind just because "it was already there", and at
> the time we were also quite concerned about not increasing even more the
> number of callbacks. It is a horrible interface IMHO.
> 

Thanks for the clarification! Then I'm fine with this patch.
