From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Potential documentation error for cpuacct
Date: Sun, 16 Nov 2014 10:09:34 +0530
Message-ID: <CAKTCnzky8QKpK04BA3f-SCWqQCY_Jyp3pg6D9r_Y+PVzqcJnHg@mail.gmail.com>
References: <CAFow3A9jryRRctZHdp+YHBiMT1Uh0R2xq_of7+7M2cbm59WfpA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=proOeIKtsOAjvosrFJICEVcMx5Nhr7OmTTfD7XKY9hg=;
        b=Mf9CTYXWAF/nILbtnD7dAC+xyickCqlkYNL8rKMJh6BdWfbDgbxOqshpfyZlloBaxk
         si31IO581HqjwIsEq+oFz5MRsr54xdkcMm9CiuFYDT2nGCO9/aml1CozHslxI7NbtHCm
         qtkdBOdfDPEpCIvPmLJN3gTm2Qbr7+MHIVUjsdRHcKHlkUN975tH8cfG1wrJG1Ap0fgn
         /7g23IEIOLX5Wy/qknyURZGM95FzgYj/7LP9bBWo7BUCpMujx+YpxzC7l93UcfyoVbNk
         0Dn+aea/H5o2VdDXmkqAzs93YzaKYvBYxOZ4zzmZdi6QmOrmfm2yOHweaIcdbACcEILi
         +/xA==
In-Reply-To: <CAFow3A9jryRRctZHdp+YHBiMT1Uh0R2xq_of7+7M2cbm59WfpA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hamilton Turner <hamiltont-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Nov 16, 2014 at 1:44 AM, Hamilton Turner <hamiltont-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I see a discrepancy between my system and the documentation at
> https://www.kernel.org/doc/Documentation/cgroups/cpuacct.txt
>
> Specifically, the references in the following paragraph to
> /sys/fs/cgroup appear to be incorrect on my system, and should instead
> be references to /sys/fs/cgroup/cpuacct
>
> Doc:
>
> New accounting groups can be created under the parent group /sys/fs/cgroup.
>
> # cd /sys/fs/cgroup
> # mkdir g1
> # echo $$ > g1/tasks
>
> The above steps create a new group g1 and move the current shell
> process (bash) into it. CPU time consumed by this bash and its children
> can be obtained from g1/cpuacct.usage and the same is accumulated in
> /sys/fs/cgroup/cpuacct.usage also.

Looks like a documentation bug, do send in a patch to fix it

Balbir Singh.
