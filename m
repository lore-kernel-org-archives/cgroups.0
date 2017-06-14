From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: Make debug controller useful for debugging
Date: Wed, 14 Jun 2017 16:53:20 -0400
Message-ID: <74634035-9740-e000-0cc3-3540e9f6e90d@redhat.com>
References: <20170614200842.15174-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 2ED604DD4B
In-Reply-To: <20170614200842.15174-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 06/14/2017 04:08 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> I dropped the thread mode part of the patches so that these aren't
> blocked on thread mode, made the debug controller an implicit one on
> cgroup2 which is enabled by "cgroup_debug" boot param (we can't mask
> it on cgroup1 with the boot param at this point), and fixed the
> lockdep warnings.
>
> I applied the updated patches + follow up changes to cgroup/for-4.13.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.13
>
> I'd really appreciate if you can go over the patches and check that I
> didn't do anything stupid.
>
> Thanks.
>
> --
> tejun

Thanks for fixing issues in my debug controller patchset. I am fine with
the changes.

Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-Longman
