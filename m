From: "Chris Murphy" <lists-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>
Subject: Re: oomd with 6.0-rc1 has ridiculously high memory pressure stats wit
Date: Tue, 23 Aug 2022 14:39:37 -0400
Message-ID: <9412f39b-9ec1-4542-944c-19577a358b97@www.fastmail.com>
References: <d0df567c-1f6a-418d-8db7-3f777bd109c8@www.fastmail.com>
 <YwUcGvE/rhHEZ+KO@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        colorremedies.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1661280051; x=
        1661283651; bh=qvny2MgkE8/C3PWUD0tDtZJxNolLM559Kqa+QIqtMUA=; b=K
        7w6Xowcj/wsqu3/e8ZORXa7EepCuFIrI8RdqNPyhFAeFj2KPChPOHkSv+nQEbjZS
        kWlmyF6JVr8dLUD9EuNBTJ6yuC2tRZjPWO/dGJnDE33cx6LUCchdzpIt/T8sUdUh
        0czgjEHEaGBB50ylU1/Hg7ZQs7S3LKEXTILGoSUBA7pND+Ve/XOR4xZ1pjieRizs
        a1PLAnVq3DFuTqayxSBLcjSesDccXfoqJ5HkhvxMeVy04rzdN2tWXkMc6iP2eHJx
        Yg9VXGxmci2zSaxF1+b3RUiWLLRRi6L9+gZJC9C8i7fuSpsaCZ7sr4Ifch8/Qyy9
        Oks++rIrYzJwtMANGK+RA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661280051; x=1661283651; bh=qvny2MgkE8/C3PWUD0tDtZJxNolL
        M559Kqa+QIqtMUA=; b=TLEmUb3YwzgEamXl3Z8ym66biGkJJLOkC466v7hdLvzm
        /fQ1q6rlVmBmVIFhmbt13bOLk3Z4bWnub8SRrWEaAWTvlUVeMFCuISVCMmEqIfOT
        7Ixbb43rRBiarFhkPYQCVewFp4b8Z8OkBxBjKl9/Irs5O8fqRJ+R6c629j8ufxVc
        bxArl9pGQN3T31choEzxZKg80aTNOYu+FHb0RlgzGleu8QrQLPSihxEQN+gue8Vj
        xpmn/qdG0OTgfMb20M3NnUYi/uTH8omNewZuzuW4+5/x2jgZzthxrObldPqRxGDK
        w7QbO6vOfpwqmD+KlMwjZfmbLopIDJnbifZRgJiD1g==
In-Reply-To: <YwUcGvE/rhHEZ+KO-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Another example,  with 6.0-rc2:

# oomctl
Dry Run: no
Swap Used Limit: 90.00%
Default Memory Pressure Limit: 60.00%
Default Memory Pressure Duration: 20s
System Context:
        Memory: Used: 1.7G Total: 3.8G
        Swap: Used: 0B Total: 3.8G
Swap Monitored CGroups:
        Path: /
                Swap Usage: (see System Context)
Memory Pressure Monitored CGroups:
        Path: /user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org
                Memory Pressure Limit: 50.00%
                Pressure: Avg10: 0.00 Avg60: 0.00 Avg300: 0.10 Total: 140y 3month 18h 24min 20s
                Current Memory Usage: 1.5G
                Memory Min: 250.0M
                Memory Low: 0B
                Pgscan: 0
                Last Pgscan: 0
# cat /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/memory.pressure
some avg10=0.00 avg60=0.00 avg300=0.18 total=8367757640799118
full avg10=0.00 avg60=0.00 avg300=0.07 total=4426019660641432

# grep -R . /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/
https://drive.google.com/file/d/1Ro6rKnEx1CCapmO3rz6SDysjP1Bs4_Re/view?usp=sharing 

Actual uptime is ~10 minutes.

-- 
Chris Murphy
