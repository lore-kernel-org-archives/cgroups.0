From: Y Song <ys114321@gmail.com>
Subject: Re: [PATCH] [RFC] bpf: tracing: new helper bpf_get_current_cgroup_ino
Date: Mon, 21 May 2018 17:24:49 -0700
Message-ID: <CAH3MdRWgruVq+3r+2pHTah-c2zTO03vPkepjWDZ0_KrYcroy9A@mail.gmail.com>
References: <20180513173318.21680-1-alban@kinvolk.io> <20180521162609.lpdrnozowmzdn57m@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=EtFhwwEJ8zT2/HaFLJ3JWPH20nX2Hqgi3pE8FXrYWF8=;
        b=SLRANYFGScceu1RQE/OzO8lLSaUlx6AQIRznq4acjMmtur2LIVEMNDE77Yy5nFtQT4
         sc7oAMThH4xMOhxl6Ls7tLvo6jWhQMl1NPbR65ekSsM9Ipkm9UQiZHrjDQX+NNYL4t+d
         JE/hGS7MFIBr7/Bt/Vl+5NVgX3SYizPP5ZajBBQRnG79Dm7iFxouuBjo0aIRrazO7JSc
         sA1+Rz9Xz3zyC+XvFjr3vvmMNFgrA32dKQPndyJcTleaUtYlKWpRIuEeVmYX0+8+pkXT
         x0Vqa2oBXfZyHYiMqHTvqlnhsS+KZJi7sFJTAm8I+aytzQWOxukt/3Galfyuzu6C2hMr
         QGSg==
In-Reply-To: <20180521162609.lpdrnozowmzdn57m@ast-mbp.dhcp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alban Crequy <alban.crequy@gmail.com>, netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, Alban Crequy <alban@kinvolk.io>, tj@kernel.org

On Mon, May 21, 2018 at 9:26 AM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Sun, May 13, 2018 at 07:33:18PM +0200, Alban Crequy wrote:
>>
>> +BPF_CALL_2(bpf_get_current_cgroup_ino, u32, hierarchy, u64, flags)
>> +{
>> +     // TODO: pick the correct hierarchy instead of the mem controller
>> +     struct cgroup *cgrp = task_cgroup(current, memory_cgrp_id);
>> +
>> +     if (unlikely(!cgrp))
>> +             return -EINVAL;
>> +     if (unlikely(hierarchy))
>> +             return -EINVAL;
>> +     if (unlikely(flags))
>> +             return -EINVAL;
>> +
>> +     return cgrp->kn->id.ino;
>
> ino only is not enough to identify cgroup. It needs generation number too.
> I don't quite see how hierarchy and flags can be used in the future.
> Also why limit it to memcg?
>
> How about something like this instead:
>
> BPF_CALL_2(bpf_get_current_cgroup_id)
> {
>         struct cgroup *cgrp = task_dfl_cgroup(current);
>
>         return cgrp->kn->id.id;
> }
> The user space can use fhandle api to get the same 64-bit id.

I think this should work. This will also be useful to bcc as user
space can encode desired id
in the bpf program and compared that id to the current cgroup id, so we can have
cgroup level tracing (esp. stat collection) support. To cope with
cgroup hierarchy, user can use
cgroup-array based approach or explicitly compare against multiple cgroup id's.
