From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v2] memcg: notify about global mem_cgroup_id space
 depletion
Date: Mon, 27 Jun 2022 09:49:18 +0300
Message-ID: <f3e4059c-69ea-eccd-a22f-9f6c6780f33a@openvz.org>
References: <Yre8tNUY8vBrO0yl@castle>
 <97bed1fd-f230-c2ea-1cb6-8230825a9a64@openvz.org>
 <CAMZfGtWQEFmyuDngPfg59D-+b9sf58m9qhGoVPSQ_jAGmgT+sg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jB9gmLMPTj46OngTeaDoiv6CEvUyIMLR8V7jwVzji04=;
        b=FC6ETplDrOSrvKwinUtNxD54YXyc1Tqr5kU/AHTxIqhiecrK8dLL0Buj583oTUDfBT
         x32T5x0pbVTqQwo0kPnIYpBqjx0tbwH8f74480tzNPj24NqzVX2kNKUl8IHxJ2zlTe8A
         9zWG0tXAmmNpmy2F3QDERfa/yKDcFuoCGv6w5yZOO/bTPCozu4QLFDUf0MK1/1FPa3In
         wO6R725pJJ7Z3OlOeABc1wL+pdv/CcmXNVMce062QhR0ur3HPu0RHKTP4bh+bgfxh/Jx
         IZCgDPgOcn6Mq+i+OAIznu6URXW/rdI3w0X8dJT3x9miytTnfhAD6sj3hihCmxXJHx+Q
         ZRIQ==
Content-Language: en-US
In-Reply-To: <CAMZfGtWQEFmyuDngPfg59D-+b9sf58m9qhGoVPSQ_jAGmgT+sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 6/27/22 06:23, Muchun Song wrote:
> If the caller can know -ENOSPC is returned by mkdir(), then I
> think the user (perhaps systemd) is the best place to throw out the
> error message instead of in the kernel log. Right?

Such an incident may occur inside the container.
OpenVZ nodes can host 300-400 containers, and the host admin cannot
monitor guest logs. the dmesg message is necessary to inform the host
owner that the global limit has been reached, otherwise he can
continue to believe that there are no problems on the node.

Thank you,
	Vasily Averin
