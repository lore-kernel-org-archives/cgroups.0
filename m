From: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/cpuset: Add a new isolated
 mems.policy type.
Date: Wed, 14 Sep 2022 23:10:47 +0800
Message-ID: <120cb50d-d617-a60a-ec24-915f826318f1@bytedance.com>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
 <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
 <0e5f380b-9201-0f56-9144-ce8449491fc8@bytedance.com>
 <YxXUjvWmZoG9vVNV@dhcp22.suse.cz>
 <ca5e57fd-4699-2cec-b328-3d6bac43c8ef@bytedance.com>
 <Yxc+HZ6rjcR535oN@dhcp22.suse.cz>
 <93d76370-6c43-5560-9a5f-f76a8cc979e0@bytedance.com>
 <YxmXeC7te2HAi4dX@dhcp22.suse.cz>
 <fa5e5a79-aa1a-a009-d0c8-0a39380a71b6@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=xZSx75ilZmaUEZs6zH1DDH3DLY7hAQRgTpb/P4DWJZM=;
        b=jOiWuFpGnmyoC1VrTOuCdvPFzUYz84CfKFS2G8Ov0tzdE5aMxCQmvShalFAKGmOa5b
         PwEeGBJo+8m8aKNIVdLeUIZf4QNLqxG9sVmToF537m5YQI+9yxTajGGC86wBj5XXdX5Y
         D6kvOz5a7bWmhcmr/U36whNSDZExbYZh36NvwRPbjk07eY41Xo99eG1d6SDhty/chEjI
         z+o3OeGVhCaGONt3Em6JYVoqo784254Lg9IMsUzfOIWNBIfgUvkwfQRjWevx9u6APFR3
         f462PkUEv/kkGstRvWSsGOvuYyTLcUrNCOYZwHyV4JCGZPWpAK8bcLXzs1OgfAeBIceL
         Oc9g==
In-Reply-To: <fa5e5a79-aa1a-a009-d0c8-0a39380a71b6-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

>>
>>> Back to the previous question.
>>>> The question is how to implement that with a sensible semantic.
>>>
>>> Thanks for your analysis and suggestions.It is really difficult to add
>>> policy directly to cgroup for the hierarchical enforcement. It would=20
>>> be a good idea to add pidfd_set_mempolicy.
>>
>> Are you going to pursue that path?

> Hi Michal, thanks for your suggestion and reply.
>=20
>  > Are you going to pursue that path?
>=20
> Yes=EF=BC=8CI'll give it a try as it makes sense to modify the policy dyn=
amically.
>=20
> Thanks.

Hi Michal, i have a question about pidfd_set_mempolicy, it would be=20
better if you have some suggestions.

The task_struct of processes and threads are independent. If we change=20
the mempolicy of the process through pidfd_set_mempolicy, the mempolicy=20
of its thread will not change. Of course users can set the mempolicy of=20
all threads by iterating through /proc/tgid/task.

The question is whether we should override the thread's mempolicy when=20
setting the process's mempolicy.

There are two options:
A:Change the process's mempolicy and set that mempolicy to all it's threads.
B:Only change the process's mempolicy in kernel. The mempolicy of the=20
thread needs to be modified by the user through pidfd_set_mempolicy in
userspace, if necessary.

Thanks.
