From: Hao Luo <haoluo@google.com>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Tue, 22 Mar 2022 14:37:38 -0700
Message-ID: <CA+khW7jFSmm5sTyAVfEZhYnKDhVZKRRGLgAmCqgZzgON8NJOGg@mail.gmail.com>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
 <Yi7ULpR70HatVP/8@slm.duckdns.org> <CAJD7tkYGUaeeFMJSWNbdgaoEq=kFTkZzx8Jy1fwWBvt2WEfqAA@mail.gmail.com>
 <f049c2f6-499b-ff7a-3910-38487878606a@fb.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=26rbbh0Rc+t58fCPLrjVyxltmsz2gfaAhKsT3lin0qU=;
        b=E4pneTceurMqMrK/ctTcQD8Ux5MsPoAf7fXe0dR1Vi4+NasJnWwgPDWsS6IXE9SFsC
         K1mTPuhYcB3HpxJ3GEoMt51U3jeaO33AhpL9EhWKpmlv7h+yq2ib41Gzqf2UnxTK9lFe
         lIgfBHrtuhDX/MQbhz14gDLxT4el9mInINuuKPju736gzx84bNf2sCrZElIomNmnijXu
         jxWc82KJL8l2Lt6orpyEBw05omUgb/E4mNF9v8fCam3yWbwaksgIqrexxXEa7F9cbCQ4
         WjouLCEeXkVb0xOFv6iujceESI7xqmeY4d3POejaRm5rslth8ExLDhKZOvTTIpdH6JAd
         3fqA==
In-Reply-To: <f049c2f6-499b-ff7a-3910-38487878606a@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs@fb.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, bpf <bpf@vger.kernel.org>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>

On Tue, Mar 22, 2022 at 11:09 AM Yonghong Song <yhs@fb.com> wrote:
>
> Hi, Yosry, I heard this was discussed in bpf office hour which I
> didn't attend. Could you summarize the conclusion and what is the
> step forward? We also have an internal tool which collects cgroup
> stats and this might help us as well. Thanks!
>

Hi Yonghong,

Yosry is out of office this entire week. I don't know whether he has
access to corp email account, so please allow me to reply on his
behalf.

So instead of using rstat in bpf (by providing a map interface), it's
better to leverage the flexibility provided by bpf to extend rstat.
"We can achieve a similar outcome with a less intrusive design." Yosry
"will look at programs providing their own aggregators and maintaining
their own stats, and only making callbacks to/from rstat." As the next
step, Yosry is going to work on an RFC patchset to drive the
discussion, when he is back.

It's great to see that this is helpful to you as well! I am looking
forward to collaboration if there is a need.

Hao
