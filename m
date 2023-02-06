From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/isolation: Add cpu_is_isolated() API
Date: Mon, 6 Feb 2023 11:50:11 -0500
Message-ID: <c6bd487d-1436-66f7-ed2a-8679303ad9b5@redhat.com>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-3-frederic@kernel.org>
 <0f388863-9498-e61e-e2dc-965654544489@redhat.com>
 <20230206154710.GC21332@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675702217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yVEU5w2/bUVcxkdB59nbmmH1xHTXkQRMgUkXR85IDjQ=;
        b=jEP6v2tr7GEBa58iTVb2HkcghJ83ecAkknUsjvHgp+LX3tXzv+GG5CWK3wSCzaHVyzFTyT
        v1rU+5fvUh98ddhk42P+q2nL0d4Acf6g4Y9SGbYgWhcBr4hr6OAdaOEZOnCDD4HpGjQ3ee
        O0oWRMI7xDoSdkQTMDMLOvfI3u/A0SU=
Content-Language: en-US
In-Reply-To: <20230206154710.GC21332-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 2/6/23 10:47, Michal Koutn=C3=BD wrote:
> Hello.
>
> On Fri, Feb 03, 2023 at 10:53:46PM -0500, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> CPUs in an isolated cpuset partition is similar to HK_TYPE_DOMAIN CPUs as
>> load balancing is disabled. I can add an API to access the cpumask and a=
dd
>> to this API. However, that list is dynamic as it can be changed at run t=
ime.
>> Will that be a problem?
> I can see a problem already -- as a CPU can be dynamically switched to
> "isolated" mode so should all dependent operations support that (switch)
> too, i.e. the CPUs local PCP caches would have to be drained when the
> CPU enters isolation.
I see the long term goal is to have more isolation capability to be done=20
dynamically. However, we are not there yet. There is still a lot of work=20
to do to achieve that.
>
>> Or should that be used separately?
> It'd be nice to have both (cpuset and cmdline flags) eventually unified.
>
> Alas, it only leads me conservatively to:
>
> #ifndef CONFIG_CPUSETS
> // the proposed implementaion
> else
> static inline bool cpu_is_isolated(int cpu) {
> 	return true;
> }
> #endif

That is too conservative from my point of view. We can have further=20
discussion when a patch is ready.

Cheers,
Longman

