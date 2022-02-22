From: Tejun Heo <tj@kernel.org>
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
Date: Tue, 22 Feb 2022 08:23:43 -1000
Message-ID: <YhUqLxR9o5UGVlTx@slm.duckdns.org>
References: <000000000000264b2a05d44bca80@google.com>
 <0000000000008f71e305d89070bb@google.com>
 <YhUc10UcAmot1AJK@slm.duckdns.org>
 <a1baa10e-2c73-1fdd-0228-820310455dd5@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XRY9BTtFDMjGt0LGbkNbt6s2IHGP2Dl3/GtZArqDt6M=;
        b=k4TDZhxO4zLnuGpfptc8tcXjeITKastU4t7LEphduxxMVQfj0PMC26Gzd50CTdJmK9
         Hk75f7bRkkezokkuF3CPaFr94vo0zuEVtktH/VPQCDDwH4b41nUn1OhcAhnVMOSuLjdD
         44ewS/IApkmNBq5DjQfE9aC7COY/oCs5EsqzYtjs495XG94VueQzaqp+F5Y6aejdcC+T
         cCyo12yrjvvi8PnV3y6S/3xM4zI9JwotFpF2Hifl9ddUktBezeqpxRDfbsPW8kiHnxQG
         /MSIAOECD7C4YXWqMCKanL2EcvGUxSapnk0NX2Vo3HNddunUS30T0vxEbXXVuMQ+Tesc
         hkAQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <a1baa10e-2c73-1fdd-0228-820310455dd5@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: syzbot <syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, lizefan.x@bytedance.com, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Tue, Feb 22, 2022 at 01:22:13PM -0500, Waiman Long wrote:
> My preliminary analysis is that the warning may be caused by my commit
> 1f1562fcd04a ("cgroup/cpuset: Don't let child cpusets restrict parent in
> default hierarchy") since the merge branch e5313968c41b is missing the fix
> commit d068eebbd482 ("cgroup/cpuset: Make child cpusets restrict parents on
> v1 hierarchy"). I believe the problem should be gone once the merge branch
> is updated to a later upstream baseline.

Fantastic. Thank you so much for taking a look.

-- 
tejun
