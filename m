From: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [cgroup] 3c87862ca1:
 WARNING:at_kernel/softirq.c:#__local_bh_enable_ip
Date: Thu, 9 Jun 2022 07:30:41 -0700
Message-ID: <b39cdb9c-aa2a-0f49-318b-8632b2989433@linaro.org>
References: <20220609085641.GB17678@xsang-OptiPlex-9020>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f3+B3/4f/EYX1WyHVwNor7M5aRUmp3PSGvyyEnFuqik=;
        b=Uf0gZWDEqsfPzDO/WoOCeZ9zDaQpoG7mpw39fhVrNd4PT36eVUs/AWQRnJc1PGQy6z
         MxJsCavq8e0r4QA2C5/DW163OyruGXogIMjLQqO9hOiXLcO9KAdDyetG2+YKxTQhKLEs
         2Z2d8kh+Z+YW308jK/76QcgUk6kjZDzT2Hb++SdFAaMfqm1xGDHP/BHFdd3FUq7HYUxE
         8N59xPbFsSOX7aqE9KZ3G0JG1v++Eu9VcU+yovBX8rENqdxOXtKpG9kuVkCEfUv35Ylq
         93P03ULGNI5XIOFC8wrJz30QYpAsVBQrYnTwXdh5W3ycKKateO+O5A+JJHeMY2GkmYv8
         FX2Q==
Content-Language: en-US
In-Reply-To: <20220609085641.GB17678@xsang-OptiPlex-9020>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 0day robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+e42ae441c3b10acf9e9d-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 6/9/22 01:56, kernel test robot wrote:
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: 3c87862ca13147416d900cf82ca56bb2f23910bf ("[PATCH v2] cgroup: serialize css kill and release paths")
> url:https://github.com/intel-lab-lkp/linux/commits/Tadeusz-Struk/cgroup-serialize-css-kill-and-release-paths/20220606-014132
> base:https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git  for-next
> patch link:https://lore.kernel.org/netdev/20220603181321.443716-1-tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
> 
> in testcase: boot
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot<oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> 
> [ 55.821003][ C1] WARNING: CPU: 1 PID: 1 at kernel/softirq.c:363 __local_bh_enable_ip (kernel/softirq.c:363)

Looks like that will need to be spin_lock_irq(&css->lock) instead of spin_lock_bh(&css->lock)
I can respin the patch, but I would like to request some feedback on it first.

Tejun, Michal
Are you interested in fixing this at syzbot issue all? Do you have any more feedback on this?

-- 
Thanks,
Tadeusz
