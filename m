From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/9] memcg accounting from OpenVZ
Date: Wed, 10 Mar 2021 13:17:19 +0300
Message-ID: <ad68d004-fa84-3d21-60b7-d4a342ad4007@virtuozzo.com>
References: <5affff71-e503-9fb9-50cb-f6d48286dd52@virtuozzo.com>
 <CALvZod5YOtqXcSqn2Zj2Nb_SKgDRKOMW4o5i-u_yj7CanQVtGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j7T74Ki28KSvdMiQAt3HSWqcxK14Ic+rNrs/T4XFHY=;
 b=QM6+pwg3BjIJtkQEMbR8FpAmbmDqFZf+n8nCk6cgHHHfmFE5hPQsDIAIyXelsNYfUSPyE/8J6IMSK56aMaRTY49wsZJdBF3xeik1aJd+bN7qo59oOvwP/cfRPgeT6C/nM99xttpcqBN3/AMYYQwQxxAquZ0EiWnC47JzvCXRzIo=
In-Reply-To: <CALvZod5YOtqXcSqn2Zj2Nb_SKgDRKOMW4o5i-u_yj7CanQVtGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 3/10/21 12:12 AM, Shakeel Butt wrote:
> On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>>
>> OpenVZ many years accounted memory of few kernel objects,
>> this helps us to prevent host memory abuse from inside memcg-limited container.
>>
> 
> The text is cryptic but I am assuming you wanted to say that OpenVZ
> has remained on a kernel which was still on opt-out kmem accounting
> i.e. <4.5. Now OpenVZ wants to move to a newer kernel and thus these
> patches are needed, right?

Something like this.
Frankly speaking I badly understand which arguments should I provide to upstream
to enable accounting for some new king of objects.

OpenVZ used own accounting subsystem since 2001 (i.e. since v2.2.x linux kernels) 
and we have accounted all required kernel objects by using our own patches.
When memcg was added to upstream Vladimir Davydov added accounting of some objects
to upstream but did not skipped another ones.
Now OpenVZ uses RHEL7-based kernels with cgroup v1 in production, and we still account
"skipped" objects by our own patches just because we accounted such objects before.
We're working on rebase to new kernels and we prefer to push our old patches to upstream. 

Thank you,
	Vasily Averin
