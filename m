From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: Kill the parent controller when its last
 child is killed
Date: Thu, 21 Apr 2022 12:37:46 -1000
Message-ID: <YmHcuuhKYfjI8nXA@slm.duckdns.org>
References: <20220404142535.145975-1-minhquangbui99@gmail.com>
 <Ykss1N/VYX7femqw@slm.duckdns.org>
 <20220405091158.GA13806@blackbody.suse.cz>
 <bdd4104d-390e-74c7-0de1-a275044831a5@gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TGnA1HghBHzaSRRxb3yDXY7uSkV0l4dlxYm07Mzp3eI=;
        b=dFLWUJYXH3dFISAztAecv3Yf1mdemauc2q2OxHs3xuKtNlSr8LppwaIILxfTl/CNyR
         kr3THRthZfoHqEj/5OGLdycki5BRTSoCriRigD1l0TtUqzKqN6uI3LzFSDvVctO3E1RE
         NCAtYPJ4GhVtCp3b/XFDm4PNopKSQONjpmTayoBiOEG7uwfZm/v745lmKWTdqS0mmKGO
         t58jj8zjJLgWKNup0fbSpaSCt5i1Ec+cPtsCYrHiVS3VT5hRArzMIlfGmVnBBqpGcYCJ
         iMwDqG7VnTYEDh46pkMd9Lk8zPW49PsPzUD5sN9IxcfZCtjbqN7VbItpzPg0+jwGmXnc
         PYMA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <bdd4104d-390e-74c7-0de1-a275044831a5@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, kernel test robot <lkp@intel.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

On Tue, Apr 05, 2022 at 09:58:01PM +0700, Bui Quang Minh wrote:
> @@ -5152,12 +5153,28 @@ static void css_release_work_fn(struct work_struct
> *work)
>                 container_of(work, struct cgroup_subsys_state,
> destroy_work);
>         struct cgroup_subsys *ss = css->ss;
>         struct cgroup *cgrp = css->cgroup;
> +       struct cgroup *parent = cgroup_parent(cgrp);
> 
>         mutex_lock(&cgroup_mutex);
> 
>         css->flags |= CSS_RELEASED;
>         list_del_rcu(&css->sibling);
> 
> +       /*
> +        * If parent doesn't have any children, start killing it.
> +        * And don't kill the default root.
> +        */
> +       if (parent && list_empty(&parent->self.children) &&
> +           parent->flags & CGRP_UMOUNT &&
> +           parent != &cgrp_dfl_root.cgrp &&
> +           !percpu_ref_is_dying(&parent->self.refcnt)) {
> +#ifdef CONFIG_CGROUP_BPF
> +               if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
> +                       cgroup_bpf_offline(parent);
> +#endif
> +               percpu_ref_kill(&parent->self.refcnt);
> +       }
> +
>         if (ss) {
>                 /* css release path */
>                 if (!list_empty(&css->rstat_css_node)) {
> 
> The idea is to set a flag in the umount path, in the rmdir it will destroy
> the css in case its direct parent is umounted, no recursive here. This is
> just an incomplete example, we may need to reset that flag when remounting.

I'm generally against adding complexities for this given that it's never
gonna be actually reliable. If adding one liner flush_workqueue makes life
easier in some cases, why not? But the root cause is something which can't
be solved from messing with release / umount paths and something we decided
against supporting.

Thanks.

-- 
tejun
