From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: a u16 is enough for cgroup_subsys.depends_on
Date: Mon, 4 Oct 2021 06:30:22 -1000
Message-ID: <YVssHgmGdoSBY59K@slm.duckdns.org>
References: <20211004084928.17622-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U/gXY3WVhJ/nvDWWVPhBXPgTxuRKJcOBX7y2RATu4k8=;
        b=nR6cs3n/l5GebOuqrwwoUW8Dmv4Uc+aROASi3zE11rcVXU1dWmmNeMTupCOCJmZ2yg
         bCsK8eKbgKW+xIniwvS78xovucXVVspEDrSlHfqTN3OcVHUna5sWqwWnzIbiM4b1rFBd
         7Rt80oTFJzJOIJBTdNuy8ic4ni/iaUbFHiL8q65mBDms2v/sarrtifDmWD8cd35OgAUg
         dVHxcZs546XIATLMQPb2SlTihIkmqAdHoPAU0e41QEUZU5+IasQLSk1zSGY5gV0SLz+k
         f5btrkA1jNoEMq+Ot1Yb98AMq2fAP5uvZEQSYUHQ1lxAwONKJMf5Kazw2FTm+wJaKFyr
         k8ig==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211004084928.17622-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 04, 2021 at 08:49:25AM +0000, Wei Yang wrote:
> After commit 6e5c830770f9 ("cgroup: make cgroup subsystem masks u16"),
> we limit the number of subsystem to be less then 16. This applies to
> cgroup_subsys.depends_on too.

None of the patches seems meaningful enough. I'm gonna ignore this series.

Thanks.

-- 
tejun
