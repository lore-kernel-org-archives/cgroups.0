From: Muhammad Usama Anjum <usama.anjum-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH v11 8/8] kselftest/cgroup: Add cpuset v2 partition root
 state test
Date: Sat, 21 May 2022 15:24:59 +0500
Message-ID: <0ede5fe6-89c8-5e63-0c0c-265b57ea5ca6@collabora.com>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-9-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1653128707;
        bh=lBOnXIC7rDI/XGVOI25lydeYhAWS63MlMY/nx5UGlLI=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=GkT6VGFso/wL6JhQo1/m7n2V+8gVKfvw5W0OgrXT76T7QVQmHpDTwOcb44zavI/QJ
         PWBMDkcVjAxMH0VyLou7Kz+dQ6lMdHBL83AgFO2KfLX84ZYZdfPhIt4s47ZiHgXZAy
         AMRnl9hLLfnO8pVa+uiZAosCmNIvu61yMgGkDmxXvAbFKseL09c9OMyeBSica2i2fC
         z7OucM+WeBD4zQPxkwuBrTibedhPZl8tkvPwW9mrw/t4DuAasHb4qfy5zti2Hex0q9
         nDsiDOOHd4xgYQiaIT5i3sSovhAxKSpd1HemtYndb75Evx/5Z7QBIYlYt43nsfIfXN
         jfVw0HiauCLLw==
Content-Language: en-US
In-Reply-To: <20220510153413.400020-9-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: usama.anjum-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 5/10/22 8:34 PM, Waiman Long wrote:
> diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
> index 745fe25fa0b9..01687418b92f 100644
> --- a/tools/testing/selftests/cgroup/Makefile
> +++ b/tools/testing/selftests/cgroup/Makefile
> @@ -1,10 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0
>  CFLAGS += -Wall -pthread
>  
> -all:
> +all: ${HELPER_PROGS}
>  
>  TEST_FILES     := with_stress.sh
> -TEST_PROGS     := test_stress.sh
> +TEST_PROGS     := test_stress.sh test_cpuset_prs.sh
> +TEST_GEN_FILES := wait_inotify
Please add wait_inotify to .gitignore file.

>  TEST_GEN_PROGS = test_memcontrol
>  TEST_GEN_PROGS += test_kmem
>  TEST_GEN_PROGS += test_core

-- 
Muhammad Usama Anjum
