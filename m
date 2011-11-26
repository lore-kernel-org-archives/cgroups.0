From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/4] Move part of cpuacct code
Date: Sat, 26 Nov 2011 18:17:33 -0200
Message-ID: <4ED1495D.1090500@parallels.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com> <1322184806-20421-4-git-send-email-glommer@parallels.com> <CAPM31RJoN2t+nUuap+FWLYoEx=EshU=v6Gy8JsxJAaichZFjcA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31RJoN2t+nUuap+FWLYoEx=EshU=v6Gy8JsxJAaichZFjcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 11/26/2011 11:21 AM, Paul Turner wrote:
> On Thu, Nov 24, 2011 at 5:33 PM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>> This patch is just a preparation patch for the next one in the series.
>> It moves the cpuacct structure definition and some helper functions early
>> in the file so we can access its members from here on.
>>
>> Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Paul Tuner<pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> CC: Peter Zijlstra<a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
>> ---
>>   kernel/sched.c |   77 +++++++++++++++++++++++++++----------------------------
>>   1 files changed, 38 insertions(+), 39 deletions(-)
>
> Bad news -- You've run afoul of a massive file re-structuring conflict :(
>
> All of sched has been refactored under "kernel/sched/"; sched.c and
> friends don't exist anymore.
>
> - Paul

can you tell me where this lives? This does not seem to be the case in 
any of my git trees here (just fetched, including your sched.git/master 
at kernel.org)

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
