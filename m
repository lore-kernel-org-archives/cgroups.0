From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 0/4] Provide cpuacct functionality in cpu cgroup
Date: Wed, 23 Nov 2011 08:29:49 -0200
Message-ID: <4ECCCB1D.2090501@parallels.com>
References: <1321372757-1581-1-git-send-email-glommer@parallels.com> <20111116095706.6304e695.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111116095706.6304e695.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/15/2011 10:57 PM, KAMEZAWA Hiroyuki wrote:
> On Tue, 15 Nov 2011 13:59:13 -0200
> Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>
>> Hi,
>>
>> This is an excerpt of the last patches I sent regarding cpu cgroup.
>> It is mostly focused on cleaning up what we have now, so it can
>> be considered largely preparation. As a user of the new organization
>> of things, I am including cpuacct stats functionality in the end of
>> the series. The files related to cpuusage are left to be sent in
>> an upcoming series after this one is included.
>>
>> Let me know if there is anything you'd like me to address.
>>
>
> I'm sorry but let me several questions.
>
> Why cpu cgroup but cpuacct cgroup ?
> If scheduler stat is reported via cpu cgroup, it makes sense.
> If user accounting information is reported via cpu cgroup, I feel it's strange.
> Do you want to make cpuacct cgroup obsolete and merge 2 cgroups ?
>
> What's relationship between this new counters and cpuacct cgroup ?
> Aren't users confused ?
>
> Please provide Documenation.

Hi Kame,

Just so you know, I intend to withdraw this. This idea came from a 
discussion with Peter, where we were thinking about ways to avoid 
collecting statistics more than once, and walking structures more than 
once as well (And cpuusage, for instance, was already collected for the 
task_groups in the scheduler).

Now, Balbir pointed out that the use case for this really needs to keep
the statistics orthogonal to scheduler entities. So with that in mind, 
merging them would complicate things more than it would simplify.

I think I can go back to my original version, where /proc/stat data is 
shown according to data collected in cpuacct.

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
