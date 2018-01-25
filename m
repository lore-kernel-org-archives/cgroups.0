From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH bpf-next] cgroup: support attaching eBPF programs to
 net_prio cgroup
Date: Thu, 25 Jan 2018 23:56:18 +0800
Message-ID: <CALOAHbCpDjivn53-OM2RpOnmm2qFujw23ANnmvCGJvcpnP4DMA@mail.gmail.com>
References: <1516894728-2061-1-git-send-email-laoar.shao@gmail.com> <20180125155029.GG17457@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=zGA4sUjZGLosQGMvhqxRNPVCahe251zNn7N4Mk/2gKs=;
        b=gERac+2N9umTrkQ43VVwgYZPwSqZBJO9WR7TiijhA7Q2vFoXalivuG5WTmCbNqph+S
         6RMBJgBcsOmLiYUNDJfmPKneCFhAzMs2b6rQQpTrX+wkC8x2sPXJgMk5VR/dvkC8qlFu
         IzEm874r05IXuHr45OpdvEWBoziJTjaI8RvAuL6Sna9WfPPmXsfQQ2xpiQ4OlGrdglme
         aVgo+0oD/A2qmFQlX2FzAtmgkMFuVMiJugP/NOw5k83XQ6IAwWoy3evygmlW48ldHBNQ
         g3DU33NdNpHwBv2RSxINlEDZioTp/nHLmaAw6ml1K9liGxTOXvjDojXXHvP0iTexq42K
         dQsA==
In-Reply-To: <20180125155029.GG17457@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, David Miller <davem@davemloft.net>, longman@redhat.com, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Jan 25, 2018 at 11:50 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Jan 25, 2018 at 11:38:48PM +0800, Yafang Shao wrote:
>> If net_prio is used, we could also use eBPF programs to attach it,
>> because the net_prio cgroup could be got with prioidx in struct
>> sock_cgroup_data.
>> Hence it should not only be limited to cgroup2.
>
> I really don't wanna do this.  This comes with all sorts of reverse
> lookup and naming issues.  In addition, cgroup1 and 2 aren't mutually
> exclusive.  If the use case is on cgroup1 and wants to use cgroup bpf
> programs, just replicate the cgroup2 hierarchy for bpf.  Hierarchy
> replication across different controllers is how most use cgroup1 after
> all.  With recent versions of systemd which defaults to using cgroup2
> for process management, you get the replication for free too.
>

Hi Tejun,

I don't understand what do you mean Hierarchy replication.
Could you pls. show me some examples  ?


Thanks
Yafang
