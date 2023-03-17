From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup/cpuset: Find another usable CPU if none found
 in current cpuset
Date: Fri, 17 Mar 2023 10:59:26 -0400
Message-ID: <ca664da8-0f47-06b2-a94c-82b2f9a1c3aa@redhat.com>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-4-longman@redhat.com>
 <20230314181749.5b4k6selbgdhl3up@blackpad>
 <58a1a878-fa0b-285d-3e43-2b5103d3c770@redhat.com>
 <20230317122708.ax3m2d4zijkfdzjq@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679065171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4YPRVQy+Pd/j5om95dzW9EJX+zmYVWMbcmqZaHwhRU0=;
        b=Ok0CnKCqWcsJfnL7/VQm9SoCtuTLNlATdzr2ekL976mb6aSaEToWt9VWS266RySk1Mocws
        b5IQ+7Z+uu/kpzGv2sI7aavgm3e2e6mJx8lic6vRro74z++v+k5lWivoG8pL6kcSRus46D
        vWdBPBJn3amAHFQ50nvU92inAT90e34=
Content-Language: en-US
In-Reply-To: <20230317122708.ax3m2d4zijkfdzjq@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 3/17/23 08:27, Michal Koutn=C3=BD wrote:
> On Tue, Mar 14, 2023 at 04:22:06PM -0400, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> Some arm64 systems can have asymmetric CPUs where certain tasks are only
>> runnable on a selected subset of CPUs.
> Ah, I'm catching up.
>
>> This information is not captured in the cpuset. As a result,
>> task_cpu_possible_mask() may return a mask that have no overlap with
>> effective_cpus causing new_cpus to become empty.
> I can see that historically, there was an approach of terminating
> unaccomodable tasks:
>     94f9c00f6460 ("arm64: Remove logic to kill 32-bit tasks on 64-bit-onl=
y cores")
> the removal of killing had been made possible with
>     df950811f4a8 ("arm64: Prevent offlining first CPU with 32-bit EL0 on =
mismatched system").
>
> That gives two other alternatives to affinity modification:
> 2) kill such tasks (not unlike OOM upon memory.max reduction),
> 3) reject cpuset reduction (violates cgroup v2 delegation).
>
> What do you think about 2)?

Yes, killing it is one possible solution.

(3) doesn't work if the affinity change is due to hot cpu removal. So=20
that leaves this patch or (2) as the only alternative. I would like to=20
hear what Will and Tejun thinks about it.

I am going to remove this patch from the series for the time being.

Thanks,
Longman

