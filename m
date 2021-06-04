From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Fri, 4 Jun 2021 12:51:00 +0100
Message-ID: <YLoTpLnmiIKBzpfh@chrisdown.name>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
 <CALvZod4SoCS6ym8ELTxWd6UwzUp8m_UUdw7oApAhW2WRq0BXqw@mail.gmail.com>
 <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg@mail.gmail.com>
 <YLZIBpJFkKNBCg2X@chrisdown.name>
 <CACZOiM21STLrZgcnEwm8w2t82Qj3Ohy-BGbD5u62gTn=z4X3Lw@mail.gmail.com>
 <CALvZod7w1tzxvYCP54KHEo=k=qUd02UTkr+1+b5rTdn-tJt45w@mail.gmail.com>
 <CACZOiM3g6GhJgXurMPeE3A7zO8eUhoUPyUvyT3p2Kw98WkX8+g@mail.gmail.com>
 <YLi/UeS71mk12VZ3@chrisdown.name>
 <CACZOiM03toiqcbtEd8LT26T2GtPsDaFj89o8rjEfELTw=KPvfg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nmP5AGQDJHyblHijhBlqQ7scqZzB+IznwgL38+TeSNM=;
        b=ZAlxWVBtcKxrDjkMXih764aGrC3O08Yb/bplxtTlgEtkni/fyJgyzoe3B8nvwoL2kj
         +4EaZPbiAzOhyGJyPs+QB3gqOY/lA5qhbBXOyrYwKIV16Taqm4Qfi6/spb3pKc255DS4
         rmhTOzbc725b2O8qU5ltrkbJWQRadCm5lQl60=
Content-Disposition: inline
In-Reply-To: <CACZOiM03toiqcbtEd8LT26T2GtPsDaFj89o8rjEfELTw=KPvfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

yulei zhang writes:
>> Having a speed throttle is a very primitive knob: it's hard to know what the
>> correct values are for a user. That's one of the reasons why we've moved away
>> from that kind of tunable for blkio.
>>
>> Ultimately, if you want work-conserving behaviour, why not use memory.low?
>
>Thanks. But currently low and high are for cgroup v2 setting, do you
>think we'd better
>extend the same mechanism to cgroup v1?

The cgroup v1 interface is frozen and in pure maintenance mode -- we're not 
adding new features there and haven't done so for some time.
