From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] sched/isolation: Merge individual nohz_full features
 into a common housekeeping flag
Date: Tue, 7 Feb 2023 10:21:35 -0500
Message-ID: <a264c69a-8dd9-3724-bfc8-97c60b45630b@redhat.com>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-2-frederic@kernel.org>
 <20230206155107.GA31453@blackbody.suse.cz> <Y+I61dp5qPkWK4s2@lothringen>
 <20230207125900.GA24523@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675783300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mcb+6eBv4ysUkvKYOCW9Qw2SLWinzQcLfFwr3z2U8Vw=;
        b=WgZhleChQd756gVgKwwOUo+OZyUMwxK6aPE7H5t7VW+zmlFauCsb/U71XskXe0VI6tVhUk
        M7JdNAgWlNi6n6jCC5E9nBVbruyHE47+LmdfL4pxLRGAeYuuS+opZz/WcemXN2J/4VB8JC
        k2Bx+4rqIMOi+E69nDKLPwPUgqUjsrE=
Content-Language: en-US
In-Reply-To: <20230207125900.GA24523-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 2/7/23 07:59, Michal Koutn=C3=BD wrote:
> On Tue, Feb 07, 2023 at 12:49:41PM +0100, Frederic Weisbecker <frederic-D=
gEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> But what do we need these annotations for? The only outcome I've ever
>> seen with these is that it confuses everyone.
> Take that as a note of a lone actor then who found it useful documenting
> relations between various parts of the code.
>
>> This way I can add the support for each part smoothly.
> Yeah, that makes sense.
>
>> For example first patch moves HK_TYPE_TIMER to HK_TYPE_KERNEL_NOISE
>> and unbound timers are supported by cpuset.kernel_noise, second patch
>> moves HK_TYPE_WQ to HK_TYPE_KERNEL_NOISE and unbound workqueues are
>> supported by cpuset.kernel_noise, etc until all of them turned by
>> nohz_full=3D are supported...
> So does this mean you'll re-introduce the finer grained HK_* flags
> again?
>
> The idea (not only mine?) is that this would extend
> cpuset.cpus.partition that only allows HK_TYPE_DOMAIN analogy. The
> mapping to individual flags may not be exposed to users. The graduality
> could be achieved by adding more flags under user_exposed_term.
>
> Just to be on the same page -- that's how I understand it, the original
> HK_* resolution turned out impractical for users and that's why the
> direction is towards some loose combinations representing user
> intentions. Is that right?

What I am envisioning is to have additional isolation attributes to an=20
isolated partition that correspond to what a user can specify on the=20
kernel command line today. That requires the minimal amount of learning=20
from the user community. Any finer grained separation of isolation=20
features will just confuse user. I don't see a problem with a generic=20
HK_TYPE_KERNEL_NOISE that gets enabled when an attribute that correspond=20
to nohz_full is used.

Cheers,
Longman

