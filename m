From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH -next 3/4] cgroup: bpf: Add bpf_skb_in_cgroup_proto
Date: Tue, 21 Jun 2016 18:15:13 -0700
Message-ID: <20160622011511.GA97149@ast-mbp.thefacebook.com>
References: <1466555002-1316296-1-git-send-email-kafai@fb.com>
 <1466555002-1316296-4-git-send-email-kafai@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ec771UXu8uT92Ys/kf8I5g5ofxEGrriqO0YKSoCQ8Es=;
        b=Hy+lfnbTneW26bmW4ySifOc4QMVCTfp4hVl4gVtmJAIGJA1Y+5eLgY/L84zQDM4FAc
         PYDCKJujkUf1eHgPNcC6lnYlDWNLL3U+OtQ4pW8WGC1gxjkd+MvR5U8hWGP/yvtP3noE
         vtCSLUZDVXKNombE4i7dvbDuwCCoubX87RQ6yCstlQ0BqNNWvMF1VcB9UA7eHL1WXx2z
         oCJHw0frpnytgRbSBeSo0NKbYlw0dBddu3X8V1uYG2g1YFX85BMgG6z2YeTlko5UacJ1
         0KCZ1rfXr+IdlWEEHyt5uXotwRwbcFCwEjpFTrPjinMn7407xS+O/9H2a1NqurLMrP4/
         EJFQ==
Content-Disposition: inline
In-Reply-To: <1466555002-1316296-4-git-send-email-kafai@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martin KaFai Lau <kafai@fb.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Tue, Jun 21, 2016 at 05:23:21PM -0700, Martin KaFai Lau wrote:
> Adds a bpf helper, bpf_skb_in_cgroup, to decide if a skb->sk
> belongs to a descendant of a cgroup2.  It is similar to the
> feature added in netfilter:
> commit c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
> 
> The user is expected to populate a BPF_MAP_TYPE_CGROUP_ARRAY
> which will be used by the bpf_skb_in_cgroup.
> 
> Modifications to the bpf verifier is to ensure BPF_MAP_TYPE_CGROUP_ARRAY
> and bpf_skb_in_cgroup() are always used together.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> Cc: Alexei Starovoitov <ast@fb.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  include/uapi/linux/bpf.h |  1 +
>  kernel/bpf/verifier.c    |  8 ++++++++
>  net/core/filter.c        | 36 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ef4e386..a91714bd 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -314,6 +314,7 @@ enum bpf_func_id {
>  	 */
>  	BPF_FUNC_skb_get_tunnel_opt,
>  	BPF_FUNC_skb_set_tunnel_opt,
> +	BPF_FUNC_skb_in_cgroup,
...
> +static u64 bpf_skb_in_cgroup(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
> +{
...
> +	if (unlikely(!cgrp))
> +		return -ENOENT;
> +
> +	return cgroup_is_descendant(sock_cgroup_ptr(&sk->sk_cgrp_data), cgrp);

if you'd need to respin the patch for other reasons please add kdoc
to bpf.h for this new helper similar to other helpers.
To say that 0 or 1 return values is indication of cg2 descendant relation
and < 0 in case of error.

Acked-by: Alexei Starovoitov <ast@kernel.org>

