From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next 6/9] cgroup: add v1 support to
 cgroup_get_from_id()
Date: Tue, 10 May 2022 08:33:58 -1000
Message-ID: <YnqwFuhncWiR3rjq@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-7-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cc7nynWlTk1v/xeUbUkmBnrl/rco57CYRTC5cF6QRvc=;
        b=ogrxbrE8ZkyEP865XaKeZApT2CTGltGBi0Vn3SjMIm99uiYupCY8gK/f1B3ohxg9x1
         JSJgV/L6tSEGJim3zIdU7dop2a7pHqN08UOaW4+urgBuwgVH8xuJ9SfwdKsCz+rD8b1a
         HfJExzyJErTjM0LmDUoXxY13aDo0oRdzb9zPwfRB6u9NX/CEOLQeg22MV9dpngtqYiH9
         wsKy9Jn2XX4AMtMPpvLQrnpbxyF/D0bypA6cbvkrPGTQ1V01yE19gGiuGerv4FlW0Qrz
         ikmq22DzzUaj8R81SQ2yUAfmuNd5Ht+Q9DHOqiEPtmRIOaKUk9FvCNFpZu17NDO4e4Bg
         HcYQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220510001807.4132027-7-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org

On Tue, May 10, 2022 at 12:18:04AM +0000, Yosry Ahmed wrote:
> The current implementation of cgroup_get_from_id() only searches the
> default hierarchy for the given id. Make it compatible with cgroup v1 by
> looking through all the roots instead.
> 
> cgrp_dfl_root should be the first element in the list so there shouldn't
> be a performance impact for cgroup v2 users (in the case of a valid id).
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  kernel/cgroup/cgroup.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index af703cfcb9d2..12700cd21973 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5970,10 +5970,16 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
>   */
>  struct cgroup *cgroup_get_from_id(u64 id)
>  {
> -	struct kernfs_node *kn;
> +	struct kernfs_node *kn = NULL;
>  	struct cgroup *cgrp = NULL;
> +	struct cgroup_root *root;
> +
> +	for_each_root(root) {
> +		kn = kernfs_find_and_get_node_by_id(root->kf_root, id);
> +		if (kn)
> +			break;
> +	}

I can't see how this can work. You're smashing together separate namespaces
and the same IDs can exist across multiple of these hierarchies. You'd need
a bigger surgery to make this work for cgroup1 which would prolly involve
complications around 32bit ino's and file handle support too, which I'm not
likely to ack, so please give it up on adding these things to cgroup1.

Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
