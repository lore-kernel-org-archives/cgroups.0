From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/cpuset: Add a new isolated
 mems.policy type.
Date: Fri, 23 Sep 2022 09:29:03 +0200
Message-ID: <Yy1gP7wcoCqzRa0B@dhcp22.suse.cz>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
 <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
 <0e5f380b-9201-0f56-9144-ce8449491fc8@bytedance.com>
 <YxXUjvWmZoG9vVNV@dhcp22.suse.cz>
 <ca5e57fd-4699-2cec-b328-3d6bac43c8ef@bytedance.com>
 <Yxc+HZ6rjcR535oN@dhcp22.suse.cz>
 <93d76370-6c43-5560-9a5f-f76a8cc979e0@bytedance.com>
 <YxmXeC7te2HAi4dX@dhcp22.suse.cz>
 <fa5e5a79-aa1a-a009-d0c8-0a39380a71b6@bytedance.com>
 <120cb50d-d617-a60a-ec24-915f826318f1@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663918144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOM18LotnWoAueDS7CKAxKNZg+usqMDivdcE9JRJPBE=;
        b=dVnRMWYNhplQavDtc54h2Ex/j2jYR77RBKGgq9v2Rjc1hmm4joAkkKC8VCpEp/rjz3GJ3D
        E2XRU17CR4X2WBeCgaI2Yt3Emris/lMgFiGkurmrvA65OOPU02Kjg7PUOixpnvsGhUOrLK
        X1I7y+0RI28a/Znu5Spp2d+yb3u9Xq0=
Content-Disposition: inline
In-Reply-To: <120cb50d-d617-a60a-ec24-915f826318f1-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Wed 14-09-22 23:10:47, Zhongkun He wrote:
> > >=20
> > > > Back to the previous question.
> > > > > The question is how to implement that with a sensible semantic.
> > > >=20
> > > > Thanks for your analysis and suggestions.It is really difficult to =
add
> > > > policy directly to cgroup for the hierarchical enforcement. It
> > > > would be a good idea to add pidfd_set_mempolicy.
> > >=20
> > > Are you going to pursue that path?
>=20
> > Hi Michal, thanks for your suggestion and reply.
> >=20
> >  > Are you going to pursue that path?
> >=20
> > Yes=EF=BC=8CI'll give it a try as it makes sense to modify the policy d=
ynamically.
> >=20
> > Thanks.
>=20
> Hi Michal, i have a question about pidfd_set_mempolicy, it would be better
> if you have some suggestions.
>=20
> The task_struct of processes and threads are independent. If we change the
> mempolicy of the process through pidfd_set_mempolicy, the mempolicy of its
> thread will not change. Of course users can set the mempolicy of all thre=
ads
> by iterating through /proc/tgid/task.
>=20
> The question is whether we should override the thread's mempolicy when
> setting the process's mempolicy.
>=20
> There are two options:
> A:Change the process's mempolicy and set that mempolicy to all it's threa=
ds.
> B:Only change the process's mempolicy in kernel. The mempolicy of the thr=
ead
> needs to be modified by the user through pidfd_set_mempolicy in
> userspace, if necessary.

set_mempolicy is a per task_struct operation and so should be pidfd
based API as well. If somebody requires a per-thread-group setting then
the whole group should be iterated. I do not think we have any
precendence where pidfd operation on the thread group leader has side
effects on other threads as well.
--=20
Michal Hocko
SUSE Labs
